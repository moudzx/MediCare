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
            if (!int.TryParse(Request.QueryString["PatientId"], out int patientId))
            {
                Response.Redirect("~/Pages/Doctor/PatientList.aspx");
                return;
            }

            PatientId = patientId;
            DoctorId = Convert.ToInt32(Session["UserId"]);

            if (!IsPostBack)
            {
                pnlAddModal.CssClass = "mm-modal-overlay";
                LoadPatientInfo();
                LoadMedicationStatistics();
                LoadMedications();
                LoadMedicineDropdown();
            }
        }

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

        private void LoadMedicationStatistics()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                lblTotalMeds.Text = ExecuteScalar(conn, "SELECT COUNT(*) FROM PatientMedications WHERE PatientId = @p", PatientId);
                lblActiveMeds.Text = ExecuteScalar(conn, "SELECT COUNT(*) FROM PatientMedications WHERE PatientId = @p AND Status = 'Active'", PatientId);
                lblCompletedMeds.Text = ExecuteScalar(conn, "SELECT COUNT(*) FROM PatientMedications WHERE PatientId = @p AND Status = 'Completed'", PatientId);
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
                    LEFT JOIN Medicine m ON m.id = TRY_CAST(pm.MedicineId AS INT)
                    WHERE pm.PatientId = @PatientId";

                if (!string.IsNullOrWhiteSpace(search))
                    query += " AND (m.name LIKE @Search OR pm.Dosage LIKE @Search OR pm.Frequency LIKE @Search)";

                if (!string.IsNullOrWhiteSpace(status))
                    query += " AND pm.Status = @Status";

                query += " ORDER BY pm.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", PatientId);
                    if (!string.IsNullOrWhiteSpace(search)) cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                    if (!string.IsNullOrWhiteSpace(status)) cmd.Parameters.AddWithValue("@Status", status);

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

        private void LoadMedicineDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(@"
                SELECT id, name FROM Medicine WHERE name IS NOT NULL ORDER BY name", conn))
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

        protected void btnOpenAddModal_Click(object sender, EventArgs e)
            => pnlAddModal.CssClass = "mm-modal-overlay mm-modal-overlay--open";

        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlAddModal.CssClass = "mm-modal-overlay";
            ClearMedicationForm();
        }

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
                {
                    conn.Open();

                    // 1. Resolve actual DoctorId from session UserId
                    int doctorId = 0;
                    using (SqlCommand cmdDoc = new SqlCommand(
                        "SELECT DoctorId FROM Doctors WHERE UserId = @UserId", conn))
                    {
                        cmdDoc.Parameters.AddWithValue("@UserId", DoctorId);
                        object res = cmdDoc.ExecuteScalar();
                        if (res != null && res != DBNull.Value)
                            doctorId = Convert.ToInt32(res);
                    }

                    // 2. Insert medication
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
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
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
                        cmd.ExecuteNonQuery();
                    }

                    // 3. Resolve patient's UserId for the notification
                    int patientUserId = 0;
                    using (SqlCommand cmdUser = new SqlCommand(
                        "SELECT UserId FROM Patients WHERE PatientId = @PatientId", conn))
                    {
                        cmdUser.Parameters.AddWithValue("@PatientId", PatientId);
                        object res = cmdUser.ExecuteScalar();
                        if (res != null && res != DBNull.Value)
                            patientUserId = Convert.ToInt32(res);
                    }

                    // 4. Send MedicationAdded notification to the patient
                    if (patientUserId > 0)
                    {
                        string medicineName = ddlMedicine.SelectedItem.Text;
                        string dosage = txtDosage.Text.Trim();
                        string frequency = ddlFrequency.SelectedValue;

                        string docName = "Your doctor";
                        if (doctorId > 0)
                        {
                            using (SqlCommand cmdDocName = new SqlCommand(
                                "SELECT FullName FROM Doctors WHERE DoctorId = @DoctorId", conn))
                            {
                                cmdDocName.Parameters.AddWithValue("@DoctorId", doctorId);
                                object res = cmdDocName.ExecuteScalar();
                                if (res != null) docName = "Dr. " + res.ToString();
                            }
                        }

                        using (SqlCommand cmdNotif = new SqlCommand(@"
                            INSERT INTO Notifications
                                (UserId, Type, Title, Message, IsRead, CreatedAt)
                            VALUES
                                (@UserId, 'MedicationAdded', 'New Medication Prescribed', @Message, 0, GETDATE())", conn))
                        {
                            cmdNotif.Parameters.AddWithValue("@UserId", patientUserId);
                            cmdNotif.Parameters.AddWithValue("@Message",
                                $"{docName} prescribed {medicineName} — {dosage}, {frequency}.");
                            cmdNotif.ExecuteNonQuery();
                        }
                    }
                }

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
                UPDATE PatientMedications SET Status = @Status WHERE PatientMedicationId = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@Id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            LoadMedicationStatistics();
            LoadMedications(txtSearch.Text.Trim(), ddlStatus.SelectedValue);
        }

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