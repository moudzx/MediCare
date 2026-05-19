using System;

namespace MediCare
{
    public partial class DoctorSiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblDoctorName.Text = "Dr. " + Session["Name"];
            //lblSpecialty.Text = Session["Specialty"].ToString();
            //lblTopName.Text = Session["Name"].ToString();
            //lblEmail.Text = Session["Email"].ToString();
            lblRoleBadge.Text = "Doctor";
            lblFooter.Text = "© MediCare " + DateTime.Now.Year;

        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("~/Default.aspx");
        }
    }
}