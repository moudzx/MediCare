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
                SetEditMode(false);
            }
           
        }
        protected void btnEdit_Click(object sender, EventArgs e)
        {
            SetEditMode(true);
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            //save data befire
            SetEditMode(false);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            SetEditMode(false);
        }
        private void SetEditMode(bool enabled)
        {
            txtPhone.ReadOnly = !enabled;

            txtAge.ReadOnly = !enabled;
            txtHeight.ReadOnly = !enabled;
            txtWeight.ReadOnly = !enabled;

            txtDisease.ReadOnly = !enabled;
            txtDisability.ReadOnly = !enabled;
            txtFamilyHistory.ReadOnly = !enabled;

            ddlPhoneCode.Enabled = enabled;
            ddlBloodType.Enabled = enabled;

            btnEdit.Visible = !enabled;

            btnSave.Visible = enabled;
            btnCancel.Visible = enabled;

            ViewState["EditMode"] = enabled;
        }
    }
}