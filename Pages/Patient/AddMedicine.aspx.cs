using System;
using System.Configuration;
using System.Data.SqlClient;

namespace MediCare.Pages.Patient
{
    public partial class AddMedicine : System.Web.UI.Page
    {
        private int medicineId;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Get medicine ID from query string
                if (!int.TryParse(Request.QueryString["medicineId"], out medicineId))
                {
                    Response.Redirect("~/Pages/Patient/Search.aspx");
                    return;
                }

                // Load medicine name
                string medicineName = GetMedicineNameById(medicineId);

                lblMedicineName.Text = medicineName;

                // Store medicine ID in ViewState
                ViewState["MedicineId"] = medicineId;
            }
            else
            {
                // Retrieve medicine ID from ViewState on postback
                if (ViewState["MedicineId"] != null)
                {
                    medicineId = Convert.ToInt32(ViewState["MedicineId"]);
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Validate inputs
            if (string.IsNullOrEmpty(txtStartDate.Text) ||
                string.IsNullOrEmpty(txtEndDate.Text))
            {
                lblMessage.Text = "Please fill start and end dates.";
                lblMessage.CssClass = "sea-inline-msg sea-inline-msg--error";
                lblMessage.Visible = true;
                return;
            }

            // Retrieve medicine ID
            if (ViewState["MedicineId"] != null)
            {
                medicineId = Convert.ToInt32(ViewState["MedicineId"]);
            }
            else
            {
                Response.Redirect("~/Pages/Patient/Search.aspx");
                return;
            }

            // Collect data
            string startDate = txtStartDate.Text;
            string endDate = txtEndDate.Text;
            string frequency = ddlFrequency.SelectedValue;
            string pillsCount = txtPillsCount.Text;
            string time = txtTime.Text;
            string mealRelation = ddlMealRelation.SelectedValue;
            bool reminder = chkReminder.Checked;

            // TODO: Save to database here

            // Success message / redirect
            Response.Redirect("~/Pages/Patient/Search.aspx?msg=Medicine+added+successfully");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/Patient/Search.aspx");
        }

        private string GetMedicineNameById(int id)
        {
            string connectionString =
                ConfigurationManager.ConnectionStrings["MediCareConnection"].ConnectionString;

            string medicineName = "Unknown Medicine";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT name FROM Medicine WHERE id = @id";

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
    }
}