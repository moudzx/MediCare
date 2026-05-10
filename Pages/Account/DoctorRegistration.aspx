<%@ Page Title="Doctor Registration" Language="C#" MasterPageFile="~/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="DoctorRegistration.aspx.cs" Inherits="MediCare.Pages.Account.DoctorRegistration" %>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="mc-auth">
        <div class="mc-container">
            <div class="mc-section-header">
                <span class="mc-section-tag">Doctor Portal</span>
                <h2 class="mc-section-title">Join our <em>Medical Network</em></h2>
                <p class="mc-section-sub">Verified tools for healthcare professionals to manage patient care.</p>
            </div>

            <div class="mc-form-panel">
                <div class="mc-form-card">
                    <div class="mc-form-card__header">
                        <div class="mc-form-avatar mc-form-avatar--teal">
                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
                            </svg>
                        </div>
                        <div>
                            <h3>Doctor Registration</h3>
                            <p>Professional profile setup</p>
                        </div>
                    </div>

                    <asp:Panel ID="pnlDoctorForm" runat="server" CssClass="mc-form">
                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Full Name <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtDoctorName" runat="server" CssClass="mc-input" placeholder="Dr. Ahmad Karimi" />
                                <asp:RequiredFieldValidator ID="rfvDoctorName" runat="server" ControlToValidate="txtDoctorName" ValidationGroup="DoctorGroup" CssClass="mc-error" ErrorMessage="Required" Display="Dynamic" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Medical License # <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtLicense" runat="server" CssClass="mc-input" placeholder="12345678" />
                                <asp:RequiredFieldValidator ID="rfvLicense" runat="server" ControlToValidate="txtLicense" ValidationGroup="DoctorGroup" CssClass="mc-error" ErrorMessage="License required" Display="Dynamic" />
                            </div>
                        </div>

                        <div class="mc-form__group">
                            <label class="mc-label">Specialization</label>
                            <asp:TextBox ID="txtSpecialty" runat="server" CssClass="mc-input" placeholder="e.g. Cardiology" />
                        </div>

                        <div class="mc-form__footer">
                            <asp:Button ID="btnDoctorSignUp" runat="server" Text="Register as Doctor" CssClass="mc-btn mc-btn--primary mc-btn--lg mc-btn--submit" style="background:#0891B2; border-color:#0891B2;" ValidationGroup="DoctorGroup" OnClick="btnDoctorSignUp_Click" />
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </section>
</asp:Content>