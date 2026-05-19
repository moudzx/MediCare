<%@ Page Title="Manage Medication – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="ManageMedication.aspx.cs"
    Inherits="MediCare.Pages.Doctor.ManageMedication" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">

    <link rel="stylesheet" href="/css/ManageMedication.css" />

    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

</asp:Content>

<asp:Content ID="PageContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <!-- ROOT -->
    <div class="mm-root">

        <!-- HEADER -->
        <div class="mm-page-header">

            <div class="mm-page-header__left">

                <div class="mm-page-header__icon">
                    <i class="fa-solid fa-pills"></i>
                </div>

                <div>

                    <h1 class="mm-page-header__title">
                        Manage Medication
                    </h1>

                    <p class="mm-page-header__sub">

                        Patient:

                        <strong>
                            <asp:Label ID="lblPatientName"
                                runat="server"
                                Text="Patient Name" />
                        </strong>

                        &nbsp;•&nbsp;

                        <asp:Label ID="lblPatientInfo"
                            runat="server"
                            Text="Gender • Blood Type" />

                    </p>

                </div>

            </div>

            <div class="mm-page-header__right">

                <div class="mm-header-stat">

                    <asp:Label ID="lblTotalMeds"
                        runat="server"
                        CssClass="mm-header-stat__num"
                        Text="0" />

                    <span class="mm-header-stat__label">
                        Total Meds
                    </span>

                </div>

                <div class="mm-header-stat">

                    <asp:Label ID="lblActiveMeds"
                        runat="server"
                        CssClass="mm-header-stat__num"
                        Text="0" />

                    <span class="mm-header-stat__label">
                        Active
                    </span>

                </div>

                <div class="mm-header-stat">

                    <asp:Label ID="lblCompletedMeds"
                        runat="server"
                        CssClass="mm-header-stat__num"
                        Text="0" />

                    <span class="mm-header-stat__label">
                        Completed
                    </span>

                </div>

                <asp:Button ID="btnOpenAddModal"
                    runat="server"
                    Text="Add Medication"
                    CssClass="mm-btn mm-btn--primary"
                    OnClick="btnOpenAddModal_Click" />

            </div>

        </div>

        <!-- TOOLBAR -->
        <div class="mm-toolbar">

            <!-- SEARCH -->
            <div class="mm-search-wrap">

                <i class="fa-solid fa-magnifying-glass mm-search-icon"></i>

                <asp:TextBox ID="txtSearch"
                    runat="server"
                    CssClass="mm-search-input"
                    placeholder="Search medications..."
                    AutoPostBack="true"
                    OnTextChanged="txtSearch_TextChanged" />

            </div>

            <!-- FILTER -->
            <div class="mm-toolbar__filters">

                <asp:DropDownList ID="ddlStatus"
                    runat="server"
                    CssClass="mm-input mm-select"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">

                    <asp:ListItem Value="">
                        All
                    </asp:ListItem>

                    <asp:ListItem Value="Active">
                        Active
                    </asp:ListItem>

                    <asp:ListItem Value="Completed">
                        Completed
                    </asp:ListItem>

                    <asp:ListItem Value="Stopped">
                        Stopped
                    </asp:ListItem>

                </asp:DropDownList>

                <asp:Button ID="btnClearSearch"
                    runat="server"
                    Text="Clear"
                    CssClass="mm-btn mm-btn--ghost"
                    OnClick="btnClearSearch_Click" />

            </div>

        </div>

        <!-- CARD -->
        <div class="mm-card">

            <!-- CARD HEADER -->
            <div class="mm-card__header">

                <div class="mm-card__title-group">

                    <i class="fa-solid fa-clipboard-list mm-card__hdr-icon"></i>

                    <div>

                        <h2 class="mm-card__title">
                            Current Medications
                        </h2>

                        <p class="mm-card__sub">
                            Prescribed medications for this patient
                        </p>

                    </div>

                </div>

                <asp:Label ID="lblMedicationCount"
                    runat="server"
                    CssClass="mm-count-badge"
                    Text="0 medication(s)" />

            </div>

            <!-- TABLE -->
            <div class="mm-table-wrap">

                <table class="mm-table">

                    <thead>

                        <tr class="mm-table__head">

                            <th>
                                <i class="fa-solid fa-pills"></i>
                                Medication
                            </th>

                            <th>
                                <i class="fa-solid fa-weight-scale"></i>
                                Dosage
                            </th>

                            <th>
                                <i class="fa-solid fa-clock"></i>
                                Frequency
                            </th>

                            <th>
                                <i class="fa-solid fa-calendar-days"></i>
                                Duration
                            </th>

                            <th>
                                Status
                            </th>

                            <th>
                                Actions
                            </th>

                        </tr>

                    </thead>

                    <tbody>

                        <asp:Repeater ID="rptMedications"
                            runat="server"
                            OnItemCommand="rptMedications_ItemCommand">

                            <ItemTemplate>

                                <tr>
                                    <td>
                                        <strong>
                                            <%# Eval("MedicineId") %>
                                        </strong>
                                    </td>
                                    <td>
                                        <%# Eval("Dosage") %>
                                    </td>
                                    <td>
                                        <%# Eval("Frequency") %>
                                    </td>
                                    <td>
                                        <%# Eval("Duration") %>
                                    </td>
                                    <td>
                                        <span class='mm-status mm-status--<%# Eval("Status").ToString().ToLower() %>'>
                                            <%# Eval("Status") %>
                                        </span>
                                    </td>
                                    <td class="mm-actions">

                                        <asp:LinkButton ID="btnComplete"
                                            runat="server"
                                            CssClass="mm-btn mm-btn--sm mm-btn--green"
                                            CommandName="CompleteMedication"
                                            CommandArgument='<%# Eval("PatientMedicationId") %>'>

                                            Complete

                                        </asp:LinkButton>

                                        <asp:LinkButton ID="btnStop"
                                            runat="server"
                                            CssClass="mm-btn mm-btn--sm mm-btn--orange"
                                            CommandName="StopMedication"
                                            CommandArgument='<%# Eval("PatientMedicationId") %>'>

                                            Stop

                                        </asp:LinkButton>

                                        <asp:LinkButton ID="btnDelete"
                                            runat="server"
                                            CssClass="mm-btn mm-btn--sm mm-btn--danger"
                                            CommandName="DeleteMedication"
                                            CommandArgument='<%# Eval("PatientMedicationId") %>'
                                            OnClientClick="return confirm('Delete medication?');">

                                            Delete

                                        </asp:LinkButton>

                                    </td>

                                </tr>

                            </ItemTemplate>

                        </asp:Repeater>

                    </tbody>

                </table>

                <!-- EMPTY -->
                <asp:Panel ID="pnlEmpty"
                    runat="server"
                    CssClass="mm-empty"
                    Visible="false">

                    <div class="mm-empty__icon">
                        <i class="fa-solid fa-pills"></i>
                    </div>

                    <p class="mm-empty__text">
                        No medications found.
                    </p>

                    <p class="mm-empty__sub">
                        Add a medication to begin.
                    </p>

                </asp:Panel>

            </div>

        </div>

    </div>

    <!-- ADD MODAL -->
    <asp:Panel ID="pnlAddModal"
    runat="server"
    CssClass="mm-modal-overlay">


        <div class="mm-modal">

            <!-- HEADER -->
            <div class="mm-modal__header">

                <div class="mm-modal__title-group">

                    <div class="mm-modal__icon mm-modal__icon--blue">
                        <i class="fa-solid fa-plus"></i>
                    </div>

                    <div>

                        <h3 class="mm-modal__title">
                            Add Medication
                        </h3>

                        <p class="mm-modal__sub">
                            Create a medication prescription
                        </p>

                    </div>

                </div>

                <asp:Button ID="btnCloseModal"
                    runat="server"
                    Text="X"
                    CssClass="mm-modal__close"
                    OnClick="btnCloseModal_Click"
                    CausesValidation="false" />

            </div>

            <!-- BODY -->
            <div class="mm-modal__body">

                <div class="mm-form-grid">

                    <!-- MEDICINE -->
                    <div class="mm-form-group mm-form-group--full">

                        <label class="mm-label">
                            Medication
                        </label>

                        <asp:DropDownList ID="ddlMedicine"
                            runat="server"
                            CssClass="mm-input mm-select" />

                    </div>

                    <!-- DOSAGE -->
                    <div class="mm-form-group">

                        <label class="mm-label">
                            Dosage
                        </label>

                        <asp:TextBox ID="txtDosage"
                            runat="server"
                            CssClass="mm-input"
                            placeholder="e.g. 500mg" />

                    </div>

                    <!-- FREQUENCY -->
                    <div class="mm-form-group">

                        <label class="mm-label">
                            Frequency
                        </label>

                        <asp:DropDownList ID="ddlFrequency"
                            runat="server"
                            CssClass="mm-input mm-select">

                            <asp:ListItem Value="">
                                Select Frequency
                            </asp:ListItem>

                            <asp:ListItem>
                                Once daily
                            </asp:ListItem>

                            <asp:ListItem>
                                Twice daily
                            </asp:ListItem>

                            <asp:ListItem>
                                Three times daily
                            </asp:ListItem>

                            <asp:ListItem>
                                Every 8 hours
                            </asp:ListItem>

                            <asp:ListItem>
                                Every 12 hours
                            </asp:ListItem>

                        </asp:DropDownList>

                    </div>

                    <!-- DURATION -->
                    <div class="mm-form-group">

                        <label class="mm-label">
                            Duration
                        </label>

                        <asp:TextBox ID="txtDuration"
                            runat="server"
                            CssClass="mm-input"
                            placeholder="e.g. 7 days" />

                    </div>

                    <!-- STATUS -->
                    <div class="mm-form-group">

                        <label class="mm-label">
                            Status
                        </label>

                        <asp:DropDownList ID="ddlMedicationStatus"
                            runat="server"
                            CssClass="mm-input mm-select">

                            <asp:ListItem Value="Active">
                                Active
                            </asp:ListItem>

                            <asp:ListItem Value="Completed">
                                Completed
                            </asp:ListItem>

                            <asp:ListItem Value="Stopped">
                                Stopped
                            </asp:ListItem>

                        </asp:DropDownList>

                    </div>

                    <!-- START DATE -->
                    <div class="mm-form-group">

                        <label class="mm-label">
                            Start Date
                        </label>

                        <asp:TextBox ID="txtStartDate"
                            runat="server"
                            CssClass="mm-input"
                            TextMode="Date" />

                    </div>

                    <!-- END DATE -->
                    <div class="mm-form-group">

                        <label class="mm-label">
                            End Date
                        </label>

                        <asp:TextBox ID="txtEndDate"
                            runat="server"
                            CssClass="mm-input"
                            TextMode="Date" />

                    </div>

                </div>
                <asp:Label ID="lblError"
    runat="server"
    CssClass="mm-error"
    Visible="false"
    ForeColor="Red" />
            </div>

            <!-- FOOTER -->
            <div class="mm-modal__footer">

                <asp:Button ID="btnCancelMedication"
                    runat="server"
                    Text="Cancel"
                    CssClass="mm-btn mm-btn--ghost"
                    OnClick="btnCloseModal_Click"
                    CausesValidation="false" />

                <asp:Button ID="btnSaveMedication"
                    runat="server"
                    Text="Save Medication"
                    CssClass="mm-btn mm-btn--primary"
                    OnClick="btnSaveMedication_Click" />

            </div>

        </div>

    </asp:Panel>

</asp:Content>