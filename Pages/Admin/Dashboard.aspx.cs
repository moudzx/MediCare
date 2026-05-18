using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Admin
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void gvPatients_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Panel pnlAvatar = (Panel)e.Row.FindControl("pnlAvatar");

                string color = DataBinder.Eval(e.Row.DataItem, "AvatarColor").ToString();

                pnlAvatar.Style["background"] = color;
                pnlAvatar.Style["width"] = "32px";
                pnlAvatar.Style["height"] = "32px";
                pnlAvatar.Style["font-size"] = "0.75rem";
            }
        }
    }
}