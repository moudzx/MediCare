using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Patient
{
    public partial class Search : System.Web.UI.Page
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
                HideAllCards();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string scope = ddlSearchScope.SelectedValue;
            string query = txtSearchQuery.Text.Trim();

            lblSearchMsg.Visible = false;

            if (string.IsNullOrWhiteSpace(query))
            {
                lblSearchMsg.Text = "Please enter a search term.";
                lblSearchMsg.Visible = true;

                HideAllCards();
                return;
            }

            HideAllCards();

            switch (scope)
            {
                case "all":
                    SearchDoctors(query);
                    SearchMedicines(query);
                    SearchFoods(query);

                    cardDoctors.Visible = true;
                    cardMedicines.Visible = true;
                    cardFoods.Visible = true;
                    break;

                case "doctors":
                    SearchDoctors(query);
                    cardDoctors.Visible = true;
                    break;

                case "medicines":
                    SearchMedicines(query);
                    cardMedicines.Visible = true;
                    break;

                case "foods":
                    SearchFoods(query);
                    cardFoods.Visible = true;
                    break;
            }
        }

        private void HideAllCards()
        {
            cardDoctors.Visible = false;
            cardMedicines.Visible = false;
            cardFoods.Visible = false;
        }

        private void SearchDoctors(string query)
        {
            int patientId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT
                        d.DoctorId,
                        d.FullName AS Name,

                        ISNULL(
                            (
                                SELECT TOP 1 Status
                                FROM PatientDoctorConnections
                                WHERE PatientId = @PatientId
                                AND DoctorId = d.DoctorId
                            ),
                            ''
                        ) AS ConnectionStatus

                    FROM Doctors d
                    WHERE d.FullName LIKE @Query
                    ORDER BY d.FullName";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", patientId);
                    cmd.Parameters.AddWithValue("@Query", "%" + query + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    // Add missing column for GridView
                    if (!dt.Columns.Contains("Specialization"))
                    {
                        dt.Columns.Add("Specialization");
                    }

                    gvDoctors.RowDataBound += gvDoctors_RowDataBound;

                    gvDoctors.DataSource = dt;
                    gvDoctors.DataBind();
                }
            }
        }

        protected void gvDoctors_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string status = DataBinder.Eval(e.Row.DataItem, "ConnectionStatus").ToString();

                Button btnConnect =
                    (Button)e.Row.FindControl("btnConnect");

                Button btnAppointment =
                    (Button)e.Row.FindControl("btnSendAppointment");

                if (btnConnect != null)
                {
                    switch (status)
                    {
                        case "Accepted":
                            btnConnect.Visible = false;

                            if (btnAppointment != null)
                            {
                                btnAppointment.Visible = true;
                            }
                            break;

                        case "Pending":
                            btnConnect.Text = "Pending";
                            btnConnect.Enabled = false;

                            if (btnAppointment != null)
                            {
                                btnAppointment.Visible = false;
                            }
                            break;

                        case "Rejected":
                            btnConnect.Text = "Rejected";
                            btnConnect.Enabled = false;

                            if (btnAppointment != null)
                            {
                                btnAppointment.Visible = false;
                            }
                            break;

                        default:
                            btnConnect.Text = "Connect";
                            btnConnect.Enabled = true;

                            if (btnAppointment != null)
                            {
                                btnAppointment.Visible = false;
                            }
                            break;
                    }
                }
            }
        }

        private void SearchMedicines(string query)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT
                        atc AS Id,
                        name AS Name,
                        ingredients AS Description
                    FROM Medicine
                    WHERE
                        name LIKE @Query
                        OR ingredients LIKE @Query
                    ORDER BY name";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Query", "%" + query + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvMedicines.DataSource = dt;
                    gvMedicines.DataBind();
                }
            }
        }


        private void SearchFoods(string query)
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                    SELECT
                        description AS Name,
                        calories AS Calories,
                        protein AS Protein,
                        carbohydrate AS Carbs,
                        sugar AS Fiber,
                        total_fat AS Fat
                    FROM Food
                    WHERE description LIKE @Query
                    ORDER BY description";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Query", "%" + query + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvFoods.DataSource = dt;
                    gvFoods.DataBind();
                }
            }
        }
    }
}