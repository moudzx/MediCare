// Search.aspx.cs
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Doctor
{
    public partial class Search : System.Web.UI.Page
    {
        private string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Doctor")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }
            if (!IsPostBack)
            {
                BindGridData("", "all");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string query = txtSearchQuery.Text.Trim();
            string scope = ddlSearchScope.SelectedValue;
            BindGridData(query, scope);
        }

        private void BindGridData(string query, string scope)
        {
            pnlMessage.Visible = false;
            lblMessage.Text = "";

            bool searchAll = (scope == "all");
            bool searchMedicines = (scope == "medicines" || searchAll);
            bool searchFoods = (scope == "foods" || searchAll);

            cardMedicines.Visible = searchMedicines;
            cardFoods.Visible = searchFoods;

            if (searchMedicines)
            {
                BindMedicines(query);
            }

            if (searchFoods)
            {
                BindFoods(query);
            }
        }

        private void BindMedicines(string query)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "SELECT id, atc, name, b_g, ingredients, dosage, form, price FROM [dbo].[Medicine]";
                if (!string.IsNullOrEmpty(query))
                {
                    sql += " WHERE name LIKE @query OR ingredients LIKE @query OR atc LIKE @query OR form LIKE @query";
                }

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (!string.IsNullOrEmpty(query))
                    {
                        cmd.Parameters.AddWithValue("@query", "%" + query + "%");
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        try
                        {
                            da.Fill(dt);
                            ViewState["MedicinesDT"] = dt;
                            gvMedicines.DataSource = dt;
                            gvMedicines.DataBind();
                        }
                        catch (Exception ex)
                        {
                            ShowErrorMessage("Error loading medicines: " + ex.Message);
                        }
                    }
                }
            }
        }

        private void BindFoods(string query)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "SELECT id, description, calories, protein, total_fat, carbohydrate, sodium, saturated_fat, cholesterol, sugar, calcium, iron, potassium, vitamin_c, vitamin_e, vitamin_d FROM [dbo].[Food]";
                if (!string.IsNullOrEmpty(query))
                {
                    sql += " WHERE description LIKE @query";
                }

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    if (!string.IsNullOrEmpty(query))
                    {
                        cmd.Parameters.AddWithValue("@query", "%" + query + "%");
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        try
                        {
                            da.Fill(dt);
                            ViewState["FoodsDT"] = dt;
                            gvFoods.DataSource = dt;
                            gvFoods.DataBind();
                        }
                        catch (Exception ex)
                        {
                            ShowErrorMessage("Error loading foods: " + ex.Message);
                        }
                    }
                }
            }
        }

        protected void gvMedicines_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMedicines.PageIndex = e.NewPageIndex;
            if (ViewState["MedicinesDT"] != null)
            {
                gvMedicines.DataSource = (DataTable)ViewState["MedicinesDT"];
                gvMedicines.DataBind();
            }
            else
            {
                BindMedicines(txtSearchQuery.Text.Trim());
            }
        }

        protected void gvFoods_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvFoods.PageIndex = e.NewPageIndex;
            if (ViewState["FoodsDT"] != null)
            {
                gvFoods.DataSource = (DataTable)ViewState["FoodsDT"];
                gvFoods.DataBind();
            }
            else
            {
                BindFoods(txtSearchQuery.Text.Trim());
            }
        }

        private void ShowErrorMessage(string message)
        {
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "sea-inline-msg sea-inline-msg--error";
            lblMessage.Text = message;
        }
    }
}