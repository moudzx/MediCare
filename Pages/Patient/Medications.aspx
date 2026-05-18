<%@ Page Title="Medications – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="Medications.aspx.cs"
    Inherits="MediCare.Pages.Patient.Medications" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">

    <link rel="stylesheet" href="/css/medications.css" />
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

</asp:Content>

<asp:Content ID="PageContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="med-root">

        <!-- PAGE HEADER -->
        <div class="med-page-header">

            <div class="med-page-header__left">

                <div class="med-page-header__icon">
                    <i class="fa-solid fa-pills"></i>
                </div>

                <div>
                    <h1 class="med-page-header__title">
                        My Medications
                    </h1>

                    <p class="med-page-header__sub">
                        Manage your prescriptions and medications
                    </p>
                </div>

            </div>

        </div>

        <!-- MAIN GRID -->
        <div class="med-main-grid">

            <!-- =========================================
                 LEFT SIDE — MEDICATIONS TABLE
            ========================================== -->
            <div class="med-card">

                <!-- CARD HEADER -->
                <div class="med-card__header">

                    <div class="med-card__title-group">

                        <div class="med-card__icon med-card__icon--green">
                            <i class="fa-solid fa-clipboard-check"></i>
                        </div>

                        <div>
                            <h2 class="med-card__title">
                                My Medications
                            </h2>

                            <p class="med-card__subtitle">
                                Current treatment plan
                            </p>
                        </div>

                    </div>

                </div>

                <!-- SEARCH -->
                <div class="med-search-row">

                    <div class="med-search-wrap">

                        <i class="fa-solid fa-magnifying-glass med-search-icon"></i>

                        <asp:TextBox ID="txtSearchMedication"
                            runat="server"
                            CssClass="med-search-input"
                            placeholder="Search medication..." />

                    </div>

                    <asp:Button ID="btnSearchMedication"
                        runat="server"
                        Text="Search"
                        CssClass="med-btn med-btn--search"
                        OnClick="btnSearchMedication_Click" />

                </div>

                <!-- MESSAGE -->
                <asp:Label ID="lblMessage"
                    runat="server"
                    CssClass="med-inline-msg"
                    Visible="false" />

                <!-- TABLE -->
                <div class="med-table-wrap">

                    <asp:GridView ID="gvMedications"
                        runat="server"
                        AutoGenerateColumns="False"
                        CssClass="med-grid"
                        GridLines="None"
                        EmptyDataText="No medications found."
                        DataKeyNames="MedicationId">

                        <Columns>
                            <asp:TemplateField HeaderText="Medication">

                                <ItemTemplate>

                                    <div class="med-medication-cell">

                                        <div class="med-pill-dot"></div>

                                        <asp:Label ID="lblMedication"
                                            runat="server"
                                            CssClass="med-medication-name"
                                            Text='<%# Eval("MedicationName") %>' />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Dosage"
                                HeaderText="Dosage" />

                            <asp:BoundField DataField="Frequency"
                                HeaderText="Frequency" />

                            <asp:BoundField DataField="PillsNumber"
                                HeaderText="Pills" />

                            <asp:BoundField DataField="StartDate"
                                HeaderText="Start Date"
                                DataFormatString="{0:yyyy-MM-dd}" />

                            <asp:BoundField DataField="EndDate"
                                HeaderText="End Date"
                                DataFormatString="{0:yyyy-MM-dd}" />

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatus"
                                        runat="server"
                                        CssClass="med-status med-status--active"
                                        Text='<%# Eval("Status") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <div class="med-card__footer">
                    <a href="Search.aspx"
                        class="med-btn med-btn--primary">

                        <i class="fa-solid fa-plus"></i>
                        Add Medication
                    </a>
                </div>
            </div>

            <!-- =========================================
                 RIGHT SIDE — ADD CUSTOM MEDICATION
            ========================================== -->
            <div class="med-card">
                <!-- CARD HEADER -->
                <div class="med-card__header">

                    <div class="med-card__title-group">

                        <div class="med-card__icon med-card__icon--purple">
                            <i class="fa-solid fa-capsules"></i>
                        </div>

                        <div>
                            <h2 class="med-card__title">
                                Add Custom Medication
                            </h2>

                            <p class="med-card__subtitle">
                                Save a medication manually
                            </p>
                        </div>

                    </div>

                </div>

                <!-- FORM -->
                <div class="med-form-body">

                    <!-- Medication Name -->
                    <div class="med-form-group">

                        <label class="med-label">
                            Medication Name
                        </label>

                        <asp:TextBox ID="txtMedicationName"
                            runat="server"
                            CssClass="med-input" />

                    </div>

                    <!-- Dosage -->
                    <div class="med-form-group">

                        <label class="med-label">
                            Dosage
                        </label>

                        <asp:TextBox ID="txtDosage"
                            runat="server"
                            CssClass="med-input" />

                    </div>

                    <!-- Frequency -->
                    <div class="med-form-group">

                        <label class="med-label">
                            Frequency
                        </label>

                        <asp:DropDownList ID="ddlFrequency"
                            runat="server"
                            CssClass="med-input">

                            <asp:ListItem Text="Select frequency"
                                Value="" />

                            <asp:ListItem Text="Once Daily"
                                Value="Once Daily" />

                            <asp:ListItem Text="Twice Daily"
                                Value="Twice Daily" />

                            <asp:ListItem Text="Every 8 Hours"
                                Value="Every 8 Hours" />

                            <asp:ListItem Text="Weekly"
                                Value="Weekly" />

                        </asp:DropDownList>

                    </div>

                    <!-- Pill Count -->
                    <div class="med-form-group">

                        <label class="med-label">
                            Pill Count
                        </label>

                        <asp:TextBox ID="txtPills"
                            runat="server"
                            CssClass="med-input"
                            TextMode="Number" />

                    </div>

                    <!-- Start Date -->
                    <div class="med-form-group">

                        <label class="med-label">
                            Start Date
                        </label>

                        <asp:TextBox ID="txtStartDate"
                            runat="server"
                            CssClass="med-input"
                            TextMode="Date" />

                    </div>

                    <!-- End Date -->
                    <div class="med-form-group">

                        <label class="med-label">
                            End Date
                        </label>

                        <asp:TextBox ID="txtEndDate"
                            runat="server"
                            CssClass="med-input"
                            TextMode="Date" />

                    </div>

                    <!-- SAVE -->
                    <div class="med-form-footer">

                        <asp:Button ID="btnSaveMedication"
                            runat="server"
                            Text="Save Medication"
                            CssClass="med-btn med-btn--save"
                            OnClick="btnSaveMedication_Click" />

                    </div>

                </div>

            </div>

        </div>

    </div>

</asp:Content>