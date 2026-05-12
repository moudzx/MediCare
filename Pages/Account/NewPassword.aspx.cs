using System;
using System.Data;
using System.Data.SqlClient;

namespace MediCare.Pages.Account
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        private readonly string connectionString =
            System.Configuration.ConfigurationManager
            .ConnectionStrings["DefaultConnection"]
            .ConnectionString;

        private string Email
        {
            get { return Request.QueryString["email"]; }
        }

        protected SqlConnection GetConnection()
        {
            return new SqlConnection(connectionString);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(Email))
            {
                Response.Redirect("ForgotPassword.aspx");
                return;
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = true;

            if (!ValidateReset(out string errorMessage))
            {
                lblMessage.Text = errorMessage;
                return;
            }

            string hash = BCrypt.Net.BCrypt.HashPassword(txtPassword.Text);

            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText =
                    @"UPDATE Users
                      SET PasswordHash = @Pass,
                          ResetCode = NULL,
                          ResetExpiry = NULL,
                          ResetAttempts = 0,
                          ResetLockedUntil = NULL
                      WHERE Email = @Email";

                    cmd.Parameters.AddWithValue("@Pass", hash);
                    cmd.Parameters.AddWithValue("@Email", Email);

                    int rows = cmd.ExecuteNonQuery();

                    if (rows == 0)
                    {
                        lblMessage.Text = "Invalid email.";
                        return;
                    }
                }
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Password reset successful.";

            Response.Redirect("Login.aspx");
        }

        private bool ValidateReset(out string errorMessage)
        {
            errorMessage = null;

            if (string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                errorMessage = "Password required.";
                return false;
            }

            if (txtPassword.Text.Length < 8)
            {
                errorMessage = "Min 8 characters.";
                return false;
            }

            if (txtPassword.Text != txtConfirmPassword.Text)
            {
                errorMessage = "Passwords do not match.";
                return false;
            }

            return true;
        }
    }
}