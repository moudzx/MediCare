using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Patient
{
    public partial class Search : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Initial load – show all results
                SearchAndBind();
            }
        }

        // SEARCH LOGIC
        private void SearchAndBind()
        {
            string scope = ddlSearchScope.SelectedValue;
            string query = txtSearchQuery.Text.Trim();

            bool searchDoctors = scope == "all" || scope == "doctors";
            bool searchMedicines = scope == "all" || scope == "medicines";
            bool searchFoods = scope == "all" || scope == "foods";

            // Filter data
            var doctors = searchDoctors ? GetFilteredDoctors(query) : new List<DoctorItem>();
            var medicines = searchMedicines ? GetFilteredMedicines(query) : new List<MedicineItem>();
            var foods = searchFoods ? GetFilteredFoods(query) : new List<FoodItem>();

            // Bind grids
            BindGrid(gvDoctors, doctors);
            BindGrid(gvMedicines, medicines);
            BindGrid(gvFoods, foods);

            // Show/hide cards
            cardDoctors.Visible = searchDoctors;
            cardMedicines.Visible = searchMedicines;
            cardFoods.Visible = searchFoods;

            // Update result count message
            int total = doctors.Count + medicines.Count + foods.Count;
            if (total > 0)
                ShowMessage($"Found {total} result(s).", "success");
            else
                ShowMessage("No results found. Try a different search term.", "error");
        }

        private void BindGrid<T>(GridView grid, List<T> data)
        {
            grid.DataSource = data;
            grid.DataBind();
        }

        private List<DoctorItem> GetFilteredDoctors(string query)
        {
            var doctors = GetSampleDoctors(); // later from DB
            if (string.IsNullOrWhiteSpace(query))
                return doctors;
            query = query.ToLower();
            return doctors.Where(d => d.Name.ToLower().Contains(query) ||
                                      d.Specialization.ToLower().Contains(query)).ToList();
        }

        private List<MedicineItem> GetFilteredMedicines(string query)
        {
            var meds = GetSampleMedicines();
            if (string.IsNullOrWhiteSpace(query))
                return meds;
            query = query.ToLower();
            return meds.Where(m => m.Name.ToLower().Contains(query) ||
                                   m.Description.ToLower().Contains(query)).ToList();
        }

        private List<FoodItem> GetFilteredFoods(string query)
        {
            var foods = GetSampleFoods();
            if (string.IsNullOrWhiteSpace(query))
                return foods;
            query = query.ToLower();
            return foods.Where(f => f.Name.ToLower().Contains(query)).ToList();
        }

        // =========================
        // BUTTON EVENTS
        // =========================
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            SearchAndBind();
        }

        protected void gvDoctors_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int doctorId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ConnectDoctor")
            {
                // TODO: Send connection request to database
                ShowMessage($"Connection request sent to doctor (ID: {doctorId}).", "success");
            }
            else if (e.CommandName == "OpenDoctorProfile")
            {
                // Redirect to the doctor's profile page
                Response.Redirect($"DoctorProfile.aspx?doctorId={doctorId}");
            }
        }

        protected void gvMedicines_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // The medicine "Add" button is a hyperlink to AddMedicine.aspx,
            // so no RowCommand is triggered. This method is kept for future use.
        }


        // =========================
        // HELPER TO DISPLAY MESSAGE
        // =========================
        private void ShowMessage(string text, string type)
        {
            lblSearchMsg.Text = text;
            lblSearchMsg.CssClass = $"sea-inline-msg sea-inline-msg--{type}";
            lblSearchMsg.Visible = true;
        }

        // =========================
        // STATIC SAMPLE DATA (replace with DB calls)
        // =========================
        private List<DoctorItem> GetSampleDoctors()
        {
            return new List<DoctorItem>
            {
                new DoctorItem { Id = 1, Name = "Dr. Ahmad Karimi", Specialization = "Cardiology" },
                new DoctorItem { Id = 2, Name = "Dr. Sara Nasser", Specialization = "Neurology" },
                new DoctorItem { Id = 3, Name = "Dr. Ali Hamdan", Specialization = "Orthopedics" }
            };
        }

        private List<MedicineItem> GetSampleMedicines()
        {
            return new List<MedicineItem>
            {
                new MedicineItem { Id = 101, Name = "Panadol", Description = "Pain relief tablet" },
                new MedicineItem { Id = 102, Name = "Amoxicillin", Description = "Antibiotic capsule" },
                new MedicineItem { Id = 103, Name = "Ventolin", Description = "Asthma inhaler" }
            };
        }

        private List<FoodItem> GetSampleFoods()
        {
            return new List<FoodItem>
            {
                new FoodItem { Id = 201, Name = "Chicken Breast", Calories = 165, Protein = 31, Carbs = 0, Fiber = 0, Fat = 3 },
                new FoodItem { Id = 202, Name = "Rice (Boiled)", Calories = 130, Protein = 2, Carbs = 28, Fiber = 1, Fat = 0 },
                new FoodItem { Id = 203, Name = "Avocado", Calories = 240, Protein = 3, Carbs = 12, Fiber = 10, Fat = 22 }
            };
        }

        // =========================
        // MODEL CLASSES
        // =========================
        private class DoctorItem
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Specialization { get; set; }
        }

        private class MedicineItem
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
        }

        private class FoodItem
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public int Calories { get; set; }
            public int Protein { get; set; }
            public int Carbs { get; set; }
            public int Fiber { get; set; }
            public int Fat { get; set; }
        }
    }
}