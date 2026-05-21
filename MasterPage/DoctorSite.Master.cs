using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MediCare.Pages.Doctor;

namespace MediCare.MasterPage
{
    public partial class DoctorSite : System.Web.UI.MasterPage
    {
        private string cs = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private SqlConnection GetConnection()
        {
            return new SqlConnection(cs);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DispNotifications();
            }
        }

        public void DispNotifications()
        {
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                ResetNotificationUI();
                return;
            }

            int doctorUserId = Convert.ToInt32(Session["UserId"]);
            int doctorId = GetDoctorIdByUserId(doctorUserId);

            if (doctorId == 0)
            {
                ResetNotificationUI();
                return;
            }

            DataTable displayTable = new DataTable();
            displayTable.Columns.Add("SourceId", typeof(int));
            displayTable.Columns.Add("ItemType", typeof(string));
            displayTable.Columns.Add("FullName", typeof(string));
            displayTable.Columns.Add("Initials", typeof(string));
            displayTable.Columns.Add("Title", typeof(string));
            displayTable.Columns.Add("Message", typeof(string));
            displayTable.Columns.Add("IconClass", typeof(string));
            displayTable.Columns.Add("TimeStamp", typeof(DateTime));
            displayTable.Columns.Add("TimeAgo", typeof(string));

            using (SqlConnection conn = GetConnection())
            {
                try
                {
                    conn.Open();

                    string connectionSql = @"
                        SELECT c.ConnectionId, p.FullName, c.RequestedAt
                        FROM PatientDoctorConnections c
                        INNER JOIN Patients p ON c.PatientId = p.PatientId
                        WHERE c.DoctorId = @DoctorId AND c.Status = 'Pending'";

                    using (SqlCommand cmd = new SqlCommand(connectionSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                DataRow row = displayTable.NewRow();
                                row["SourceId"] = reader["ConnectionId"];
                                row["ItemType"] = "Connection";
                                string name = reader["FullName"].ToString();
                                row["FullName"] = name;
                                row["Initials"] = GetInitials(name);
                                row["Title"] = "Connection Request";
                                row["Message"] = $"{name} sent you a patient connection request.";
                                row["IconClass"] = "fa-solid fa-user-plus text-primary";
                                DateTime reqDate = Convert.ToDateTime(reader["RequestedAt"]);
                                row["TimeStamp"] = reqDate;
                                row["TimeAgo"] = GetTimeAgo(reqDate);
                                displayTable.Rows.Add(row);
                            }
                        }
                    }

                    string appointmentSql = @"
                        SELECT a.AppointmentId, p.FullName, a.AppointmentDate
                        FROM Appointments a
                        INNER JOIN Patients p ON a.PatientId = p.PatientId
                        WHERE a.DoctorId = @DoctorId AND a.Status = 'Pending'";

                    using (SqlCommand cmd = new SqlCommand(appointmentSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                DataRow row = displayTable.NewRow();
                                row["SourceId"] = reader["AppointmentId"];
                                row["ItemType"] = "Appointment";
                                string name = reader["FullName"].ToString();
                                row["FullName"] = name;
                                row["Initials"] = GetInitials(name);
                                row["Title"] = "Appointment Query";
                                DateTime appDate = Convert.ToDateTime(reader["AppointmentDate"]);
                                row["Message"] = $"{name} requested a booking slot for {appDate:yyyy-MM-dd HH:mm}.";
                                row["IconClass"] = "fa-solid fa-calendar-days text-warning";
                                row["TimeStamp"] = appDate;
                                row["TimeAgo"] = "Pending review";
                                displayTable.Rows.Add(row);
                            }
                        }
                    }
                }
                catch (Exception)
                {
                }
            }

            DataView view = displayTable.DefaultView;
            view.Sort = "TimeStamp DESC";
            DataTable sortedTable = view.ToTable();

            rptNotifications.DataSource = sortedTable;
            rptNotifications.DataBind();

            litNotifCount.Text = sortedTable.Rows.Count.ToString();
            pnlNoNotifications.Visible = (sortedTable.Rows.Count == 0);
        }

        private void ResetNotificationUI()
        {
            litNotifCount.Text = "0";
            pnlNoNotifications.Visible = true;
            rptNotifications.DataSource = null;
            rptNotifications.DataBind();
        }

        protected void rptNotifications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int targetId = Convert.ToInt32(e.CommandArgument);
            string command = e.CommandName;

            if (command == "AcceptConnection")
            {
                UpdateConnectionStatus(targetId, "Accepted");
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Connection accepted successfully.');", true);
            }
            else if (command == "RejectConnection")
            {
                UpdateConnectionStatus(targetId, "Rejected");
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Connection request declined.');", true);
            }
            else if (command == "AcceptAppointment")
            {
                UpdateAppointmentStatus(targetId, "Accepted");
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Appointment accepted successfully.');", true);
            }
            else if (command == "RejectAppointment")
            {
                UpdateAppointmentStatus(targetId, "Rejected");
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Appointment query declined.');", true);
            }

            DispNotifications();

            if (Page is Dashboard dashboardPage)
            {
                dashboardPage.Response.Redirect(Request.RawUrl);
            }
        }

        private void UpdateConnectionStatus(int connectionId, string status)
        {
            using (SqlConnection conn = GetConnection())
            {
                string sql = "UPDATE PatientDoctorConnections SET Status = @Status, RespondedAt = GETDATE() WHERE ConnectionId = @Id";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@Id", connectionId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private void UpdateAppointmentStatus(int appointmentId, string status)
        {
            using (SqlConnection conn = GetConnection())
            {
                string sql = "UPDATE Appointments SET Status = @Status WHERE AppointmentId = @Id";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@Id", appointmentId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private int GetDoctorIdByUserId(int userId)
        {
            using (SqlConnection conn = GetConnection())
            {
                string sql = "SELECT DoctorId FROM Doctors WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value) return Convert.ToInt32(result);
                }
            }
            return 0;
        }

        private string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "?";
            string[] parts = fullName.Trim().Split(' ');
            if (parts.Length == 1) return parts[0].Substring(0, 1).ToUpper();
            return (parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1)).ToUpper();
        }

        private string GetTimeAgo(DateTime dateTime)
        {
            TimeSpan span = DateTime.Now - dateTime;
            if (span.TotalMinutes < 1) return "Just now";
            if (span.TotalMinutes < 60) return Convert.ToInt32(span.TotalMinutes) + " min ago";
            if (span.TotalHours < 24) return Convert.ToInt32(span.TotalHours) + " h ago";
            if (span.TotalDays < 7) return Convert.ToInt32(span.TotalDays) + " day(s) ago";
            return dateTime.ToString("dd MMM yyyy");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Pages/Account/Login.aspx");
        }
    }
}