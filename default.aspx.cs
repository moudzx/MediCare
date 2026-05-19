using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;

namespace MediCare
{
    public partial class Default : System.Web.UI.Page
    {
        private readonly string connectionString =
            System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected SqlConnection GetConnection()
        {
            return new SqlConnection(connectionString);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnPatientSignUp_Click(object sender, EventArgs e)
        {
            lblPatientMessage.Visible = true;

            if (!Page.IsValid)
                return;

            if (!ValidatePatient(out string errorMessage))
            {
                lblPatientMessage.Text = errorMessage;
                lblPatientMessage.CssClass = "mc-form__message mc-form__message--error";
                return;
            }

            using (SqlConnection conn = GetConnection())
            {
                conn.Open();
                using (SqlTransaction tx = conn.BeginTransaction())
                {
                    try
                    {
                        // 1. Insert into Users
                        int userId;
                        using (SqlCommand cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            cmd.CommandText = @"
                                INSERT INTO Users (Email, PasswordHash, Role, CreatedAt)
                                VALUES (@Email, @Hash, 'Patient', @Date);
                                SELECT SCOPE_IDENTITY();";

                            cmd.Parameters.AddWithValue("@Email", txtPatientEmail.Text.Trim());
                            cmd.Parameters.AddWithValue("@Hash", BCrypt.Net.BCrypt.HashPassword(txtPatientPassword.Text));
                            cmd.Parameters.AddWithValue("@Date", DateTime.Now);
                            userId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        // 2. Insert into Patients
                        int patientId;
                        using (SqlCommand cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            cmd.CommandText = @"
                                INSERT INTO Patients
                                    (UserId, FullName, PhoneNumber, Age, Height, Weight, Disability, ChronicDisease, FamilyHistory)
                                VALUES
                                    (@UserId, @Name, @Phone, @Age, @Height, @Weight, @Disability, @Disease, @Family);
                                SELECT SCOPE_IDENTITY();";

                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.Parameters.AddWithValue("@Name", txtPatientName.Text.Trim());
                            cmd.Parameters.AddWithValue("@Phone",
                                string.IsNullOrWhiteSpace(txtPatientPhone.Text)
                                    ? (object)DBNull.Value
                                    : txtPatientPhone.Text.Trim());
                            cmd.Parameters.AddWithValue("@Age", int.Parse(txtPatientAge.Text));
                            cmd.Parameters.AddWithValue("@Height",
                                string.IsNullOrWhiteSpace(txtPatientHeight.Text)
                                    ? (object)DBNull.Value
                                    : double.Parse(txtPatientHeight.Text));
                            cmd.Parameters.AddWithValue("@Weight",
                                string.IsNullOrWhiteSpace(txtPatientWeight.Text)
                                    ? (object)DBNull.Value
                                    : double.Parse(txtPatientWeight.Text));
                            cmd.Parameters.AddWithValue("@Disability",
                                string.IsNullOrWhiteSpace(txtDisability.Text)
                                    ? (object)DBNull.Value
                                    : txtDisability.Text.Trim());
                            cmd.Parameters.AddWithValue("@Disease",
                                string.IsNullOrWhiteSpace(txtChronicDisease.Text)
                                    ? (object)DBNull.Value
                                    : txtChronicDisease.Text.Trim());
                            cmd.Parameters.AddWithValue("@Family",
                                string.IsNullOrWhiteSpace(txtFamilyHistory.Text)
                                    ? (object)DBNull.Value
                                    : txtFamilyHistory.Text.Trim());

                            patientId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        tx.Commit();

                        // Store session and redirect to patient profile
                        Session["UserId"] = userId;
                        Session["PatientId"] = patientId;
                        Session["Role"] = "Patient";
                        Session["FullName"] = txtPatientName.Text.Trim();

                        Response.Redirect("~/Pages/Patient/PatientProfile.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                    catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
                    {
                        // Unique constraint violation (duplicate email)
                        tx.Rollback();
                        lblPatientMessage.Text = "This email is already registered. Please sign in or use another email.";
                        lblPatientMessage.CssClass = "mc-form__message mc-form__message--error";
                    }
                    catch
                    {
                        tx.Rollback();
                        lblPatientMessage.Text = "An unexpected error occurred. Please try again.";
                        lblPatientMessage.CssClass = "mc-form__message mc-form__message--error";
                    }
                }
            }
        }


        protected void btnDoctorSignUp_Click(object sender, EventArgs e)
        {
            lblDoctorMessage.Visible = true;

            if (!Page.IsValid)
                return;

            if (!ValidateDoctor(out string errorMessage, out string certificatePath))
            {
                lblDoctorMessage.Text = errorMessage;
                lblDoctorMessage.CssClass = "mc-form__message mc-form__message--error";
                return;
            }

            using (SqlConnection conn = GetConnection())
            {
                conn.Open();
                using (SqlTransaction tx = conn.BeginTransaction())
                {
                    try
                    {
                        // 1. Insert into Users
                        int userId;
                        using (SqlCommand cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            cmd.CommandText = @"
                                INSERT INTO Users (Email, PasswordHash, Role, CreatedAt)
                                VALUES (@Email, @Hash, 'Doctor', @Date);
                                SELECT SCOPE_IDENTITY();";

                            cmd.Parameters.AddWithValue("@Email", txtDoctorEmail.Text.Trim());
                            cmd.Parameters.AddWithValue("@Hash", BCrypt.Net.BCrypt.HashPassword(txtDoctorPassword.Text));
                            cmd.Parameters.AddWithValue("@Date", DateTime.Now);
                            userId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        // 2. Insert into Doctors
                        int doctorId;
                        using (SqlCommand cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            cmd.CommandText = @"
                                INSERT INTO Doctors
                                    (UserId, FullName, PhoneNumber, Age, ClinicAddress, CertificatePath, Speciality)
                                VALUES
                                    (@UserId, @Name, @Phone, @Age, @ClinicAddress, @Path, @Speciality);
                                SELECT SCOPE_IDENTITY();";

                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.Parameters.AddWithValue("@Name", txtDoctorName.Text.Trim());
                            cmd.Parameters.AddWithValue("@Phone",
                                string.IsNullOrWhiteSpace(txtDoctorPhone.Text)
                                    ? (object)DBNull.Value
                                    : txtDoctorPhone.Text.Trim());
                            cmd.Parameters.AddWithValue("@Age", int.Parse(txtDoctorAge.Text));
                            cmd.Parameters.AddWithValue("@ClinicAddress",
                                string.IsNullOrWhiteSpace(txtDoctorClinicAddress.Text)
                                    ? (object)DBNull.Value
                                    : txtDoctorClinicAddress.Text.Trim());
                            cmd.Parameters.AddWithValue("@Path", certificatePath);
                            cmd.Parameters.AddWithValue("@Speciality",
                                string.IsNullOrWhiteSpace(txtDoctorSpeciality.Text)
                                    ? (object)DBNull.Value
                                    : txtDoctorSpeciality.Text.Trim());

                            doctorId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        tx.Commit();

                        // Store session and redirect to doctor profile
                        Session["UserId"] = userId;
                        Session["DoctorId"] = doctorId;
                        Session["Role"] = "Doctor";
                        Session["FullName"] = txtDoctorName.Text.Trim();

                        Response.Redirect("~/Pages/Doctor/DoctorProfile.aspx", false);
                        Context.ApplicationInstance.CompleteRequest();
                    }
                    catch (SqlException ex) when (ex.Number == 2627 || ex.Number == 2601)
                    {
                        tx.Rollback();
                        lblDoctorMessage.Text = "This email is already registered. Please use another email.";
                        lblDoctorMessage.CssClass = "mc-form__message mc-form__message--error";
                    }
                    catch
                    {
                        tx.Rollback();
                        lblDoctorMessage.Text = "An unexpected error occurred. Please try again.";
                        lblDoctorMessage.CssClass = "mc-form__message mc-form__message--error";
                    }
                }
            }
        }

        private bool ValidatePatient(out string errorMessage)
        {
            errorMessage = null;

            if (string.IsNullOrWhiteSpace(txtPatientName.Text))
            {
                errorMessage = "Full name is required.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtPatientEmail.Text))
            {
                errorMessage = "Email is required.";
                return false;
            }

            if (!IsValidEmail(txtPatientEmail.Text))
            {
                errorMessage = "Please enter a valid email.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtPatientPassword.Text))
            {
                errorMessage = "Password is required.";
                return false;
            }

            if (txtPatientPassword.Text.Length < 8)
            {
                errorMessage = "Password must be at least 8 characters.";
                return false;
            }

            if (txtPatientPassword.Text != txtPatientConfirmPwd.Text)
            {
                errorMessage = "Passwords do not match.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtPatientAge.Text) ||
                !int.TryParse(txtPatientAge.Text, out int age) || age <= 0 || age > 150)
            {
                errorMessage = "Please enter a valid age (1–150).";
                return false;
            }

            if (!string.IsNullOrWhiteSpace(txtPatientHeight.Text))
            {
                if (!double.TryParse(txtPatientHeight.Text, out double h) || h <= 0)
                {
                    errorMessage = "Height must be a positive number.";
                    return false;
                }
            }

            if (!string.IsNullOrWhiteSpace(txtPatientWeight.Text))
            {
                if (!double.TryParse(txtPatientWeight.Text, out double w) || w <= 0)
                {
                    errorMessage = "Weight must be a positive number.";
                    return false;
                }
            }

            if (EmailExists(txtPatientEmail.Text.Trim()))
            {
                errorMessage = "This email is already registered. Please sign in or use another email.";
                return false;
            }

            return true;
        }

        private bool ValidateDoctor(out string errorMessage, out string certificatePath)
        {
            errorMessage = null;
            certificatePath = null;

            if (string.IsNullOrWhiteSpace(txtDoctorName.Text))
            {
                errorMessage = "Full name is required.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDoctorEmail.Text))
            {
                errorMessage = "Email is required.";
                return false;
            }

            if (!IsValidEmail(txtDoctorEmail.Text))
            {
                errorMessage = "Please enter a valid email.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDoctorPassword.Text))
            {
                errorMessage = "Password is required.";
                return false;
            }

            if (txtDoctorPassword.Text.Length < 8)
            {
                errorMessage = "Password must be at least 8 characters.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDoctorAge.Text) ||
                !int.TryParse(txtDoctorAge.Text, out int age) || age <= 0 || age > 150)
            {
                errorMessage = "Please enter a valid age (1–150).";
                return false;
            }

            if (EmailExists(txtDoctorEmail.Text.Trim()))
            {
                errorMessage = "This email is already registered. Please use another email.";
                return false;
            }

            if (!fuDoctorCertificate.HasFile)
            {
                errorMessage = "Please upload your medical certificate.";
                return false;
            }

            HttpPostedFile file = fuDoctorCertificate.PostedFile;
            string extension = Path.GetExtension(file.FileName).ToLower();
            string[] allowed = { ".pdf", ".jpg", ".jpeg", ".png" };

            if (Array.IndexOf(allowed, extension) == -1)
            {
                errorMessage = "Only PDF, JPG, JPEG, PNG files are allowed.";
                return false;
            }

            if (file.ContentLength > 10 * 1024 * 1024)
            {
                errorMessage = "File size must be less than 10 MB.";
                return false;
            }

            string folder = Server.MapPath("~/Uploads/Certificates/");
            if (!Directory.Exists(folder))
                Directory.CreateDirectory(folder);

            string uniqueName = Guid.NewGuid().ToString() + extension;
            file.SaveAs(Path.Combine(folder, uniqueName));
            certificatePath = "~/Uploads/Certificates/" + uniqueName;

            return true;
        }

        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email.Trim();
            }
            catch
            {
                return false;
            }
        }

        private bool EmailExists(string email)
        {
            using (SqlConnection conn = GetConnection())
            {
                conn.Open();
                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandText = "SELECT COUNT(1) FROM Users WHERE Email = @Email";
                    cmd.Parameters.AddWithValue("@Email", email);
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
        }
    }
}