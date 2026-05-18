using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Patient
{
    public partial class Medications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPatientMedications();
                LoadCustomMedications();
            }
        }

        private void LoadPatientMedications()
        {
            var data = new List<MedicationVM>
            {
                new MedicationVM
                {
                    Medication = "Amoxicillin",
                    PillsNumber = 2,
                    Dosage = "500mg",
                    Frequency = "Twice Daily",
                    StartDate = DateTime.Now.AddDays(-3),
                    EndDate = DateTime.Now.AddDays(7)
                },
                new MedicationVM
                {
                    Medication = "Paracetamol",
                    PillsNumber = 1,
                    Dosage = "1g",
                    Frequency = "Every 8 Hours",
                    StartDate = DateTime.Now.AddDays(-1),
                    EndDate = DateTime.Now.AddDays(5)
                },
                new MedicationVM
                {
                    Medication = "Vitamin D",
                    PillsNumber = 1,
                    Dosage = "1000 IU",
                    Frequency = "Once Daily",
                    StartDate = DateTime.Now.AddDays(-10),
                    EndDate = DateTime.Now.AddMonths(1)
                },
                new MedicationVM
                {
                    Medication = "Ibuprofen",
                    PillsNumber = 2,
                    Dosage = "400mg",
                    Frequency = "As needed",
                    StartDate = DateTime.Now.AddDays(-2),
                    EndDate = DateTime.Now.AddDays(10)
                }
            };

            tblPatientMedications.DataSource = data;
            tblPatientMedications.DataBind();
        }

        private void LoadCustomMedications()
        {
            var data = new List<CustomMedicationVM>
            {
                new CustomMedicationVM
                {
                    Name = "Zinc Supplements",
                    Dosage = "50mg",
                    Frequency = "Once daily",
                    Status = "Active"
                },
                new CustomMedicationVM
                {
                    Name = "Omega 3",
                    Dosage = "1000mg",
                    Frequency = "Twice daily",
                    Status = "Pending"
                }
            };

            // ⚠️ If you don't have a second GridView for custom meds yet,
            // you can ignore this OR bind later.
            // Example:
            // gvCustomMedications.DataSource = data;
            // gvCustomMedications.DataBind();
        }

        protected void btnSaveCustomMed_Click(object sender, EventArgs e)
        {
            // demo only (no DB)
            lblCustomMsg.Visible = true;
            lblCustomMsg.Text = "Medication saved (demo mode)";
        }

        // ===== VIEW MODELS =====

        public class MedicationVM
        {
            public string Medication { get; set; }
            public int PillsNumber { get; set; }
            public string Dosage { get; set; }
            public string Frequency { get; set; }
            public DateTime StartDate { get; set; }
            public DateTime EndDate { get; set; }
        }

        public class CustomMedicationVM
        {
            public string Name { get; set; }
            public string Dosage { get; set; }
            public string Frequency { get; set; }
            public string Status { get; set; }
        }
    }
}