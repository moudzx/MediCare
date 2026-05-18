using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;

namespace MediCare.Pages.Patient
{
    public partial class Medications : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                
            }
        }
        
        protected void btnSearchMedication_Click(object sender, EventArgs e)
        {
            // TODO: Implement search logic for gvMedications
        }

        protected void btnSaveMedication_Click(object sender, EventArgs e)
        {
            // TODO: Save custom medication from form inputs
        }
    }
}