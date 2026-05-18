using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Admin
{
    public partial class MedicineCatalog : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadMedicines();
        }

        private void LoadMedicines(string search = "")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Medicine";

                if (!string.IsNullOrEmpty(search))
                {
                    query += " WHERE name LIKE @search OR atc LIKE @search";
                }

                SqlCommand cmd = new SqlCommand(query, conn);

                if (!string.IsNullOrEmpty(search))
                    cmd.Parameters.AddWithValue("@search", "%" + search + "%");

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

        protected void btnAddMedicine_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
INSERT INTO Medicine
(atc, name, b_g, ingredients, dosage, form, price)
VALUES
(@atc, @name, @b_g, @ingredients, @dosage, @form, @price)";

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

            lblMessage.Text = "Medicine added successfully.";
            lblMessage.Visible = true;

            ClearFields();
            LoadMedicines();
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string atc = ((Button)sender).CommandArgument;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Medicine WHERE atc=@atc", conn);
                cmd.Parameters.AddWithValue("@atc", atc);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Medicine deleted.";
            lblMessage.Visible = true;

            LoadMedicines();
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            string atc = ((Button)sender).CommandArgument;

            lblMessage.Text = "Edit clicked: " + atc;
            lblMessage.Visible = true;

            // later you can load data into modal for editing
        }

        protected void gvMedicines_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // optional (you can move logic here later)
        }

        protected void btnOpenAddModal_Click(object sender, EventArgs e)
        {
            // if you use JS modal later, you can trigger it here
        }

        protected void btnCancelModal_Click(object sender, EventArgs e)
        {
            ClearFields();
        }

        protected void btnHamburger_Click(object sender, EventArgs e)
        {
            // optional mobile menu logic
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
        }
    }
}