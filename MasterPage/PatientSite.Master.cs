using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace MediCare.MasterPage
{
    public partial class PatientSite : System.Web.UI.MasterPage
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) return;

            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadNotifications();
                LoadUnreadChatCount(); // Calculates unopened live conversations
            }

            btnMarkAllRead.Click += BtnMarkAllRead_Click;
        }

        private int UserId => Convert.ToInt32(Session["UserId"]);

        // ── User info for navbar ──────────────────────────────────────────────
        private void LoadUserInfo()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT u.Email, p.FullName
                    FROM Users u
                    INNER JOIN Patients p ON p.UserId = u.UserId
                    WHERE u.UserId = @UserId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", UserId);
                conn.Open();

                SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    string fullName = r["FullName"].ToString();
                    lblFullName.Text = fullName;
                    lblEmail.Text = r["Email"].ToString();
                    lblFirstName.Text = fullName.Contains(" ")
                        ? fullName.Substring(0, fullName.IndexOf(' '))
                        : fullName;
                }
            }
        }

        // ── ADDED: Unopened/Unread Chat Counter Logic ────────────────────────
        private void LoadUnreadChatCount()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // This checks unread chat messages that were sent to this user by a partner
                string query = @"
                    SELECT COUNT(*) 
                    FROM ChatMessages m
                    INNER JOIN Conversations c ON m.ConversationId = c.ConversationId
                    WHERE (c.ParticipantA = @UserId OR c.ParticipantB = @UserId)
                      AND m.SenderId != @UserId 
                      AND ISNULL(m.IsRead, 0) = 0";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", UserId);

                try
                {
                    conn.Open();
                    int unreadCount = Convert.ToInt32(cmd.ExecuteScalar());

                    if (unreadCount > 0)
                    {
                        lblChatCount.Text = unreadCount > 99 ? "99+" : unreadCount.ToString();
                        lblChatCount.Visible = true;
                    }
                    else
                    {
                        lblChatCount.Visible = false;
                    }
                }
                catch
                {
                    // Fallback to prevent app crash if column 'IsRead' hasn't migrated yet
                    lblChatCount.Visible = false;
                }
            }
        }

        // ── Notifications ─────────────────────────────────────────────────────
        private void LoadNotifications()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 10
                        NotificationId, Type, Title, Message, IsRead, CreatedAt
                    FROM Notifications
                    WHERE UserId = @UserId
                    ORDER BY CreatedAt DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", UserId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                int unread = 0;
                phNotifications.Controls.Clear();

                if (dt.Rows.Count == 0)
                {
                    var empty = new HtmlGenericControl("div");
                    empty.Attributes["class"] = "pn-notification__empty";
                    empty.InnerText = "No notifications yet.";
                    phNotifications.Controls.Add(empty);
                }
                else
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        bool isRead = Convert.ToBoolean(row["IsRead"]);
                        if (!isRead) unread++;

                        string type = row["Type"].ToString();
                        string title = row["Title"].ToString();
                        string message = row["Message"].ToString();
                        string timeAgo = TimeAgo(Convert.ToDateTime(row["CreatedAt"]));
                        int notifId = Convert.ToInt32(row["NotificationId"]);

                        var item = new HtmlAnchor();
                        item.HRef = "#";
                        item.Attributes["class"] = "pn-notification__item" + (isRead ? "" : " pn-notification__item--unread");
                        item.Attributes["data-notif-id"] = notifId.ToString();

                        var iconDiv = new HtmlGenericControl("div");
                        iconDiv.Attributes["class"] = "pn-notification__icon";
                        iconDiv.InnerHtml = $"<i class=\"{GetIcon(type)}\"></i>";

                        var contentDiv = new HtmlGenericControl("div");
                        contentDiv.Attributes["class"] = "pn-notification__content";
                        contentDiv.InnerHtml =
                            $"<strong>{Server.HtmlEncode(title)}</strong>" +
                            $"<small>{Server.HtmlEncode(message)}</small>" +
                            $"<small style='color:#9ca3af;margin-top:4px'>{timeAgo}</small>";

                        item.Controls.Add(iconDiv);
                        item.Controls.Add(contentDiv);
                        phNotifications.Controls.Add(item);
                    }
                }

                if (unread > 0)
                {
                    lblNotifCount.Text = unread > 99 ? "99+" : unread.ToString();
                    lblNotifCount.Visible = true;
                }
                else
                {
                    lblNotifCount.Visible = false;
                }
            }
        }

        private void BtnMarkAllRead_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE Notifications
                    SET IsRead = 1
                    WHERE UserId = @UserId AND IsRead = 0";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", UserId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            LoadNotifications();
        }

        // ── Helpers ───────────────────────────────────────────────────────────
        private static string GetIcon(string type)
        {
            switch (type)
            {
                case "MedicationAdded": return "fa-solid fa-pills";
                case "NutritionPlanAdded": return "fa-solid fa-utensils";
                case "ConnectionRequest": return "fa-solid fa-user-plus";
                case "ConnectionAccepted": return "fa-solid fa-handshake";
                case "ConnectionRejected": return "fa-solid fa-user-xmark";
                case "AppointmentRequested": return "fa-solid fa-calendar-plus";
                case "AppointmentAccepted": return "fa-solid fa-calendar-check";
                case "AppointmentRejected":
                case "AppointmentCancelled": return "fa-solid fa-calendar-xmark";
                default: return "fa-solid fa-bell";
            }
        }

        private static string TimeAgo(DateTime dt)
        {
            TimeSpan diff = DateTime.Now - dt;
            if (diff.TotalMinutes < 1) return "Just now";
            if (diff.TotalMinutes < 60) return $"{(int)diff.TotalMinutes}m ago";
            if (diff.TotalHours < 24) return $"{(int)diff.TotalHours}h ago";
            if (diff.TotalDays < 7) return $"{(int)diff.TotalDays}d ago";
            return dt.ToString("MMM dd");
        }
    }
}