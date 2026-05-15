using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;


namespace MediCare.Pages.Account
{
    public partial class Login : System.Web.UI.Page
    {
        //        private readonly string connectionString =
        //            System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        //        protected SqlConnection GetConnection()
        //        {
        //            return new SqlConnection(connectionString);
        //        }

        //        protected void Page_Load(object sender, EventArgs e)
        //        {

        //        }

        //        protected void btnLogin_Click(object sender, EventArgs e)
        //        {
        //            lblLoginMessage.Visible = true;

        //            if (string.IsNullOrWhiteSpace(txtEmail.Text))
        //            {
        //                lblLoginMessage.Text = "Please enter your email.";
        //                return;
        //            }

        //            if (!txtEmail.Text.Contains("@") ||
        //                !txtEmail.Text.Contains(".") ||
        //                txtEmail.Text.IndexOf("@") > txtEmail.Text.LastIndexOf("."))
        //            {
        //                lblLoginMessage.Text = "Please enter a valid email.";
        //                return;
        //            }

        //            if (string.IsNullOrWhiteSpace(txtPassword.Text))
        //            {
        //                lblLoginMessage.Text = "Please enter your password.";
        //                return;
        //            }

        //            if (txtPassword.Text.Length < 8)
        //            {
        //                lblLoginMessage.Text = "Password must be at least 8 characters.";
        //                return;
        //            }

        //            SqlConnection conn = GetConnection();
        //            conn.Open();

        //            SqlCommand cmd = conn.CreateCommand();
        //            cmd.CommandType = CommandType.Text;
        //            cmd.CommandText = @"SELECT UserId, Email, PasswordHash, Role FROM Users WHERE Email = @Email";
        //            cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

        //            DataTable dt = new DataTable();
        //            SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        //            adapter.Fill(dt);

        //            if (dt.Rows.Count == 0)
        //            {
        //                cmd.Dispose();
        //                conn.Close();
        //                lblLoginMessage.Text = "Invalid email or password.";
        //                return;
        //            }

        //            else
        //            {
        //                DataRow row = dt.Rows[0];
        //                int userId = Convert.ToInt32(row["UserId"]);
        //                string email = row["Email"].ToString();
        //                string passwordHash = row["PasswordHash"].ToString();
        //                string role = row["Role"].ToString();

        //                cmd.Dispose();
        //                adapter.Dispose();

        //                if (!BCrypt.Net.BCrypt.Verify(txtPassword.Text, passwordHash))
        //                {
        //                    conn.Close();
        //                    lblLoginMessage.Text = "Invalid email or password.";
        //                    return;
        //                }

        //                else
        //                {
        //                    Session["UserId"] = userId;
        //                    Session["Email"] = email;
        //                    Session["Role"] = role;

        //                    conn.Close();

        //                    switch (role)
        //                    {
        //                        case "Patient":
        //                            Response.Redirect("~/Pages/Patient/Dashboard.aspx");
        //                            break;
        //                        case "Doctor":
        //                            Response.Redirect("~/Pages/Doctor/Dashboard.aspx");
        //                            break;
        //                        case "Admin":
        //                            Response.Redirect("~/Pages/Admin/Dashboard.aspx");
        //                            break;
        //                    }
        //                }

        //            }

        //        }
    }
}