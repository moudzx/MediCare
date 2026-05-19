using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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
                litNotifCount.Text = "0";
                pnlNoNotifications.Visible = true;
                rptNotifications.DataSource = null;
                rptNotifications.DataBind();
                return;
            }

            int doctorUserId = Convert.ToInt32(Session["UserId"]);
            int doctorId = GetDoctorIdByUserId(doctorUserId);

            if (doctorId == 0)
            {
                litNotifCount.Text = "0";
                pnlNoNotifications.Visible = true;
                rptNotifications.DataSource = null;
                rptNotifications.DataBind();
                return;
            }

            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = @"
                                    SELECT 
                                        c.ConnectionId,
                                        p.FullName,
                                        p.Gender,
                                        p.Age,
                                        c.RequestedAt
                                    FROM PatientDoctorConnections c
                                    INNER JOIN Patients p ON c.PatientId = p.PatientId
                                    WHERE c.DoctorId = @DoctorId
                                    AND c.Status = 'Pending'
                                    ORDER BY c.RequestedAt DESC";

                cmd.Parameters.AddWithValue("@DoctorId", doctorId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                dt.Columns.Add("Initials");
                dt.Columns.Add("Title");
                dt.Columns.Add("Message");
                dt.Columns.Add("TimeAgo");

                foreach (DataRow row in dt.Rows)
                {
                    row["Initials"] = GetInitials(row["FullName"].ToString());
                    row["Title"] = "Connection request";
                    row["Message"] = row["FullName"].ToString() + " sent you a connection request.";
                    row["TimeAgo"] = GetTimeAgo(Convert.ToDateTime(row["RequestedAt"]));
                }

                rptNotifications.DataSource = dt;
                rptNotifications.DataBind();

                litNotifCount.Text = dt.Rows.Count.ToString();

                if (dt.Rows.Count == 0)
                {
                    pnlNoNotifications.Visible = true;
                }
                else
                {
                    pnlNoNotifications.Visible = false;
                }

                cmd.Dispose();
                conn.Close();
            }
        }

        protected void rptNotifications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int connectionId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "AcceptConnection")
            {
                UpdateRequestStatus(connectionId, "Accepted");
                Response.Write("<script>alert('Connection accepted successfully')</script>");
            }
            else if (e.CommandName == "RejectConnection")
            {
                UpdateRequestStatus(connectionId, "Rejected");
                Response.Write("<script>alert('Connection rejected successfully')</script>");
            }

            DispNotifications();
        }

        private void UpdateRequestStatus(int connectionId, string status)
        {
            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = @"
                                    UPDATE PatientDoctorConnections
                                    SET Status = @Status,
                                        RespondedAt = GETDATE()
                                    WHERE ConnectionId = @ConnectionId";

                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@ConnectionId", connectionId);

                cmd.ExecuteNonQuery();

                cmd.Dispose();
                conn.Close();
            }
        }

        private int GetDoctorIdByUserId(int userId)
        {
            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                SqlCommand cmd = conn.CreateCommand();
                cmd.CommandType = CommandType.Text;
                cmd.CommandText = "SELECT DoctorId FROM Doctors WHERE UserId = @UserId";
                cmd.Parameters.AddWithValue("@UserId", userId);

                object result = cmd.ExecuteScalar();

                cmd.Dispose();
                conn.Close();

                if (result != null && result != DBNull.Value)
                {
                    return Convert.ToInt32(result);
                }
            }
            return 0;
        }

        private string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName))
            {
                return "?";
            }

            string[] parts = fullName.Trim().Split(' ');

            if (parts.Length == 1)
            {
                return parts[0].Substring(0, 1).ToUpper();
            }

            return (
                parts[0].Substring(0, 1) +
                parts[parts.Length - 1].Substring(0, 1)
            ).ToUpper();
        }

        private string GetTimeAgo(DateTime dateTime)
        {
            TimeSpan span = DateTime.Now - dateTime;

            if (span.TotalMinutes < 1)
            {
                return "Just now";
            }
            else if (span.TotalMinutes < 60)
            {
                return Convert.ToInt32(span.TotalMinutes) + " min ago";
            }
            else if (span.TotalHours < 24)
            {
                return Convert.ToInt32(span.TotalHours) + " h ago";
            }
            else if (span.TotalDays < 7)
            {
                return Convert.ToInt32(span.TotalDays) + " day(s) ago";
            }
            else
            {
                return dateTime.ToString("dd MMM yyyy");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Pages/Account/Login.aspx");
        }
    }
}