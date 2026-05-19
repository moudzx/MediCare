using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace MediCare.Pages.Patient
{
    public partial class PatientProfile : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadPatientData();
                SetEditMode(false);
            }
        }
        private void LoadPatientData()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 1 
                        p.FullName,
                        u.Email,
                        p.PhoneNumber,
                        p.Age,
                        p.Height,
                        p.Weight,
                        p.ChronicDisease,
                        p.Disability,
                        p.FamilyHistory,
                        p.BloodType
                    FROM Patients p
                    INNER JOIN Users u ON p.UserId = u.UserId
                    WHERE p.UserId = @UserId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    string fullName = dr["FullName"].ToString();

                    lblDisplayName.Text = fullName;
                    lblCardName.Text = fullName;

                    lblInitials.Text = GetInitials(fullName);
                    lblInitialsCard.Text = GetInitials(fullName);

                    txtUsername.Text = fullName;
                    txtEmail.Text = dr["Email"].ToString();

                    txtPhone.Text = dr["PhoneNumber"].ToString();
                    txtAge.Text = dr["Age"].ToString();
                    txtHeight.Text = dr["Height"].ToString();
                    txtWeight.Text = dr["Weight"].ToString();

                    txtDisease.Text = dr["ChronicDisease"].ToString();
                    txtDisability.Text = dr["Disability"].ToString();
                    txtFamilyHistory.Text = dr["FamilyHistory"].ToString();

                    if (dr["BloodType"] != DBNull.Value)
                        ddlBloodType.SelectedValue = dr["BloodType"].ToString();
                }
            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            SetEditMode(true);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            LoadPatientData();
            SetEditMode(false);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            SavePatientData();
            SetEditMode(false);
            LoadPatientData();
        }

        private void SavePatientData()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE Patients
                    SET 
                        PhoneNumber = @Phone,
                        Age = @Age,
                        Height = @Height,
                        Weight = @Weight,
                        ChronicDisease = @Disease,
                        Disability = @Disability,
                        FamilyHistory = @FamilyHistory,
                        BloodType = @BloodType
                    WHERE UserId = @UserId";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text);
                cmd.Parameters.AddWithValue("@Age", Convert.ToInt32(txtAge.Text));
                cmd.Parameters.AddWithValue("@Height", Convert.ToDouble(txtHeight.Text));
                cmd.Parameters.AddWithValue("@Weight", Convert.ToDouble(txtWeight.Text));

                cmd.Parameters.AddWithValue("@Disease", txtDisease.Text);
                cmd.Parameters.AddWithValue("@Disability", txtDisability.Text);
                cmd.Parameters.AddWithValue("@FamilyHistory", txtFamilyHistory.Text);

                cmd.Parameters.AddWithValue("@BloodType", ddlBloodType.SelectedValue);
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        
        private void SetEditMode(bool enabled)
        {
            txtPhone.ReadOnly = !enabled;

            txtAge.ReadOnly = !enabled;
            txtHeight.ReadOnly = !enabled;
            txtWeight.ReadOnly = !enabled;

            txtDisease.ReadOnly = !enabled;
            txtDisability.ReadOnly = !enabled;
            txtFamilyHistory.ReadOnly = !enabled;

            ddlPhoneCode.Enabled = enabled;
            ddlBloodType.Enabled = enabled;

            btnEdit.Visible = !enabled;
            btnSave.Visible = enabled;
            btnCancel.Visible = enabled;

            ViewState["EditMode"] = enabled;
        }

        
        private string GetInitials(string fullName)
        {
            if (string.IsNullOrEmpty(fullName)) return "U";

            string[] parts = fullName.Split(' ');
            if (parts.Length == 1) return parts[0][0].ToString().ToUpper();

            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper();
        }
    }
}