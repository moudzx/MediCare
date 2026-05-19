using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Patient
{
    public partial class DoctorProfile : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        // Simple class to map available slots to the GridView
        public class TimeSlot
        {
            public string SlotText { get; set; }
            public string SlotValue { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Verify Patient Authentication
            if (Session["UserId"] == null || Session["Role"] == null || Session["Role"].ToString() != "Patient")
            {
                Response.Redirect("~/Pages/Account/Login.aspx");
                return;
            }

            // 2. Load Initial Data
            if (!IsPostBack)
            {
                if (int.TryParse(Request.QueryString["id"], out int doctorId))
                {
                    LoadDoctorDetails(doctorId);
                    calAppointments.SelectedDate = DateTime.Today; // Default to today
                    LoadAvailableSlots(DateTime.Today, doctorId);
                }
                else
                {
                    // No doctor ID provided, redirect back to search/directory
                    Response.Redirect("~/Pages/Patient/SearchDoctors.aspx");
                }
            }
        }

        private void LoadDoctorDetails(int doctorId)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Note: Adjust the exact column names (FullName, Specialization, etc.) 
                // to match your actual [dbo].[Doctors] / [dbo].[Users] schema.
                string sql = @"
                    SELECT FullName, Specialization, Location, Experience, Languages, Qualifications, About 
                    FROM [dbo].[Doctors] 
                    WHERE DoctorId = @DoctorId";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string name = reader["FullName"].ToString();
                                lblDoctorName.Text = "Dr. " + name;
                                lblAvatarInitials.Text = GetInitials(name);

                                lblSpecialization.Text = reader["Specialization"].ToString();
                                lblLocation.Text = reader["Location"].ToString();
                                lblExperience.Text = reader["Experience"].ToString() + " Years";
                                lblLanguages.Text = reader["Languages"].ToString();
                                lblQualifications.Text = reader["Qualifications"].ToString();
                                lblAbout.Text = reader["About"].ToString();
                            }
                            else
                            {
                                Response.Redirect("~/Pages/Patient/SearchDoctors.aspx");
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error loading profile: " + ex.Message;
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }
        }

        // Prevent users from clicking past dates on the calendar
        protected void calAppointments_DayRender(object sender, DayRenderEventArgs e)
        {
            if (e.Day.Date < DateTime.Today)
            {
                e.Day.IsSelectable = false;
                e.Cell.ForeColor = System.Drawing.Color.LightGray;
            }
        }

        protected void calAppointments_SelectionChanged(object sender, EventArgs e)
        {
            lblMessage.Text = ""; // Clear previous messages
            if (int.TryParse(Request.QueryString["id"], out int doctorId))
            {
                LoadAvailableSlots(calAppointments.SelectedDate, doctorId);
            }
        }

        private void LoadAvailableSlots(DateTime selectedDate, int doctorId)
        {
            List<TimeSlot> availableSlots = new List<TimeSlot>();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Fetch slots for this doctor on this specific day that DO NOT have an active appointment
                string sql = @"
                        SELECT da.StartTime, da.EndTime
                        FROM [dbo].[DoctorAvailability] da
                        WHERE da.DoctorId = @DoctorId
                          AND CAST(da.StartTime AS DATE) = @SelectedDate
                          AND NOT EXISTS (
                                SELECT 1 
                                FROM [dbo].[Appointments] a
                                WHERE a.DoctorId = da.DoctorId
                                  AND a.Status IN ('Pending', 'Accepted')
                                  AND ABS(DATEDIFF(MINUTE, a.AppointmentDate, da.StartTime)) < 1
                          )
                        ORDER BY da.StartTime ASC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@DoctorId", doctorId);
                    cmd.Parameters.AddWithValue("@SelectedDate", selectedDate.Date);

                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                DateTime start = Convert.ToDateTime(reader["StartTime"]);
                                DateTime end = Convert.ToDateTime(reader["EndTime"]);

                                availableSlots.Add(new TimeSlot
                                {
                                    SlotText = $"{start.ToString("hh:mm tt")} - {end.ToString("hh:mm tt")}",
                                    SlotValue = start.ToString("yyyy-MM-dd HH:mm:ss") // Store exact timestamp as value
                                });
                            }
                        }

                        // Bind to UI
                        if (availableSlots.Count > 0)
                        {
                            gvSlots.DataSource = availableSlots;
                            gvSlots.DataBind();
                            gvSlots.Visible = true;
                            phNoSlots.Visible = false;
                        }
                        else
                        {
                            gvSlots.Visible = false;
                            phNoSlots.Visible = true;
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error loading slots: " + ex.Message;
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }
        }

        protected void gvSlots_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "BookSlot")
            {
                if (!int.TryParse(Request.QueryString["id"], out int doctorId)) return;

                DateTime appointmentTime = DateTime.Parse(e.CommandArgument.ToString());
                int patientUserId = Convert.ToInt32(Session["UserId"]);

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    try
                    {
                        conn.Open();

                        // 1. Resolve PatientId from UserId
                        int patientId = 0;

                        using (SqlCommand cmdPatient = new SqlCommand(
                            "SELECT PatientId FROM [dbo].[Patients] WHERE UserId = @UserId", conn))
                        {
                            cmdPatient.Parameters.AddWithValue("@UserId", patientUserId);
                            object result = cmdPatient.ExecuteScalar();
                            if (result != null)
                                patientId = Convert.ToInt32(result);
                        }

                        if (patientId == 0) throw new Exception("Patient profile not found.");

                        // 2. Double check the slot is still free (Concurrency Check)
                        string checkSql = @"
                                    SELECT COUNT(*) 
                                    FROM [dbo].[Appointments] 
                                    WHERE DoctorId = @DoctorId 
                                      AND Status IN ('Pending', 'Accepted')
                                      AND ABS(DATEDIFF(MINUTE, AppointmentDate, @AppDate)) < 1";
                        using (SqlCommand cmdCheck = new SqlCommand(checkSql, conn))
                        {
                            cmdCheck.Parameters.AddWithValue("@DoctorId", doctorId);
                            cmdCheck.Parameters.AddWithValue("@AppDate", appointmentTime);
                            int existingCount = (int)cmdCheck.ExecuteScalar();

                            if (existingCount > 0)
                            {
                                lblMessage.Text = "Sorry, this slot was just booked by someone else. Please select another.";
                                lblMessage.ForeColor = System.Drawing.Color.Red;
                                LoadAvailableSlots(calAppointments.SelectedDate, doctorId);
                                return;
                            }
                        }

                        // 3. Insert Appointment Request
                        string insertAppSql = @"
                            INSERT INTO [dbo].[Appointments] (DoctorId, PatientId, AppointmentDate, Status, Reason) 
                            VALUES (@DoctorId, @PatientId, @AppointmentDate, 'Pending', 'General Checkup / Consultation')";

                        using (SqlCommand cmdInsert = new SqlCommand(insertAppSql, conn))
                        {
                            cmdInsert.Parameters.AddWithValue("@DoctorId", doctorId);
                            cmdInsert.Parameters.AddWithValue("@PatientId", patientId);
                            cmdInsert.Parameters.AddWithValue("@AppointmentDate", appointmentTime);
                            cmdInsert.ExecuteNonQuery();
                        }

                        // 4. Notify Doctor (Optional but aligns with your pipeline design)
                        int doctorUserId = 0;
                        using (SqlCommand cmdDoc = new SqlCommand("SELECT UserId FROM [dbo].[Doctors] WHERE DoctorId = @DoctorId", conn))
                        {
                            cmdDoc.Parameters.AddWithValue("@DoctorId", doctorId);
                            object result = cmdDoc.ExecuteScalar();
                            if (result != null) doctorUserId = Convert.ToInt32(result);
                        }

                        if (doctorUserId > 0)
                        {
                            string notifSql = @"
                                INSERT INTO [dbo].[Notifications] (UserId, Type, Title, Message, IsRead, CreatedAt) 
                                VALUES (@UserId, 'AppointmentRequested', 'New Booking Request', @Msg, 0, GETDATE())";
                            using (SqlCommand cmdNotif = new SqlCommand(notifSql, conn))
                            {
                                cmdNotif.Parameters.AddWithValue("@UserId", doctorUserId);
                                cmdNotif.Parameters.AddWithValue("@Msg", $"You have a new appointment request pending for {appointmentTime:yyyy-MM-dd HH:mm}.");
                                cmdNotif.ExecuteNonQuery();
                            }
                        }

                        // Success UI Updates
                        lblMessage.Text = $"Success! Your request for {appointmentTime.ToString("f")} has been sent to the doctor for approval.";
                        lblMessage.ForeColor = System.Drawing.Color.Green;

                        // Refresh the UI to remove the booked slot
                        LoadAvailableSlots(calAppointments.SelectedDate, doctorId);
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "Error during booking: " + ex.Message;
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }
        }

        // Helper to grab initials for the Avatar circle (e.g. "John Doe" -> "JD")
        private string GetInitials(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "MD";
            string[] words = fullName.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (words.Length == 1) return words[0].Substring(0, Math.Min(2, words[0].Length)).ToUpper();
            return (words[0].Substring(0, 1) + words[words.Length - 1].Substring(0, 1)).ToUpper();
        }
    }
}