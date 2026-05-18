using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Admin
{
    public partial class FoodCatalog : System.Web.UI.Page
    {
       
              //string conStr = ConfigurationManager.ConnectionStrings["MediCareDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            //    if (!IsPostBack)
            //    {
            //        LoadFood();
            //    }
        }

        private void LoadFood(string search = "", string sort = "")
        {
            //using (SqlConnection con = new SqlConnection(conStr))
            //{
            //    string query = @"
            //        SELECT 
            //            ID,
            //            Description,
            //            Calories,
            //            Protein,
            //            TotalFat,
            //            Carbohydrate,
            //            Sodium,
            //            SaturatedFat,
            //            Cholesterol,
            //            Sugar,
            //            Calcium,
            //            Iron,
            //            Potassium,
            //            VitaminC,
            //            VitaminE,
            //            VitaminD
            //        FROM FoodItems
            //        WHERE Description LIKE @search";

            //    if (sort == "cal_desc")
            //        query += " ORDER BY Calories DESC";
            //    else if (sort == "cal_asc")
            //        query += " ORDER BY Calories ASC";
            //    else if (sort == "protein")
            //        query += " ORDER BY Protein DESC";
            //    else if (sort == "az")
            //        query += " ORDER BY Description ASC";
            //    else
            //        query += " ORDER BY ID DESC";

            //    using (SqlCommand cmd = new SqlCommand(query, con))
            //    {
            //        cmd.Parameters.AddWithValue("@search", "%" + search + "%");

            //        SqlDataAdapter da = new SqlDataAdapter(cmd);
            //        DataTable dt = new DataTable();

            //        da.Fill(dt);

            //        gvFood.DataSource = dt;
            //        gvFood.DataBind();
            //    }
            //}
        }

        protected void txtSearchFood_TextChanged(object sender, EventArgs e)
        {
            //LoadFood(txtSearchFood.Text.Trim(), ddlSortFood.SelectedValue);
        }

        protected void ddlSortFood_SelectedIndexChanged(object sender, EventArgs e)
        {
            //LoadFood(txtSearchFood.Text.Trim(), ddlSortFood.SelectedValue);
        }
    }
    
}