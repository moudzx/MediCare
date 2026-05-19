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
            //if (Session["UserId"] == null || Session["Role"] == null)
            //{
            //    Response.Redirect("~/Pages/Account/Login.aspx");
            //    return;
            //}

            //    if (Session["Role"].ToString() != "Doctor")
            //    {
            //        Response.Redirect("~/Default.aspx");
            //        return;
            //}

            if (!IsPostBack)
            {
                LoadPatients();
                LoadStatistics();
            }
        }

        // =====================================================
        // LOAD PATIENTS
        // =====================================================
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
                        Gender,
                        BloodType,
                        ChronicDisease
                    FROM Patients
                    WHERE 1 = 1";

                // SEARCH
                if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                {
                    query += @"
                        AND (
                            FullName LIKE @Search
                            OR ChronicDisease LIKE @Search
                            OR PhoneNumber LIKE @Search
                        )";
                }

                // GENDER FILTER
                if (!string.IsNullOrWhiteSpace(ddlGender.SelectedValue))
                {
                    query += " AND Gender = @Gender";
                }

                query += " ORDER BY PatientId DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                    {
                        cmd.Parameters.AddWithValue(
                            "@Search",
                            "%" + txtSearch.Text.Trim() + "%"
                        );
                    }

                    if (!string.IsNullOrWhiteSpace(ddlGender.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue(
                            "@Gender",
                            ddlGender.SelectedValue
                        );
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();

                        da.Fill(dt);

                        dt.Columns.Add("Initials");

                        foreach (DataRow row in dt.Rows)
                        {
                            row["Initials"] =
                                GetInitials(
                                    row["FullName"].ToString()
                                );
                        }

                        rptPatients.DataSource = dt;
                        rptPatients.DataBind();

                        lblResultsCount.Text =
                            "Showing " + dt.Rows.Count + " patients";

                        pnlEmptyState.Visible =
                            dt.Rows.Count == 0;
                    }
                }
            }
        }

        // =====================================================
        // LOAD STATS
        // =====================================================
        private void LoadStatistics()
        {
            using (SqlConnection conn =
                new SqlConnection(connectionString))
            {
                conn.Open();

                using (SqlCommand cmd =
                    new SqlCommand(
                        "SELECT COUNT(*) FROM Patients",
                        conn))
                {
                    lblStatTotal.Text =
                        cmd.ExecuteScalar().ToString();
                }

                using (SqlCommand cmd =
                    new SqlCommand(@"
                        SELECT COUNT(*)
                        FROM Patients
                        WHERE ChronicDisease IS NOT NULL
                        AND ChronicDisease <> ''",
                        conn))
                {
                    lblStatOnMeds.Text =
                        cmd.ExecuteScalar().ToString();
                }

                using (SqlCommand cmd =
                    new SqlCommand(@"
                        SELECT COUNT(*)
                        FROM Patients
                        WHERE PhoneNumber IS NOT NULL
                        AND PhoneNumber <> ''",
                        conn))
                {
                    lblStatUpcoming.Text =
                        cmd.ExecuteScalar().ToString();
                }

                lblStatActive.Text = lblStatTotal.Text;
            }
        }

        // =====================================================
        // SEARCH
        // =====================================================
        protected void txtSearch_TextChanged(
            object sender,
            EventArgs e)
        {
            LoadPatients();
        }

        protected void btnClearSearch_Click(
            object sender,
            EventArgs e)
        {
            txtSearch.Text = "";

            ddlGender.SelectedIndex = 0;

            LoadPatients();
        }

        // =====================================================
        // FILTER
        // =====================================================
        protected void ddlGender_SelectedIndexChanged(
            object sender,
            EventArgs e)
        {
            LoadPatients();
        }

        // =====================================================
        // REPEATER ACTIONS
        // =====================================================
        protected void rptPatients_ItemCommand(
            object source,
            RepeaterCommandEventArgs e)
        {
            int patientId =
                Convert.ToInt32(e.CommandArgument);

            // MEDICATION PAGE
            if (e.CommandName == "OpenMedications")
            {
                Response.Redirect(
                    "~/Pages/Doctor/ManageMedication.aspx?PatientId="
                    + patientId
                );
            }

            // NUTRITION PAGE
            else if (e.CommandName == "OpenNutrition")
            {
                Response.Redirect(
                    "~/Pages/Doctor/ManageNutrition.aspx?PatientId="
                    + patientId
                );
            }

            // DELETE
            else if (e.CommandName == "RequestRemove")
            {
                DeletePatient(patientId);
            }
        }

        // =====================================================
        // DELETE PATIENT
        // =====================================================
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
                        "@PatientId",
                        patientId
                    );

                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
            }

            ShowToast("Patient removed successfully.");

            LoadPatients();

            LoadStatistics();
        }

        // =====================================================
        // TOAST
        // =====================================================
        private void ShowToast(string message)
        {
            pnlToast.Visible = true;

            lblToastMsg.Text = message;
        }

        // =====================================================
        // INITIALS
        // =====================================================
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