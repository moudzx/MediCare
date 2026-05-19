using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Doctor
{
    public partial class PatientList : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPatients();
                LoadStatistics();
            }
        }

        // =========================================================
        // LOAD PATIENTS
        // =========================================================
        private void LoadPatients()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        PatientId,
                        FullName,
                        PhoneNumber,
                        Age,
                        ChronicDisease,
                        BloodType,
                        Gender
                    FROM Patients
                    ORDER BY PatientId DESC";

                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    // Extra UI columns
                    dt.Columns.Add("Initials");

                    foreach (DataRow row in dt.Rows)
                    {
                        row["Initials"] =
                            GetInitials(row["FullName"].ToString());
                    }

                    rptPatients.DataSource = dt;
                    rptPatients.DataBind();

                    lblResultsCount.Text =
                        "Showing " + dt.Rows.Count + " patients";

                    pnlEmptyState.Visible = dt.Rows.Count == 0;
                }
            }
        }

        // =========================================================
        // LOAD STATS
        // =========================================================
        private void LoadStatistics()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Total Patients
                using (SqlCommand cmd =
                    new SqlCommand("SELECT COUNT(*) FROM Patients", conn))
                {
                    lblStatTotal.Text =
                        cmd.ExecuteScalar().ToString();
                }

                // Total Doctors
                using (SqlCommand cmd =
                    new SqlCommand("SELECT COUNT(*) FROM Doctors", conn))
                {
                    lblStatActive.Text =
                        cmd.ExecuteScalar().ToString();
                }

                // Users
                using (SqlCommand cmd =
                    new SqlCommand("SELECT COUNT(*) FROM Users", conn))
                {
                    lblStatUpcoming.Text =
                        cmd.ExecuteScalar().ToString();
                }

                // Patients with chronic disease
                using (SqlCommand cmd =
                    new SqlCommand(@"
                        SELECT COUNT(*)
                        FROM Patients
                        WHERE ChronicDisease IS NOT NULL
                        AND ChronicDisease <> ''", conn))
                {
                    lblStatOnMeds.Text =
                        cmd.ExecuteScalar().ToString();
                }
            }
        }

        // =========================================================
        // SEARCH
        // =========================================================
        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            LoadPatients();
        }

        // =========================================================
        // FILTERS
        // =========================================================
        protected void ddlGender_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPatients();
        }

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadPatients();
        }

        // =========================================================
        // REPEATER COMMANDS
        // =========================================================
        protected void rptPatients_ItemCommand(object source,
            RepeaterCommandEventArgs e)
        {
            int patientId =
                Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "OpenMedications")
            {
                ShowToast("Medication section is not connected yet.");
            }

            else if (e.CommandName == "OpenNutrition")
            {
                ShowToast("Nutrition section is not connected yet.");
            }

            else if (e.CommandName == "RequestRemove")
            {
                DeletePatient(patientId);
            }
        }

        // =========================================================
        // DELETE PATIENT
        // =========================================================
        private void DeletePatient(int patientId)
        {
            using (SqlConnection conn =
                new SqlConnection(connectionString))
            {
                string query =
                    "DELETE FROM Patients WHERE PatientId=@PatientId";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue(
                        "@PatientId", patientId);

                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
            }

            ShowToast("Patient removed successfully.");

            LoadPatients();
            LoadStatistics();
        }

        // =========================================================
        // TOAST
        // =========================================================
        private void ShowToast(string message)
        {
            pnlToast.Visible = true;

            lblToastMsg.Text = message;
        }

        // =========================================================
        // INITIALS
        // =========================================================
        private string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName))
                return "?";

            string[] parts =
                fullName.Trim().Split(' ');

            if (parts.Length == 1)
            {
                return parts[0]
                    .Substring(0, 1)
                    .ToUpper();
            }

            return (
                parts[0].Substring(0, 1) +
                parts[parts.Length - 1].Substring(0, 1)
            ).ToUpper();
        }
    }
}