using System;
using System.Configuration;
using System.Data.SqlClient;

namespace MediCare.Pages.Patient
{
    public partial class AddMedicine : System.Web.UI.Page
    {
        private readonly string connectionString =
                System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;


        private string medicineId = "";
        private string medicineName = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Patient")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            medicineId = Request.QueryString["medicineId"];

            if (string.IsNullOrWhiteSpace(medicineId))
            {
                Response.Redirect("~/Pages/Patient/Search.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadMedicine();

                txtStartDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtEndDate.Text = DateTime.Now.AddDays(7).ToString("yyyy-MM-dd");
            }
        }


        private void LoadMedicine()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT
                        atc,
                        name
                    FROM Medicine
                    WHERE atc = @MedicineId";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@MedicineId", medicineId);

                    conn.Open();

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        medicineName = reader["name"].ToString();

                        lblMedicineName.Text = medicineName;
                    }
                    else
                    {
                        Response.Redirect("~/Pages/Patient/Search.aspx");
                    }
                }
            }
        }


        protected void btnSave_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = false;

            int patientId = Convert.ToInt32(Session["UserId"]);

            string dosage = txtPillsCount.Text.Trim() + " pill(s)";
            string frequency = ddlFrequency.SelectedItem.Text;

            string duration = "";

            DateTime startDate;
            DateTime endDate;

            if (!DateTime.TryParse(txtStartDate.Text, out startDate))
            {
                ShowMessage("Please select a valid start date.");
                return;
            }

            if (!DateTime.TryParse(txtEndDate.Text, out endDate))
            {
                ShowMessage("Please select a valid end date.");
                return;
            }

            if (endDate < startDate)
            {
                ShowMessage("End date cannot be before start date.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtPillsCount.Text))
            {
                ShowMessage("Please enter pills count.");
                return;
            }

            int totalDays = (endDate - startDate).Days + 1;

            duration = totalDays + " day(s)";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    INSERT INTO PatientMedications
                    (
                        PatientId,
                        DoctorId,
                        MedicineId,
                        Dosage,
                        Frequency,
                        Duration,
                        StartDate,
                        EndDate,
                        Status
                    )
                    VALUES
                    (
                        @PatientId,
                        0,
                        @MedicineId,
                        @Dosage,
                        @Frequency,
                        @Duration,
                        @StartDate,
                        @EndDate,
                        'Active'
                    )";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", patientId);
                    cmd.Parameters.AddWithValue("@MedicineId", medicineId);
                    cmd.Parameters.AddWithValue("@Dosage", dosage);
                    cmd.Parameters.AddWithValue("@Frequency", frequency);
                    cmd.Parameters.AddWithValue("@Duration", duration);
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
            }

            ShowMessage("Medicine schedule saved successfully.");

            ClearForm();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/Patient/Search.aspx");
        }

        private void ShowMessage(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }

        private void ClearForm()
        {
            txtPillsCount.Text = "";
            txtTime.Text = "";

            ddlFrequency.SelectedIndex = 0;
            ddlMealRelation.SelectedIndex = 0;

            chkReminder.Checked = false;

            txtStartDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtEndDate.Text = DateTime.Now.AddDays(7).ToString("yyyy-MM-dd");
        }
    }
}