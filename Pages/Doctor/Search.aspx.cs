using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Doctor
{
    public partial class Search : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            
        }

        

        protected void gvFoods_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            
        }
        protected void gvMedicines_RowCommand(object sender, GridViewCommandEventArgs e)
        {

        }
    }
}