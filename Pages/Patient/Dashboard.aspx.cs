using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace MediCare.Patient
{
    public partial class Dashboard : Page
    {
        private readonly string connStr =
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
                SetGreeting();
                LoadPatientInfo();
                LoadTodayDoses();
                LoadDoctors();
                LoadAppointments();
            }
        }

        private int GetPatientId()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT PatientId FROM Patients WHERE UserId = @UserId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);
                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null) return Convert.ToInt32(result);
            }
            return 0;
        }

        private void SetGreeting()
        {
            int hour = DateTime.Now.Hour;
            if (hour < 12) lblGreeting.Text = "Good Morning";
            else if (hour < 18) lblGreeting.Text = "Good Afternoon";
            else lblGreeting.Text = "Good Evening";

            lblCurrentDate.Text = DateTime.Now.ToString("dddd, MMMM dd yyyy");
        }

        private void LoadPatientInfo()
        {
            int patientId = GetPatientId();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT TOP 1 FullName, Age, Height, Weight, BloodType, Gender,
                                        ChronicDisease, Disability, FamilyHistory
                                 FROM Patients WHERE PatientId = @PatientId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@PatientId", patientId);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblPatientName.Text = reader["FullName"].ToString();

                    lblAge.Text = reader["Age"] == DBNull.Value ? "-" : reader["Age"].ToString();
                    lblHeight.Text = reader["Height"] == DBNull.Value ? "-" : Convert.ToDouble(reader["Height"]).ToString("0");
                    lblWeight.Text = reader["Weight"] == DBNull.Value ? "-" : Convert.ToDouble(reader["Weight"]).ToString("0");
                    lblBloodType.Text = reader["BloodType"] == DBNull.Value ? "-" : reader["BloodType"].ToString();
                    lblGender.Text = reader["Gender"] == DBNull.Value ? "-" : reader["Gender"].ToString();
                    lblDisease.Text = reader["ChronicDisease"] == DBNull.Value ? "-" : reader["ChronicDisease"].ToString();
                    lblDisability.Text = reader["Disability"] == DBNull.Value ? "-" : reader["Disability"].ToString();
                    lblFamilyHistory.Text = reader["FamilyHistory"] == DBNull.Value ? "-" : reader["FamilyHistory"].ToString();

                    lblPatientStatus.Text = "Active";
                }
            }
        }

        private void LoadTodayDoses()
        {
            int patientId = GetPatientId();
            DateTime today = DateTime.Today;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        pm.PatientMedicationId AS DoseId,
                        ISNULL(m.name, pm.MedicineId) AS MedicineName,
                        pm.Dosage,
                        pm.Frequency AS Instructions,
                        pm.StartDate,
                        pm.EndDate,
                        CAST(0 AS BIT) AS IsTaken
                    FROM PatientMedications pm
                    LEFT JOIN Medicine m ON m.id = TRY_CAST(pm.MedicineId AS INT)
                    WHERE pm.PatientId = @PatientId
                      AND pm.Status = 'Active'
                    ORDER BY ISNULL(m.name, pm.MedicineId) ASC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@PatientId", patientId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                DataTable filtered = dt.Clone();
                foreach (DataRow row in dt.Rows)
                {
                    if (IsDoseDueToday(row, today))
                        filtered.ImportRow(row);
                }

                if (!filtered.Columns.Contains("Time"))
                    filtered.Columns.Add("Time", typeof(string));

                foreach (DataRow row in filtered.Rows)
                {
                    row["Time"] = row["Instructions"] == DBNull.Value
                        ? "-"
                        : row["Instructions"].ToString();
                }

                gvDoses.DataSource = filtered;
                gvDoses.DataBind();

                int total = filtered.Rows.Count;
                int taken = 0;
                foreach (DataRow row in filtered.Rows)
                {
                    if (Convert.ToBoolean(row["IsTaken"])) taken++;
                }

                lblDoseCount.Text = total.ToString();
            }
        }

        private void LoadDoctors()
        {
            int patientId = GetPatientId();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT d.DoctorId, d.FullName AS DoctorName, d.Speciality AS Specialty, c.Status
                    FROM PatientDoctorConnections c
                    INNER JOIN Doctors d ON d.DoctorId = c.DoctorId
                    WHERE c.PatientId = @PatientId
                    ORDER BY d.FullName ASC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@PatientId", patientId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvDoctors.DataSource = dt;
                gvDoctors.DataBind();
            }
        }

        private void LoadAppointments()
        {
            int patientId = GetPatientId();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        a.AppointmentId,
                        d.FullName AS DoctorName,
                        a.AppointmentDate,
                        a.Status,
                        a.Reason
                    FROM Appointments a
                    INNER JOIN Doctors d ON d.DoctorId = a.DoctorId
                    WHERE a.PatientId = @PatientId
                    ORDER BY a.AppointmentDate DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@PatientId", patientId);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvAppointments.DataSource = dt;
                gvAppointments.DataBind();
            }
        }

        protected void gvAppointments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "CancelAppointment")
            {
                int appointmentId = Convert.ToInt32(e.CommandArgument);
                CancelAppointment(appointmentId);
                LoadAppointments();
            }
        }

        private void CancelAppointment(int appointmentId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Update status to Cancelled, then notify the doctor.
                    // Notifications table uses CreatedAt (not Date).
                    string query = @"
                        DECLARE @DoctorId INT;
                        SELECT @DoctorId = DoctorId
                        FROM Appointments
                        WHERE AppointmentId = @AppointmentId;

                        UPDATE Appointments
                        SET Status = 'Cancelled'
                        WHERE AppointmentId = @AppointmentId;

                        IF @DoctorId IS NOT NULL
                        BEGIN
                            INSERT INTO Notifications (UserId, Title, Message, Type, IsRead)
                            SELECT UserId,
                                   'Appointment Cancelled',
                                   'A patient has cancelled their appointment.',
                                   'AppointmentCancelled',
                                   0
                            FROM Doctors
                            WHERE DoctorId = @DoctorId;
                        END";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@AppointmentId", appointmentId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (SqlException ex)
            {
                string errMsg = ex.Message.Replace("'", "\\'");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "errorAlert",
                    $"alert('SQL Error: {errMsg}');", true);
            }
        }

        protected void gvAppointments_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lblStatus = (Label)e.Row.FindControl("lblApptStatus");
                if (lblStatus != null)
                {
                    string status = lblStatus.Text.ToLower();
                    if (status == "accepted")
                        lblStatus.CssClass += " pd-status-accepted";
                    else if (status == "pending")
                        lblStatus.CssClass += " pd-status-pending";
                    else if (status == "rejected" || status == "cancelled")
                        lblStatus.CssClass += " pd-status-rejected";
                }
            }
        }

        protected void gvDoctors_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lbl = (Label)e.Row.FindControl("lblStatus");
                string status = lbl.Text.ToLower();
                if (status == "accepted") lbl.CssClass += " pd-doctor-status--accepted";
                else if (status == "pending") lbl.CssClass += " pd-doctor-status--pending";
                else if (status == "rejected") lbl.CssClass += " pd-doctor-status--rejected";
            }
        }

        private bool IsDoseDueToday(DataRow row, DateTime today)
        {
            string frequency = row["Instructions"] == DBNull.Value
                ? ""
                : row["Instructions"].ToString().Trim().ToLowerInvariant();

            DateTime? startDate = row["StartDate"] == DBNull.Value
                ? (DateTime?)null
                : Convert.ToDateTime(row["StartDate"]).Date;

            DateTime? endDate = row["EndDate"] == DBNull.Value
                ? (DateTime?)null
                : Convert.ToDateTime(row["EndDate"]).Date;

            if (startDate.HasValue && today < startDate.Value) return false;
            if (endDate.HasValue && today > endDate.Value) return false;

            if (frequency.Contains("weekly"))
            {
                if (!startDate.HasValue) return true;
                int daysSinceStart = (today - startDate.Value).Days;
                return daysSinceStart >= 0 && daysSinceStart % 7 == 0;
            }

            if (frequency.Contains("once daily") ||
                frequency.Contains("twice daily") ||
                frequency.Contains("every 8 hours"))
                return true;

            return true;
        }
    }
}