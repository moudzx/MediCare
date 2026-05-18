using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Admin
{
    public partial class FoodCatalog : Page
    {

        private readonly string connStr =
                System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadFood();
            }
        }

        private void LoadFood(string search = "", string sort = "")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Food";

                if (!string.IsNullOrEmpty(search))
                {
                    query += " WHERE description LIKE @search";
                }

                switch (sort)
                {
                    case "cal_desc":
                        query += " ORDER BY calories DESC";
                        break;

                    case "cal_asc":
                        query += " ORDER BY calories ASC";
                        break;

                    case "protein":
                        query += " ORDER BY protein DESC";
                        break;
                }

                SqlCommand cmd = new SqlCommand(query, conn);

                if (!string.IsNullOrEmpty(search))
                {
                    cmd.Parameters.AddWithValue("@search", "%" + search + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();

                da.Fill(dt);

                gvFood.DataSource = dt;
                gvFood.DataBind();
            }
        }

        protected void txtSearchFood_TextChanged(object sender, EventArgs e)
        {
            LoadFood(txtSearchFood.Text.Trim(), ddlSortFood.SelectedValue);
        }

        protected void ddlSortFood_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadFood(txtSearchFood.Text.Trim(), ddlSortFood.SelectedValue);
        }

        protected void btnAddFood_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                INSERT INTO Food
                (
                    id,
                    description,
                    calories,
                    protein,
                    total_fat,
                    carbohydrate,
                    sodium,
                    saturated_fat,
                    cholesterol,
                    sugar,
                    calcium,
                    iron,
                    potassium,
                    vitamin_c,
                    vitamin_e,
                    vitamin_d
                )
                VALUES
                (
                    @id,
                    @description,
                    @calories,
                    @protein,
                    @total_fat,
                    @carbohydrate,
                    @sodium,
                    @saturated_fat,
                    @cholesterol,
                    @sugar,
                    @calcium,
                    @iron,
                    @potassium,
                    @vitamin_c,
                    @vitamin_e,
                    @vitamin_d
                )";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@id", txtID.Text.Trim());
                cmd.Parameters.AddWithValue("@description", txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@calories", txtCalories.Text.Trim());
                cmd.Parameters.AddWithValue("@protein", txtProtein.Text.Trim());
                cmd.Parameters.AddWithValue("@total_fat", txtTotalFat.Text.Trim());
                cmd.Parameters.AddWithValue("@carbohydrate", txtCarbohydrate.Text.Trim());
                cmd.Parameters.AddWithValue("@sodium", txtSodium.Text.Trim());
                cmd.Parameters.AddWithValue("@saturated_fat", txtSaturatedFat.Text.Trim());
                cmd.Parameters.AddWithValue("@cholesterol", txtCholesterol.Text.Trim());
                cmd.Parameters.AddWithValue("@sugar", txtSugar.Text.Trim());
                cmd.Parameters.AddWithValue("@calcium", txtCalcium.Text.Trim());
                cmd.Parameters.AddWithValue("@iron", txtIron.Text.Trim());
                cmd.Parameters.AddWithValue("@potassium", txtPotassium.Text.Trim());
                cmd.Parameters.AddWithValue("@vitamin_c", txtVitaminC.Text.Trim());
                cmd.Parameters.AddWithValue("@vitamin_e", txtVitaminE.Text.Trim());
                cmd.Parameters.AddWithValue("@vitamin_d", txtVitaminD.Text.Trim());

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            lblMessage.Text = "Food item added successfully.";
            lblMessage.Visible = true;

            ClearFields();

            LoadFood();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;

            string id = btn.CommandArgument;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Food WHERE id=@id";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@id", id);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            lblMessage.Text = "Food item deleted successfully.";
            lblMessage.Visible = true;

            LoadFood();
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;

            string id = btn.CommandArgument;

            lblMessage.Text = "Edit clicked for ID: " + id;
            lblMessage.Visible = true;
        }

        protected void gvFood_RowCommand(object sender, GridViewCommandEventArgs e)
        {

        }

        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {

        }

        protected void btnCancelModal_Click(object sender, EventArgs e)
        {
            ClearFields();
        }

        protected void btnHamburger_Click(object sender, EventArgs e)
        {

        }

        private void ClearFields()
        {
            txtID.Text = "";
            txtDescription.Text = "";
            txtCalories.Text = "";
            txtProtein.Text = "";
            txtTotalFat.Text = "";
            txtCarbohydrate.Text = "";
            txtSodium.Text = "";
            txtSaturatedFat.Text = "";
            txtCholesterol.Text = "";
            txtSugar.Text = "";
            txtCalcium.Text = "";
            txtIron.Text = "";
            txtPotassium.Text = "";
            txtVitaminC.Text = "";
            txtVitaminE.Text = "";
            txtVitaminD.Text = "";
        }
    }
}