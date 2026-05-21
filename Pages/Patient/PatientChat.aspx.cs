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
        private string ConnStr
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["DefaultConnection"]
                    .ConnectionString;
            }
        }

        protected int SelectedConvID
        {
            get
            {
                return ViewState["SelectedConvID"] != null
                    ? Convert.ToInt32(ViewState["SelectedConvID"])
                    : 0;
            }
            set
            {
                ViewState["SelectedConvID"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null ||
                Session["Role"] == null ||
                Session["Role"].ToString() != "Patient")
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
            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT PatientId FROM Patients WHERE UserId=@uid", conn))
            {
                cmd.Parameters.AddWithValue(
                    "@uid",
                    Convert.ToInt32(Session["UserId"])
                );

                conn.Open();

                object result = cmd.ExecuteScalar();

                return result != null
                    ? Convert.ToInt32(result)
                    : 0;
            }
        }

        private void EnsureConversationsExist()
        {
            int patientID = GetCurrentPatientID();

            string sql = @"
INSERT INTO Conversations (PatientID, DoctorID)
SELECT
    pdc.PatientId,
    pdc.DoctorId
FROM PatientDoctorConnections pdc
WHERE pdc.PatientId = @pid
AND pdc.Status = 'Accepted'
AND NOT EXISTS
(
    SELECT 1
    FROM Conversations c
    WHERE c.PatientID = pdc.PatientId
    AND c.DoctorID = pdc.DoctorId
)";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@pid", patientID);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName))
                return "?";

            string[] parts = fullName.Trim().Split(' ');

            if (parts.Length >= 2)
            {
                return (
                    parts[0][0].ToString() +
                    parts[parts.Length - 1][0].ToString()
                ).ToUpper();
            }

            return fullName.Substring(
                0,
                Math.Min(2, fullName.Length)
            ).ToUpper();
        }

        private void LoadConversations()
        {
            int patientID = GetCurrentPatientID();

            string sql = @"
SELECT
    c.ConversationID,
    d.FullName AS DoctorName,

    ISNULL
    (
        (
            SELECT TOP 1 Body
            FROM Messages m
            WHERE m.ConversationID = c.ConversationID
            ORDER BY m.SentAt DESC
        ),
        'No messages yet'
    ) AS LastSnippet,

    (
        SELECT COUNT(*)
        FROM Messages m2
        WHERE m2.ConversationID = c.ConversationID
        AND m2.SenderUserID <> @uid
        AND m2.IsRead = 0
    ) AS UnreadCount

FROM Conversations c

INNER JOIN Doctors d
ON c.DoctorID = d.DoctorId

WHERE c.PatientID = @pid

ORDER BY c.LastMessageAt DESC";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@pid", patientID);

                cmd.Parameters.AddWithValue(
                    "@uid",
                    Convert.ToInt32(Session["UserId"])
                );

                DataTable dt = new DataTable();

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);

                rptConversations.DataSource = dt;
                rptConversations.DataBind();
            }
        }

        protected void rptConversations_ItemCommand(
            object source,
            RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                int conversationID =
                    Convert.ToInt32(e.CommandArgument);

                OpenConversation(conversationID);
            }
        }

        private void OpenConversation(int conversationID)
        {
            SelectedConvID = conversationID;

            pnlNoneSelected.Visible = false;
            pnlChat.Visible = true;

            LoadChatHeader(conversationID);
            LoadMessages(conversationID);
            MarkMessagesRead(conversationID);
        }

        private void LoadChatHeader(int conversationID)
        {
            string sql = @"
SELECT
    d.FullName,
    ISNULL(d.Speciality, 'Doctor') AS Speciality
FROM Conversations c
INNER JOIN Doctors d
ON c.DoctorID = d.DoctorId
WHERE c.ConversationID = @cid";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cid", conversationID);

                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string doctorName =
                        reader["FullName"].ToString();

                    litDrName.Text = doctorName;

                    litDrInitials.Text =
                        GetInitials(doctorName);

                    litDrSpec.Text =
                        reader["Speciality"].ToString();
                }
            }
        }

        private void LoadMessages(int conversationID)
        {
            int myUserID =
                Convert.ToInt32(Session["UserId"]);

            string sql = @"
SELECT
    MessageID,
    SenderUserID,
    Body,
    SentAt
FROM Messages
WHERE ConversationID = @cid
ORDER BY SentAt ASC";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cid", conversationID);

                DataTable dt = new DataTable();

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                da.Fill(dt);

                List<MessageRow> rows =
                    new List<MessageRow>();

                DateTime? lastDate = null;

                foreach (DataRow dr in dt.Rows)
                {
                    DateTime sentAt =
                        Convert.ToDateTime(dr["SentAt"]);

                    bool divider =
                        lastDate == null ||
                        lastDate.Value.Date != sentAt.Date;

                    rows.Add(new MessageRow
                    {
                        MessageID =
                            Convert.ToInt32(dr["MessageID"]),

                        Body =
                            dr["Body"].ToString(),

                        SentAt =
                            sentAt,

                        IsMe =
                            Convert.ToInt32(
                                dr["SenderUserID"]
                            ) == myUserID,

                        ShowDivider =
                            divider,

                        DayLabel =
                            sentAt.Date == DateTime.Today
                                ? "Today"
                                : sentAt.Date == DateTime.Today.AddDays(-1)
                                    ? "Yesterday"
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
            string sql = @"
UPDATE Messages
SET IsRead = 1
WHERE ConversationID = @cid
AND SenderUserID <> @uid
AND IsRead = 0";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@cid", conversationID);

                cmd.Parameters.AddWithValue(
                    "@uid",
                    Convert.ToInt32(Session["UserId"])
                );

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnSend_Click(
            object sender,
            EventArgs e)
        {
            if (SelectedConvID == 0)
                return;

            string body = txtMessage.Text;

            if (string.IsNullOrWhiteSpace(body))
                return;

            string sql = @"
INSERT INTO Messages
(
    ConversationID,
    SenderUserID,
    Body,
    SentAt,
    IsRead
)
VALUES
(
    @cid,
    @uid,
    @body,
    GETDATE(),
    0
)

UPDATE Conversations
SET LastMessageAt = GETDATE()
WHERE ConversationID = @cid";

            using (SqlConnection conn = new SqlConnection(ConnStr))
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue(
                    "@cid",
                    SelectedConvID
                );

                cmd.Parameters.AddWithValue(
                    "@uid",
                    Convert.ToInt32(Session["UserId"])
                );

                cmd.Parameters.AddWithValue(
                    "@body",
                    body.Trim()
                );

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            txtMessage.Text = string.Empty;

            LoadMessages(SelectedConvID);
            MarkMessagesRead(SelectedConvID);
            LoadConversations();
        }

        protected void timerRefresh_Tick(
            object sender,
            EventArgs e)
        {
            if (SelectedConvID > 0)
            {
                LoadMessages(SelectedConvID);
                MarkMessagesRead(SelectedConvID);
                LoadConversations();
            }
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