using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace MediCare.Patient
{
    public partial class Dashboard : Page
    {
        private readonly string connStr =
            ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                SetGreeting();
                LoadPatientInfo();
                LoadTodayDoses();
                LoadInventory();
                LoadDoctors();
            }
        }

        private int GetPatientId()
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT PatientId
                    FROM Patients
                    WHERE UserId = @UserId";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();

                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    return Convert.ToInt32(result);
                }
            }

            return 0;
        }

        private void SetGreeting()
        {
            int hour = DateTime.Now.Hour;

            if (hour < 12)
            {
                lblGreeting.Text = "Good Morning";
            }
            else if (hour < 18)
            {
                lblGreeting.Text = "Good Afternoon";
            }
            else
            {
                lblGreeting.Text = "Good Evening";
            }

            lblCurrentDate.Text =
                DateTime.Now.ToString("dddd, MMMM dd yyyy");
        }
        private void LoadPatientInfo()
        {
            int patientId = GetPatientId();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT TOP 1
                FullName,
                Age,
                Height,
                Weight,
                BloodType,
                Gender,
                ChronicDisease,
                Disability,
                FamilyHistory
            FROM Patients
            WHERE PatientId = @PatientId";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@PatientId", patientId);

                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    lblPatientName.Text = reader["FullName"].ToString();

                    txtAge.Text =
                        reader["Age"] == DBNull.Value ? "-" : reader["Age"].ToString();

                    txtHeight.Text =
                        reader["Height"] == DBNull.Value
                            ? "-"
                            : Convert.ToDouble(reader["Height"]).ToString("0");

                    txtWeight.Text =
                        reader["Weight"] == DBNull.Value
                            ? "-"
                            : Convert.ToDouble(reader["Weight"]).ToString("0");

                    ddlBloodType.Text =
                        reader["BloodType"] == DBNull.Value
                            ? "-"
                            : reader["BloodType"].ToString();

                    ddlGender.Text =
                        reader["Gender"] == DBNull.Value
                            ? "-"
                            : reader["Gender"].ToString();

                    txtDisease.Text =
                        reader["ChronicDisease"] == DBNull.Value
                            ? "-"
                            : reader["ChronicDisease"].ToString();

                    txtDisability.Text =
                        reader["Disability"] == DBNull.Value
                            ? "-"
                            : reader["Disability"].ToString();

                    txtFamilyHistory.Text =
                        reader["FamilyHistory"] == DBNull.Value
                            ? "-"
                            : reader["FamilyHistory"].ToString();

                    lblPatientStatus.Text = "Active";
                }
            }
        }

        private void LoadTodayDoses()
        {
            int patientId = GetPatientId();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        pm.PatientMedicationId AS DoseId,
                        m.name AS MedicineName,
                        pm.Dosage,
                        pm.Frequency AS Instructions,
                        ISNULL(pm.Frequency, '-') AS Time,
                        CAST(0 AS BIT) AS IsTaken
                    FROM PatientMedications pm
                    INNER JOIN Medicine m
                        ON m.id = TRY_CAST(pm.MedicineId AS INT)
                    WHERE pm.PatientId = @PatientId
                    AND pm.Status = 'Active'
                    ORDER BY m.name ASC";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@PatientId", patientId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();

                da.Fill(dt);

                gvDoses.DataSource = dt;
                gvDoses.DataBind();

                int total = dt.Rows.Count;
                int taken = 0;

                foreach (DataRow row in dt.Rows)
                {
                    bool isTaken =
                        Convert.ToBoolean(row["IsTaken"]);

                    if (isTaken)
                    {
                        taken++;
                    }
                }

                int percentage = 0;

                if (total > 0)
                {
                    percentage =
                        (int)Math.Round(
                            (double)taken / total * 100);
                }

                lblDoseCount.Text = total.ToString();
                lblDosePct.Text = percentage + "%";

                lblDoseSummary.Text =
                    taken + " of " + total + " doses completed";

                dpmArc.Attributes["stroke-dasharray"] =
                    percentage + " 100";
            }
        }

        private void LoadInventory()
        {
            int patientId = GetPatientId();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 6
                        m.name AS Name,
                        20 AS Remaining,
                        30 AS Total,
                        66 AS Percentage
                    FROM PatientMedications pm
                    INNER JOIN Medicine m
                        ON m.id = TRY_CAST(pm.MedicineId AS INT)
                    WHERE pm.PatientId = @PatientId
                    AND pm.Status = 'Active'";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@PatientId", patientId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();

                da.Fill(dt);

                gvInventory.DataSource = dt;
                gvInventory.DataBind();
            }
        }

        private void LoadDoctors()
        {
            int patientId = GetPatientId();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        d.DoctorId,
                        d.FullName AS DoctorName,
                        d.Speciality AS Specialty,
                        c.Status
                    FROM PatientDoctorConnections c
                    INNER JOIN Doctors d
                        ON d.DoctorId = c.DoctorId
                    WHERE c.PatientId = @PatientId
                    ORDER BY d.FullName ASC";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@PatientId", patientId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);

                DataTable dt = new DataTable();

                da.Fill(dt);

                gvDoctors.DataSource = dt;
                gvDoctors.DataBind();
            }
        }

        protected void chkTaken_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;

            GridViewRow row =
                (GridViewRow)chk.NamingContainer;

            int doseId =
                Convert.ToInt32(
                    gvDoses.DataKeys[row.RowIndex].Value);

            LoadTodayDoses();
        }

        protected void gvDoses_RowDataBound(
            object sender,
            GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                CheckBox chk =
                    (CheckBox)e.Row.FindControl("chkTaken");

                if (chk.Checked)
                {
                    e.Row.CssClass += " pd-dose-completed";
                }
            }
        }

        protected void gvDoctors_RowDataBound(
            object sender,
            GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lbl =
                    (Label)e.Row.FindControl("lblStatus");

                string status = lbl.Text.ToLower();

                if (status == "accepted")
                {
                    lbl.CssClass +=
                        " pd-doctor-status--accepted";
                }
                else if (status == "pending")
                {
                    lbl.CssClass +=
                        " pd-doctor-status--pending";
                }
                else if (status == "rejected")
                {
                    lbl.CssClass +=
                        " pd-doctor-status--rejected";
                }
            }
        }
    }
}