using System;
using System.IO;
using System.Web;
using System.Web.UI;

namespace MediCare.Pages.Admin
{
    public partial class AdminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public string ActiveLink(string pageName)
        {
            string current = Path.GetFileNameWithoutExtension(Request.PhysicalPath);
            return current.Equals(pageName, StringComparison.OrdinalIgnoreCase)
                ? "mc-nav-active"
                : string.Empty;
        }

        protected void lbLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            if (HttpContext.Current.Response.Cookies["ASP.NET_SessionId"] != null)
            {
                HttpContext.Current.Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddDays(-1);
            }

            Response.Redirect("~/Default.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}