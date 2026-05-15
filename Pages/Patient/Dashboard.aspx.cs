


using System;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace MediCare.Patient
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
        }
        //when implementing the method for the checkbox of the taken dose
        //be sure to add to the checkbox tag this: OnCheckedChanged="function_name" 
        //so the checkbox interact with the function babyyy
        protected void btnFindDoctors_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Pages/Patient/SearchDoctors.aspx");
        }
    }
}

