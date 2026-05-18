using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Patient
{
    public partial class Search : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void gvMedicines_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "OpenMedicineModal")
            {
                int medicineId = Convert.ToInt32(e.CommandArgument);

                GridViewRow row =
                    ((Button)e.CommandSource).NamingContainer as GridViewRow;

                string medicineName = row.Cells[0].Text;

                pnlMedicineModal.Visible = true;
            }
        }
        protected void btnCloseModal_Click(object sender, EventArgs e)
        {
            pnlMedicineModal.Visible = false;
        }
        protected void btnSaveMedicine_Click(object sender, EventArgs e)
        {
            string startDate = txtStartDate.Text;
            string endDate = txtEndDate.Text;
            string frequency = ddlFrequency.SelectedValue;
            string pills = txtPillsCount.Text;
            string time = txtTime.Text;
            string mealRelation = ddlMealRelation.SelectedValue;
            bool reminder = chkReminder.Checked;

            // SAVE TO DATABASE HERE

            pnlMedicineModal.Visible = false;
        }

    }
}