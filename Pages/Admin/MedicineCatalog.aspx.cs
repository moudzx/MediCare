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
    public partial class MedicineCatalog : System.Web.UI.Page
    {
       

            //string conStr = ConfigurationManager.ConnectionStrings["MediCareDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!IsPostBack)
            //{
            //    LoadMedicines();
            //}
        }

        private void LoadMedicines(string search = "")
        {
            //using (SqlConnection con = new SqlConnection(conStr))
            //{
            //    string query = @"
            //    SELECT 
            //        ID,
            //        MedicineName,
            //        Description,
            //        ATCCode,
            //        Dosage,
            //        Form,
            //        FormIcon,
            //        Ingredients,
            //        Price
            //    FROM Medicines
            //    WHERE 
            //        MedicineName LIKE @search
            //        OR ATCCode LIKE @search
            //    ORDER BY MedicineName";

            //    SqlCommand cmd = new SqlCommand(query, con);

            //    cmd.Parameters.AddWithValue("@search", "%" + search + "%");

            //    SqlDataAdapter da = new SqlDataAdapter(cmd);

            //    DataTable dt = new DataTable();

            //    da.Fill(dt);

            //    gvMedicines.DataSource = dt;
            //    gvMedicines.DataBind();
            //}
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            //LoadMedicines(txtSearch.Text.Trim());
        }

    
    }
}