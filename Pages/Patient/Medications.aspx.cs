using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace MediCare.Pages.Patient
{
    public partial class Medications : System.Web.UI.Page
    {
        private string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadMedications();
            }
        }

        private void LoadMedications(string search = "")
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT
                pm.PatientMedicationId AS MedicationId,
                pm.MedicineId AS MedicationName,
                pm.Dosage,
                pm.Frequency,
                pm.Duration AS PillsNumber,
                pm.StartDate,
                pm.EndDate,
                pm.Status
            FROM PatientMedications pm
            INNER JOIN Patients p
                ON pm.PatientId = p.PatientId
            WHERE p.UserId = @UserId";

                if (!string.IsNullOrWhiteSpace(search))
                {
                    query += @" AND pm.MedicineId LIKE @Search";
                }

                query += " ORDER BY pm.CreatedAt DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);

                if (!string.IsNullOrWhiteSpace(search))
                {
                    cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMedications.DataSource = dt;
                gvMedications.DataBind();
            }
        }

        // =========================================
        // SEARCH
        // =========================================
        protected void btnSearchMedication_Click(object sender, EventArgs e)
        {
            string search = txtSearchMedication.Text.Trim();

            LoadMedications(search);
        }

        // =========================================
        // SAVE CUSTOM MEDICATION
        // =========================================
        protected void btnSaveMedication_Click(object sender, EventArgs e)
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserId"]);

                int patientId = GetPatientId(userId);

                if (patientId == -1)
                {
                    ShowMessage("Patient not found.", true);
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                INSERT INTO PatientMedications
                (
                    PatientId,
                    DoctorId,
                    MedicineId,
                    Dosage,
                    Frequency,
                    Duration,
                    StartDate,
                    EndDate,
                    Status
                )
                VALUES
                (
                    @PatientId,
                    @DoctorId,
                    @MedicineId,
                    @Dosage,
                    @Frequency,
                    @Duration,
                    @StartDate,
                    @EndDate,
                    @Status
                )";

                    SqlCommand cmd = new SqlCommand(query, conn);

                    cmd.Parameters.AddWithValue("@PatientId", patientId);

                    // custom medication → no doctor
                    cmd.Parameters.AddWithValue("@DoctorId", 0);

                    // save medication name directly
                    cmd.Parameters.AddWithValue(
                        "@MedicineId",
                        txtMedicationName.Text.Trim());

                    cmd.Parameters.AddWithValue(
                        "@Dosage",
                        txtDosage.Text.Trim());

                    cmd.Parameters.AddWithValue(
                        "@Frequency",
                        ddlFrequency.SelectedValue);

                    cmd.Parameters.AddWithValue(
                        "@Duration",
                        txtPills.Text.Trim());

                    // Start Date
                    if (!string.IsNullOrWhiteSpace(txtStartDate.Text))
                    {
                        cmd.Parameters.AddWithValue(
                            "@StartDate",
                            Convert.ToDateTime(txtStartDate.Text));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue(
                            "@StartDate",
                            DBNull.Value);
                    }

                    // End Date
                    if (!string.IsNullOrWhiteSpace(txtEndDate.Text))
                    {
                        cmd.Parameters.AddWithValue(
                            "@EndDate",
                            Convert.ToDateTime(txtEndDate.Text));
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue(
                            "@EndDate",
                            DBNull.Value);
                    }

                    cmd.Parameters.AddWithValue("@Status", "Active");

                    conn.Open();

                    cmd.ExecuteNonQuery();
                }

                ClearForm();

                LoadMedications();

                ShowMessage(
                    "Medication saved successfully.",
                    false);
            }
            catch (Exception ex)
            {
                ShowMessage(
                    "Error: " + ex.Message,
                    true);
            }
        }

        // =========================================
        // GET PATIENT ID
        // =========================================
        private int GetPatientId(int userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT PatientId
                    FROM Patients
                    WHERE UserId = @UserId";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();

                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    return Convert.ToInt32(result);
                }

                return -1;
            }
        }

        // =========================================
        // GENERATE MEDICINE ID
        // =========================================
        private int GenerateMedicineId()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query =
                    "SELECT ISNULL(MAX(id), 0) + 1 FROM Medicine";

                SqlCommand cmd = new SqlCommand(query, conn);

                conn.Open();

                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        // =========================================
        // MESSAGE
        // =========================================
        private void ShowMessage(string message, bool isError)
        {
            lblMessage.Text = message;

            lblMessage.Visible = true;

            if (isError)
            {
                lblMessage.CssClass =
                    "med-inline-msg med-inline-msg--error";
            }
            else
            {
                lblMessage.CssClass =
                    "med-inline-msg med-inline-msg--success";
            }
        }

        // =========================================
        // CLEAR FORM
        // =========================================
        private void ClearForm()
        {
            txtMedicationName.Text = "";
            txtDosage.Text = "";
            ddlFrequency.SelectedIndex = 0;
            txtPills.Text = "";
            txtStartDate.Text = "";
            txtEndDate.Text = "";
        }
    }
}