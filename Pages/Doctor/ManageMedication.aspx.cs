using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Doctor
{
    public partial class ManageMedication : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected int PatientId
        {
            get
            {
                object obj = ViewState["PatientId"];
                if (obj == null) return 0;
                return Convert.ToInt32(obj);
            }
            set { ViewState["PatientId"] = value; }
        }

        protected int DoctorId
        {
            get
            {
                object obj = ViewState["DoctorId"];
                if (obj == null) return 0;
                return Convert.ToInt32(obj);
            }
            set { ViewState["DoctorId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Auth guards
            //if (Session["UserId"] == null || Session["Role"] == null)
            //{
            //    Response.Redirect("~/Pages/Account/Login.aspx");
            //    return;
            //}

            //if (Session["Role"].ToString() != "Doctor")
            //{
            //    Response.Redirect("~/Default.aspx");
            //    return;
            //}

            // Read PatientId from QueryString
            if (!int.TryParse(Request.QueryString["PatientId"], out int patientId))
            {
                Response.Redirect("~/Pages/Doctor/PatientList.aspx");
                return;
            }

            PatientId = patientId;
            DoctorId = Convert.ToInt32(Session["UserId"]);

            // ── CRITICAL: always runs on every postback ──────────────
            // Because pnlAddModal is always rendered (no Visible=false),
            // ddlMedicine is always in the page and must always be bound.
            // Without this, the dropdown is empty every postback.
           

            if (!IsPostBack)
            {
                // Modal starts hidden via CSS class (not Visible=false)
                pnlAddModal.CssClass = "mm-modal-overlay";

                LoadPatientInfo();
                LoadMedicationStatistics();
                LoadMedications();
                LoadMedicineDropdown();
            }
        }

        // ─────────────────────────────────────────────────────────────
        // LOAD PATIENT INFO
        // ─────────────────────────────────────────────────────────────
        private void LoadPatientInfo()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT FullName, Gender, BloodType
                FROM   Patients
                WHERE  PatientId = @PatientId", conn))
            {
                cmd.Parameters.AddWithValue("@PatientId", PatientId);
                conn.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblPatientName.Text = reader["FullName"].ToString();
                        lblPatientInfo.Text =
                            reader["Gender"].ToString() +
                            " • Blood Type: " +
                            reader["BloodType"].ToString();
                    }
                }
            }
        }

        // ─────────────────────────────────────────────────────────────
        // LOAD STATS
        // ─────────────────────────────────────────────────────────────
        private void LoadMedicationStatistics()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                lblTotalMeds.Text = ExecuteScalar(conn,
                    "SELECT COUNT(*) FROM PatientMedications WHERE PatientId = @p",
                    PatientId);

                lblActiveMeds.Text = ExecuteScalar(conn,
                    "SELECT COUNT(*) FROM PatientMedications WHERE PatientId = @p AND Status = 'Active'",
                    PatientId);

                lblCompletedMeds.Text = ExecuteScalar(conn,
                    "SELECT COUNT(*) FROM PatientMedications WHERE PatientId = @p AND Status = 'Completed'",
                    PatientId);
            }
        }

        private string ExecuteScalar(SqlConnection conn, string sql, int patientId)
        {
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@p", patientId);
                return cmd.ExecuteScalar().ToString();
            }
        }

        // ─────────────────────────────────────────────────────────────
        // LOAD MEDICATIONS
        // ─────────────────────────────────────────────────────────────
        private void LoadMedications(string search = "", string status = "")
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = @"
                    SELECT
                        pm.PatientMedicationId,
                        pm.MedicineId,
                        pm.Dosage,
                        pm.Frequency,
                        pm.Duration,
                        pm.StartDate,
                        pm.EndDate,
                        pm.Status,
                        pm.CreatedAt,
                        ISNULL(m.name, '(Unknown)') AS MedicineName,
                        m.form,
                        m.price
                    FROM  PatientMedications pm
                    LEFT JOIN Medicine m
                        ON m.id = TRY_CAST(pm.MedicineId AS INT)
                    WHERE pm.PatientId = @PatientId";

                if (!string.IsNullOrWhiteSpace(search))
                    query += @"
                        AND (
                            m.name         LIKE @Search
                            OR pm.Dosage    LIKE @Search
                            OR pm.Frequency LIKE @Search
                        )";

                if (!string.IsNullOrWhiteSpace(status))
                    query += " AND pm.Status = @Status";

                query += " ORDER BY pm.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", PatientId);

                    if (!string.IsNullOrWhiteSpace(search))
                        cmd.Parameters.AddWithValue("@Search", "%" + search + "%");

                    if (!string.IsNullOrWhiteSpace(status))
                        cmd.Parameters.AddWithValue("@Status", status);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        rptMedications.DataSource = dt;
                        rptMedications.DataBind();

                        pnlEmpty.Visible = dt.Rows.Count == 0;
                        lblMedicationCount.Text = dt.Rows.Count + " medication(s)";
                    }
                }
            }
        }

        // ─────────────────────────────────────────────────────────────
        // LOAD MEDICINE DROPDOWN
        // ─────────────────────────────────────────────────────────────
        private void LoadMedicineDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT id, name
                FROM   Medicine
                WHERE  name IS NOT NULL
                ORDER  BY name", conn))
            {
                conn.Open();

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlMedicine.DataSource = dt;
                    ddlMedicine.DataTextField = "name";
                    ddlMedicine.DataValueField = "id";
                    ddlMedicine.DataBind();
                }

                ddlMedicine.Items.Insert(0, new ListItem("Select Medication...", ""));
            }
        }

        // ─────────────────────────────────────────────────────────────
        // SEARCH / FILTER / CLEAR
        // ─────────────────────────────────────────────────────────────
        protected void txtSearch_TextChanged(object sender, EventArgs e)
            => LoadMedications(txtSearch.Text.Trim(), ddlStatus.SelectedValue);

        protected void ddlStatus_SelectedIndexChanged(object sender, EventArgs e)
            => LoadMedications(txtSearch.Text.Trim(), ddlStatus.SelectedValue);

        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlStatus.SelectedIndex = 0;
            LoadMedications();
        }

        // ─────────────────────────────────────────────────────────────
        // MODAL OPEN / CLOSE  ← CSS class, NOT Visible
        // ─────────────────────────────────────────────────────────────
        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            pnlAddModal.CssClass = "mm-modal-overlay mm-modal-overlay--open";
        }

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlAddModal.CssClass = "mm-modal-overlay";
            ClearMedicationForm();
        }

        // ─────────────────────────────────────────────────────────────
        // SAVE MEDICATION
        // ─────────────────────────────────────────────────────────────
        protected void btnSaveMedication_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlMedicine.SelectedValue))
            {
                lblError.Text = "Please select a medication.";
                lblError.Visible = true;
                pnlAddModal.CssClass = "mm-modal-overlay mm-modal-overlay--open";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connectionString))
                using (SqlCommand cmd = new SqlCommand(@"
                    INSERT INTO PatientMedications
                        (PatientId, DoctorId, MedicineId,
                         Dosage, Frequency, Duration,
                         StartDate, EndDate, Status)
                    VALUES
                        (@PatientId, @DoctorId, @MedicineId,
                         @Dosage, @Frequency, @Duration,
                         @StartDate, @EndDate, @Status)", conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", PatientId);
                    cmd.Parameters.AddWithValue("@DoctorId", DoctorId);
                    cmd.Parameters.AddWithValue("@MedicineId", ddlMedicine.SelectedValue);
                    cmd.Parameters.AddWithValue("@Dosage", txtDosage.Text.Trim());
                    cmd.Parameters.AddWithValue("@Frequency", ddlFrequency.SelectedValue);
                    cmd.Parameters.AddWithValue("@Duration", txtDuration.Text.Trim());

                    cmd.Parameters.AddWithValue("@StartDate",
                        string.IsNullOrWhiteSpace(txtStartDate.Text)
                            ? (object)DBNull.Value
                            : DateTime.Parse(txtStartDate.Text));

                    cmd.Parameters.AddWithValue("@EndDate",
                        string.IsNullOrWhiteSpace(txtEndDate.Text)
                            ? (object)DBNull.Value
                            : DateTime.Parse(txtEndDate.Text));

                    cmd.Parameters.AddWithValue("@Status", ddlMedicationStatus.SelectedValue);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Success — close modal
                pnlAddModal.CssClass = "mm-modal-overlay";
                ClearMedicationForm();
                LoadMedicationStatistics();
                LoadMedications();
            }
            catch (Exception ex)
            {
                lblError.Text = "Error saving: " + ex.Message;
                lblError.Visible = true;
                pnlAddModal.CssClass = "mm-modal-overlay mm-modal-overlay--open";
            }
        }

        // ─────────────────────────────────────────────────────────────
        // REPEATER COMMANDS
        // ─────────────────────────────────────────────────────────────
        protected void rptMedications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            switch (e.CommandName)
            {
                case "DeleteMedication": DeleteMedication(id); break;
                case "CompleteMedication": UpdateMedicationStatus(id, "Completed"); break;
                case "StopMedication": UpdateMedicationStatus(id, "Stopped"); break;
            }
        }

        private void DeleteMedication(int id)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(
                "DELETE FROM PatientMedications WHERE PatientMedicationId = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            LoadMedicationStatistics();
            LoadMedications(txtSearch.Text.Trim(), ddlStatus.SelectedValue);
        }

        private void UpdateMedicationStatus(int id, string status)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                UPDATE PatientMedications
                SET    Status = @Status
                WHERE  PatientMedicationId = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            LoadMedicationStatistics();
            LoadMedications(txtSearch.Text.Trim(), ddlStatus.SelectedValue);
        }

        // ─────────────────────────────────────────────────────────────
        // CLEAR FORM
        // ─────────────────────────────────────────────────────────────
        private void ClearMedicationForm()
        {
            ddlMedicine.SelectedIndex = 0;
            txtDosage.Text = "";
            ddlFrequency.SelectedIndex = 0;
            txtDuration.Text = "";
            txtStartDate.Text = "";
            txtEndDate.Text = "";
            ddlMedicationStatus.SelectedValue = "Active";
            lblError.Visible = false;
            lblError.Text = "";
        }
    }
}