using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace MediCare.Pages.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Optional admin protection
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStatistics();
                LoadRecentPatients();
            }
        }

        private void LoadStatistics()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Doctors count
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Doctors", conn))
                {
                    lblDoctors.Text = cmd.ExecuteScalar().ToString();
                }

                // Patients count
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Patients", conn))
                {
                    lblPatients.Text = cmd.ExecuteScalar().ToString();
                }

                // Foods count
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Food", conn))
                {
                    lblFoods.Text = cmd.ExecuteScalar().ToString();
                }

                // Medicines count
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Medicine", conn))
                {
                    lblMedicines.Text = cmd.ExecuteScalar().ToString();
                }
            }
        }

        private void LoadRecentPatients()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT TOP 5
                        FullName AS Name,
                        Age,
                        PhoneNumber AS Contact
                    FROM Patients
                    ORDER BY PatientId DESC";

                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    // Add initials column manually
                    dt.Columns.Add("Initials");

                    foreach (DataRow row in dt.Rows)
                    {
                        string fullName = row["Name"].ToString();

                        string initials = GetInitials(fullName);

                        row["Initials"] = initials;
                    }

                    gvPatients.DataSource = dt;
                    gvPatients.DataBind();
                }
            }
        }

        private string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName))
                return "?";

            string[] parts = fullName.Trim().Split(' ');

            if (parts.Length == 1)
                return parts[0].Substring(0, 1).ToUpper();

            return (
                parts[0].Substring(0, 1) +
                parts[parts.Length - 1].Substring(0, 1)
            ).ToUpper();
        }
    }
}