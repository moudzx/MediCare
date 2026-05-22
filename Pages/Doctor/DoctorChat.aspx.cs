using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Doctor
{
    public partial class DoctorChat : Page
    {
        private string ConnStr =>
            ConfigurationManager
                .ConnectionStrings["DefaultConnection"]
                .ConnectionString;

        public int SelectedConvID
        {
            get => ViewState["SelectedConvID"] != null
                ? Convert.ToInt32(ViewState["SelectedConvID"]) : 0;
            set => ViewState["SelectedConvID"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null ||
                Session["Role"]?.ToString() != "Doctor")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                EnsureConversationsExist();
                LoadConversations();
            }
        }

        private int CurrentDoctorID()
        {
            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(
                "SELECT DoctorId FROM Doctors WHERE UserId=@uid", conn))
            {
                cmd.Parameters.AddWithValue("@uid", Convert.ToInt32(Session["UserId"]));
                conn.Open();
                var result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : 0;
            }
        }

        private void EnsureConversationsExist()
        {
            int doctorID = CurrentDoctorID();

            const string sql = @"
INSERT INTO Conversations (PatientID, DoctorID)
SELECT pdc.PatientId, pdc.DoctorId
FROM PatientDoctorConnections pdc
WHERE pdc.DoctorId = @did
  AND pdc.Status = 'Accepted'
  AND NOT EXISTS
  (
      SELECT 1 FROM Conversations c
      WHERE c.PatientID = pdc.PatientId AND c.DoctorID = pdc.DoctorId
  )";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@did", doctorID);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "?";
            var parts = name.Trim().Split(' ');
            return parts.Length >= 2
                ? (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper()
                : name.Substring(0, Math.Min(2, name.Length)).ToUpper();
        }

        private void LoadConversations()
        {
            int doctorID = CurrentDoctorID();

            const string sql = @"
SELECT
    c.ConversationID,
    p.FullName AS PatientName,
    ISNULL(
        (SELECT TOP 1 Body FROM Messages
         WHERE ConversationID = c.ConversationID ORDER BY SentAt DESC),
        'No messages yet'
    ) AS LastSnippet,
    (SELECT COUNT(*) FROM Messages
     WHERE ConversationID = c.ConversationID
       AND SenderUserID <> @uid AND IsRead = 0) AS UnreadCount
FROM Conversations c
INNER JOIN Patients p ON p.PatientId = c.PatientID
WHERE c.DoctorID = @doctorID
ORDER BY c.LastMessageAt DESC";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@doctorID", doctorID);
                cmd.Parameters.AddWithValue("@uid", Convert.ToInt32(Session["UserId"]));

                var dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                rptConversations.DataSource = dt;
                rptConversations.DataBind();
            }
        }

        protected void rptConversations_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "Open") return;

            int convID = Convert.ToInt32(e.CommandArgument);
            SelectedConvID = convID;

            pnlNoChat.Visible = false;
            pnlChat.Visible = true;

            LoadHeader(convID);
            LoadMessages(convID);
            MarkMessagesRead(convID);
            LoadConversations();
        }

        private void LoadHeader(int conversationID)
        {
            const string sql = @"
SELECT p.FullName AS PatientName
FROM Conversations c
INNER JOIN Patients p ON p.PatientId = c.PatientID
WHERE c.ConversationID = @cid";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cid", conversationID);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        string name = rdr["PatientName"].ToString();
                        litPatientName.Text = name;
                        litPatientInitials.Text = GetInitials(name);
                    }
                }
            }
        }

        private void LoadMessages(int conversationID)
        {
            int myUserID = Convert.ToInt32(Session["UserId"]);

            const string sql = @"
SELECT SenderUserID, Body, SentAt
FROM Messages
WHERE ConversationID = @cid
ORDER BY SentAt";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cid", conversationID);

                var dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                var rows = new List<MessageRow>(dt.Rows.Count);
                DateTime? lastDate = null;

                foreach (DataRow r in dt.Rows)
                {
                    var sentAt = Convert.ToDateTime(r["SentAt"]);
                    bool divider = lastDate == null || lastDate.Value.Date != sentAt.Date;

                    rows.Add(new MessageRow
                    {
                        Body = r["Body"].ToString(),
                        SentAt = sentAt,
                        IsMe = Convert.ToInt32(r["SenderUserID"]) == myUserID,
                        ShowDivider = divider,
                        DayLabel = sentAt.Date == DateTime.Today ? "Today"
                                    : sentAt.Date == DateTime.Today.AddDays(-1) ? "Yesterday"
                                    : sentAt.ToString("MMMM d, yyyy")
                    });

                    lastDate = sentAt.Date;
                }

                rptMessages.DataSource = rows;
                rptMessages.DataBind();
            }
        }

        private void MarkMessagesRead(int conversationID)
        {
            const string sql = @"
UPDATE Messages SET IsRead = 1
WHERE ConversationID = @cid
  AND SenderUserID <> @uid
  AND IsRead = 0";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cid", conversationID);
                cmd.Parameters.AddWithValue("@uid", Convert.ToInt32(Session["UserId"]));
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (SelectedConvID == 0) return;

            string body = txtMsg.Value.Trim();
            if (string.IsNullOrWhiteSpace(body)) return;

            const string sql = @"
INSERT INTO Messages (ConversationID, SenderUserID, Body, SentAt, IsRead)
VALUES (@cid, @uid, @body, GETDATE(), 0);

UPDATE Conversations SET LastMessageAt = GETDATE()
WHERE ConversationID = @cid;";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cid", SelectedConvID);
                cmd.Parameters.AddWithValue("@uid", Convert.ToInt32(Session["UserId"]));
                cmd.Parameters.AddWithValue("@body", body);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            txtMsg.Value = string.Empty;

            LoadMessages(SelectedConvID);
            LoadConversations();
        }

        protected void timerRefresh_Tick(object sender, EventArgs e)
        {
            if (SelectedConvID == 0) return;

            LoadMessages(SelectedConvID);
            MarkMessagesRead(SelectedConvID);
            LoadConversations();
        }

        public class MessageRow
        {
            public string Body { get; set; }
            public DateTime SentAt { get; set; }
            public bool IsMe { get; set; }
            public bool ShowDivider { get; set; }
            public string DayLabel { get; set; }
        }
    }
}