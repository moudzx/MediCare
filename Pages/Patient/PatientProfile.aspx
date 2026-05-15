<%@ Page Title="Profile – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="PatientProfile.aspx.cs"
    Inherits="MediCare.Pages.Patient.PatientProfile" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/profile.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="pro-root">

    <!-- HEADER -->
    <div class="pro-header">

        <div class="pro-header__left">
            <div class="pro-avatar">
                <i class="fa-solid fa-user"></i>
            </div>

            <div>
                <h1 class="pro-title">
                    <asp:Label ID="lblName" runat="server" Text=""></asp:Label>
                </h1>
                <p class="pro-subtitle">
                    Welcome to your profile dashboard
                </p>
            </div>
        </div>

        <div class="pro-role-badge" id="roleBadge">
            <i class="fa-solid fa-user-shield"></i>
            Patient
        </div>

    </div>

    <!-- MAIN GRID -->
    <div class="pro-grid">

        <!-- LEFT -->
        <div class="pro-card">

            <div class="pro-card__header">
                <h2>Account Information</h2>
            </div>

            <div class="pro-card__body">

                <div class="pro-field">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="input" />
                </div>

                <div class="pro-field">
                    <label>Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="input" TextMode="Password" />
                </div>

                <div class="pro-field">
                    <label>Role</label>
                    <asp:TextBox ID="txtRole" runat="server" CssClass="input" ReadOnly="true" />
                </div>

                <div class="pro-field">
                    <label>Created At</label>
                    <asp:TextBox ID="txtCreatedAt" runat="server" CssClass="input" ReadOnly="true" />
                </div>

            </div>

        </div>

        <!-- RIGHT -->
        <div class="pro-card">

            <div class="pro-card__header">
                <h2>Profile Information</h2>
            </div>

            <div class="pro-card__body">

                <div class="pro-row">
                    <div class="pro-field">
                        <label>Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="input" />
                    </div>

                    <div class="pro-field">
                        <label>Age</label>
                        <asp:TextBox ID="txtAge" runat="server" CssClass="input" TextMode="Number" />
                    </div>
                </div>

                <!-- PATIENT SECTION -->
                <div id="patientSection">

                    <div class="pro-row">
                        <div class="pro-field">
                            <label>Height (cm)</label>
                            <asp:TextBox ID="txtHeight" runat="server" CssClass="input" TextMode="Number" />
                        </div>

                        <div class="pro-field">
                            <label>Weight (kg)</label>
                            <asp:TextBox ID="txtWeight" runat="server" CssClass="input" TextMode="Number" />
                        </div>
                    </div>

                    <div class="pro-field">
                        <label>Disability</label>
                        <asp:TextBox ID="txtDisability" runat="server" CssClass="input" />
                    </div>

                    <div class="pro-field">
                        <label>Chronic Disease</label>
                        <asp:TextBox ID="txtDisease" runat="server" CssClass="input" />
                    </div>

                    <div class="pro-field">
                        <label>Family History</label>
                        <asp:TextBox ID="txtFamilyHistory" runat="server" CssClass="input" TextMode="MultiLine" />
                    </div>

                </div><%-- end patientSection --%>

            </div><%-- end pro-card__body --%>

        </div><%-- end pro-card RIGHT --%>

    </div><%-- end pro-grid --%>

    <!-- ACTIONS -->
    <div class="pro-actions">

        <button type="button"
                class="pro-btn pro-btn--primary"
                onclick="saveProfile()">
            <i class="fa-solid fa-floppy-disk"></i>
            Save Changes
        </button>

        <button type="button"
                class="pro-btn pro-btn--gray"
                onclick="resetProfile()">
            <i class="fa-solid fa-rotate-left"></i>
            Reset
        </button>

    </div>

    <!-- MESSAGE -->
    <div id="profileMsg"
         class="pro-msg"
         style="display:none;">
    </div>

</div><%-- end pro-root --%>

<script src="/js/profile.js"></script>

</asp:Content><%--  --%>