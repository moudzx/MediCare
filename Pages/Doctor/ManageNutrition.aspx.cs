using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Doctor
{
    public partial class ManageNutrition : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        private int targetPatientId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["Role"] == null || Session["Role"].ToString() != "Doctor")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (Request.QueryString["PatientId"] == null || !int.TryParse(Request.QueryString["PatientId"], out targetPatientId))
            {
                Response.Redirect("~/Pages/Doctor/PatientList.aspx");
                return;
            }

            if (!IsPostBack)
            {
                pnlValidationError.Visible = false;
                if (LoadPatientContextAndVerify())
                {
                    BindNutritionPlansGrid();
                }
                else
                {
                    Response.Redirect("~/Pages/Doctor/PatientList.aspx");
                }
            }
            else
            {
                LoadPatientContextAndVerify();
            }
        }

        private int GetDoctorId(SqlConnection conn)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string sql = "SELECT DoctorId FROM [dbo].[Doctors] WHERE UserId = @UserId";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                object result = cmd.ExecuteScalar();
                if (result != null && result != DBNull.Value) return Convert.ToInt32(result);
            }
            return 0;
        }

        private bool LoadPatientContextAndVerify()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return false;


                    string sql = @"
                        SELECT p.FullName 
                        FROM [dbo].[PatientDoctorConnections] c
                        INNER JOIN [dbo].[Patients] p ON c.PatientId = p.PatientId
                        WHERE c.DoctorId = @DoctorId AND c.PatientId = @PatientId AND c.Status = 'Accepted'";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        cmd.Parameters.AddWithValue("@PatientId", targetPatientId);
                        object name = cmd.ExecuteScalar();

                        if (name != null)
                        {
                            lblPatientName.Text = name.ToString();
                            return true;
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Verification Failure Context: " + ex.Message);
                }
            }
            return false;
        }

        private void BindNutritionPlansGrid()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);

                    string sql = @"
                        SELECT PlanId, PatientId, DoctorId, calories, protein, total_fat, carbohydrate, 
                               sodium, saturated_fat, cholesterol, sugar, calcium, iron, potassium, 
                               vitamin_c, vitamin_e, vitamin_d, Notes, CreatedAt
                        FROM [dbo].[NutritionPlans]
                        WHERE PatientId = @PatientId AND DoctorId = @DoctorId
                        ORDER BY PlanId DESC";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@PatientId", targetPatientId);
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count == 0)
                            {
                                pnlEmptyState.Visible = true;
                                rptPlans.Visible = false;
                                lblStatPlans.Text = "0";
                                lblStatAvgCal.Text = "0";
                            }
                            else
                            {
                                pnlEmptyState.Visible = false;
                                rptPlans.Visible = true;
                                rptPlans.DataSource = dt;
                                rptPlans.DataBind();

                                lblStatPlans.Text = dt.Rows.Count.ToString();
                                object avgCalories = dt.Compute("AVG(calories)", "");
                                lblStatAvgCal.Text = avgCalories != DBNull.Value ? Convert.ToInt32(avgCalories).ToString() : "0";
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowToastAlert("Error Loading Nutrition Interface: " + ex.Message, true);
                }
            }
        }

        protected void btnConfirmSave_Click(object sender, EventArgs e)
        {
            pnlValidationError.Visible = false;
            pnlToast.Visible = false;

            string caloriesText = inputCalories.Text.Trim();
            if (string.IsNullOrEmpty(caloriesText) || !double.TryParse(caloriesText, out double caloriesValue) || caloriesValue < 0)
            {
                pnlValidationError.Visible = true;
                lblValidationError.Text = "Please enter a valid positive daily baseline caloric target.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    int doctorId = GetDoctorId(conn);
                    if (doctorId == 0) return;

                    string insertSql = @"
                        INSERT INTO [dbo].[NutritionPlans]
                        (PatientId, DoctorId, calories, protein, total_fat, carbohydrate, sodium, 
                         saturated_fat, cholesterol, sugar, calcium, iron, potassium, vitamin_c, 
                         vitamin_e, vitamin_d, Notes, CreatedAt)
                        VALUES
                        (@PatientId, @DoctorId, @Calories, @Protein, @TotalFat, @Carbs, @Sodium, 
                         @SatFat, @Cholesterol, @Sugar, @Calcium, @Iron, @Potassium, @VitC, 
                         @VitE, @VitD, @Notes, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@PatientId", targetPatientId);
                        cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                        cmd.Parameters.AddWithValue("@Calories", caloriesValue);

                        cmd.Parameters.AddWithValue("@Protein", GetParsedDoubleValue(inputProtein.Text));
                        cmd.Parameters.AddWithValue("@TotalFat", GetParsedDoubleValue(inputTotalFat.Text));
                        cmd.Parameters.AddWithValue("@Carbs", GetParsedDoubleValue(inputCarbs.Text));
                        cmd.Parameters.AddWithValue("@Sodium", GetParsedDoubleValue(inputSodium.Text));
                        cmd.Parameters.AddWithValue("@SatFat", GetParsedDoubleValue(inputSatFat.Text));
                        cmd.Parameters.AddWithValue("@Cholesterol", GetParsedDoubleValue(inputCholesterol.Text));
                        cmd.Parameters.AddWithValue("@Sugar", GetParsedDoubleValue(inputSugar.Text));
                        cmd.Parameters.AddWithValue("@Calcium", GetParsedDoubleValue(inputCalcium.Text));
                        cmd.Parameters.AddWithValue("@Iron", GetParsedDoubleValue(inputIron.Text));
                        cmd.Parameters.AddWithValue("@Potassium", GetParsedDoubleValue(inputPotassium.Text));
                        cmd.Parameters.AddWithValue("@VitC", GetParsedDoubleValue(inputVitC.Text));
                        cmd.Parameters.AddWithValue("@VitE", GetParsedDoubleValue(inputVitE.Text));
                        cmd.Parameters.AddWithValue("@VitD", GetParsedDoubleValue(inputVitD.Text));

                        cmd.Parameters.AddWithValue("@Notes", string.IsNullOrEmpty(inputNotes.Text) ? (object)DBNull.Value : inputNotes.Text.Trim());

                        cmd.ExecuteNonQuery();
                    }


                    int patientUserId = 0;
                    using (SqlCommand cmdUser = new SqlCommand("SELECT UserId FROM [dbo].[Patients] WHERE PatientId = @PatientId", conn))
                    {
                        cmdUser.Parameters.AddWithValue("@PatientId", targetPatientId);
                        object userRes = cmdUser.ExecuteScalar();
                        if (userRes != null) patientUserId = Convert.ToInt32(userRes);
                    }


                    if (patientUserId > 0)
                    {
                        string docName = "Your doctor";
                        using (SqlCommand cmdDoc = new SqlCommand("SELECT FullName FROM [dbo].[Doctors] WHERE DoctorId = @DoctorId", conn))
                        {
                            cmdDoc.Parameters.AddWithValue("@DoctorId", doctorId);
                            object docRes = cmdDoc.ExecuteScalar();
                            if (docRes != null) docName = docRes.ToString();
                        }

                        string alertSql = @"
                            INSERT INTO [dbo].[Notifications] 
                            (UserId, Type, Title, Message, IsRead, CreatedAt) 
                            VALUES 
                            (@UserId, 'NutritionPlanAdded', 'New Nutrition Plan Assigned', @Message, 0, GETDATE())";

                        using (SqlCommand cmdAlert = new SqlCommand(alertSql, conn))
                        {
                            cmdAlert.Parameters.AddWithValue("@UserId", patientUserId);
                            cmdAlert.Parameters.AddWithValue("@Message", $"Dr. {docName} created a new nutrition profile template with a {caloriesValue} kcal baseline.");
                            cmdAlert.ExecuteNonQuery();
                        }
                    }

                    ClearModalInputFields();
                    BindNutritionPlansGrid();
                    ShowToastAlert("New customized health targets saved and patient notified!", false);
                }
                catch (Exception ex)
                {
                    ShowToastAlert("Database Error: " + ex.Message, true);
                }
            }
        }

        protected void rptPlans_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeletePlan")
            {
                int planId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    try
                    {
                        conn.Open();
                        int doctorId = GetDoctorId(conn);

                        string deleteSql = "DELETE FROM [dbo].[NutritionPlans] WHERE PlanId = @PlanId AND DoctorId = @DoctorId";
                        using (SqlCommand cmd = new SqlCommand(deleteSql, conn))
                        {
                            cmd.Parameters.AddWithValue("@PlanId", planId);
                            cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                            cmd.ExecuteNonQuery();
                        }

                        BindNutritionPlansGrid();
                        ShowToastAlert("Target record removed successfully.", false);
                    }
                    catch (Exception ex)
                    {
                        ShowToastAlert("Error removing entry: " + ex.Message, true);
                    }
                }
            }
        }

        private double GetParsedDoubleValue(string inputText)
        {
            return double.TryParse(inputText, out double val) ? val : 0.0;
        }

        private void ClearModalInputFields()
        {
            inputCalories.Text = "";
            inputProtein.Text = "";
            inputTotalFat.Text = "";
            inputCarbs.Text = "";
            inputSodium.Text = "";
            inputSatFat.Text = "";
            inputCholesterol.Text = "";
            inputSugar.Text = "";
            inputCalcium.Text = "";
            inputIron.Text = "";
            inputPotassium.Text = "";
            inputVitC.Text = "";
            inputVitD.Text = "";
            inputVitE.Text = "";
            inputNotes.Text = "";
        }

        private void ShowToastAlert(string message, bool isError)
        {
            pnlToast.Visible = true;
            pnlToast.BackColor = System.Drawing.ColorTranslator.FromHtml(isError ? "#ef4444" : "#10b981");
            lblToastMsg.Text = message;
        }
    }
}