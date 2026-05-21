using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace MediCare.Pages.Doctor
{
    public partial class DoctorProfile : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["UserId"] == null || Session["Role"] == null || Session["Role"].ToString() != "Doctor")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDoctorProfileData();
            }
        }

        private void LoadDoctorProfileData()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();


                    string docSql = @"
                        SELECT d.DoctorId, d.FullName, d.PhoneNumber, d.Age, d.ClinicAddress, 
                               d.CertificatePath, d.Speciality, d.Gender, u.Email
                        FROM [dbo].[Doctors] d
                        INNER JOIN [dbo].[Users] u ON d.UserId = u.UserId
                        WHERE d.UserId = @UserId";

                    int currentDoctorId = 0;

                    using (SqlCommand cmd = new SqlCommand(docSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                currentDoctorId = Convert.ToInt32(reader["DoctorId"]);


                                txtEmail.Text = reader["Email"].ToString();
                                txtFullName.Text = reader["FullName"].ToString();
                                txtPhone.Text = reader["PhoneNumber"] != DBNull.Value ? reader["PhoneNumber"].ToString() : "";
                                txtAge.Text = reader["Age"].ToString();
                                txtClinicAddress.Text = reader["ClinicAddress"] != DBNull.Value ? reader["ClinicAddress"].ToString() : "";
                                txtCertificatePath.Text = reader["CertificatePath"].ToString();
                                txtSpeciality.Text = reader["Speciality"] != DBNull.Value ? reader["Speciality"].ToString() : "";
                                txtGender.SelectedValue = reader["Gender"] != DBNull.Value ? reader["Gender"].ToString() : "Not specified";


                                lblHeaderName.Text = reader["FullName"].ToString();
                                lblHeaderSpeciality.Text = reader["Speciality"] != DBNull.Value && !string.IsNullOrEmpty(reader["Speciality"].ToString())
                                    ? reader["Speciality"].ToString()
                                    : "General Medical Practice";
                                lblStatAge.Text = reader["Age"].ToString();
                            }
                        }
                    }


                    if (currentDoctorId > 0)
                    {

                        string connSql = "SELECT COUNT(*) FROM [dbo].[PatientDoctorConnections] WHERE DoctorId = @DoctorId AND [Status] = 'Accepted'";
                        using (SqlCommand cmdConn = new SqlCommand(connSql, conn))
                        {
                            cmdConn.Parameters.AddWithValue("@DoctorId", currentDoctorId);
                            lblStatPatients.Text = cmdConn.ExecuteScalar().ToString();
                        }


                        string appSql = "SELECT COUNT(*) FROM [dbo].[Appointments] WHERE DoctorId = @DoctorId";
                        using (SqlCommand cmdApp = new SqlCommand(appSql, conn))
                        {
                            cmdApp.Parameters.AddWithValue("@DoctorId", currentDoctorId);
                            lblStatAppointments.Text = cmdApp.ExecuteScalar().ToString();
                        }
                    }
                }
                catch (Exception ex)
                {
                    DisplayAlert("Critical error loading credentials: " + ex.Message, true);
                }
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);


            string fullName = txtFullName.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string speciality = txtSpeciality.Text.Trim();
            string clinicAddress = txtClinicAddress.Text.Trim();
            string ageText = txtAge.Text.Trim();
            string gender = txtGender.SelectedValue;

            if (string.IsNullOrEmpty(fullName))
            {
                DisplayAlert("Full Name is a mandatory operational field.", true);
                return;
            }

            if (!int.TryParse(ageText, out int ageValue) || ageValue <= 0 || ageValue > 150)
            {
                DisplayAlert("Please input a valid medical practitioner age range calculation (1-150).", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();


                    string updateSql = @"
                     UPDATE [dbo].[Doctors]
                       SET FullName = @FullName,
                       PhoneNumber = @PhoneNumber,
                        Age = @Age,
                        ClinicAddress = @ClinicAddress,
                        Speciality = @Speciality,
                         Gender = @Gender
                         WHERE UserId = @UserId";

                    using (SqlCommand cmd = new SqlCommand(updateSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.Parameters.AddWithValue("@PhoneNumber", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);
                        cmd.Parameters.AddWithValue("@Age", ageValue);
                        cmd.Parameters.AddWithValue("@ClinicAddress", string.IsNullOrEmpty(clinicAddress) ? (object)DBNull.Value : clinicAddress);
                        cmd.Parameters.AddWithValue("@Speciality", string.IsNullOrEmpty(speciality) ? (object)DBNull.Value : speciality);
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@Gender", string.IsNullOrEmpty(gender) ? (object)DBNull.Value : gender);
                        cmd.ExecuteNonQuery();
                    }


                    LoadDoctorProfileData();
                    DisplayAlert("Your professional profile matrix configurations have been successfully saved.", false);
                }
                catch (Exception ex)
                {
                    DisplayAlert("Transaction fault committing profile updates: " + ex.Message, true);
                }
            }
        }

        private void DisplayAlert(string message, bool isError)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = isError ? "prof-alert prof-alert--error" : "prof-alert prof-alert--success";
            alertIcon.Attributes["class"] = isError ? "fa-solid fa-circle-exclamation" : "fa-solid fa-circle-check";
            lblAlertMessage.Text = message;
        }
    }
}