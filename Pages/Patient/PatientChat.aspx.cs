using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Patient
{
    public partial class PatientChat : Page
    {
        private string ConnStr =>
            ConfigurationManager
                .ConnectionStrings["DefaultConnection"]
                .ConnectionString;

        protected int SelectedConvID
        {
            get => ViewState["SelectedConvID"] != null
                ? Convert.ToInt32(ViewState["SelectedConvID"]) : 0;
            set => ViewState["SelectedConvID"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null ||
                Session["Role"]?.ToString() != "Patient")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                EnsureConversationsExist();
                LoadConversations();
                pnlNoneSelected.Visible = true;
                pnlChat.Visible = false;
            }
        }

        private int GetCurrentPatientID()
        {
            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(
                "SELECT PatientId FROM Patients WHERE UserId=@uid", conn))
            {
                cmd.Parameters.AddWithValue("@uid", Convert.ToInt32(Session["UserId"]));
                conn.Open();
                var result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : 0;
            }
        }

        private void EnsureConversationsExist()
        {
            int patientID = GetCurrentPatientID();

            const string sql = @"
INSERT INTO Conversations (PatientID, DoctorID)
SELECT pdc.PatientId, pdc.DoctorId
FROM PatientDoctorConnections pdc
WHERE pdc.PatientId = @pid
  AND pdc.Status = 'Accepted'
  AND NOT EXISTS
  (
      SELECT 1 FROM Conversations c
      WHERE c.PatientID = pdc.PatientId AND c.DoctorID = pdc.DoctorId
  )";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@pid", patientID);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "?";
            var parts = fullName.Trim().Split(' ');
            return parts.Length >= 2
                ? (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper()
                : fullName.Substring(0, Math.Min(2, fullName.Length)).ToUpper();
        }

        private void LoadConversations()
        {
            int patientID = GetCurrentPatientID();

            const string sql = @"
SELECT
    c.ConversationID,
    d.FullName AS DoctorName,
    ISNULL(
        (SELECT TOP 1 Body FROM Messages m
         WHERE m.ConversationID = c.ConversationID ORDER BY m.SentAt DESC),
        'No messages yet'
    ) AS LastSnippet,
    (SELECT COUNT(*) FROM Messages m2
     WHERE m2.ConversationID = c.ConversationID
       AND m2.SenderUserID <> @uid AND m2.IsRead = 0) AS UnreadCount
FROM Conversations c
INNER JOIN Doctors d ON c.DoctorID = d.DoctorId
WHERE c.PatientID = @pid
ORDER BY c.LastMessageAt DESC";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@pid", patientID);
                cmd.Parameters.AddWithValue("@uid", Convert.ToInt32(Session["UserId"]));

                var dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                rptConversations.DataSource = dt;
                rptConversations.DataBind();
            }
        }

        protected void rptConversations_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "Select") return;

            int convID = Convert.ToInt32(e.CommandArgument);
            SelectedConvID = convID;

            pnlNoneSelected.Visible = false;
            pnlChat.Visible = true;

            LoadChatHeader(convID);
            LoadMessages(convID);
            MarkMessagesRead(convID);
            LoadConversations();
        }

        private void LoadChatHeader(int conversationID)
        {
            const string sql = @"
SELECT d.FullName, ISNULL(d.Speciality, 'Doctor') AS Speciality
FROM Conversations c
INNER JOIN Doctors d ON c.DoctorID = d.DoctorId
WHERE c.ConversationID = @cid";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cid", conversationID);
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string name = reader["FullName"].ToString();
                        litDrName.Text = name;
                        litDrInitials.Text = GetInitials(name);
                        litDrSpec.Text = reader["Speciality"].ToString();
                    }
                }
            }
        }

        private void LoadMessages(int conversationID)
        {
            int myUserID = Convert.ToInt32(Session["UserId"]);

            const string sql = @"
SELECT MessageID, SenderUserID, Body, SentAt
FROM Messages
WHERE ConversationID = @cid
ORDER BY SentAt ASC";

            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cid", conversationID);

                var dt = new DataTable();
                new SqlDataAdapter(cmd).Fill(dt);

                var rows = new List<MessageRow>(dt.Rows.Count);
                DateTime? lastDate = null;

                foreach (DataRow dr in dt.Rows)
                {
                    var sentAt = Convert.ToDateTime(dr["SentAt"]);
                    bool divider = lastDate == null || lastDate.Value.Date != sentAt.Date;

                    rows.Add(new MessageRow
                    {
                        MessageID = Convert.ToInt32(dr["MessageID"]),
                        Body = dr["Body"].ToString(),
                        SentAt = sentAt,
                        IsMe = Convert.ToInt32(dr["SenderUserID"]) == myUserID,
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

            string body = txtMessage.Text.Trim();
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

            txtMessage.Text = string.Empty;

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
            public int MessageID { get; set; }
            public string Body { get; set; }
            public DateTime SentAt { get; set; }
            public bool IsMe { get; set; }
            public bool ShowDivider { get; set; }
            public string DayLabel { get; set; }
        }
    }
}