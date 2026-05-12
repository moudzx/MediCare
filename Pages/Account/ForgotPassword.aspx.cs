using System;
using System.Data;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Security.Cryptography;
using static System.Runtime.CompilerServices.RuntimeHelpers;

namespace MediCare.Pages.Account
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private readonly string connectionString =
            System.Configuration.ConfigurationManager
            .ConnectionStrings["DefaultConnection"]
            .ConnectionString;

        protected SqlConnection GetConnection()
        {
            return new SqlConnection(connectionString);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSendCode_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = true;

            if (!ValidateEmail(out string errorMessage))
            {
                lblMessage.Text = errorMessage;
                return;
            }

            string code = GenerateCode();

            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText =
                    @"UPDATE Users
                      SET ResetCode = @Code,
                          ResetExpiry = @Expiry,
                          ResetAttempts = 0,
                          ResetLockedUntil = NULL
                      WHERE Email = @Email";

                    cmd.Parameters.AddWithValue("@Code", code);
                    cmd.Parameters.AddWithValue("@Expiry", DateTime.Now.AddMinutes(15));
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                    cmd.ExecuteNonQuery();
                }
            }

            SendResetEmail(txtEmail.Text.Trim(), code);

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Verification code sent successfully.";
        }

        protected void btnResendCode_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = true;

            if (!ValidateEmail(out string errorMessage))
            {
                lblMessage.Text = errorMessage;
                return;
            }

            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText =
                    @"SELECT ResetLockedUntil
                      FROM Users
                      WHERE Email = @Email";

                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                    object lockObj = cmd.ExecuteScalar();

                    if (lockObj != DBNull.Value && lockObj != null)
                    {
                        DateTime lockedUntil = Convert.ToDateTime(lockObj);

                        if (DateTime.Now < lockedUntil)
                        {
                            lblMessage.Text = "Locked until " + lockedUntil;
                            return;
                        }
                    }
                }
            }

            string code = GenerateCode();

            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText =
                    @"UPDATE Users
                      SET ResetCode = @Code,
                          ResetExpiry = @Expiry,
                          ResetAttempts = 0
                      WHERE Email = @Email";

                    cmd.Parameters.AddWithValue("@Code", code);
                    cmd.Parameters.AddWithValue("@Expiry", DateTime.Now.AddMinutes(15));
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                    cmd.ExecuteNonQuery();
                }
            }

            SendResetEmail(txtEmail.Text.Trim(), code);

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "New verification code sent.";
        }

        protected void btnVerifyCode_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = true;

            if (!ValidateEmail(out string errorMessage))
            {
                lblMessage.Text = errorMessage;
                return;
            }

            if (string.IsNullOrWhiteSpace(txtCode.Text))
            {
                lblMessage.Text = "Code required.";
                return;
            }

            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText =
                    @"SELECT ResetLockedUntil
                      FROM Users
                      WHERE Email = @Email";

                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                    object lockObj = cmd.ExecuteScalar();

                    if (lockObj == null)
                    {
                        lblMessage.Text = "Invalid email.";
                        return;
                    }

                    if (lockObj != DBNull.Value)
                    {
                        DateTime lockedUntil = Convert.ToDateTime(lockObj);

                        if (DateTime.Now < lockedUntil)
                        {
                            lblMessage.Text = "Locked until " + lockedUntil;
                            return;
                        }
                    }
                }

                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText =
                    @"SELECT COUNT(*)
                      FROM Users
                      WHERE Email = @Email
                      AND ResetCode = @Code
                      AND ResetExpiry > @Now";

                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Code", txtCode.Text.Trim());
                    cmd.Parameters.AddWithValue("@Now", DateTime.Now);

                    int valid = (int)cmd.ExecuteScalar();

                    if (valid == 0)
                    {
                        using (SqlCommand lockCmd = conn.CreateCommand())
                        {
                            lockCmd.CommandType = CommandType.Text;

                            lockCmd.CommandText =
                            @"UPDATE Users
                              SET ResetAttempts = ISNULL(ResetAttempts, 0) + 1,
                                  ResetLockedUntil = CASE
                                      WHEN ISNULL(ResetAttempts, 0) + 1 >= 3
                                      THEN @LockTime ELSE ResetLockedUntil END,
                                  ResetCode = CASE
                                      WHEN ISNULL(ResetAttempts, 0) + 1 >= 3
                                      THEN NULL ELSE ResetCode END,
                                  ResetExpiry = CASE
                                      WHEN ISNULL(ResetAttempts, 0) + 1 >= 3
                                      THEN NULL ELSE ResetExpiry END
                              WHERE Email = @Email";

                            lockCmd.Parameters.AddWithValue("@LockTime", DateTime.Now.AddHours(24));
                            lockCmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                            lockCmd.ExecuteNonQuery();
                        }

                        lblMessage.Text = "Invalid code.";
                        return;
                    }
                }

                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText =
                    @"UPDATE Users
                      SET ResetAttempts = 0
                      WHERE Email = @Email";

                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                    cmd.ExecuteNonQuery();
                }
            }

            Response.Redirect("ResetPassword.aspx?email=" + Uri.EscapeDataString(txtEmail.Text.Trim()));
        }

        private bool ValidateEmail(out string errorMessage)
        {
            errorMessage = null;

            if (string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                errorMessage = "Email is required.";
                return false;
            }

            if (!txtEmail.Text.Contains("@") ||
                !txtEmail.Text.Contains(".") ||
                txtEmail.Text.IndexOf("@") > txtEmail.Text.LastIndexOf("."))
            {
                errorMessage = "Invalid email.";
                return false;
            }

            if (!EmailExists(txtEmail.Text.Trim()))
            {
                errorMessage = "Email not found.";
                return false;
            }

            return true;
        }

        private bool EmailExists(string email)
        {
            using (SqlConnection conn = GetConnection())
            {
                conn.Open();

                using (SqlCommand cmd = conn.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText =
                        "SELECT COUNT(*) FROM Users WHERE Email = @Email";

                    cmd.Parameters.AddWithValue("@Email", email);

                    int count = (int)cmd.ExecuteScalar();

                    return count > 0;
                }
            }
        }

        private string GenerateCode()
        {
            return RandomNumberGenerator.GetInt32(100000, 999999).ToString();
        }

        private void SendResetEmail(string email, string code)
        {
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("moss35903@gmail.com");
            mail.To.Add(email);
            mail.Subject = "Password Reset Code";
            mail.Body = "Your code: " + code + "\nExpires in 15 minutes.";

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new System.Net.NetworkCredential(
                "moss35903@gmail.com",
                "miralem74");

            smtp.EnableSsl = true;
            smtp.Send(mail);
        }
    }
}