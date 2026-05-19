using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Admin
{
    public partial class FoodCatalog : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        private bool IsEditMode
        {
            get
            {
                return ViewState["IsEditMode"] != null &&
                       (bool)ViewState["IsEditMode"];
            }
            set
            {
                ViewState["IsEditMode"] = value;
            }
        }

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

                if (!string.IsNullOrWhiteSpace(search))
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

                    default:
                        query += " ORDER BY id ASC";
                        break;
                }

                SqlCommand cmd = new SqlCommand(query, conn);

                if (!string.IsNullOrWhiteSpace(search))
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

        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            ClearFields();

            pnlForm.Visible = true;

            txtID.Enabled = true;

            IsEditMode = false;

            lblFormTitle.Text = "Add Food Item";

            btnSave.Text = "Add Item";

            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "scrollForm",
                "scrollToForm();",
                true
            );
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query;

                    if (IsEditMode)
                    {
                        query = @"
                        UPDATE Food
                        SET
                            description = @description,
                            calories = @calories,
                            protein = @protein,
                            total_fat = @total_fat,
                            carbohydrate = @carbohydrate,
                            sodium = @sodium,
                            saturated_fat = @saturated_fat,
                            cholesterol = @cholesterol,
                            sugar = @sugar,
                            calcium = @calcium,
                            iron = @iron,
                            potassium = @potassium,
                            vitamin_c = @vitamin_c,
                            vitamin_e = @vitamin_e,
                            vitamin_d = @vitamin_d
                        WHERE id = @id";
                    }
                    else
                    {
                        query = @"
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
                    }

                    SqlCommand cmd = new SqlCommand(query, conn);

                    cmd.Parameters.AddWithValue("@id", Convert.ToInt32(txtID.Text));
                    cmd.Parameters.AddWithValue("@description", txtDescription.Text.Trim());

                    cmd.Parameters.AddWithValue("@calories", ParseNullableDouble(txtCalories.Text));
                    cmd.Parameters.AddWithValue("@protein", ParseNullableDouble(txtProtein.Text));
                    cmd.Parameters.AddWithValue("@total_fat", ParseNullableDouble(txtTotalFat.Text));
                    cmd.Parameters.AddWithValue("@carbohydrate", ParseNullableDouble(txtCarbohydrate.Text));
                    cmd.Parameters.AddWithValue("@sodium", ParseNullableDouble(txtSodium.Text));
                    cmd.Parameters.AddWithValue("@saturated_fat", ParseNullableDouble(txtSaturatedFat.Text));
                    cmd.Parameters.AddWithValue("@cholesterol", ParseNullableDouble(txtCholesterol.Text));
                    cmd.Parameters.AddWithValue("@sugar", ParseNullableDouble(txtSugar.Text));
                    cmd.Parameters.AddWithValue("@calcium", ParseNullableDouble(txtCalcium.Text));
                    cmd.Parameters.AddWithValue("@iron", ParseNullableDouble(txtIron.Text));
                    cmd.Parameters.AddWithValue("@potassium", ParseNullableDouble(txtPotassium.Text));
                    cmd.Parameters.AddWithValue("@vitamin_c", ParseNullableDouble(txtVitaminC.Text));
                    cmd.Parameters.AddWithValue("@vitamin_e", ParseNullableDouble(txtVitaminE.Text));
                    cmd.Parameters.AddWithValue("@vitamin_d", ParseNullableDouble(txtVitaminD.Text));

                    conn.Open();

                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = IsEditMode
                    ? "Food item updated successfully."
                    : "Food item added successfully.";

                lblMessage.Visible = true;

                pnlForm.Visible = false;

                ClearFields();

                LoadFood();
            }
            catch (Exception ex)
            {
                lblMessage.Text = ex.Message;
                lblMessage.Visible = true;

                pnlForm.Visible = true;
            }
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;

            int id = Convert.ToInt32(btn.CommandArgument);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Food WHERE id=@id";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@id", id);

                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtID.Text = reader["id"].ToString();
                    txtDescription.Text = reader["description"].ToString();
                    txtCalories.Text = reader["calories"].ToString();
                    txtProtein.Text = reader["protein"].ToString();
                    txtTotalFat.Text = reader["total_fat"].ToString();
                    txtCarbohydrate.Text = reader["carbohydrate"].ToString();
                    txtSodium.Text = reader["sodium"].ToString();
                    txtSaturatedFat.Text = reader["saturated_fat"].ToString();
                    txtCholesterol.Text = reader["cholesterol"].ToString();
                    txtSugar.Text = reader["sugar"].ToString();
                    txtCalcium.Text = reader["calcium"].ToString();
                    txtIron.Text = reader["iron"].ToString();
                    txtPotassium.Text = reader["potassium"].ToString();
                    txtVitaminC.Text = reader["vitamin_c"].ToString();
                    txtVitaminE.Text = reader["vitamin_e"].ToString();
                    txtVitaminD.Text = reader["vitamin_d"].ToString();

                    txtID.Enabled = false;

                    IsEditMode = true;

                    lblFormTitle.Text = "Edit Food Item";

                    btnSave.Text = "Update Item";

                    pnlForm.Visible = true;

                    ScriptManager.RegisterStartupScript(
                        this,
                        GetType(),
                        "scrollForm",
                        "scrollToForm();",
                        true
                    );
                }
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;

            int id = Convert.ToInt32(btn.CommandArgument);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Food WHERE id=@id";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@id", id);

                conn.Open();

                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Food item deleted successfully.";
            lblMessage.Visible = true;

            LoadFood();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = false;

            ClearFields();
        }

        private object ParseNullableDouble(string value)
        {
            if (double.TryParse(value, out double result))
            {
                return result;
            }

            return DBNull.Value;
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

            txtID.Enabled = true;
        }
    }
}