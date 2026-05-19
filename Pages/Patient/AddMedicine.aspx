<%@ Page Title="Add Medicine – MediCare" Language="C#" MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true" CodeBehind="AddMedicine.aspx.cs" Inherits="MediCare.Pages.Patient.AddMedicine" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/search.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="sea-root">

        <div class="sea-page-header">
            <div class="sea-page-header__left">
                <div class="sea-page-header__icon">
                    <i class="fa-solid fa-pills"></i>
                </div>
                <div>
                    <h1 class="sea-page-header__title">Add Medicine</h1>
                    <p class="sea-page-header__sub">
                        Setting schedule for
                        <asp:Label ID="lblMedicineName" runat="server" Font-Bold="true" />
                    </p>
                </div>
            </div>
        </div>

        <div class="sea-card">
            <div class="sea-card__header">
                <h2 class="sea-card__title">Schedule Details</h2>
            </div>
            <div class="sea-card__body" style="padding: 24px;">

                <asp:Label ID="lblMessage" runat="server" CssClass="sea-inline-msg" Visible="false" />

                <div class="med-grid">
                    <div class="med-field">
                        <label class="med-label">Start Date</label>
                        <asp:TextBox ID="txtStartDate" runat="server" CssClass="med-input" TextMode="Date" />
                    </div>
                    <div class="med-field">
                        <label class="med-label">End Date</label>
                        <asp:TextBox ID="txtEndDate" runat="server" CssClass="med-input" TextMode="Date" />
                    </div>
                </div>

                <div class="med-grid">
                    <div class="med-field">
                        <label class="med-label">Frequency</label>
                        <asp:DropDownList ID="ddlFrequency" runat="server" CssClass="med-input">
                            <asp:ListItem Text="Once Daily" Value="1" />
                            <asp:ListItem Text="Twice Daily" Value="2" />
                            <asp:ListItem Text="3 Times Daily" Value="3" />
                            <asp:ListItem Text="Every 6 Hours" Value="6" />
                            <asp:ListItem Text="Every 8 Hours" Value="8" />
                            <asp:ListItem Text="Weekly" Value="7" />
                        </asp:DropDownList>
                    </div>
                    <div class="med-field">
                        <label class="med-label">Pills Count</label>
                        <asp:TextBox ID="txtPillsCount" runat="server" CssClass="med-input" TextMode="Number" />
                    </div>
                </div>

                <div class="med-grid">
                    <div class="med-field">
                        <label class="med-label">Time</label>
                        <asp:TextBox ID="txtTime" runat="server" CssClass="med-input" TextMode="Time" />
                    </div>
                    <div class="med-field">
                        <label class="med-label">Meal Relation</label>
                        <asp:DropDownList ID="ddlMealRelation" runat="server" CssClass="med-input">
                            <asp:ListItem Text="Before Meal" Value="before" />
                            <asp:ListItem Text="After Meal" Value="after" />
                            <asp:ListItem Text="With Meal" Value="with" />
                            <asp:ListItem Text="Any Time" Value="any" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="med-check">
                    <asp:CheckBox ID="chkReminder" runat="server" />
                    <label for="<%= chkReminder.ClientID %>">Enable reminders</label>
                </div>

                <div style="margin-top: 24px; display: flex; gap: 12px; justify-content: flex-end;">
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                        CssClass="sea-btn sea-btn--gray" OnClick="btnCancel_Click" />
                    <asp:Button ID="btnSave" runat="server" Text="Save Medicine"
                        CssClass="sea-btn sea-btn--green" OnClick="btnSave_Click" />
                </div>

            </div>
        </div>
    </div>
</asp:Content>