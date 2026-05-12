using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;

// emlt download la BCrypt endi w nzed bel .config
// eza 3ndkn ma chta8al futu aa package manager console w ktbu hydi
// Install-Package BCrypt.Net-Next

namespace MediCare
{
    public partial class Default : System.Web.UI.Page
    {
        private readonly string connectionString =
            System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected SqlConnection GetConnection()
        {
            return new SqlConnection(connectionString);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnPatientSignUp_Click(object sender, EventArgs e)
        {
            lblPatientMessage.Visible = true;

            if (!ValidatePatient(out string errorMessage))
            {
                lblPatientMessage.Text = errorMessage;
                return;
            }

            SqlConnection conn = GetConnection();
            conn.Open();

            // user table
            SqlCommand cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.Text;
            cmd.CommandText = @"INSERT INTO Users (Email, PasswordHash, Role, CreatedAt) 
                                VALUES (@Email, @Hash, 'Patient', @Date);
                                SELECT SCOPE_IDENTITY();";

            cmd.Parameters.AddWithValue("@Email", txtPatientEmail.Text.Trim());
            string passwordHash = BCrypt.Net.BCrypt.HashPassword(txtPatientPassword.Text);
            cmd.Parameters.AddWithValue("@Hash", passwordHash);
            cmd.Parameters.AddWithValue("@Date", DateTime.Now);
            int userId = Convert.ToInt32(cmd.ExecuteScalar());

            cmd.Dispose();

            // patient table
            cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.Text;
            cmd.CommandText = @"INSERT INTO Patients 
                                (UserId, FullName, Age, Height, Weight, Disability, ChronicDisease, FamilyHistory)
                                VALUES 
                                (@UserId, @Name, @Age, @Height, @Weight, @Disability, @Disease, @Family)";

            // dont forget to set identity: PatientId INT IDENTITY PRIMARY KEY
            cmd.Parameters.AddWithValue("@UserId", userId);
            cmd.Parameters.AddWithValue("@Name", txtPatientName.Text.Trim());
            cmd.Parameters.AddWithValue("@Age", int.Parse(txtPatientAge.Text));
            cmd.Parameters.AddWithValue("@Height", string.IsNullOrWhiteSpace(txtPatientHeight.Text) ? DBNull.Value : (object)double.Parse(txtPatientHeight.Text));
            cmd.Parameters.AddWithValue("@Weight", string.IsNullOrWhiteSpace(txtPatientWeight.Text) ? DBNull.Value : (object)double.Parse(txtPatientWeight.Text));
            cmd.Parameters.AddWithValue("@Disability", string.IsNullOrWhiteSpace(txtDisability.Text) ? DBNull.Value : (object)txtDisability.Text.Trim());
            cmd.Parameters.AddWithValue("@Disease", string.IsNullOrWhiteSpace(txtChronicDisease.Text) ? DBNull.Value : (object)txtChronicDisease.Text.Trim());
            cmd.Parameters.AddWithValue("@Family", string.IsNullOrWhiteSpace(txtFamilyHistory.Text) ? DBNull.Value : (object)txtFamilyHistory.Text.Trim());
            cmd.ExecuteNonQuery();

            cmd.Dispose();
            conn.Close();

            Response.Write("<script>alert('Registration successful. You can now sign in.')</script>");
            Response.Redirect("Pages/Account/Login.aspx");
        }

        protected void btnDoctorSignUp_Click(object sender, EventArgs e)
        {
            lblDoctorMessage.Visible = true;

            if (!ValidateDoctor(out string errorMessage, out string certificatePath))
            {
                lblDoctorMessage.Text = errorMessage;
                return;
            }


            SqlConnection conn = GetConnection();
            conn.Open();

            // user table
            SqlCommand cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.Text;
            cmd.CommandText = @"INSERT INTO Users (Email, PasswordHash, Role, CreatedAt) 
                                VALUES (@Email, @Hash, 'Doctor', @Date);
                                SELECT SCOPE_IDENTITY();";

            cmd.Parameters.AddWithValue("@Email", txtDoctorEmail.Text.Trim());
            string passwordHash = BCrypt.Net.BCrypt.HashPassword(txtDoctorPassword.Text);
            cmd.Parameters.AddWithValue("@Hash", passwordHash);
            cmd.Parameters.AddWithValue("@Date", DateTime.Now);
            int userId = Convert.ToInt32(cmd.ExecuteScalar());

            cmd.Dispose();

            // doctor table
            cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.Text;
            cmd.CommandText = @"INSERT INTO Doctors 
                                (UserId, FullName, Age, CertificatePath)
                                VALUES 
                                (@UserId, @Name, @Age, @Path)";

            // dont forget to set identity: DoctorId INT IDENTITY PRIMARY KEY
            cmd.Parameters.AddWithValue("@UserId", userId);
            cmd.Parameters.AddWithValue("@Name", txtDoctorName.Text.Trim());
            cmd.Parameters.AddWithValue("@Age", int.Parse(txtDoctorAge.Text));
            cmd.Parameters.AddWithValue("@Path", certificatePath);
            cmd.ExecuteNonQuery();

            cmd.Dispose();
            conn.Close();

            Response.Write("<script>alert('Registration successful. You can now sign in.')</script>");
            Response.Redirect("Pages/Account/Login.aspx");
        }

        private bool ValidatePatient(out string errorMessage)
        {
            errorMessage = null;

            if (string.IsNullOrWhiteSpace(txtPatientName.Text))
            {
                errorMessage = "Full name is required.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtPatientEmail.Text))
            {
                errorMessage = "Email is required.";
                return false;
            }

            if (!txtPatientEmail.Text.Contains("@") ||
                !txtPatientEmail.Text.Contains(".") ||
                txtPatientEmail.Text.IndexOf("@") > txtPatientEmail.Text.LastIndexOf("."))
            {
                errorMessage = "Please enter a valid email.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtPatientPassword.Text))
            {
                errorMessage = "Password is required.";
                return false;
            }

            if (txtPatientPassword.Text.Length < 8)
            {
                errorMessage = "Password must be at least 8 characters.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtPatientConfirmPwd.Text))
            {
                errorMessage = "Please confirm your password.";
                return false;
            }

            if (txtPatientPassword.Text != txtPatientConfirmPwd.Text)
            {
                errorMessage = "Passwords do not match.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtPatientAge.Text))
            {
                errorMessage = "Age is required.";
                return false;
            }

            if (!int.TryParse(txtPatientAge.Text, out int age) || age <= 0 || age > 150)
            {
                errorMessage = "Please enter a valid age (1-150).";
                return false;
            }

            if (!string.IsNullOrWhiteSpace(txtPatientHeight.Text))
            {
                if (!double.TryParse(txtPatientHeight.Text, out double height) || height <= 0)
                {
                    errorMessage = "Height must be a positive number.";
                    return false;
                }
            }

            if (!string.IsNullOrWhiteSpace(txtPatientWeight.Text))
            {
                if (!double.TryParse(txtPatientWeight.Text, out double weight) || weight <= 0)
                {
                    errorMessage = "Weight must be a positive number.";
                    return false;
                }
            }

            if (EmailExists(txtPatientEmail.Text.Trim()))
            {
                errorMessage = "This email is already registered. Please sign in or use another email.";
                return false;
            }

            return true;
        }

        private bool ValidateDoctor(out string errorMessage, out string certificatePath)
        {
            errorMessage = null;
            certificatePath = null;

            if (string.IsNullOrWhiteSpace(txtDoctorName.Text))
            {
                errorMessage = "Full name is required.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDoctorEmail.Text))
            {
                errorMessage = "Email is required.";
                return false;
            }

            if (!txtDoctorEmail.Text.Contains("@") ||
                !txtDoctorEmail.Text.Contains(".") ||
                txtDoctorEmail.Text.IndexOf("@") > txtDoctorEmail.Text.LastIndexOf("."))
            {
                errorMessage = "Please enter a valid email.";
                return false;
            }

            if (EmailExists(txtDoctorEmail.Text.Trim()))
            {
                errorMessage = "This email is already registered. Please use another email.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDoctorPassword.Text))
            {
                errorMessage = "Password is required.";
                return false;
            }

            if (txtDoctorPassword.Text.Length < 8)
            {
                errorMessage = "Password must be at least 8 characters.";
                return false;
            }

            if (string.IsNullOrWhiteSpace(txtDoctorAge.Text))
            {
                errorMessage = "Age is required.";
                return false;
            }

            if (!int.TryParse(txtDoctorAge.Text, out int age) || age <= 0 || age > 150)
            {
                errorMessage = "Please enter a valid age (1-150).";
                return false;
            }

            if (!fuDoctorCertificate.HasFile)
            {
                errorMessage = "Please upload your medical certificate.";
                return false;
            }

            HttpPostedFile file = fuDoctorCertificate.PostedFile;
            string fileName = Path.GetFileName(file.FileName);
            string extension = Path.GetExtension(fileName).ToLower();
            string[] allowedExtensions = { ".pdf", ".jpg", ".jpeg", ".png" };

            if (Array.IndexOf(allowedExtensions, extension) == -1)
            {
                errorMessage = "Only PDF, JPG, JPEG, PNG files are allowed.";
                return false;
            }

            if (file.ContentLength > 10 * 1024 * 1024)
            {
                errorMessage = "File size must be less than 10 MB.";
                return false;
            }

            string uploadFolder = Server.MapPath("~/Uploads/Certificates/");
            if (!Directory.Exists(uploadFolder))
                Directory.CreateDirectory(uploadFolder);

            string uniqueFileName = Guid.NewGuid().ToString() + extension;
            string savePath = Path.Combine(uploadFolder, uniqueFileName);
            file.SaveAs(savePath);
            certificatePath = "~/Uploads/Certificates/" + uniqueFileName;

            return true;
        }

        private bool EmailExists(string email)
        {
            SqlConnection conn = GetConnection();
            conn.Open();

            SqlCommand cmd = conn.CreateCommand();
            cmd.CommandType = CommandType.Text;
            cmd.CommandText = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
            cmd.Parameters.AddWithValue("@Email", email);
            int count = (int)cmd.ExecuteScalar();

            cmd.Dispose();
            conn.Close();

            return count > 0;
        }

    }
}