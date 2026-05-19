using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace MediCare.Pages.Patient
{
    public partial class Nutritions : System.Web.UI.Page
    {
        private readonly string connectionString =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

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
            }
        }

        private int GetPatientId()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT PatientId
                    FROM Patients
                    WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();

                    object result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        return Convert.ToInt32(result);
                    }
                }
            }

            return 0;
        }

        protected void btnSearchFoods_Click(object sender, EventArgs e)
        {
            int patientId = GetPatientId();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"

                SELECT *
                FROM
                (
                    SELECT
                        description AS Name,
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
                    FROM Food

                    UNION ALL

                    SELECT
                        description AS Name,
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
                    FROM CustomFoods
                    WHERE PatientId = @PatientId
                ) x

                WHERE
                    (@Calories = 0 OR calories BETWEEN @Calories - 5 AND @Calories + 5)
                    AND (@Protein = 0 OR protein BETWEEN @Protein - 5 AND @Protein + 5)
                    AND (@Fat = 0 OR total_fat BETWEEN @Fat - 5 AND @Fat + 5)
                    AND (@Carbs = 0 OR carbohydrate BETWEEN @Carbs - 5 AND @Carbs + 5)
                    AND (@Sodium = 0 OR sodium BETWEEN @Sodium - 5 AND @Sodium + 5)
                    AND (@SaturatedFat = 0 OR saturated_fat BETWEEN @SaturatedFat - 5 AND @SaturatedFat + 5)
                    AND (@Cholesterol = 0 OR cholesterol BETWEEN @Cholesterol - 5 AND @Cholesterol + 5)
                    AND (@Sugar = 0 OR sugar BETWEEN @Sugar - 5 AND @Sugar + 5)
                    AND (@Calcium = 0 OR calcium BETWEEN @Calcium - 5 AND @Calcium + 5)
                    AND (@Iron = 0 OR iron BETWEEN @Iron - 5 AND @Iron + 5)
                    AND (@Potassium = 0 OR potassium BETWEEN @Potassium - 5 AND @Potassium + 5)
                    AND (@VitaminC = 0 OR vitamin_c BETWEEN @VitaminC - 5 AND @VitaminC + 5)
                    AND (@VitaminE = 0 OR vitamin_e BETWEEN @VitaminE - 5 AND @VitaminE + 5)
                    AND (@VitaminD = 0 OR vitamin_d BETWEEN @VitaminD - 5 AND @VitaminD + 5)

                ORDER BY calories";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", patientId);

                    cmd.Parameters.AddWithValue("@Calories", ParseDouble(txtCalories.Text));
                    cmd.Parameters.AddWithValue("@Protein", ParseDouble(txtProtein.Text));
                    cmd.Parameters.AddWithValue("@Fat", ParseDouble(txtFat.Text));
                    cmd.Parameters.AddWithValue("@Carbs", ParseDouble(txtCarbs.Text));

                    cmd.Parameters.AddWithValue("@Sodium", ParseDouble(txtSodium.Text));
                    cmd.Parameters.AddWithValue("@SaturatedFat", ParseDouble(txtSaturatedFat.Text));
                    cmd.Parameters.AddWithValue("@Cholesterol", ParseDouble(txtCholesterol.Text));
                    cmd.Parameters.AddWithValue("@Sugar", ParseDouble(txtSugar.Text));

                    cmd.Parameters.AddWithValue("@Calcium", ParseDouble(txtCalcium.Text));
                    cmd.Parameters.AddWithValue("@Iron", ParseDouble(txtIron.Text));
                    cmd.Parameters.AddWithValue("@Potassium", ParseDouble(txtPotassium.Text));

                    cmd.Parameters.AddWithValue("@VitaminC", ParseDouble(txtVitaminC.Text));
                    cmd.Parameters.AddWithValue("@VitaminE", ParseDouble(txtVitaminE.Text));
                    cmd.Parameters.AddWithValue("@VitaminD", ParseDouble(txtVitaminD.Text));

                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvSearchResults.DataSource = dt;
                    gvSearchResults.DataBind();
                }
            }
        }

        private void LoadNutritionPlans()
        {
            int patientId = GetPatientId();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT
                        CASE
                            WHEN DoctorId IS NULL
                                THEN 'My Plan'
                            ELSE 'Doctor Plan'
                        END AS Source,

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
                        vitamin_d,
                        Notes,
                        CreatedAt

                    FROM NutritionPlans
                    WHERE PatientId = @PatientId
                    ORDER BY CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", patientId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvNutritionPlan.DataSource = dt;
                    gvNutritionPlan.DataBind();
                }
            }
        }

        protected void btnSaveMyPlan_Click(object sender, EventArgs e)
        {
            int patientId = GetPatientId();

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"

                    INSERT INTO NutritionPlans
                    (
                        PatientId,
                        DoctorId,

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
                        vitamin_d,

                        Notes
                    )

                    VALUES
                    (
                        @PatientId,
                        NULL,

                        @Calories,
                        @Protein,
                        @Fat,
                        @Carbs,
                        @Sodium,
                        @SaturatedFat,
                        @Cholesterol,
                        @Sugar,
                        @Calcium,
                        @Iron,
                        @Potassium,
                        @VitaminC,
                        @VitaminE,
                        @VitaminD,

                        ''
                    )";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", patientId);

                    cmd.Parameters.AddWithValue("@Calories", ParseDouble(txtMyCalories.Text));
                    cmd.Parameters.AddWithValue("@Protein", ParseDouble(txtMyProtein.Text));
                    cmd.Parameters.AddWithValue("@Fat", ParseDouble(txtMyFat.Text));
                    cmd.Parameters.AddWithValue("@Carbs", ParseDouble(txtMyCarbs.Text));

                    cmd.Parameters.AddWithValue("@Sodium", ParseDouble(txtMySodium.Text));
                    cmd.Parameters.AddWithValue("@SaturatedFat", ParseDouble(txtMySaturatedFat.Text));
                    cmd.Parameters.AddWithValue("@Cholesterol", ParseDouble(txtMyCholesterol.Text));
                    cmd.Parameters.AddWithValue("@Sugar", ParseDouble(txtMySugar.Text));

                    cmd.Parameters.AddWithValue("@Calcium", ParseDouble(txtMyCalcium.Text));
                    cmd.Parameters.AddWithValue("@Iron", ParseDouble(txtMyIron.Text));
                    cmd.Parameters.AddWithValue("@Potassium", ParseDouble(txtMyPotassium.Text));

                    cmd.Parameters.AddWithValue("@VitaminC", ParseDouble(txtMyVitaminC.Text));
                    cmd.Parameters.AddWithValue("@VitaminE", ParseDouble(txtMyVitaminE.Text));
                    cmd.Parameters.AddWithValue("@VitaminD", ParseDouble(txtMyVitaminD.Text));

                    conn.Open();

                    cmd.ExecuteNonQuery();
                }
            }

            LoadNutritionPlans();
        }

        private double ParseDouble(string value)
        {
            double result;

            if (double.TryParse(value, out result))
            {
                return result;
            }

            return 0;
        }
    }
}