using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Admin
{
    public partial class PatientManagement : System.Web.UI.Page
    {
        private readonly string _connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }
            if (!IsPostBack)
            {
                LoadStats();
                LoadPatients(string.Empty);
            }
        }

        private void LoadStats()
        {
            const string query = @"
                SELECT COUNT(*) AS TotalPatients,
                       SUM(CASE WHEN MONTH(u.CreatedAt) = MONTH(GETDATE()) AND YEAR(u.CreatedAt) = YEAR(GETDATE()) THEN 1 ELSE 0 END) AS NewThisMonth
                FROM Patients p
                JOIN Users u ON p.UserId = u.UserId";

            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(query, conn))
            {
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        lblPatientsCount.Text = reader["TotalPatients"].ToString();
                        lblNewPatients.Text = reader["NewThisMonth"].ToString();
                    }
                }
            }
        }

        private void LoadPatients(string searchTerm)
        {
            const string query = @"
                SELECT p.PatientId, p.FullName, p.Age, p.PhoneNumber,
                       LEFT(p.FullName, 1) + CASE WHEN CHARINDEX(' ', RTRIM(p.FullName)) > 0 
                       THEN SUBSTRING(p.FullName, CHARINDEX(' ', RTRIM(p.FullName)) + 1, 1) ELSE '' END AS Initials
                FROM Patients p
                WHERE (@Search = '' OR p.FullName LIKE '%' + @Search + '%')
                ORDER BY p.FullName";

            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Search", searchTerm ?? string.Empty);
                var adapter = new SqlDataAdapter(cmd);
                var table = new DataTable();
                adapter.Fill(table);
                gvPatients.DataSource = table;
                gvPatients.DataBind();
            }
        }

        protected void txtSearchPatients_TextChanged(object sender, EventArgs e)
        {
            LoadPatients(txtSearchPatients.Text.Trim());
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            if (!int.TryParse(btn.CommandArgument, out int patientId))
            {
                ShowError("Invalid patient ID.");
                return;
            }

            DeletePatient(patientId);
            LoadStats();
            LoadPatients(txtSearchPatients.Text.Trim());
        }

        private void DeletePatient(int patientId)
        {
            const string getUserId = "SELECT UserId FROM Patients WHERE PatientId = @PatientId";
            const string deletePatient = "DELETE FROM Patients WHERE PatientId = @PatientId";
            const string deleteUser = "DELETE FROM Users WHERE UserId = @UserId";

            using (var conn = new SqlConnection(_connStr))
            {
                conn.Open();
                using (var tx = conn.BeginTransaction())
                {
                    try
                    {
                        int userId;
                        using (var cmd = new SqlCommand(getUserId, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@PatientId", patientId);
                            var result = cmd.ExecuteScalar();
                            if (result == null || result == DBNull.Value) throw new Exception("Patient not found.");
                            userId = Convert.ToInt32(result);
                        }

                        using (var cmd = new SqlCommand(deletePatient, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@PatientId", patientId);
                            cmd.ExecuteNonQuery();
                        }

                        using (var cmd = new SqlCommand(deleteUser, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                        ShowSuccess("Patient deleted successfully.");
                    }
                    catch (Exception ex)
                    {
                        tx.Rollback();
                        ShowError("Delete failed: " + ex.Message);
                    }
                }
            }
        }

        private void ShowSuccess(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "mc-alert mc-alert--success";
            lblMessage.Visible = true;
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "mc-alert mc-alert--danger";
            lblMessage.Visible = true;
        }
    }
}