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
                LoadAllData();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadAllData();
        }

        protected void ddlSearchScope_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAllData();
        }

        private void LoadAllData()
        {
            string scope = ddlSearchScope.SelectedValue;
            string query = txtSearchQuery.Text.Trim();

            HideAllCards();

            if (scope == "all" || scope == "doctors")
            {
                SearchDoctors(query);
                cardDoctors.Visible = true;
            }

            if (scope == "all" || scope == "medicines")
            {
                SearchMedicines(query);
                cardMedicines.Visible = true;
            }

            if (scope == "all" || scope == "foods")
            {
                SearchFoods(query);
                cardFoods.Visible = true;
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
            int patientId = Convert.ToInt32(Session["PatientId"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string sql = @"
                SELECT
                    d.DoctorId,
                    d.FullName AS Name,
                    d.Speciality AS Specialization,

                    ISNULL(
                    (
                        SELECT TOP 1 Status
                        FROM PatientDoctorConnections
                        WHERE PatientId = @PatientId
                        AND DoctorId = d.DoctorId
                    ),
                    'Not Connected'
                    ) AS ConnectionStatus

                FROM Doctors d

                WHERE
                    (
                        @Query = ''
                        OR d.FullName LIKE @Search
                        OR d.Speciality LIKE @Search
                    )

                ORDER BY d.FullName";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@PatientId", patientId);
                    cmd.Parameters.AddWithValue("@Query", query);
                    cmd.Parameters.AddWithValue("@Search", "%" + query + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvDoctors.DataSource = dt;
                    gvDoctors.DataBind();
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
                    (
                        @Query = ''
                        OR name LIKE @Search
                        OR ingredients LIKE @Search
                    )

                ORDER BY name";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Query", query);
                    cmd.Parameters.AddWithValue("@Search", "%" + query + "%");

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
                    total_fat AS Fat

                FROM Food

                WHERE
                    (
                        @Query = ''
                        OR description LIKE @Search
                    )

                ORDER BY description";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Query", query);
                    cmd.Parameters.AddWithValue("@Search", "%" + query + "%");

                    SqlDataAdapter da = new SqlDataAdapter(cmd);

                    DataTable dt = new DataTable();

                    da.Fill(dt);

                    gvFoods.DataSource = dt;
                    gvFoods.DataBind();
                }
            }
        }
        protected void gvDoctors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int doctorId = Convert.ToInt32(e.CommandArgument);

            int patientId = Convert.ToInt32(Session["PatientId"]);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                if (e.CommandName == "ConnectDoctor")
                {
                    string checkSql = @"
                                    SELECT COUNT(*)
                                    FROM PatientDoctorConnections
                                    WHERE PatientId = @PatientId
                                    AND DoctorId = @DoctorId";

                    SqlCommand checkCmd = new SqlCommand(checkSql, conn);

                    checkCmd.Parameters.AddWithValue("@PatientId", patientId);
                    checkCmd.Parameters.AddWithValue("@DoctorId", doctorId);

                    int exists = Convert.ToInt32(checkCmd.ExecuteScalar());

                    if (exists == 0)
                    {
                        string insertSql = @"
                                        INSERT INTO PatientDoctorConnections
                                        (
                                            PatientId,
                                            DoctorId,
                                            Status
                                        )
                                        VALUES
                                        (
                                            @PatientId,
                                            @DoctorId,
                                            'Pending'
                                        )";

                        SqlCommand insertCmd =
                            new SqlCommand(insertSql, conn);

                        insertCmd.Parameters.AddWithValue("@PatientId", patientId);
                        insertCmd.Parameters.AddWithValue("@DoctorId", doctorId);

                        insertCmd.ExecuteNonQuery();

                        lblSearchMsg.Text =
                            "Connection request sent successfully.";

                        lblSearchMsg.Visible = true;
                    }
                }

                else if (e.CommandName == "UndoConnect")
                {
                    string deleteSql = @"
            DELETE FROM PatientDoctorConnections
            WHERE PatientId = @PatientId
            AND DoctorId = @DoctorId
            AND Status = 'Pending'";

                    SqlCommand deleteCmd =
                        new SqlCommand(deleteSql, conn);

                    deleteCmd.Parameters.AddWithValue("@PatientId", patientId);
                    deleteCmd.Parameters.AddWithValue("@DoctorId", doctorId);

                    deleteCmd.ExecuteNonQuery();

                    lblSearchMsg.Text =
                        "Connection request cancelled.";

                    lblSearchMsg.Visible = true;
                }
            }

            LoadAllData();
        }

        protected void gvDoctors_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvDoctors.PageIndex = e.NewPageIndex;
            LoadAllData();
        }

        protected void gvMedicines_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMedicines.PageIndex = e.NewPageIndex;
            LoadAllData();
        }

        protected void gvFoods_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvFoods.PageIndex = e.NewPageIndex;
            LoadAllData();
        }
        protected void gvDoctors_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string status =
                    DataBinder.Eval(e.Row.DataItem, "ConnectionStatus").ToString();

                Button btnConnect =
                    (Button)e.Row.FindControl("btnConnect");

                if (btnConnect != null)
                {
                    switch (status)
                    {
                        case "Pending":

                            btnConnect.Text = "Undo Request";
                            btnConnect.Enabled = true;
                            btnConnect.CssClass =
                                "sea-btn sea-btn--small sea-btn--danger";

                            break;

                        case "Accepted":

                            btnConnect.Text = "Connected";
                            btnConnect.Enabled = false;
                            btnConnect.CssClass =
                                "sea-btn sea-btn--small sea-btn--green";

                            break;

                        case "Rejected":

                            btnConnect.Text = "Rejected";
                            btnConnect.Enabled = false;
                            btnConnect.CssClass =
                                "sea-btn sea-btn--small sea-btn--gray";

                            break;

                        default:

                            btnConnect.Text = "Connect";
                            btnConnect.Enabled = true;
                            btnConnect.CssClass =
                                "sea-btn sea-btn--small sea-btn--blue";

                            break;
                    }
                }
            }
        }
    }
}