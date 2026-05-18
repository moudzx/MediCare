using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Patient
{
    public partial class Nutritions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSearchResults();
                LoadNutritionPlan();
                LoadMyPlanDefaults();
            }
        }

        // =========================================
        // STATIC FOOD SEARCH RESULTS
        // =========================================
        private void LoadSearchResults()
        {
            var foods = new List<Food>
            {
                new Food { Name = "Grilled Chicken", Calories = 165, Protein = 31, Carbs = 0, Fat = 3 },
                new Food { Name = "Brown Rice", Calories = 216, Protein = 5, Carbs = 45, Fat = 2 },
                new Food { Name = "Avocado", Calories = 240, Protein = 3, Carbs = 12, Fat = 22 },
                new Food { Name = "Banana", Calories = 105, Protein = 1, Carbs = 27, Fat = 0 },
                new Food { Name = "Oats", Calories = 150, Protein = 6, Carbs = 27, Fat = 3 }
            };

            gvSearchResults.DataSource = foods;
            gvSearchResults.DataBind();
        }

        // =========================================
        // STATIC NUTRITION PLAN (DOCTOR VS PATIENT)
        // =========================================
        private void LoadNutritionPlan()
        {
            var plans = new List<NutritionPlan>
            {
                new NutritionPlan
                {
                    Source = "Doctor",
                    Calories = 2000,
                    Protein = 120,
                    Carbs = 220,
                    Fiber = 30,
                    Fat = 70
                },
                new NutritionPlan
                {
                    Source = "My Plan",
                    Calories = 1800,
                    Protein = 100,
                    Carbs = 200,
                    Fiber = 25,
                    Fat = 60
                }
            };

            gvNutritionPlan.DataSource = plans;
            gvNutritionPlan.DataBind();
        }

        // =========================================
        // DEFAULT VALUES FOR "MY PLAN" FORM
        // =========================================
        private void LoadMyPlanDefaults()
        {
            txtMyCalories.Text = "1800";
            txtMyProtein.Text = "100";
            txtMyCarbs.Text = "200";
            txtMyFiber.Text = "25";
            txtMyFat.Text = "60";
        }

        // =========================================
        // BUTTON EVENTS
        // =========================================

        protected void btnSaveMyPlan_Click(object sender, EventArgs e)
        {
            // just simulation (no DB yet)
            string msg = "Plan saved successfully (static demo).";

            ClientScript.RegisterStartupScript(
                this.GetType(),
                "msg",
                $"alert('{msg}');",
                true
            );

            LoadNutritionPlan();
        }

        // =========================================
        // MODELS (LOCAL FOR TESTING ONLY)
        // =========================================

        public class Food
        {
            public string Name { get; set; }
            public int Calories { get; set; }
            public int Protein { get; set; }
            public int Carbs { get; set; }
            public int Fat { get; set; }
        }

        public class NutritionPlan
        {
            public string Source { get; set; }
            public int Calories { get; set; }
            public int Protein { get; set; }
            public int Carbs { get; set; }
            public int Fiber { get; set; }
            public int Fat { get; set; }
        }
    }
}