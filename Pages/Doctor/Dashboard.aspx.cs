using System;
using System.Collections.Generic;
using System.Text;

namespace MediCare.Pages.Doctor
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDoctorInfo();
                LoadSchedule();
                LoadUpcoming();
            }
        }

        // ═════════════════ DOCTOR INFO ═════════════════
        private void LoadDoctorInfo()
        {
            lblDoctorName.Text = "Dr. Ahmad Karimi";
            lblSpecialty.Text = "Cardiologist";

            int h = DateTime.Now.Hour;

            lblGreeting.Text =
                h < 12 ? "Good morning," :
                h < 18 ? "Good afternoon," :
                "Good evening,";
        }


        // ═════════════════ SCHEDULE (HTML BUILDER) ═════════════════
        private void LoadSchedule()
        {
            StringBuilder html = new StringBuilder();

            for (int hour = 8; hour <= 18; hour++)
            {
                bool isBreak = (hour == 11);

                string timeMain = (hour % 12 == 0 ? 12 : hour % 12).ToString();
                string period = hour < 12 ? "AM" : "PM";

                if (isBreak)
                {
                    html.Append($@"
                    <div class='db-slot'>
                        <div class='db-slot__time'>
                            <span class='db-slot__time-main'>{timeMain}</span>
                            <span class='db-slot__time-period'>{period}</span>
                        </div>

                        <div class='db-slot__line'></div>

                        <div class='db-slot__card db-slot__card--break'>
                            <div class='db-slot__icon'>
                                <i class='fa-solid fa-mug-hot'></i>
                            </div>
                            <div class='db-slot__info'>
                                <div class='db-slot__patient-name'>Break</div>
                            </div>
                        </div>
                    </div>");
                }
                else
                {
                    html.Append($@"
                    <div class='db-slot'>
                        <div class='db-slot__time'>
                            <span class='db-slot__time-main'>{timeMain}</span>
                            <span class='db-slot__time-period'>{period}</span>
                        </div>

                        <div class='db-slot__line'></div>

                        <div class='db-slot__card db-slot__card--booked'>
                            <div class='db-slot__icon'>
                                <i class='fa-solid fa-user-injured'></i>
                            </div>

                            <div class='db-slot__info'>
                                <div class='db-slot__patient-name'>
                                    Patient {hour}
                                </div>
                                <div class='db-slot__detail'>
                                    Check-up
                                </div>
                            </div>
                        </div>
                    </div>");
                }
            }

            phSchedule.Controls.Add(new System.Web.UI.LiteralControl(html.ToString()));
        }

        // ═════════════════ UPCOMING LIST ═════════════════
        private void LoadUpcoming()
        {
            StringBuilder html = new StringBuilder();

            var patients = new[]
            {
                new { Name = "Sara Al-Khalil", Reason = "Follow-up", Time = "10:00 AM" },
                new { Name = "Omar Mansour", Reason = "ECG", Time = "11:30 AM" },
                new { Name = "Lara Hassan", Reason = "Check-up", Time = "12:15 PM" }
            };

            foreach (var p in patients)
            {
                html.Append($@"
                <div class='db-upcoming-item'>

                    <div class='db-upcoming-avatar'>
                        {p.Name[0]}
                    </div>

                    <div class='db-upcoming-info'>
                        <div class='db-upcoming-name'>{p.Name}</div>
                        <div class='db-upcoming-reason'>{p.Reason}</div>
                    </div>

                    <div class='db-upcoming-time'>
                        {p.Time}
                    </div>

                    <span class='db-upcoming-status db-upcoming-status--confirmed'>
                        Booked
                    </span>

                </div>");
            }

            phUpcoming.Controls.Add(new System.Web.UI.LiteralControl(html.ToString()));
        }
    }
    
}