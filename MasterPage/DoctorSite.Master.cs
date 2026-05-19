using System;

namespace MediCare.MasterPage
{
    public partial class DoctorSite : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // You can load doctor info here later if you want
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear session and redirect to login
            Session.Abandon();
            Response.Redirect("/Default.aspx");
        }
    }
    
}