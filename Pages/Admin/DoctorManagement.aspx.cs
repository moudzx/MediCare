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
    public partial class DoctorManagement : System.Web.UI.Page
    {
        //string conStr = ConfigurationManager.ConnectionStrings["MediCareDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{
            //    LoadDoctors();
            //}
        }

        private void LoadDoctors(string search = "")
        {
            //using (SqlConnection con = new SqlConnection(conStr))
            //{
            //    string query = @"
            //        SELECT 
            //            ID,
            //            DoctorName,
            //            Specialty,
            //            SpecialtyIcon,
            //            Email,
            //            Phone
            //        FROM Doctors
            //        WHERE 
            //            DoctorName LIKE @search
            //            OR Specialty LIKE @search
            //        ORDER BY DoctorName";

            //    SqlCommand cmd = new SqlCommand(query, con);
            //    cmd.Parameters.AddWithValue("@search", "%" + search + "%");

            //    SqlDataAdapter da = new SqlDataAdapter(cmd);
            //    DataTable dt = new DataTable();
            //    da.Fill(dt);

            //    gvDoctors.DataSource = dt;
            //    gvDoctors.DataBind();
            //}
        }

        protected void txtSearchDoctors_TextChanged(object sender, EventArgs e)
        {
            //LoadDoctors(txtSearchDoctors.Text.Trim());
        }
    }
}