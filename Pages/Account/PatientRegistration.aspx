<%@ Page Title="Patient Registration – MediCare" Language="C#" MasterPageFile="~/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="PatientRegistration.aspx.cs" Inherits="MediCare.PatientRegistration" %>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="mc-auth">
        <div class="mc-container">
            <div class="mc-section-header">
                <span class="mc-section-tag">Patient Portal</span>
                <h2 class="mc-section-title">Create your <em>health profile</em></h2>
                <p class="mc-section-sub">Join thousands of patients managing their health intelligently.</p>
            </div>

            <div class="mc-form-panel">
                <div class="mc-form-card">
                    <div class="mc-form-card__header">
                        <div class="mc-form-avatar mc-form-avatar--green">
                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>
                        <div>
                            <h3>Patient Registration</h3>
                            <p>Enter your details to get started</p>
                        </div>
                    </div>

                    <asp:Panel ID="pnlPatientForm" runat="server" CssClass="mc-form">
                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Full Name <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtPatientName" runat="server" CssClass="mc-input" placeholder="e.g. Sara Al-Khalil" />
                                <asp:RequiredFieldValidator ID="rfvPatientName" runat="server" ControlToValidate="txtPatientName" ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Full name is required." Display="Dynamic" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Email Address <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtPatientEmail" runat="server" CssClass="mc-input" TextMode="Email" placeholder="you@example.com" />
                                <asp:RequiredFieldValidator ID="rfvPatientEmail" runat="server" ControlToValidate="txtPatientEmail" ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Email is required." Display="Dynamic" />
                            </div>
                        </div>

                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Password <span class="mc-required">*</span></label>
                                <div class="mc-input-wrap">
                                    <asp:TextBox ID="txtPatientPassword" runat="server" CssClass="mc-input" TextMode="Password" placeholder="Min 8 characters" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvPatientPwd" runat="server" ControlToValidate="txtPatientPassword" ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Password is required." Display="Dynamic" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Confirm Password <span class="mc-required">*</span></label>
                                <div class="mc-input-wrap">
                                    <asp:TextBox ID="txtPatientConfirmPwd" runat="server" CssClass="mc-input" TextMode="Password" placeholder="Re-enter password" />
                                </div>
                                <asp:CompareValidator ID="cvPatientPwd" runat="server" ControlToValidate="txtPatientConfirmPwd" ControlToCompare="txtPatientPassword" ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Passwords do not match." Display="Dynamic" />
                            </div>
                        </div>

                        <div class="mc-form__row mc-form__row--thirds">
                            <div class="mc-form__group">
                                <label class="mc-label">Age <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtPatientAge" runat="server" CssClass="mc-input" TextMode="Number" placeholder="25" />
                                <asp:RequiredFieldValidator ID="rfvPatientAge" runat="server" ControlToValidate="txtPatientAge" ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Age is required." Display="Dynamic" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Height (cm)</label>
                                <asp:TextBox ID="txtPatientHeight" runat="server" CssClass="mc-input" TextMode="Number" placeholder="170" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Weight (kg)</label>
                                <asp:TextBox ID="txtPatientWeight" runat="server" CssClass="mc-input" TextMode="Number" placeholder="70" />
                            </div>
                        </div>

                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Disability (if any)</label>
                                <asp:TextBox ID="txtDisability" runat="server" CssClass="mc-input" placeholder="None" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Chronic Disease</label>
                                <asp:TextBox ID="txtChronicDisease" runat="server" CssClass="mc-input" placeholder="None" />
                            </div>
                        </div>

                        <div class="mc-form__footer">
                            <asp:Button ID="btnPatientSignUp" runat="server" Text="Create Patient Account" CssClass="mc-btn mc-btn--primary mc-btn--lg mc-btn--submit" ValidationGroup="PatientGroup" OnClick="btnPatientSignUp_Click" />
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </section>
</asp:Content>