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
                    lblHeight.Text = reader["Height"] == DBNull.Value ? "-"
                        : Convert.ToDouble(reader["Height"]).ToString("0");
                    lblWeight.Text = reader["Weight"] == DBNull.Value ? "-"
                        : Convert.ToDouble(reader["Weight"]).ToString("0");
                    lblBloodType.Text = reader["BloodType"] == DBNull.Value ? "-" : reader["BloodType"].ToString();
                    lblGender.Text = reader["Gender"] == DBNull.Value ? "-" : reader["Gender"].ToString();
                    lblDisease.Text = reader["ChronicDisease"] == DBNull.Value ? "-"
                        : reader["ChronicDisease"].ToString();
                    lblDisability.Text = reader["Disability"] == DBNull.Value ? "-"
                        : reader["Disability"].ToString();
                    lblFamilyHistory.Text = reader["FamilyHistory"] == DBNull.Value ? "-"
                        : reader["FamilyHistory"].ToString();

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
            LEFT JOIN Medicine m
                ON m.id = TRY_CAST(pm.MedicineId AS INT)
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
                    {
                        filtered.ImportRow(row);
                    }
                }

                // add a Time column for the GridView if it expects it
                if (!filtered.Columns.Contains("Time"))
                {
                    filtered.Columns.Add("Time", typeof(string));
                }

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
                    if (Convert.ToBoolean(row["IsTaken"]))
                    {
                        taken++;
                    }
                }

                int percentage = 0;
                if (total > 0)
                {
                    percentage = (int)Math.Round((double)taken / total * 100);
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

            // Not started yet
            if (startDate.HasValue && today < startDate.Value)
            {
                return false;
            }

            // Already ended
            if (endDate.HasValue && today > endDate.Value)
            {
                return false;
            }

            // Weekly: show only once every 7 days starting from StartDate
            if (frequency.Contains("weekly"))
            {
                if (!startDate.HasValue)
                {
                    return true;
                }

                int daysSinceStart = (today - startDate.Value).Days;
                return daysSinceStart >= 0 && daysSinceStart % 7 == 0;
            }

            // Daily schedules: show every day in range
            if (frequency.Contains("once daily") ||
                frequency.Contains("twice daily") ||
                frequency.Contains("every 8 hours"))
            {
                return true;
            }

            // Fallback for unknown frequency
            return true;
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
    }
}