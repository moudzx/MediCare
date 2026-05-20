using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Admin
{
    public partial class DoctorManagement : System.Web.UI.Page
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
                LoadDoctors(string.Empty);
            }
        }

        private void LoadDoctors(string searchTerm)
        {
            const string query = @"
                SELECT d.DoctorId, d.FullName, d.Speciality, d.PhoneNumber, u.Email
                FROM Doctors d
                JOIN Users u ON d.UserId = u.UserId
                WHERE (@Search = '' OR d.FullName LIKE '%' + @Search + '%' OR d.Speciality LIKE '%' + @Search + '%')
                ORDER BY d.FullName";

            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@Search", searchTerm ?? string.Empty);
                var adapter = new SqlDataAdapter(cmd);
                var table = new DataTable();
                adapter.Fill(table);
                gvDoctors.DataSource = table;
                gvDoctors.DataBind();
            }
        }

        protected void txtSearchDoctors_TextChanged(object sender, EventArgs e)
        {
            LoadDoctors(txtSearchDoctors.Text.Trim());
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            var btn = (Button)sender;
            if (!int.TryParse(btn.CommandArgument, out int doctorId))
            {
                ShowError("Invalid doctor ID.");
                return;
            }

            DeleteDoctor(doctorId);
            LoadDoctors(txtSearchDoctors.Text.Trim());
        }

        private void DeleteDoctor(int doctorId)
        {
            const string getUserId = "SELECT UserId FROM Doctors WHERE DoctorId = @DoctorId";
            const string deleteDoctor = "DELETE FROM Doctors WHERE DoctorId = @DoctorId";
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
                            cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                            var result = cmd.ExecuteScalar();
                            if (result == null || result == DBNull.Value) throw new Exception("Doctor not found.");
                            userId = Convert.ToInt32(result);
                        }

                        using (var cmd = new SqlCommand(deleteDoctor, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                            cmd.ExecuteNonQuery();
                        }

                        using (var cmd = new SqlCommand(deleteUser, conn, tx))
                        {
                            cmd.Parameters.AddWithValue("@UserId", userId);
                            cmd.ExecuteNonQuery();
                        }

                        tx.Commit();
                        ShowSuccess("Doctor deleted successfully.");
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