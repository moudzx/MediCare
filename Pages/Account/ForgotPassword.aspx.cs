using System;
using System.Data;
using System.Data.SqlClient;
using System.Net.Mail;
using System.Security.Cryptography;

namespace MediCare.Pages.Account
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        private string cs => System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private SqlConnection GetConnection() => new SqlConnection(cs);

        protected void btnSendCode_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = true;

            if (!EmailExists(txtEmail.Text.Trim()))
            {
                lblMessage.Text = "Email not found.";
                return;
            }

            string code = GenerateCode();

            using (var conn = GetConnection())
            {
                conn.Open();
                var cmd = new SqlCommand(@"
                    UPDATE Users
                    SET ResetCode=@Code,
                        ResetExpiry=@Expiry,
                        ResetAttempts=0,
                        ResetLockedUntil=NULL
                    WHERE Email=@Email", conn);

                cmd.Parameters.AddWithValue("@Code", code);
                cmd.Parameters.AddWithValue("@Expiry", DateTime.Now.AddMinutes(15));
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                cmd.ExecuteNonQuery();
            }

            SendResetEmail(txtEmail.Text.Trim(), code);

            lblMessage.Text = "Code sent.";
        }

        protected void btnVerifyCode_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = true;

            string email = txtEmail.Text.Trim();
            string code = txtCode.Text.Trim();

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(code))
            {
                lblMessage.Text = "Missing data.";
                return;
            }

            using (var conn = GetConnection())
            {
                conn.Open();

                var cmd = new SqlCommand(@"
                    SELECT ResetCode, ResetExpiry, ISNULL(ResetAttempts,0), ResetLockedUntil
                    FROM Users
                    WHERE Email=@Email", conn);

                cmd.Parameters.AddWithValue("@Email", email);

                using (var r = cmd.ExecuteReader())
                {
                    if (!r.Read())
                    {
                        lblMessage.Text = "Invalid email.";
                        return;
                    }

                    string dbCode = r["ResetCode"] as string;
                    DateTime? expiry = r["ResetExpiry"] as DateTime?;
                    int attempts = Convert.ToInt32(r[2]);
                    DateTime? locked = r["ResetLockedUntil"] as DateTime?;

                    if (locked != null && DateTime.Now < locked)
                    {
                        lblMessage.Text = "Locked for 24 hours.";
                        return;
                    }

                    bool expired = expiry == null || expiry < DateTime.Now;
                    bool valid = !expired && dbCode == code;

                    r.Close();

                    if (!valid)
                    {
                        attempts++;

                        SqlCommand up;

                        if (attempts >= 3)
                        {
                            up = new SqlCommand(@"
                                UPDATE Users
                                SET ResetAttempts=3,
                                    ResetLockedUntil=@Lock,
                                    ResetCode=NULL,
                                    ResetExpiry=NULL
                                WHERE Email=@Email", conn);

                            up.Parameters.AddWithValue("@Lock", DateTime.Now.AddHours(24));
                        }
                        else
                        {
                            up = new SqlCommand(@"
                                UPDATE Users
                                SET ResetAttempts=@A
                                WHERE Email=@Email", conn);

                            up.Parameters.AddWithValue("@A", attempts);
                        }

                        up.Parameters.AddWithValue("@Email", email);
                        up.ExecuteNonQuery();

                        lblMessage.Text = "Invalid code.";
                        return;
                    }

                    var ok = new SqlCommand(@"
                        UPDATE Users
                        SET ResetAttempts=0,
                            ResetLockedUntil=NULL
                        WHERE Email=@Email", conn);

                    ok.Parameters.AddWithValue("@Email", email);
                    ok.ExecuteNonQuery();
                }
            }

            Response.Redirect("NewPassword.aspx?email=" + Server.UrlEncode(email));
        }

        protected void btnResendCode_Click(object sender, EventArgs e)
        {
            btnSendCode_Click(sender, e);
        }

        private bool EmailExists(string email)
        {
            using (var conn = GetConnection())
            {
                conn.Open();
                var cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Email=@E", conn);
                cmd.Parameters.AddWithValue("@E", email);
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        private string GenerateCode()
        {
            byte[] b = new byte[4];
            RandomNumberGenerator.Create().GetBytes(b);
            int v = Math.Abs(BitConverter.ToInt32(b, 0)) % 900000 + 100000;
            return v.ToString();
        }

        private void SendResetEmail(string email, string code)
        {
            var mail = new MailMessage();
            mail.From = new MailAddress("moss35903@gmail.com");
            mail.To.Add(email);
            mail.Subject = "Reset Code";
            mail.Body = code;

            var smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new System.Net.NetworkCredential("moss35903@gmail.com", "gdgl rzew hths okia");
            smtp.EnableSsl = true;
            smtp.Send(mail);
        }
    }
}