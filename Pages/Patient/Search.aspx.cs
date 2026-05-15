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
            if (e.CommandName == "AddToFavorites") // change this to whatever your button does
            {
                int medicineId = Convert.ToInt32(e.CommandArgument);
                // your logic here
            }
        }
    }
}