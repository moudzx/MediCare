<%@ Page Title="Doctor Profile" Language="C#" MasterPageFile="~/MasterPage/DoctorSite.Master" AutoEventWireup="true" CodeBehind="DoctorProfile.aspx.cs" Inherits="MediCare.Pages.Account.DoctorProfile" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/DoctorProfile.css" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="dp-root" id="dpRoot">

        <!-- Profile Banner -->
        <div class="dp-banner">
            <div class="dp-banner__bg"></div>

            <div class="dp-banner__content">
                <div class="dp-avatar-wrap">
                    <div class="dp-avatar" id="dpAvatar">
                        <span class="dp-avatar__initials">
                            <asp:Label ID="lblInitials" runat="server" Text="--" />
                        </span>
                    </div>

                    <div class="dp-avatar__availability" id="dpAvailabilityDot" title="Available" runat="server"></div>
                </div>

                <div class="dp-banner__info">
                    <div class="dp-banner__specialty-tag">
                        <i class="fas fa-stethoscope"></i>
                        <asp:TextBox ID="txtSpecialty" runat="server" CssClass="dp-specialty-input" ReadOnly="true" />
                    </div>

                    <h1 class="dp-banner__name">
                        <asp:Label ID="lblFullName" runat="server" Text="Dr Name" />
                    </h1>

                    <div class="dp-banner__meta">
                        <span class="dp-meta-chip">
                            <i class="fas fa-award"></i>
                            <asp:TextBox ID="txtExperience" runat="server" CssClass="dp-chip-input" ReadOnly="true" />
                            <span> yrs experience</span>
                        </span>

                        <span class="dp-meta-chip">
                            <i class="fas fa-hospital"></i>
                            <asp:TextBox ID="txtDepartment" runat="server" CssClass="dp-chip-input" ReadOnly="true" />
                        </span>

                        <span class="dp-meta-chip">
                            <i class="fas fa-id-badge"></i>
                            <asp:TextBox ID="txtLicense" runat="server" CssClass="dp-chip-input" ReadOnly="true" />
                        </span>
                    </div>
                </div>

                <div class="dp-banner__actions">
                    <asp:Button ID="btnEdit" runat="server" Text="Edit Profile" CssClass="dp-btn dp-btn--outline" OnClick="btnEdit_Click" />
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="dp-btn dp-btn--primary" Visible="false" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="dp-btn dp-btn--ghost" Visible="false" OnClick="btnCancel_Click" />
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <main class="dp-main">

            <div class="dp-main-grid">
                <!-- Contact Details -->
                <section class="dp-card dp-card--contact">
                    <div class="dp-card__header">
                        <i class="fas fa-address-card"></i>
                        <h3>Contact Details</h3>
                    </div>

                    <div class="dp-card__body">
                        <div class="dp-info-row dp-info-row--highlight">
                            <i class="fas fa-phone-alt"></i>
                            <div class="dp-field">
                                <span class="dp-info-row__label">Phone Number</span>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="dp-info-row__value" ReadOnly="true" />
                            </div>
                        </div>

                        <div class="dp-info-row">
                            <i class="fas fa-envelope"></i>
                            <div class="dp-field">
                                <span class="dp-info-row__label">Email Address</span>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="dp-info-row__value" ReadOnly="true" />
                            </div>
                        </div>

                        <div class="dp-info-row">
                            <i class="fas fa-building"></i>
                            <div class="dp-field">
                                <span class="dp-info-row__label">Clinic Address</span>
                                <asp:TextBox ID="txtClinicAddress" runat="server" CssClass="dp-info-row__value" ReadOnly="true" />
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Professional Details -->
                <section class="dp-card">
                    <div class="dp-card__header">
                        <i class="fas fa-briefcase-medical"></i>
                        <h3>Professional Details</h3>
                    </div>

                    <div class="dp-card__body">
                        <div class="dp-info-grid">
                            <div class="dp-info-cell">
                                <span class="dp-info-cell__label">Sub-Specialty</span>
                                <asp:TextBox ID="txtSubSpecialty" runat="server" CssClass="dp-info-cell__val" ReadOnly="true" />
                            </div>

                            <div class="dp-info-cell">
                                <span class="dp-info-cell__label">Department</span>
                                <asp:TextBox ID="txtDepartmentProf" runat="server" CssClass="dp-info-cell__val" ReadOnly="true" />
                            </div>

                            <div class="dp-info-cell">
                                <span class="dp-info-cell__label">Languages</span>
                                <asp:TextBox ID="txtLanguages" runat="server" CssClass="dp-info-cell__val" ReadOnly="true" />
                            </div>

                            <div class="dp-info-cell">
                                <span class="dp-info-cell__label">Years of Experience</span>
                                <asp:TextBox ID="txtYearsExperience" runat="server" CssClass="dp-info-cell__val" ReadOnly="true" />
                            </div>

                            <div class="dp-info-cell">
                                <span class="dp-info-cell__label">Consultation Fee</span>
                                <asp:TextBox ID="txtConsultationFee" runat="server" CssClass="dp-info-cell__val" ReadOnly="true" />
                            </div>

                            <div class="dp-info-cell">
                                <span class="dp-info-cell__label">License No.</span>
                                <asp:TextBox ID="txtLicenseProf" runat="server" CssClass="dp-info-cell__val" ReadOnly="true" />
                            </div>
                        </div>
                    </div>
                </section>
            </div>
            <section class="dp-card dp-card--availability">

                <div class="dp-card__header">
                    <i class="fas fa-clock"></i>
                    <h3>Manage Availability</h3>
                </div>

                <div class="dp-card__body">

                    <div class="dp-availability-form">

                        <!-- Date -->
                        <div class="dp-form-group">
                            <label>Date</label>
                            <asp:TextBox ID="txtDate" runat="server" TextMode="Date" CssClass="dp-input" />
                        </div>

                        <!-- Start Time -->
                        <div class="dp-form-group">
                            <label>Start Time</label>
                            <asp:TextBox ID="txtStartTime" runat="server" TextMode="Time" CssClass="dp-input" />
                        </div>

                        <!-- End Time -->
                        <div class="dp-form-group">
                            <label>End Time</label>
                            <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time" CssClass="dp-input" />
                        </div>

                        <!-- Add Button -->
                        <asp:Button ID="btnAddSlot"
                                    runat="server"
                                    Text="Add Availability"
                                    CssClass="dp-btn dp-btn--primary"
                                    OnClick="btnAddSlot_Click" />

                    </div>

                </div>
            </section>
            <section class="dp-card">

                <div class="dp-card__header">
                    <i class="fas fa-calendar-check"></i>
                    <h3>Your Availability</h3>
                </div>

                <div class="dp-card__body">

                    <asp:GridView ID="gvAvailability"
                                  runat="server"
                                  AutoGenerateColumns="False"
                                  CssClass="dp-grid"
                                  OnRowCommand="gvAvailability_RowCommand">

                        <Columns>

                            <asp:BoundField DataField="StartTime" HeaderText="Start" />
                            <asp:BoundField DataField="EndTime" HeaderText="End" />

                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:Button ID="btnDelete"
                                                runat="server"
                                                Text="Delete"
                                                CommandName="DeleteSlot"
                                                CommandArgument='<%# Eval("AvailabilityId") %>'
                                                CssClass="dp-btn dp-btn--danger" />
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>

            </section>
        </main>

    </div>

    <div class="dp-toast" id="dpToast" runat="server" visible="false">
        <i class="fas fa-check-circle"></i>
        <span><asp:Literal ID="litToastMsg" runat="server" Text="Profile updated." /></span>
    </div>

</asp:Content>