using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Admin
{
    public partial class PatientManagement : System.Web.UI.Page
    {
        //string conStr = ConfigurationManager.ConnectionStrings["MediCareDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{
            //    LoadPatients();
            //}
        }

        private void LoadPatients(string search = "")
        {
        //    using (SqlConnection con = new SqlConnection(conStr))
        //    {
        //        string query = @"
        //            SELECT 
        //                PatientID,
        //                PatientName,
        //                Age,
        //                Phone,
        //                Phone AS PhoneRaw,
        //                SUBSTRING(PatientName,1,1) AS Initials
        //            FROM Patients
        //            WHERE PatientName LIKE @search
        //            ORDER BY PatientName";

        //        SqlCommand cmd = new SqlCommand(query, con);
        //        cmd.Parameters.AddWithValue("@search", "%" + search + "%");

        //        SqlDataAdapter da = new SqlDataAdapter(cmd);
        //        DataTable dt = new DataTable();
        //        da.Fill(dt);

        //        gvPatients.DataSource = dt;
        //        gvPatients.DataBind();
        //    }
        }

        protected void txtSearchPatients_TextChanged(object sender, EventArgs e)
        {
        //    LoadPatients(txtSearchPatients.Text.Trim());
        }


    }
}