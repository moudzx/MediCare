using System;
using System.Configuration;
using System.Data.SqlClient;

namespace MediCare.Pages.Patient
{
    public partial class AddMedicine : System.Web.UI.Page
    {
        private int medicineId;


        private string medicineId = "";
        private string medicineName = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                // Get medicine ID from query string
                if (!int.TryParse(Request.QueryString["medicineId"], out medicineId))
                {
                    Response.Redirect("Search.aspx");
                    return;
                }

                // Load medicine name from your data source (DB or static list)
                string medicineName = GetMedicineNameById(medicineId);
                lblMedicineName.Text = medicineName;

                // Store ID in ViewState for later use
                ViewState["MedicineId"] = medicineId;
            }
            else
            {
                // On postback, retrieve ID from ViewState
                medicineId = (int)ViewState["MedicineId"];
            }
        }


        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Validate inputs
            if (string.IsNullOrEmpty(txtStartDate.Text) || string.IsNullOrEmpty(txtEndDate.Text))
            {
                lblMessage.Text = "Please fill start and end dates.";
                lblMessage.CssClass = "sea-inline-msg sea-inline-msg--error";
                lblMessage.Visible = true;
                return;
            }

            //Collect data
            string startDate = txtStartDate.Text;
            string endDate = txtEndDate.Text;
            string frequency = ddlFrequency.SelectedValue;
            string pillsCount = txtPillsCount.Text;
            string time = txtTime.Text;
            string mealRelation = ddlMealRelation.SelectedValue;
            bool reminder = chkReminder.Checked;

            //Save to database
            //Use medicineId to know which medicine was selected

            //Redirect back to search with success message
            Response.Redirect($"Search.aspx?msg=Medicine+added+successfully");
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/Patient/Search.aspx");
        }

        
        private string GetMedicineNameById(int id)
        {
            return "Unknown Medicine";
        }
    }
}