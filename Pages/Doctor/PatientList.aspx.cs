using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Doctor
{
    public partial class PatientList : System.Web.UI.Page
    {
        private string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Doctor")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStats();
                BindPendingRequests();
                BindPatients();
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
                if (result != null && result != DBNull.Value)
                    return Convert.ToInt32(result);
            }
            return 0;
        }

        private void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    string sql = @"
                        SELECT 
                            COUNT(p.PatientId)  as Total,
                            SUM(CASE WHEN c.Status = 'Accepted' THEN 1 ELSE 0 END) as Active,
                            SUM(CASE WHEN p.PhoneNumber IS NOT NULL AND p.PhoneNumber <> '' THEN 1 ELSE 0 END) as WithPhone,
                            SUM(CASE WHEN p.ChronicDisease IS NOT NULL AND p.ChronicDisease <> '' THEN 1 ELSE 0 END) as WithChronic
                        FROM [dbo].[PatientDoctorConnections] c
                        INNER JOIN [dbo].[Patients] p ON c.PatientId = p.PatientId
                        WHERE c.DoctorId = @DoctorId AND c.Status = 'Accepted'";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        using (SqlDataReader rdr = cmd.ExecuteReader())
                        {
                            if (rdr.Read())
                            {
                                lblStatTotal.Text = rdr["Total"] != DBNull.Value ? rdr["Total"].ToString() : "0";
                                lblStatActive.Text = rdr["Active"] != DBNull.Value ? rdr["Active"].ToString() : "0";
                                lblStatUpcoming.Text = rdr["WithPhone"] != DBNull.Value ? rdr["WithPhone"].ToString() : "0";
                                lblStatOnMeds.Text = rdr["WithChronic"] != DBNull.Value ? rdr["WithChronic"].ToString() : "0";
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Stats Error: " + ex.Message);
                }
            }
        }

        private void BindPendingRequests()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    string sql = @"
                        SELECT 
                            p.PatientId,
                            p.FullName,
                            p.Age,
                            p.Gender,
                            p.BloodType,
                            p.PhoneNumber,
                            p.ChronicDisease,
                            c.RequestedAt,
                            LEFT(p.FullName, 2) as Initials
                        FROM [dbo].[PatientDoctorConnections] c
                        INNER JOIN [dbo].[Patients] p ON c.PatientId = p.PatientId
                        WHERE c.DoctorId = @DoctorId AND c.Status = 'Pending'
                        ORDER BY c.RequestedAt DESC";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                pnlPendingSection.Visible = true;
                                rptPendingRequests.DataSource = dt;
                                rptPendingRequests.DataBind();
                            }
                            else
                            {
                                pnlPendingSection.Visible = false;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowToast("Pending Request Binding Fail: " + ex.Message);
                }
            }
        }

        private void BindPatients()
        {
            string search = txtSearch.Text.Trim();
            string gender = ddlGender.SelectedValue;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    string sql = @"
                        SELECT 
                            p.PatientId,
                            p.FullName,
                            p.Age,
                            p.Gender,
                            p.BloodType,
                            p.ChronicDisease,
                            p.PhoneNumber,
                            LEFT(p.FullName, 2) as Initials
                        FROM [dbo].[PatientDoctorConnections] c
                        INNER JOIN [dbo].[Patients] p ON c.PatientId = p.PatientId
                        WHERE c.DoctorId = @DoctorId AND c.Status = 'Accepted'";

                    if (!string.IsNullOrEmpty(search))
                        sql += " AND (p.FullName LIKE @Search OR p.ChronicDisease LIKE @Search OR p.PhoneNumber LIKE @Search)";

                    if (!string.IsNullOrEmpty(gender))
                        sql += " AND p.Gender = @Gender";

                    sql += " ORDER BY p.FullName ASC";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        if (!string.IsNullOrEmpty(search)) cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
                        if (!string.IsNullOrEmpty(gender)) cmd.Parameters.AddWithValue("@Gender", gender);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            lblResultsCount.Text = $"Showing {dt.Rows.Count} patients";

                            if (dt.Rows.Count == 0)
                            {
                                rptPatients.Visible = false;
                                pnlEmptyState.Visible = true;
                            }
                            else
                            {
                                rptPatients.Visible = true;
                                pnlEmptyState.Visible = false;
                                rptPatients.DataSource = dt;
                                rptPatients.DataBind();
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Active Bind Error: " + ex.Message);
                }
            }
        }

        protected void rptPendingRequests_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int targetPatientId = Convert.ToInt32(e.CommandArgument);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    if (e.CommandName == "AcceptRequest")
                    {
                        string sql = @"
                            UPDATE [dbo].[PatientDoctorConnections]
                            SET Status = 'Accepted', RespondedAt = GETDATE()
                            WHERE DoctorId = @DoctorId AND PatientId = @PatientId";

                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                            cmd.Parameters.AddWithValue("@PatientId", targetPatientId);
                            cmd.ExecuteNonQuery();
                        }

                        SendConnectionNotification(conn, targetPatientId, doctorId,
                            type: "ConnectionAccepted",
                            title: "Connection Request Accepted",
                            message: "Your connection request has been accepted by the doctor.");

                        ShowToast("Connection request accepted.");
                    }
                    else if (e.CommandName == "RejectRequest")
                    {

                        SendConnectionNotification(conn, targetPatientId, doctorId,
                            type: "ConnectionRejected",
                            title: "Connection Request Declined",
                            message: "Your connection request has been declined by the doctor.");

                        string sql = @"
                            DELETE FROM [dbo].[PatientDoctorConnections]
                            WHERE DoctorId = @DoctorId AND PatientId = @PatientId AND Status = 'Pending'";

                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                            cmd.Parameters.AddWithValue("@PatientId", targetPatientId);
                            cmd.ExecuteNonQuery();
                        }

                        ShowToast("Connection request declined.");
                    }

                    LoadStats();
                    BindPendingRequests();
                    BindPatients();
                }
                catch (Exception ex)
                {
                    ShowToast("Action Error: " + ex.Message);
                }
            }
        }


        private void SendConnectionNotification(SqlConnection conn, int patientId, int doctorId,
            string type, string title, string message)
        {

            string docName = "Your doctor";
            using (SqlCommand cmdDoc = new SqlCommand(
                "SELECT FullName FROM Doctors WHERE DoctorId = @DoctorId", conn))
            {
                cmdDoc.Parameters.AddWithValue("@DoctorId", doctorId);
                object res = cmdDoc.ExecuteScalar();
                if (res != null) docName = "Dr. " + res.ToString();
            }

            int patientUserId = 0;
            using (SqlCommand cmdUser = new SqlCommand(
                "SELECT UserId FROM Patients WHERE PatientId = @PatientId", conn))
            {
                cmdUser.Parameters.AddWithValue("@PatientId", patientId);
                object res = cmdUser.ExecuteScalar();
                if (res == null || res == DBNull.Value) return;
                patientUserId = Convert.ToInt32(res);
            }

            using (SqlCommand cmdNotif = new SqlCommand(@"
                INSERT INTO Notifications (UserId, Type, Title, Message, IsRead, CreatedAt)
                VALUES (@UserId, @Type, @Title, @Message, 0, GETDATE())", conn))
            {
                cmdNotif.Parameters.AddWithValue("@UserId", patientUserId);
                cmdNotif.Parameters.AddWithValue("@Type", type);
                cmdNotif.Parameters.AddWithValue("@Title", title);
                cmdNotif.Parameters.AddWithValue("@Message", $"{docName}: {message}");
                cmdNotif.ExecuteNonQuery();
            }
        }

        protected void rptPatients_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string patientId = e.CommandArgument.ToString();

            if (e.CommandName == "OpenMedications")
            {
                Response.Redirect($"~/Pages/Doctor/ManageMedication.aspx?PatientId={patientId}");
            }
            else if (e.CommandName == "OpenNutrition")
            {
                Response.Redirect($"~/Pages/Doctor/ManageNutrition.aspx?PatientId={patientId}");
            }
            else if (e.CommandName == "RequestRemove")
            {
                int targetPatientId = Convert.ToInt32(patientId);

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    try
                    {
                        conn.Open();
                        int doctorId = GetDoctorId(conn);
                        if (doctorId == 0) return;

                        string sql = @"
                            DELETE FROM [dbo].[PatientDoctorConnections]
                            WHERE DoctorId = @DoctorId AND PatientId = @PatientId";

                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                            cmd.Parameters.AddWithValue("@PatientId", targetPatientId);
                            cmd.ExecuteNonQuery();

                            ShowToast("Connection successfully removed.");
                            LoadStats();
                            BindPendingRequests();
                            BindPatients();
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowToast("Removal Error: " + ex.Message);
                    }
                }
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e) => BindPatients();
        protected void btnClearSearch_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            BindPatients();
        }
        protected void ddlGender_SelectedIndexChanged(object sender, EventArgs e) => BindPatients();

        private void ShowToast(string msg)
        {
            pnlToast.Visible = true;
            lblToastMsg.Text = msg;
        }
    }
}