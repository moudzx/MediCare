using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace MediCare.Pages.Patient
{
    public partial class Nutritions : System.Web.UI.Page
    {
        private readonly string connectionString =
                        System.Configuration.ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (Session["Role"].ToString() != "Patient")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadNutritionPlans();
                LoadCustomFoods();
            }
        }

        protected void btnSearchFoods_Click(object sender, EventArgs e)
        {
            lblSearchMsg.Visible = false;

            int calories = ParseInt(txtCalories.Text);
            int protein = ParseInt(txtProtein.Text);
            int carbs = ParseInt(txtCarbs.Text);
            int fat = ParseInt(txtFat.Text);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT TOP 25
                        description AS Name,
                        calories AS Calories,
                        protein AS Protein,
                        carbohydrate AS Carbs,
                        total_fat AS Fat
                    FROM Food
                    WHERE
                        (@Calories = 0 OR calories BETWEEN @Calories - 50 AND @Calories + 50)
                        AND (@Protein = 0 OR protein BETWEEN @Protein - 10 AND @Protein + 10)
                        AND (@Carbs = 0 OR carbohydrate BETWEEN @Carbs - 10 AND @Carbs + 10)
                        AND (@Fat = 0 OR total_fat BETWEEN @Fat - 10 AND @Fat + 10)
                    ORDER BY calories";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Calories", calories);
                    cmd.Parameters.AddWithValue("@Protein", protein);
                    cmd.Parameters.AddWithValue("@Carbs", carbs);
                    cmd.Parameters.AddWithValue("@Fat", fat);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvSearchResults.DataSource = dt;
                    gvSearchResults.DataBind();

                    if (dt.Rows.Count == 0)
                    {
                        lblSearchMsg.Text = "No matching foods found.";
                        lblSearchMsg.Visible = true;
                    }
                }
            }
        }


        private void LoadNutritionPlans()
        {
            int patientId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT
                        CASE
                            WHEN DoctorId IS NULL THEN 'My Plan'
                            ELSE 'Doctor Plan'
                        END AS Source,

                        Calories,
                        Protein,
                        Carbs,
                        0 AS Fiber,
                        Fat

                    FROM NutritionPlans
                    WHERE PatientId = @PatientId
                    AND Status = 'Active'
                    ORDER BY CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", patientId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvNutritionPlan.DataSource = dt;
                    gvNutritionPlan.DataBind();

                    LoadMyPlanIntoInputs(dt);
                }
            }
        }


        private void LoadMyPlanIntoInputs(DataTable dt)
        {
            foreach (DataRow row in dt.Rows)
            {
                if (row["Source"].ToString() == "My Plan")
                {
                    txtMyCalories.Text = row["Calories"].ToString();
                    txtMyProtein.Text = row["Protein"].ToString();
                    txtMyCarbs.Text = row["Carbs"].ToString();
                    txtMyFat.Text = row["Fat"].ToString();
                    txtMyFiber.Text = row["Fiber"].ToString();

                    break;
                }
            }
        }


        protected void btnSaveMyPlan_Click(object sender, EventArgs e)
        {
            lblPlanMsg.Visible = false;

            int patientId = Convert.ToInt32(Session["UserId"]);

            int calories = ParseInt(txtMyCalories.Text);
            int protein = ParseInt(txtMyProtein.Text);
            int carbs = ParseInt(txtMyCarbs.Text);
            int fat = ParseInt(txtMyFat.Text);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Check if personal plan already exists
                string checkSql = @"
                    SELECT COUNT(*)
                    FROM NutritionPlans
                    WHERE PatientId = @PatientId
                    AND DoctorId IS NULL
                    AND Status = 'Active'";

                using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                {
                    checkCmd.Parameters.AddWithValue("@PatientId", patientId);

                    int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (exists > 0)
                    {
                        string updateSql = @"
                            UPDATE NutritionPlans
                            SET
                                Calories = @Calories,
                                Protein = @Protein,
                                Carbs = @Carbs,
                                Fat = @Fat,
                                UpdatedAt = GETDATE()
                            WHERE
                                PatientId = @PatientId
                                AND DoctorId IS NULL
                                AND Status = 'Active'";

                        using (SqlCommand updateCmd =
                               new SqlCommand(updateSql, conn))
                        {
                            updateCmd.Parameters.AddWithValue("@Calories", calories);
                            updateCmd.Parameters.AddWithValue("@Protein", protein);
                            updateCmd.Parameters.AddWithValue("@Carbs", carbs);
                            updateCmd.Parameters.AddWithValue("@Fat", fat);
                            updateCmd.Parameters.AddWithValue("@PatientId", patientId);

                            updateCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string insertSql = @"
                            INSERT INTO NutritionPlans
                            (
                                PatientId,
                                DoctorId,
                                Calories,
                                Protein,
                                Carbs,
                                Fat,
                                Goal,
                                Notes
                            )
                            VALUES
                            (
                                @PatientId,
                                NULL,
                                @Calories,
                                @Protein,
                                @Carbs,
                                @Fat,
                                'Personal Goal',
                                ''
                            )";

                        using (SqlCommand insertCmd =
                               new SqlCommand(insertSql, conn))
                        {
                            insertCmd.Parameters.AddWithValue("@PatientId", patientId);
                            insertCmd.Parameters.AddWithValue("@Calories", calories);
                            insertCmd.Parameters.AddWithValue("@Protein", protein);
                            insertCmd.Parameters.AddWithValue("@Carbs", carbs);
                            insertCmd.Parameters.AddWithValue("@Fat", fat);

                            insertCmd.ExecuteNonQuery();
                        }
                    }
                }
            }

            lblPlanMsg.Text = "Nutrition plan saved successfully.";
            lblPlanMsg.Visible = true;

            LoadNutritionPlans();
        }


        protected void btnSaveFood_Click(object sender, EventArgs e)
        {
            lblFoodMsg.Visible = false;

            string name = txtFoodName.Text.Trim();

            if (string.IsNullOrWhiteSpace(name))
            {
                lblFoodMsg.Text = "Food name is required.";
                lblFoodMsg.Visible = true;
                return;
            }

            int calories = ParseInt(txtFoodCalories.Text);
            int protein = ParseInt(txtFoodProtein.Text);
            int carbs = ParseInt(txtFoodCarbs.Text);
            int fat = ParseInt(txtFoodFat.Text);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    INSERT INTO Food
                    (
                        id,
                        description,
                        calories,
                        protein,
                        carbohydrate,
                        total_fat
                    )
                    VALUES
                    (
                        (SELECT ISNULL(MAX(id), 0) + 1 FROM Food),
                        @Description,
                        @Calories,
                        @Protein,
                        @Carbs,
                        @Fat
                    )";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Description", name);
                    cmd.Parameters.AddWithValue("@Calories", calories);
                    cmd.Parameters.AddWithValue("@Protein", protein);
                    cmd.Parameters.AddWithValue("@Carbs", carbs);
                    cmd.Parameters.AddWithValue("@Fat", fat);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            lblFoodMsg.Text = "Custom food added successfully.";
            lblFoodMsg.Visible = true;

            ClearFoodInputs();

            LoadCustomFoods();
        }


        private void LoadCustomFoods()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT TOP 20
                        description AS Name,
                        calories AS Calories,
                        protein AS Protein,
                        carbohydrate AS Carbs,
                        total_fat AS Fat
                    FROM Food
                    ORDER BY id DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvCustomFoods.DataSource = dt;
                    gvCustomFoods.DataBind();

                    cardCustomFoods.Visible = dt.Rows.Count > 0;
                }
            }
        }


        private int ParseInt(string value)
        {
            int result;

            if (int.TryParse(value, out result))
            {
                return result;
            }

            return 0;
        }

        private void ClearFoodInputs()
        {
            txtFoodName.Text = "";
            txtFoodCalories.Text = "";
            txtFoodProtein.Text = "";
            txtFoodCarbs.Text = "";
            txtFoodFat.Text = "";
        }
    }
}