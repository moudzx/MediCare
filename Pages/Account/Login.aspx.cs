using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

//hon bdna nktob onclick lal login button w eza klchi valid (user, pass) mnaaml store lal info bi session
//w eza Patient -> ~/Pages/Patient/Dashboard.aspx
//w eza Doctor -> ~/Pages/Doctor/Dashboard.aspx
//w eza Admin -> ~/Pages/Admin/Dashboard.aspx

namespace MediCare.Pages.Account
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // For now, this just prevents the error. 
            // We will add the actual login logic here later.
        }
    }
}