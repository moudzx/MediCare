using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Admin
{
    public partial class MedicineCatalog : Page
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
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }
            if (!IsPostBack)
            {
                LoadMedicines();
            }
        }

        private void LoadMedicines(string search = "")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                SELECT *
                FROM Medicine";

                if (!string.IsNullOrWhiteSpace(search))
                {
                    query += @"
                    WHERE
                        name LIKE @search
                        OR atc LIKE @search
                        OR ingredients LIKE @search";
                }

                query += " ORDER BY name ASC";

                SqlCommand cmd = new SqlCommand(query, conn);

                if (!string.IsNullOrWhiteSpace(search))
                {
                    cmd.Parameters.AddWithValue("@search", "%" + search + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();

                da.Fill(dt);

                gvMedicines.DataSource = dt;
                gvMedicines.DataBind();
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadMedicines(txtSearch.Text.Trim());
        }

        protected void gvMedicines_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMedicines.PageIndex = e.NewPageIndex;

            LoadMedicines(txtSearch.Text.Trim());
        }

        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            ClearFields();

            pnlForm.Visible = true;

            txtATC.Enabled = true;

            IsEditMode = false;

            lblFormTitle.Text = "Add Medicine";

            btnSave.Text = "Add Medicine";

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
                        UPDATE Medicine
                        SET
                            name = @name,
                            b_g = @b_g,
                            ingredients = @ingredients,
                            dosage = @dosage,
                            form = @form,
                            price = @price
                        WHERE atc = @atc";
                    }
                    else
                    {
                        query = @"
                        INSERT INTO Medicine
                        (
                            atc,
                            name,
                            b_g,
                            ingredients,
                            dosage,
                            form,
                            price
                        )
                        VALUES
                        (
                            @atc,
                            @name,
                            @b_g,
                            @ingredients,
                            @dosage,
                            @form,
                            @price
                        )";
                    }

                    SqlCommand cmd = new SqlCommand(query, conn);

                    cmd.Parameters.AddWithValue("@atc", txtATC.Text.Trim());
                    cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@b_g", txtBG.Text.Trim());
                    cmd.Parameters.AddWithValue("@ingredients", txtIngredients.Text.Trim());
                    cmd.Parameters.AddWithValue("@dosage", txtDosage.Text.Trim());
                    cmd.Parameters.AddWithValue("@form", txtForm.Text.Trim());
                    cmd.Parameters.AddWithValue("@price", txtPrice.Text.Trim());

                    conn.Open();

                    cmd.ExecuteNonQuery();
                }

                lblMessage.Text = IsEditMode
                    ? "Medicine updated successfully."
                    : "Medicine added successfully.";

                lblMessage.Visible = true;

                pnlForm.Visible = false;

                ClearFields();

                LoadMedicines();
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

            string atc = btn.CommandArgument;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Medicine WHERE atc=@atc";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@atc", atc);

                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    txtATC.Text = reader["atc"].ToString();
                    txtName.Text = reader["name"].ToString();
                    txtBG.Text = reader["b_g"].ToString();
                    txtIngredients.Text = reader["ingredients"].ToString();
                    txtDosage.Text = reader["dosage"].ToString();
                    txtForm.Text = reader["form"].ToString();
                    txtPrice.Text = reader["price"].ToString();

                    txtATC.Enabled = false;

                    IsEditMode = true;

                    lblFormTitle.Text = "Edit Medicine";

                    btnSave.Text = "Update Medicine";

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

            string atc = btn.CommandArgument;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Medicine WHERE atc=@atc";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@atc", atc);

                conn.Open();

                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Medicine deleted successfully.";
            lblMessage.Visible = true;

            LoadMedicines(txtSearch.Text.Trim());
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = false;

            ClearFields();
        }

        private void ClearFields()
        {
            txtATC.Text = "";
            txtName.Text = "";
            txtBG.Text = "";
            txtIngredients.Text = "";
            txtDosage.Text = "";
            txtForm.Text = "";
            txtPrice.Text = "";

            txtATC.Enabled = true;
        }
    }
}