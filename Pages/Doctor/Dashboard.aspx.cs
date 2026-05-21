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
        private readonly string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null || Session["Role"].ToString() != "Doctor")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                RefreshDashboardDataPipelines();
            }
        }

        private int GetDoctorId(SqlConnection conn)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string sql = "SELECT DoctorId FROM [dbo].[Doctors] WHERE UserId = @UserId";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value) return Convert.ToInt32(result);
            }
            return 0;
        }

        private void RefreshDashboardDataPipelines()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    string sqlPending = @"
                        SELECT a.AppointmentId, a.AppointmentDate, a.Reason, p.FullName as PatientName
                        FROM [dbo].[Appointments] a
                        INNER JOIN [dbo].[Patients] p ON a.PatientId = p.PatientId
                        WHERE a.DoctorId = @DoctorId AND a.Status = 'Pending'
                        ORDER BY a.AppointmentDate ASC";

                    using (SqlCommand cmd = new SqlCommand(sqlPending, conn))
                    {
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            rptIncomingRequests.DataSource = dt;
                            rptIncomingRequests.DataBind();
                            pnlNoRequests.Visible = (dt.Rows.Count == 0);
                        }
                    }

                    string sqlReserved = @"
                        SELECT a.AppointmentId, a.AppointmentDate, a.Status, p.FullName as PatientName
                        FROM [dbo].[Appointments] a
                        INNER JOIN [dbo].[Patients] p ON a.PatientId = p.PatientId
                        WHERE a.DoctorId = @DoctorId AND a.Status = 'Accepted'
                        ORDER BY a.AppointmentDate ASC";

                    using (SqlCommand cmd = new SqlCommand(sqlReserved, conn))
                    {
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            rptReservedAppointments.DataSource = dt;
                            rptReservedAppointments.DataBind();
                            pnlNoReserved.Visible = (dt.Rows.Count == 0);
                        }
                    }

                    string sqlOpen = @"
                        SELECT AvailabilityId, StartTime, EndTime 
                        FROM [dbo].[DoctorAvailability]
                        WHERE DoctorId = @DoctorId 
                        ORDER BY StartTime ASC";

                    using (SqlCommand cmd = new SqlCommand(sqlOpen, conn))
                    {
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            rptAvailabilityBlocks.DataSource = dt;
                            rptAvailabilityBlocks.DataBind();
                            pnlNoAvailability.Visible = (dt.Rows.Count == 0);
                        }
                    }
                }
                catch (Exception ex)
                {
                    DisplayAlert("Fault loading dashboard pipelines: " + ex.Message, true);
                }
            }
        }

        protected void rptIncomingRequests_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int appointmentId = Convert.ToInt32(e.CommandArgument);
            string targetStatus = (e.CommandName == "AcceptRequest") ? "Accepted" : "Rejected";
            string notificationType = (e.CommandName == "AcceptRequest") ? "AppointmentAccepted" : "AppointmentRejected";

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);

                    string updateSql = "UPDATE [dbo].[Appointments] SET Status = @Status WHERE AppointmentId = @AppointmentId AND DoctorId = @DoctorId";
                    using (SqlCommand cmd = new SqlCommand(updateSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", targetStatus);
                        cmd.Parameters.AddWithValue("@AppointmentId", appointmentId);
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        cmd.ExecuteNonQuery();
                    }

                    int patientUserId = 0;
                    DateTime appointmentTime = DateTime.Now;
                    using (SqlCommand cmdContext = new SqlCommand("SELECT p.UserId, a.AppointmentDate FROM [dbo].[Appointments] a INNER JOIN [dbo].[Patients] p ON a.PatientId = p.PatientId WHERE a.AppointmentId = @Id", conn))
                    {
                        cmdContext.Parameters.AddWithValue("@Id", appointmentId);
                        using (SqlDataReader r = cmdContext.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                patientUserId = Convert.ToInt32(r["UserId"]);
                                appointmentTime = Convert.ToDateTime(r["AppointmentDate"]);
                            }
                        }
                    }

                    if (patientUserId > 0)
                    {
                        string msg = $"Your scheduled appointment for {appointmentTime:yyyy-MM-dd HH:mm} has been {targetStatus.ToLower()} by your doctor.";
                        string alertSql = "INSERT INTO [dbo].[Notifications] (UserId, Type, Title, Message, IsRead, CreatedAt) VALUES (@UserId, @Type, @Title, @Message, 0, GETDATE())";
                        using (SqlCommand cmdAlert = new SqlCommand(alertSql, conn))
                        {
                            cmdAlert.Parameters.AddWithValue("@UserId", patientUserId);
                            cmdAlert.Parameters.AddWithValue("@Type", notificationType);
                            cmdAlert.Parameters.AddWithValue("@Title", $"Appointment Request {targetStatus}");
                            cmdAlert.Parameters.AddWithValue("@Message", msg);
                            cmdAlert.ExecuteNonQuery();
                        }
                    }

                    RefreshDashboardDataPipelines();
                    DisplayAlert($"Appointment request successfully updated to: {targetStatus}.", false);
                }
                catch (Exception ex)
                {
                    DisplayAlert("Pipeline Transaction Fault: " + ex.Message, true);
                }
            }
        }

        protected void rptReservedAppointments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "CancelBooking")
            {
                int appointmentId = Convert.ToInt32(e.CommandArgument);
                CancelAndNotifyIndividualAppointment(appointmentId);
            }
        }

        private void CancelAndNotifyIndividualAppointment(int appointmentId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);

                    int patientUserId = 0;
                    DateTime appTime = DateTime.Now;
                    string contextSql = "SELECT p.UserId, a.AppointmentDate FROM [dbo].[Appointments] a INNER JOIN [dbo].[Patients] p ON a.PatientId = p.PatientId WHERE a.AppointmentId = @Id AND a.DoctorId = @DocId";

                    using (SqlCommand cmdCtx = new SqlCommand(contextSql, conn))
                    {
                        cmdCtx.Parameters.AddWithValue("@Id", appointmentId);
                        cmdCtx.Parameters.AddWithValue("@DocId", doctorId);
                        using (SqlDataReader r = cmdCtx.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                patientUserId = Convert.ToInt32(r["UserId"]);
                                appTime = Convert.ToDateTime(r["AppointmentDate"]);
                            }
                        }
                    }

                    string cancelSql = "UPDATE [dbo].[Appointments] SET Status = 'Cancelled' WHERE AppointmentId = @AppointmentId AND DoctorId = @DoctorId";
                    using (SqlCommand cmd = new SqlCommand(cancelSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@AppointmentId", appointmentId);
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        cmd.ExecuteNonQuery();
                    }

                    if (patientUserId > 0)
                    {
                        string msg = $"CRITICAL UPDATE: Your scheduled booking on {appTime:yyyy-MM-dd HH:mm} has been cancelled by the physician due to direct schedule adjustments.";
                        string notifySql = "INSERT INTO [dbo].[Notifications] (UserId, Type, Title, Message, IsRead, CreatedAt) VALUES (@UserId, 'AppointmentCancelled', 'Booking Cancelled By Doctor', @Message, 0, GETDATE())";
                        using (SqlCommand cmdNotify = new SqlCommand(notifySql, conn))
                        {
                            cmdNotify.Parameters.AddWithValue("@UserId", patientUserId);
                            cmdNotify.Parameters.AddWithValue("@Message", msg);
                            cmdNotify.ExecuteNonQuery();
                        }
                    }

                    RefreshDashboardDataPipelines();
                    DisplayAlert("Appointment successfully dropped and patient alerted.", false);
                }
                catch (Exception ex)
                {
                    DisplayAlert("Error executing cancellation chain: " + ex.Message, true);
                }
            }
        }

        protected void btnGenerateRecurring_Click(object sender, EventArgs e)
        {
            pnlGlobalAlert.Visible = false;

            if (string.IsNullOrEmpty(txtStartTime.Text) || string.IsNullOrEmpty(txtEndTime.Text))
            {
                DisplayAlert("Please define both Start and End parameters for availability generation.", true);
                return;
            }

            TimeSpan rawStart = TimeSpan.Parse(txtStartTime.Text);
            TimeSpan rawEnd = TimeSpan.Parse(txtEndTime.Text);

            if (rawStart >= rawEnd)
            {
                DisplayAlert("Shift Start Time must precede its corresponding End Time parameter.", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    int totalSlotsAdded = 0;
                    DateTime horizonBase = DateTime.Today;

                    for (int dayOffset = 0; dayOffset < 30; dayOffset++)
                    {
                        DateTime processingDate = horizonBase.AddDays(dayOffset);

                        if (processingDate.DayOfWeek == DayOfWeek.Saturday || processingDate.DayOfWeek == DayOfWeek.Sunday)
                        {
                            continue;
                        }

                        DateTime shiftCursor = processingDate.Add(rawStart);
                        DateTime shiftTerminator = processingDate.Add(rawEnd);

                        while (shiftCursor.AddHours(1) <= shiftTerminator)
                        {
                            DateTime blockStart = shiftCursor;
                            DateTime blockEnd = shiftCursor.AddHours(1);

                            string insertSql = @"
                                INSERT INTO [dbo].[DoctorAvailability] (DoctorId, StartTime, EndTime) 
                                VALUES (@DoctorId, @StartTime, @EndTime)";

                            using (SqlCommand cmd = new SqlCommand(insertSql, conn))
                            {
                                cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                                cmd.Parameters.AddWithValue("@StartTime", blockStart);
                                cmd.Parameters.AddWithValue("@EndTime", blockEnd);
                                cmd.ExecuteNonQuery();
                            }

                            totalSlotsAdded++;
                            shiftCursor = shiftCursor.AddHours(1);
                        }
                    }

                    RefreshDashboardDataPipelines();
                    DisplayAlert($"Successfully published {totalSlotsAdded} hourly open slots across all weekdays for the next 30 days.", false);
                }
                catch (Exception ex)
                {
                    DisplayAlert("Generation Pipeline Exception Error: " + ex.Message, true);
                }
            }
        }

        protected void btnCancelSpecificHour_Click(object sender, EventArgs e)
        {
            pnlGlobalAlert.Visible = false;
            string dateText = txtSpecificDay.Text.Trim();
            string hourText = txtSpecificHour.Text.Trim();

            if (string.IsNullOrEmpty(dateText) || string.IsNullOrEmpty(hourText) ||
                !DateTime.TryParse(dateText, out DateTime parsedDate) || !TimeSpan.TryParse(hourText, out TimeSpan parsedHour))
            {
                DisplayAlert("Please input a valid date and a structured hour timestamp to drop.", true);
                return;
            }


            DateTime blockStart = parsedDate.Date.Add(parsedHour);
            DateTime blockEnd = blockStart.AddHours(1);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    string deleteAvailabilitySql = @"
                        DELETE FROM [dbo].[DoctorAvailability] 
                        WHERE DoctorId = @DoctorId AND StartTime = @Start AND EndTime = @End";

                    using (SqlCommand cmdDelAvail = new SqlCommand(deleteAvailabilitySql, conn))
                    {
                        cmdDelAvail.Parameters.AddWithValue("@DoctorId", doctorId);
                        cmdDelAvail.Parameters.AddWithValue("@Start", blockStart);
                        cmdDelAvail.Parameters.AddWithValue("@End", blockEnd);
                        cmdDelAvail.ExecuteNonQuery();
                    }

                    string findBookingSql = @"
                        SELECT AppointmentId 
                        FROM [dbo].[Appointments] 
                        WHERE DoctorId = @DoctorId 
                          AND AppointmentDate = @Start 
                          AND Status IN ('Pending', 'Accepted')";

                    int conflictingAppointmentId = 0;
                    using (SqlCommand cmdFind = new SqlCommand(findBookingSql, conn))
                    {
                        cmdFind.Parameters.AddWithValue("@DoctorId", doctorId);
                        cmdFind.Parameters.AddWithValue("@Start", blockStart);
                        object res = cmdFind.ExecuteScalar();
                        if (res != null && res != DBNull.Value)
                        {
                            conflictingAppointmentId = Convert.ToInt32(res);
                        }
                    }

                    bool appointmentWasCancelled = false;

                    if (conflictingAppointmentId > 0)
                    {
                        CancelAndNotifyIndividualAppointment(conflictingAppointmentId);
                        appointmentWasCancelled = true;
                    }

                    txtSpecificDay.Text = "";
                    txtSpecificHour.Text = "";
                    RefreshDashboardDataPipelines();

                    if (appointmentWasCancelled)
                    {
                        DisplayAlert($"Surgical adjustment completed: The open slot was withdrawn, and the active booking for {blockStart:yyyy-MM-dd HH:mm} was canceled and the patient was notified.", false);
                    }
                    else
                    {
                        DisplayAlert($"Surgical adjustment completed: The unreserved open window for {blockStart:yyyy-MM-dd HH:mm} was successfully removed.", false);
                    }
                }
                catch (Exception ex)
                {
                    DisplayAlert("Surgical operation pipeline faulted: " + ex.Message, true);
                }
            }
        }

        protected void rptAvailabilityBlocks_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteBlock")
            {
                int availabilityId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    try
                    {
                        conn.Open();
                        int doctorId = GetDoctorId(conn);

                        string deleteSql = "DELETE FROM [dbo].[DoctorAvailability] WHERE AvailabilityId = @AvailabilityId AND DoctorId = @DoctorId";
                        using (SqlCommand cmd = new SqlCommand(deleteSql, conn))
                        {
                            cmd.Parameters.AddWithValue("@AvailabilityId", availabilityId);
                            cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                            cmd.ExecuteNonQuery();
                        }

                        RefreshDashboardDataPipelines();
                        DisplayAlert("Availability block matrix entry safely revoked.", false);
                    }
                    catch (Exception ex)
                    {
                        DisplayAlert("Error deleting block element: " + ex.Message, true);
                    }
                }
            }
        }

        private void DisplayAlert(string message, bool isError)
        {
            pnlGlobalAlert.Visible = true;
            pnlGlobalAlert.CssClass = isError ? "db-alert db-alert--error" : "db-alert db-alert--success";
            alertIcon.Attributes["class"] = isError ? "fa-solid fa-triangle-exclamation" : "fa-solid fa-circle-check";
            lblAlertMessage.Text = message;
        }
    }
}