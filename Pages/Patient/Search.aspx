<%@ Page Title="Search – MediCare" Language="C#" MasterPageFile="~/MasterPage/PatientSite.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="MediCare.Pages.Patient.Search" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/search.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="sea-root">

        <!-- HEADER -->
        <div class="sea-page-header">
            <div class="sea-page-header__left">
                <div class="sea-page-header__icon">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </div>
                <div>
                    <h1 class="sea-page-header__title">Search</h1>
                    <p class="sea-page-header__sub">Search across doctors, medicines, and foods</p>
                </div>
            </div>
        </div>

        <!-- SEARCH BAR -->
        <div class="sea-toolbar">
            <div class="sea-search-panel">
                <div class="sea-search-field">
                    <label class="sea-label" for="ddlSearchScope">Search scope</label>
                    <select id="ddlSearchScope" class="sea-select">
                        <option value="all">Search everything</option>
                        <option value="doctors">Doctors</option>
                        <option value="medicines">Medicines</option>
                        <option value="foods">Foods</option>
                    </select>
                </div>

                <div class="sea-search-field sea-search-field--grow">
                    <label class="sea-label" for="txtSearchQuery">Search text</label>
                    <div class="sea-search-input-wrap">
                        <i class="fa-solid fa-magnifying-glass sea-search-icon"></i>
                        <input type="text" id="txtSearchQuery" class="sea-search-input" placeholder="Type a name, specialization, description, or food..." />
                    </div>
                </div>

                <div class="sea-search-field sea-search-field--btn">
                    <label class="sea-label sea-label--ghost"> </label>
                    <button type="button" class="sea-btn sea-btn--primary" onclick="performSearch()">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        Search
                    </button>
                </div>
            </div>
        </div>

        <div id="searchMsg" class="sea-inline-msg" style="display:none;"></div>

        <div class="sea-results-grid">

            <!-- DOCTORS -->
            <div class="sea-card" id="cardDoctors">
                <div class="sea-card__header">
                    <div>
                        <h2 class="sea-card__title">Doctors</h2>
                        <p class="sea-card__subtitle">Find doctors by name or specialization</p>
                    </div>
                </div>

                <div class="sea-table-wrap">
                    <asp:GridView ID="gvDoctors" runat="server"
                        CssClass="sea-grid"
                        AutoGenerateColumns="False"
                        ShowHeader="True"
                        GridLines="None"
                        EmptyDataText="No doctors found. Try a different search term.">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Name" />
                            <asp:BoundField DataField="Specialization" HeaderText="Specialization" />
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:Button ID="btnRequestApproval" runat="server"
                                        Text="Request Approval"
                                        CssClass="sea-btn sea-btn--small sea-btn--blue"
                                        CommandName="RequestApproval"
                                        CommandArgument='<%# Eval("Id") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- MEDICINES -->
            <div class="sea-card" id="cardMedicines">
                <div class="sea-card__header">
                    <div>
                        <h2 class="sea-card__title">Medicines</h2>
                        <p class="sea-card__subtitle">Find medicine names and descriptions</p>
                    </div>
                </div>

                <div class="sea-table-wrap">
                    <asp:GridView ID="gvMedicines" runat="server"
                        CssClass="sea-grid"
                        AutoGenerateColumns="False"
                        ShowHeader="True"
                        GridLines="None"
                        OnRowCommand="gvMedicines_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Name" />
                            <asp:BoundField DataField="Description" HeaderText="Description" />
                            <asp:TemplateField HeaderText="Pills">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtPillCount" runat="server"
                                        CssClass="pill-input"
                                        TextMode="Number"
                                        Width="60px" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:Button ID="btnAddMedicine" runat="server"
                                        Text="Add"
                                        CssClass="sea-btn sea-btn--small sea-btn--green"
                                        CommandName="OpenMedicineModal"
                                        CommandArgument='<%# Eval("Id") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

            <!-- FOODS -->
            <div class="sea-card" id="cardFoods">
                <div class="sea-card__header">
                    <div>
                        <h2 class="sea-card__title">Foods</h2>
                        <p class="sea-card__subtitle">Find foods with nutrition facts</p>
                    </div>
                </div>

                <div class="sea-table-wrap">
                    <asp:GridView ID="gvFoods" runat="server"
                        CssClass="sea-grid"
                        AutoGenerateColumns="False"
                        ShowHeader="True"
                        GridLines="None"
                        EmptyDataText="No foods found. Try a different search term.">
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="Name" />
                            <asp:BoundField DataField="Calories" HeaderText="Calories" />
                            <asp:BoundField DataField="Protein" HeaderText="Protein" />
                            <asp:BoundField DataField="Carbs" HeaderText="Carbs" />
                            <asp:BoundField DataField="Fiber" HeaderText="Fiber" />
                            <asp:BoundField DataField="Fat" HeaderText="Fat" />
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:Button ID="btnAddFood" runat="server"
                                        Text="Add"
                                        CssClass="sea-btn sea-btn--small sea-btn--purple"
                                        CommandName="AddFood"
                                        CommandArgument='<%# Eval("Id") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

        </div>
    </div>

    <!-- =========================================
         MEDICINE MODAL
    ========================================= -->

    <asp:Panel ID="pnlMedicineModal"
        runat="server"
        CssClass="med-modal-overlay"
        Visible="true">

        <div class="med-modal">

            <!-- HEADER -->
            <div class="med-modal__header">
                <div>
                    <h2 class="med-modal__title">Add Medicine</h2>
                    <p class="med-modal__sub">Configure medication schedule</p>
                </div>

                <asp:Button ID="btnCloseModal"
                    runat="server"
                    Text="✕"
                    CssClass="med-close-btn"
                    OnClick="btnCloseModal_Click" />
            </div>

            <!-- BODY -->
            <div class="med-modal__body">

                <div class="med-grid">
                    <div class="med-field">
                        <label class="med-label">Start Date</label>
                        <asp:TextBox ID="txtStartDate"
                            runat="server"
                            CssClass="med-input"
                            TextMode="Date" />
                    </div>

                    <div class="med-field">
                        <label class="med-label">End Date</label>
                        <asp:TextBox ID="txtEndDate"
                            runat="server"
                            CssClass="med-input"
                            TextMode="Date" />
                    </div>
                </div>

                <div class="med-grid">
                    <div class="med-field">
                        <label class="med-label">Frequency</label>
                        <asp:DropDownList ID="ddlFrequency"
                            runat="server"
                            CssClass="med-input">
                            <asp:ListItem Text="Once Daily" />
                            <asp:ListItem Text="Twice Daily" />
                            <asp:ListItem Text="3 Times Daily" />
                            <asp:ListItem Text="Every 6 Hours" />
                            <asp:ListItem Text="Every 8 Hours" />
                            <asp:ListItem Text="Weekly" />
                        </asp:DropDownList>
                    </div>

                    <div class="med-field">
                        <label class="med-label">Pills Count</label>
                        <asp:TextBox ID="txtPillsCount"
                            runat="server"
                            CssClass="med-input"
                            TextMode="Number" />
                    </div>
                </div>

                <div class="med-grid">
                    <div class="med-field">
                        <label class="med-label">Time</label>
                        <asp:TextBox ID="txtTime"
                            runat="server"
                            CssClass="med-input"
                            TextMode="Time" />
                    </div>

                    <div class="med-field">
                        <label class="med-label">Meal Relation</label>
                        <asp:DropDownList ID="ddlMealRelation"
                            runat="server"
                            CssClass="med-input">
                            <asp:ListItem Text="Before Meal" />
                            <asp:ListItem Text="After Meal" />
                            <asp:ListItem Text="With Meal" />
                            <asp:ListItem Text="Any Time" />
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="med-check">
                    <asp:CheckBox ID="chkReminder" runat="server" />
                    <span>Enable reminders</span>
                </div>

            </div>

            <!-- FOOTER -->
            <div class="med-modal__footer">
                <asp:Button ID="btnCancelMedicine"
                    runat="server"
                    Text="Cancel"
                    CssClass="sea-btn sea-btn--gray"
                    OnClick="btnCloseModal_Click" />

                <asp:Button ID="btnSaveMedicine"
                    runat="server"
                    Text="Save Medicine"
                    CssClass="sea-btn sea-btn--green"
                    OnClick="btnSaveMedicine_Click" />
            </div>

        </div>
    </asp:Panel>

    <script src="/js/search.js"></script>

</asp:Content>