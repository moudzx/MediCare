using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace MediCare.Pages.Account
{
    public partial class DoctorProfile : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ToggleEditMode(false);
            }
        }

        // ── Edit mode helpers ──────────────────────────────
        private void ToggleEditMode(bool editing)
        {
            // Banner fields
            txtSpecialty.ReadOnly = !editing;
            txtExperience.ReadOnly = !editing;
            txtDepartment.ReadOnly = !editing;
            txtLicense.ReadOnly = !editing;

            // Contact fields
            txtPhone.ReadOnly = !editing;
            txtEmail.ReadOnly = !editing;
            txtClinicAddress.ReadOnly = !editing;

            // Professional details
            txtSubSpecialty.ReadOnly = !editing;
            txtDepartmentProf.ReadOnly = !editing;
            txtLanguages.ReadOnly = !editing;
            txtYearsExperience.ReadOnly = !editing;
            txtConsultationFee.ReadOnly = !editing;
            txtLicenseProf.ReadOnly = !editing;

            // Buttons
            btnEdit.Visible = !editing;
            btnSave.Visible = editing;
            btnCancel.Visible = editing;
        }

        // ── Edit button click ──────────────────────────────
        protected void btnEdit_Click(object sender, EventArgs e)
        {
            ToggleEditMode(true);
        }
        
        // ── Cancel button click ────────────────────────────
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ToggleEditMode(false);
        }

        // ── Save button click ──────────────────────────────
        protected void btnSave_Click(object sender, EventArgs e)
        {
        }
        protected void btnAddSlot_Click(object sender, EventArgs e)
        {

        }

        protected void gvAvailability_RowCommand(object sender, GridViewCommandEventArgs e)
        {

        }
    }
}