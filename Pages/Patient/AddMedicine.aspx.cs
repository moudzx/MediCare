using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace MediCare.Pages.Patient
{
    public partial class AddMedicine : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("Search.aspx");
        }
    }
}