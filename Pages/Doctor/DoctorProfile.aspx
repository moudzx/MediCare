<%@ Page Title="My Profile – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="DoctorProfile.aspx.cs"
    Inherits="MediCare.Pages.Doctor.DoctorProfile" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        .prof-container { max-width: 900px; margin: 30px auto; padding: 0 20px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .prof-card { background: #fff; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border: 1px solid #eef2f5; overflow: hidden; }
        .prof-header { background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%); padding: 40px 30px; color: #fff; display: flex; align-items: center; gap: 25px; }
        .prof-avatar-circle { width: 90px; height: 90px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; border: 3px solid rgba(255,255,255,0.4); }
        .prof-header-info h1 { margin: 0 0 5px 0; font-size: 1.8rem; font-weight: 600; }
        .prof-header-info p { margin: 0; opacity: 0.9; font-size: 1rem; }
        .prof-badge { display: inline-block; background: #e0f2fe; color: #0369a1; padding: 4px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; margin-top: 8px; }
        
        .prof-stats-bar { display: grid; grid-template-columns: repeat(3, 1fr); background: #f8fafc; border-bottom: 1px solid #e2e8f0; text-align: center; padding: 15px 0; }
        .prof-stat-item { border-right: 1px solid #e2e8f0; }
        .prof-stat-item:last-child { border-right: none; }
        .prof-stat-num { block: text; font-size: 1.4rem; font-weight: bold; color: #1e293b; }
        .prof-stat-lbl { font-size: 0.8rem; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; }

        .prof-body { padding: 30px; }
        .prof-section-title { font-size: 1.1rem; color: #334155; margin: 0 0 20px 0; padding-bottom: 8px; border-bottom: 2px solid #f1f5f9; display: flex; align-items: center; gap: 10px; font-weight: 600; }
        
        .prof-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 30px; }
        .prof-grid--full { grid-template-columns: 1fr; }
        .prof-group { display: flex; flex-direction: column; gap: 6px; }
        .prof-label { font-size: 0.85rem; color: #475569; font-weight: 500; }
        .prof-input { padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 0.95rem; color: #334155; transition: border 0.2s; background-color: #fff; }
        .prof-input:focus { border-color: #0284c7; outline: none; box-shadow: 0 0 0 3px rgba(2,132,199,0.1); }
        .prof-input--readonly { background-color: #f1f5f9; color: #64748b; cursor: not-allowed; }
        
        .prof-actions { display: flex; justify-content: flex-end; gap: 12px; padding-top: 20px; border-top: 1px solid #f1f5f9; }
        .prof-btn { padding: 10px 24px; border-radius: 6px; font-size: 0.95rem; font-weight: 500; cursor: pointer; border: none; transition: background 0.2s; }
        .prof-btn--primary { background: #0284c7; color: #fff; }
        .prof-btn--primary:hover { background: #0369a1; }
        
        .prof-alert { padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; font-size: 0.9rem; display: flex; align-items: center; gap: 10px; }
        .prof-alert--success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
        .prof-alert--error { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
    </style>
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="prof-container">

    <asp:Panel ID="pnlAlert" runat="server" Visible="false">
        <i id="alertIcon" runat="server" class="fa-solid"></i>
        <asp:Label ID="lblAlertMessage" runat="server" />
    </asp:Panel>

    <div class="prof-card">
        <div class="prof-header">
            <div class="prof-avatar-circle">
                <i class="fa-solid fa-user-md"></i>
            </div>
            <div class="prof-header-info">
                <h1><asp:Label ID="lblHeaderName" runat="server" Text="Doctor Name" /></h1>
                <p><asp:Label ID="lblHeaderSpeciality" runat="server" Text="General Practice" /></p>
                <span class="prof-badge"><i class="fa-solid fa-id-card"></i> Verified Practitioner</span>
            </div>
        </div>

        <div class="prof-stats-bar">
            <div class="prof-stat-item">
                <span class="prof-stat-num"><asp:Label ID="lblStatPatients" runat="server" Text="0" /></span>
                <span class="prof-stat-lbl">Active Patients</span>
            </div>
            <div class="prof-stat-item">
                <span class="prof-stat-num"><asp:Label ID="lblStatAppointments" runat="server" Text="0" /></span>
                <span class="prof-stat-lbl">Appointments</span>
            </div>
            <div class="prof-stat-item">
                <span class="prof-stat-num"><asp:Label ID="lblStatAge" runat="server" Text="--" /></span>
                <span class="prof-stat-lbl">Age</span>
            </div>
        </div>

        <div class="prof-body">
            
            <div class="prof-section-title">
                <i class="fa-solid fa-lock"></i> Account Credentials
            </div>
            <div class="prof-grid">
                <div class="prof-group">
                    <label class="prof-label">Account Email (Username)</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="prof-input prof-input--readonly" ReadOnly="true" />
                </div>
                <div class="prof-group">
                    <label class="prof-label">Gender Role Context</label>
                    <asp:TextBox ID="txtGender" runat="server" CssClass="prof-input prof-input--readonly" ReadOnly="true" />
                </div>
            </div>

            <div class="prof-section-title">
                <i class="fa-solid fa-user-gear"></i> Clinical Practice Details
            </div>
            
            <div class="prof-grid">
                <div class="prof-group">
                    <label class="prof-label">Full Name *</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="prof-input" placeholder="Dr. John Doe" />
                </div>
                <div class="prof-group">
                    <label class="prof-label">Contact Phone Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="prof-input" placeholder="+1 (555) 000-0000" />
                </div>
                <div class="prof-group">
                    <label class="prof-label">Medical Speciality Area</label>
                    <asp:TextBox ID="txtSpeciality" runat="server" CssClass="prof-input" placeholder="e.g., Cardiology, Pediatrics" />
                </div>
                <div class="prof-group">
                    <label class="prof-label">Practitioner Age *</label>
                    <asp:TextBox ID="txtAge" runat="server" TextMode="Number" CssClass="prof-input" placeholder="35" />
                </div>
            </div>

            <div class="prof-grid prof-grid--full">
                <div class="prof-group">
                    <label class="prof-label">Clinic / Hospital Practice Address</label>
                    <asp:TextBox ID="txtClinicAddress" runat="server" CssClass="prof-input" placeholder="Suite 404, Medical Building, Healthcare Ave." />
                </div>
                <div class="prof-group">
                    <label class="prof-label">Medical Certification File Reference</label>
                    <asp:TextBox ID="txtCertificatePath" runat="server" CssClass="prof-input prof-input--readonly" ReadOnly="true" />
                </div>
            </div>

            <div class="prof-actions">
                <asp:Button ID="btnSaveProfile" runat="server" OnClick="btnSaveProfile_Click" CssClass="prof-btn prof-btn--primary" Text="Update Profile Details" />
            </div>

        </div>
    </div>
</div>
</asp:Content>