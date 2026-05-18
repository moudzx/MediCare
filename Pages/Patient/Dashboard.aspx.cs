using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace MediCare.Patient
{
    public partial class Dashboard : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null || 
                Session["Role"].ToString() != "Patient")
            {
                Response.Redirect("Pages/Account/Login.aspx");
                return;
            }


            int userId = Convert.ToInt32(Session["UserId"]);

            //
        }
    }
}

