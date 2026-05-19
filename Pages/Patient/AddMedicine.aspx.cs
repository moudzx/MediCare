using System;
using System.Configuration;
using System.Data.SqlClient;

namespace MediCare.Pages.Patient
{
    public partial class AddMedicine : System.Web.UI.Page
    {
        private string medicineId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                medicineId = Request.QueryString["medicineId"];

                if (string.IsNullOrWhiteSpace(medicineId))
                {
                    Response.Redirect("~/Pages/Patient/Search.aspx");
                    return;
                }

                ViewState["MedicineId"] = medicineId;

                string medicineName = GetMedicineNameById(medicineId);
                lblMedicineName.Text = medicineName;
            }
            else
            {
                if (ViewState["MedicineId"] != null)
                {
                    medicineId = ViewState["MedicineId"].ToString();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtStartDate.Text) ||
                string.IsNullOrWhiteSpace(txtEndDate.Text))
            {
                lblMessage.Text = "Please fill start and end dates.";
                lblMessage.CssClass = "sea-inline-msg sea-inline-msg--error";
                lblMessage.Visible = true;
                return;
            }

            if (ViewState["MedicineId"] == null)
            {
                Response.Redirect("~/Pages/Patient/Search.aspx");
                return;
            }

            string medicineId = ViewState["MedicineId"].ToString();

            int userId = Convert.ToInt32(Session["UserId"]);
            int patientId = GetPatientId();

            if (patientId == 0)
            {
                lblMessage.Text = "Patient not found.";
                lblMessage.CssClass = "sea-inline-msg sea-inline-msg--error";
                lblMessage.Visible = true;
                return;
            }

            string frequencyText = ddlFrequency.SelectedItem.Text;
            string pillsCount = txtPillsCount.Text;
            string time = txtTime.Text;
            string mealRelation = ddlMealRelation.SelectedValue;
            bool reminder = chkReminder.Checked;

            DateTime startDate = Convert.ToDateTime(txtStartDate.Text);
            DateTime endDate = Convert.ToDateTime(txtEndDate.Text);

            using (SqlConnection conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
            {
                string query = @"
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
                                NULL,
                                @MedicineId,
                                @Dosage,
                                @Frequency,
                                @Duration,
                                @StartDate,
                                @EndDate,
                                'Active'
                            )";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", patientId);
                    cmd.Parameters.AddWithValue("@MedicineId", medicineId);
                    cmd.Parameters.AddWithValue("@Dosage", pillsCount ?? "");
                    cmd.Parameters.AddWithValue("@Frequency", frequencyText);
                    cmd.Parameters.AddWithValue("@Duration", mealRelation);
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            Response.Redirect("~/Pages/Patient/Search.aspx?msg=Medicine+added+successfully");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/Patient/Search.aspx");
        }

        private string GetMedicineNameById(string id)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

            string medicineName = "Unknown Medicine";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT name FROM Medicine WHERE atc = @id";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@id", id);

                    conn.Open();

                    object result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        medicineName = result.ToString();
                    }
                }
            }

            return medicineName;
        }
        private int GetPatientId()
        {
            if (Session["UserId"] == null)
                return 0;

            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString))
            {
                string query = @"
            SELECT PatientId
            FROM Patients
            WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();

                    object result = cmd.ExecuteScalar();

                    if (result != null && result != DBNull.Value)
                        return Convert.ToInt32(result);
                }
            }

            return 0;
        }
    }
}