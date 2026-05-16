using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace MediCare.Pages.Patient
{
    public partial class PatientProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Load your data but DO NOT change ReadOnly properties here!
                // The JavaScript will lock the fields on page load.
                txtEmail.Text = "user@example.com";
                txtFullName.Text = "John Doe";
                txtAge.Text = "30";
                // ... load health labels ...
            }
            // DO NOT write: txtEmail.ReadOnly = false;
        }

        protected void btnSaveAll_Click(object sender, EventArgs e)
        {
            // All fields are now editable, so you can read them
            string email = txtEmail.Text;
            string fullName = txtFullName.Text;
            int age = int.Parse(txtAge.Text);
            // ... save to database ...

            // After saving, you can either redirect or reload the page.
            // If you want to keep the page in view mode, just call Page_Load again.
        }
    }
}