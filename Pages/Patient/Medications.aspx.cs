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

    CASE 
        WHEN m.name IS NOT NULL 
            THEN m.name
        ELSE pm.MedicineId
    END AS MedicationName,

    pm.DoctorId,
    pm.Dosage,
    pm.Frequency,
    pm.Duration AS PillsNumber,
    pm.StartDate,
    pm.EndDate,
    pm.Status

FROM PatientMedications pm

INNER JOIN Patients p
    ON pm.PatientId = p.PatientId

LEFT JOIN Medicine m
    ON TRY_CAST(pm.MedicineId AS INT) = m.id

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
                rptMedications.DataSource = dt;
                rptMedications.DataBind();
                pnlEmpty.Visible = dt.Rows.Count == 0;

                lblTotalMeds.Text = dt.Rows.Count.ToString();
                lblActiveMeds.Text = dt.Select("Status = 'Active'").Length.ToString();
                lblPrescribed.Text = dt.Select("DoctorId > 0").Length.ToString();
            }
        }

        protected void btnSearchMedication_Click(object sender, EventArgs e)
        {
            string search = txtSearchMedication.Text.Trim();
            LoadMedications(search);
        }

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
                    cmd.Parameters.AddWithValue("@DoctorId", 0);
                    cmd.Parameters.AddWithValue("@MedicineId", txtMedicationName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Dosage", txtDosage.Text.Trim());
                    cmd.Parameters.AddWithValue("@Frequency", ddlFrequency.SelectedValue);
                    cmd.Parameters.AddWithValue("@Duration", txtPills.Text.Trim());

                    if (!string.IsNullOrWhiteSpace(txtStartDate.Text))
                        cmd.Parameters.AddWithValue("@StartDate", Convert.ToDateTime(txtStartDate.Text));
                    else
                        cmd.Parameters.AddWithValue("@StartDate", DBNull.Value);

                    if (!string.IsNullOrWhiteSpace(txtEndDate.Text))
                        cmd.Parameters.AddWithValue("@EndDate", Convert.ToDateTime(txtEndDate.Text));
                    else
                        cmd.Parameters.AddWithValue("@EndDate", DBNull.Value);

                    cmd.Parameters.AddWithValue("@Status", "Active");

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                ClearForm();
                LoadMedications();
                ShowMessage("Medication saved successfully.", false);
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, true);
            }
        }

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
                return result != null ? Convert.ToInt32(result) : -1;
            }
        }

        private void ShowMessage(string message, bool isError)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
            lblMessage.CssClass = isError
                ? "med-inline-msg med-inline-msg--error"
                : "med-inline-msg med-inline-msg--success";
        }

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