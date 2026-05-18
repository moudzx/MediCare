<%@ Page Title="Patient Profile"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="PatientProfile.aspx.cs"
    Inherits="MediCare.Pages.Patient.PatientProfile" %>

<asp:Content ID="HeadContent"
    ContentPlaceHolderID="HeadContent"
    runat="server">

    <link rel="stylesheet" href="/css/ProfilePatient.css" />

</asp:Content>

<asp:Content ID="MainContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="prp-root">

        <!-- =========================
             BANNER
        ========================= -->
        <div class="prp-banner">

            <div class="prp-banner__overlay"></div>

            <div class="prp-banner__body">

                <!-- Avatar -->
                <div class="prp-avatar-ring">

                    <div class="prp-avatar">

                        <asp:Label ID="lblInitials"
                            runat="server"
                            CssClass="prp-avatar__initials" />

                    </div>

                    <span class="prp-online-dot"></span>

                </div>

                <!-- Name -->
                <div class="prp-banner__info">

                    <h1 class="prp-banner__name">

                        <asp:Label ID="lblDisplayName"
                            runat="server" />

                    </h1>

                    <span class="prp-banner__role">

                        <i class="fas fa-user-circle"></i>
                        Patient

                    </span>

                </div>

                <!-- Buttons -->
                <div class="prp-banner__actions">

                    <asp:Button ID="btnEdit"
                        runat="server"
                        Text="Edit Profile"
                        CssClass="prp-btn prp-btn--outline"
                        OnClick="btnEdit_Click" />

                    <asp:Button ID="btnSave"
                        runat="server"
                        Text="Save Changes"
                        CssClass="prp-btn prp-btn--primary"
                        Visible="false"
                        OnClick="btnSave_Click" />

                    <asp:Button ID="btnCancel"
                        runat="server"
                        Text="Cancel"
                        CssClass="prp-btn prp-btn--ghost"
                        Visible="false"
                        OnClick="btnCancel_Click" />

                </div>

            </div>

        </div>

        <!-- =========================
             PAGE BODY
        ========================= -->
        <div class="prp-body">

            <!-- LEFT -->
            <div class="prp-col prp-col--left">

                <div class="prp-card prp-card--profile">

                    <div class="prp-card__avatar-area">

                        <div class="prp-avatar prp-avatar--lg">

                            <asp:Label ID="lblInitialsCard"
                                runat="server"
                                CssClass="prp-avatar__initials" />

                        </div>

                        <h2 class="prp-card__name">

                            <asp:Label ID="lblCardName"
                                runat="server" />

                        </h2>

                        <span class="prp-card__tag">

                            <i class="fas fa-shield-alt"></i>
                            Verified Patient

                        </span>

                    </div>

                </div>

            </div>

            <!-- RIGHT -->
            <div class="prp-col prp-col--right">

                <!-- =========================
                     ACCOUNT INFO
                ========================= -->
                <div class="prp-card">

                    <div class="prp-card__header">

                        <div class="prp-card__header-icon prp-card__header-icon--blue">
                            <i class="fas fa-user"></i>
                        </div>

                        <div>
                            <h3 class="prp-card__title">
                                Account Information
                            </h3>

                            <p class="prp-card__sub">
                                Your account details
                            </p>
                        </div>

                    </div>

                    <div class="prp-card__body">

                        <!-- Username -->
                        <div class="prp-field">

                            <label class="prp-field__label">
                                <i class="fas fa-at"></i>
                                Username
                            </label>

                            <asp:TextBox ID="txtUsername"
                                runat="server"
                                CssClass="prp-input"
                                ReadOnly="true" />

                        </div>

                        <!-- Email -->
                        <div class="prp-field">

                            <label class="prp-field__label">
                                <i class="fas fa-envelope"></i>
                                Email
                            </label>

                            <asp:TextBox ID="txtEmail"
                                runat="server"
                                CssClass="prp-input"
                                ReadOnly="True" />

                        </div>

                    </div>

                </div>

                <!-- =========================
                     CONTACT INFO
                ========================= -->
                <div class="prp-card">

                    <div class="prp-card__header">

                        <div class="prp-card__header-icon prp-card__header-icon--green">
                            <i class="fas fa-phone"></i>
                        </div>

                        <div>
                            <h3 class="prp-card__title">
                                Contact Information
                            </h3>

                            <p class="prp-card__sub">
                                Your phone number
                            </p>
                        </div>

                    </div>

                    <div class="prp-card__body">

                        <!-- Phone -->
                        <div class="prp-field">

                            <label class="prp-field__label">
                                <i class="fas fa-mobile-alt"></i>
                                Phone Number
                            </label>

                            <div class="prp-phone-wrap">

                                <asp:DropDownList ID="ddlPhoneCode"
                                    runat="server"
                                    CssClass="prp-select"
                                    Enabled="false">

                                    <asp:ListItem Text="+961" Value="+961" />
                                    <asp:ListItem Text="+1" Value="+1" />
                                    <asp:ListItem Text="+44" Value="+44" />

                                </asp:DropDownList>

                                <asp:TextBox ID="txtPhone"
                                    runat="server"
                                    CssClass="prp-input prp-input--phone"
                                    ReadOnly="true" />

                            </div>

                        </div>

                    </div>

                </div>

                <!-- =========================
                     HEALTH INFO
                ========================= -->
                <div class="prp-card">

                    <div class="prp-card__header">

                        <div class="prp-card__header-icon prp-card__header-icon--green">
                            <i class="fas fa-heart-pulse"></i>
                        </div>

                        <div>
                            <h3 class="prp-card__title">
                                Health Information
                            </h3>

                            <p class="prp-card__sub">
                                Medical profile
                            </p>
                        </div>

                    </div>

                    <div class="prp-card__body">

                        <!-- Age -->
                        <div class="prp-field">

                            <label class="prp-field__label">
                                Age
                            </label>

                            <asp:TextBox ID="txtAge"
                                runat="server"
                                CssClass="prp-input"
                                TextMode="Number"
                                ReadOnly="true" />

                        </div>

                        <!-- Height -->
                        <div class="prp-field">

                            <label class="prp-field__label">
                                Height
                            </label>

                            <asp:TextBox ID="txtHeight"
                                runat="server"
                                CssClass="prp-input"
                                TextMode="Number"
                                ReadOnly="true" />

                        </div>

                        <!-- Weight -->
                        <div class="prp-field">

                            <label class="prp-field__label">
                                Weight
                            </label>

                            <asp:TextBox ID="txtWeight"
                                runat="server"
                                CssClass="prp-input"
                                TextMode="Number"
                                ReadOnly="true" />

                        </div>

                        <!-- Blood Type -->
                        <div class="prp-field">

                            <label class="prp-field__label">
                                Blood Type
                            </label>

                            <asp:DropDownList ID="ddlBloodType"
                                runat="server"
                                CssClass="prp-select"
                                Enabled="false">

                                <asp:ListItem Text="A+" Value="A+" />
                                <asp:ListItem Text="O+" Value="O+" />
                                <asp:ListItem Text="B+" Value="B+" />
                                <asp:ListItem Text="AB+" Value="AB+" />
                                <asp:ListItem Text="A-" Value="A-" />
                                <asp:ListItem Text="O-" Value="O-" />

                            </asp:DropDownList>

                        </div>

                        <!-- Disease -->
                        <div class="prp-field">

                            <label class="prp-field__label">
                                Chronic Disease
                            </label>

                            <asp:TextBox ID="txtDisease"
                                runat="server"
                                CssClass="prp-input"
                                ReadOnly="true" />

                        </div>

                        <!-- Disability -->
                        <div class="prp-field">

                            <label class="prp-field__label">
                                Disability
                            </label>

                            <asp:TextBox ID="txtDisability"
                                runat="server"
                                CssClass="prp-input"
                                ReadOnly="true" />

                        </div>

                        <!-- Family History -->
                        <div class="prp-field">

                            <label class="prp-field__label">
                                Family History
                            </label>

                            <asp:TextBox ID="txtFamilyHistory"
                                runat="server"
                                CssClass="prp-input"
                                TextMode="MultiLine"
                                Rows="4"
                                ReadOnly="true" />

                        </div>

                    </div>

                </div>

            </div>

        </div>

    </div>

</asp:Content>