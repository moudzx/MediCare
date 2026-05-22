using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Doctor
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private readonly string _conn = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null || Session["Role"].ToString() != "Doctor")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
                BindAll();
        }

        private int GetDoctorId(SqlConnection conn)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            using (var cmd = new SqlCommand(
                "SELECT DoctorId FROM [dbo].[Doctors] WHERE UserId = @uid", conn))
            {
                cmd.Parameters.AddWithValue("@uid", userId);
                var r = cmd.ExecuteScalar();
                return (r != null && r != DBNull.Value) ? Convert.ToInt32(r) : 0;
            }
        }

        private void BindAll()
        {
            using (var conn = new SqlConnection(_conn))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    BindPending(conn, doctorId);
                    BindAccepted(conn, doctorId);
                    BindSlots(conn, doctorId);
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading dashboard: " + ex.Message, true);
                }
            }
        }

        private void BindPending(SqlConnection conn, int doctorId)
        {
            const string sql = @"
                SELECT a.AppointmentId, a.AppointmentDate, a.Reason, p.FullName AS PatientName
                FROM [dbo].[Appointments] a
                INNER JOIN [dbo].[Patients] p ON a.PatientId = p.PatientId
                WHERE a.DoctorId = @did AND a.Status = 'Pending'
                ORDER BY a.AppointmentDate ASC";

            var dt = FillTable(conn, sql, ("@did", doctorId));
            rptPending.DataSource = dt;
            rptPending.DataBind();
            pnlNoPending.Visible = (dt.Rows.Count == 0);
        }

        private void BindAccepted(SqlConnection conn, int doctorId)
        {
            const string sql = @"
                SELECT a.AppointmentId, a.AppointmentDate, a.Status, p.FullName AS PatientName
                FROM [dbo].[Appointments] a
                INNER JOIN [dbo].[Patients] p ON a.PatientId = p.PatientId
                WHERE a.DoctorId = @did AND a.Status = 'Accepted'
                ORDER BY a.AppointmentDate ASC";

            var dt = FillTable(conn, sql, ("@did", doctorId));
            rptAccepted.DataSource = dt;
            rptAccepted.DataBind();
            pnlNoAccepted.Visible = (dt.Rows.Count == 0);
        }

        private void BindSlots(SqlConnection conn, int doctorId)
        {
            const string sql = @"
                SELECT AvailabilityId, StartTime, EndTime
                FROM [dbo].[DoctorAvailability]
                WHERE DoctorId = @did
                ORDER BY StartTime ASC";

            var dt = FillTable(conn, sql, ("@did", doctorId));
            rptSlots.DataSource = dt;
            rptSlots.DataBind();
            pnlNoSlots.Visible = (dt.Rows.Count == 0);
        }

        private static DataTable FillTable(SqlConnection conn, string sql,
            params (string name, object value)[] parms)
        {
            using (var cmd = new SqlCommand(sql, conn))
            {
                foreach (var (name, value) in parms)
                    cmd.Parameters.AddWithValue(name, value);

                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
        }

        protected void rptPending_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int appointmentId = Convert.ToInt32(e.CommandArgument);
            bool accept = (e.CommandName == "Accept");
            string newStatus = accept ? "Accepted" : "Rejected";
            string notifType = accept ? "AppointmentAccepted" : "AppointmentRejected";

            using (var conn = new SqlConnection(_conn))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);

                    Execute(conn,
                        "UPDATE [dbo].[Appointments] SET Status = @s WHERE AppointmentId = @aid AND DoctorId = @did",
                        ("@s", newStatus), ("@aid", appointmentId), ("@did", doctorId));

                    if (accept)
                    {
                        DateTime appDate = GetAppointmentDate(conn, appointmentId);
                        if (appDate != DateTime.MinValue)
                        {
                            Execute(conn,
                                @"DELETE FROM [dbo].[DoctorAvailability]
                                  WHERE DoctorId = @did AND StartTime = @start AND EndTime = @end",
                                ("@did", doctorId),
                                ("@start", appDate),
                                ("@end", appDate.AddHours(1)));
                        }
                    }

                    var (patUserId, appTime) = GetAppointmentContext(conn, appointmentId);
                    if (patUserId > 0)
                    {
                        string msg = $"Your appointment for {appTime:yyyy-MM-dd HH:mm} has been {newStatus.ToLower()} by your doctor.";
                        InsertNotification(conn, patUserId, notifType,
                            $"Appointment {newStatus}", msg);
                    }

                    BindAll();
                    ShowAlert($"Appointment {newStatus.ToLower()} successfully.", false);
                }
                catch (Exception ex)
                {
                    ShowAlert("Error processing request: " + ex.Message, true);
                }
            }
        }

        protected void rptAccepted_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
                CancelAppointment(Convert.ToInt32(e.CommandArgument));
        }

        private void CancelAppointment(int appointmentId)
        {
            using (var conn = new SqlConnection(_conn))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);

                    var (patUserId, appTime) = GetAppointmentContext(conn, appointmentId);

                    Execute(conn,
                        "UPDATE [dbo].[Appointments] SET Status = 'Cancelled' WHERE AppointmentId = @aid AND DoctorId = @did",
                        ("@aid", appointmentId), ("@did", doctorId));

                    if (patUserId > 0)
                    {
                        string msg = $"Your appointment on {appTime:yyyy-MM-dd HH:mm} has been cancelled by your doctor.";
                        InsertNotification(conn, patUserId, "AppointmentCancelled",
                            "Appointment Cancelled", msg);
                    }

                    BindAll();
                    ShowAlert("Appointment cancelled and patient notified.", false);
                }
                catch (Exception ex)
                {
                    ShowAlert("Error cancelling appointment: " + ex.Message, true);
                }
            }
        }


        protected void btnGenerateRange_Click(object sender, EventArgs e)
        {
            string fromText = txtRangeFromDate.Text.Trim();
            string toText = txtRangeToDate.Text.Trim();
            string startText = txtRangeStartTime.Text.Trim();
            string endText = txtRangeEndTime.Text.Trim();

            if (!DateTime.TryParse(fromText, out DateTime fromDate) ||
                !DateTime.TryParse(toText, out DateTime toDate) ||
                !TimeSpan.TryParse(startText, out TimeSpan startTs) ||
                !TimeSpan.TryParse(endText, out TimeSpan endTs))
            {
                ShowAlert("Please fill in all four fields with valid date and time values.", true);
                return;
            }

            if (fromDate > toDate)
            {
                ShowAlert("'From Date' must be before or equal to 'To Date'.", true);
                return;
            }

            if (startTs >= endTs)
            {
                ShowAlert("Start time must be before end time.", true);
                return;
            }

            bool includeWeekends = chkIncludeWeekends.Checked;

            using (var conn = new SqlConnection(_conn))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    int added = 0;

                    for (DateTime day = fromDate.Date; day <= toDate.Date; day = day.AddDays(1))
                    {
                        if (!includeWeekends &&
                            (day.DayOfWeek == DayOfWeek.Saturday || day.DayOfWeek == DayOfWeek.Sunday))
                            continue;

                        DateTime cursor = day.Add(startTs);
                        DateTime dayEnd = day.Add(endTs);

                        while (cursor.AddHours(1) <= dayEnd)
                        {
                            DateTime blockEnd = cursor.AddHours(1);

                            if (!SlotExists(conn, doctorId, cursor))
                            {
                                Execute(conn,
                                    "INSERT INTO [dbo].[DoctorAvailability] (DoctorId, StartTime, EndTime) VALUES (@did, @s, @e)",
                                    ("@did", doctorId), ("@s", cursor), ("@e", blockEnd));
                                added++;
                            }

                            cursor = blockEnd;
                        }
                    }

                    BindAll();
                    ShowAlert($"{added} slot(s) generated successfully.", false);
                }
                catch (Exception ex)
                {
                    ShowAlert("Error generating slots: " + ex.Message, true);
                }
            }
        }

        protected void btnAddSpecific_Click(object sender, EventArgs e)
        {
            if (!DateTime.TryParse(txtSpecificDate.Text.Trim(), out DateTime date) ||
                !TimeSpan.TryParse(txtSpecificHour.Text.Trim(), out TimeSpan hour))
            {
                ShowAlert("Please enter a valid date and time.", true);
                return;
            }

            DateTime slotStart = date.Date.Add(hour);
            DateTime slotEnd = slotStart.AddHours(1);

            using (var conn = new SqlConnection(_conn))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    if (SlotExists(conn, doctorId, slotStart))
                    {
                        ShowAlert($"A slot already exists for {slotStart:yyyy-MM-dd HH:mm}.", true);
                        return;
                    }

                    Execute(conn,
                        "INSERT INTO [dbo].[DoctorAvailability] (DoctorId, StartTime, EndTime) VALUES (@did, @s, @e)",
                        ("@did", doctorId), ("@s", slotStart), ("@e", slotEnd));

                    txtSpecificDate.Text = "";
                    txtSpecificHour.Text = "";
                    BindAll();
                    ShowAlert($"Slot added: {slotStart:ddd, MMM dd yyyy HH:mm} – {slotEnd:HH:mm}.", false);
                }
                catch (Exception ex)
                {
                    ShowAlert("Error adding slot: " + ex.Message, true);
                }
            }
        }

        protected void btnDropSlot_Click(object sender, EventArgs e)
        {
            if (!DateTime.TryParse(txtDropDate.Text.Trim(), out DateTime date) ||
                !TimeSpan.TryParse(txtDropHour.Text.Trim(), out TimeSpan hour))
            {
                ShowAlert("Please enter a valid date and time to remove.", true);
                return;
            }

            DateTime slotStart = date.Date.Add(hour);
            DateTime slotEnd = slotStart.AddHours(1);

            using (var conn = new SqlConnection(_conn))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    // Delete availability slot
                    Execute(conn,
                        "DELETE FROM [dbo].[DoctorAvailability] WHERE DoctorId = @did AND StartTime = @s AND EndTime = @e",
                        ("@did", doctorId), ("@s", slotStart), ("@e", slotEnd));

                    // Cancel any active booking in this slot
                    int bookedId = GetConflictingAppointment(conn, doctorId, slotStart);
                    bool hadBooking = bookedId > 0;

                    if (hadBooking)
                    {
                        var (patUserId, appTime) = GetAppointmentContext(conn, bookedId);

                        Execute(conn,
                            "UPDATE [dbo].[Appointments] SET Status = 'Cancelled' WHERE AppointmentId = @aid",
                            ("@aid", bookedId));

                        if (patUserId > 0)
                        {
                            string msg = $"Your appointment on {appTime:yyyy-MM-dd HH:mm} has been cancelled because the doctor removed that time slot.";
                            InsertNotification(conn, patUserId, "AppointmentCancelled",
                                "Appointment Cancelled", msg);
                        }
                    }

                    txtDropDate.Text = "";
                    txtDropHour.Text = "";
                    BindAll();

                    ShowAlert(
                        hadBooking
                            ? $"Slot removed and existing booking for {slotStart:yyyy-MM-dd HH:mm} was cancelled. Patient notified."
                            : $"Open slot for {slotStart:yyyy-MM-dd HH:mm} removed.",
                        false);
                }
                catch (Exception ex)
                {
                    ShowAlert("Error removing slot: " + ex.Message, true);
                }
            }
        }


        protected void rptSlots_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "Delete") return;

            int availabilityId = Convert.ToInt32(e.CommandArgument);

            using (var conn = new SqlConnection(_conn))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);

                    Execute(conn,
                        "DELETE FROM [dbo].[DoctorAvailability] WHERE AvailabilityId = @aid AND DoctorId = @did",
                        ("@aid", availabilityId), ("@did", doctorId));

                    BindAll();
                    ShowAlert("Availability slot removed.", false);
                }
                catch (Exception ex)
                {
                    ShowAlert("Error removing slot: " + ex.Message, true);
                }
            }
        }

        private bool SlotExists(SqlConnection conn, int doctorId, DateTime slotStart)
        {
            using (var cmd = new SqlCommand(
                "SELECT COUNT(1) FROM [dbo].[DoctorAvailability] WHERE DoctorId = @did AND StartTime = @s",
                conn))
            {
                cmd.Parameters.AddWithValue("@did", doctorId);
                cmd.Parameters.AddWithValue("@s", slotStart);
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        private int GetConflictingAppointment(SqlConnection conn, int doctorId, DateTime slotStart)
        {
            using (var cmd = new SqlCommand(
                @"SELECT TOP 1 AppointmentId FROM [dbo].[Appointments]
                  WHERE DoctorId = @did AND AppointmentDate = @s
                    AND Status IN ('Pending','Accepted')",
                conn))
            {
                cmd.Parameters.AddWithValue("@did", doctorId);
                cmd.Parameters.AddWithValue("@s", slotStart);
                var r = cmd.ExecuteScalar();
                return (r != null && r != DBNull.Value) ? Convert.ToInt32(r) : 0;
            }
        }

        private DateTime GetAppointmentDate(SqlConnection conn, int appointmentId)
        {
            using (var cmd = new SqlCommand(
                "SELECT AppointmentDate FROM [dbo].[Appointments] WHERE AppointmentId = @aid",
                conn))
            {
                cmd.Parameters.AddWithValue("@aid", appointmentId);
                var r = cmd.ExecuteScalar();
                return (r != null && r != DBNull.Value) ? Convert.ToDateTime(r) : DateTime.MinValue;
            }
        }

        private (int patUserId, DateTime appTime) GetAppointmentContext(SqlConnection conn, int appointmentId)
        {
            using (var cmd = new SqlCommand(
                @"SELECT p.UserId, a.AppointmentDate
                  FROM [dbo].[Appointments] a
                  INNER JOIN [dbo].[Patients] p ON a.PatientId = p.PatientId
                  WHERE a.AppointmentId = @aid",
                conn))
            {
                cmd.Parameters.AddWithValue("@aid", appointmentId);
                using (var r = cmd.ExecuteReader())
                {
                    if (r.Read())
                        return (Convert.ToInt32(r["UserId"]), Convert.ToDateTime(r["AppointmentDate"]));
                }
            }

            return (0, DateTime.MinValue);
        }

        private static void InsertNotification(SqlConnection conn, int userId,
            string type, string title, string message)
        {
            Execute(conn,
                @"INSERT INTO [dbo].[Notifications] (UserId, Type, Title, Message, IsRead, CreatedAt)
                  VALUES (@uid, @type, @title, @msg, 0, GETDATE())",
                ("@uid", userId), ("@type", type), ("@title", title), ("@msg", message));
        }

        private static void Execute(SqlConnection conn, string sql,
            params (string name, object value)[] parms)
        {
            using (var cmd = new SqlCommand(sql, conn))
            {
                foreach (var (name, value) in parms)
                    cmd.Parameters.AddWithValue(name, value);
                cmd.ExecuteNonQuery();
            }
        }


        private void ShowAlert(string message, bool isError)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = isError ? "alert alert-error" : "alert alert-success";
            alertIcon.Attributes["class"] = isError
                ? "fa-solid fa-triangle-exclamation"
                : "fa-solid fa-circle-check";
            lblAlert.Text = message;
        }
    }
}