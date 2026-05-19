<%@ Page Title="Search – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="Search.aspx.cs"
    Inherits="MediCare.Pages.Patient.Search" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/search.css" />
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
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

                <p class="sea-page-header__sub">
                    Search across doctors, medicines, and foods
                </p>
            </div>
        </div>
    </div>

    <!-- SEARCH -->
    <div class="sea-toolbar">

        <div class="sea-search-panel">

            <div class="sea-search-field">

                <label class="sea-label">
                    Search scope
                </label>

                <asp:DropDownList ID="ddlSearchScope"
                    runat="server"
                    CssClass="sea-select"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="ddlSearchScope_SelectedIndexChanged">

                    <asp:ListItem Value="all">Search everything</asp:ListItem>
                    <asp:ListItem Value="doctors">Doctors</asp:ListItem>
                    <asp:ListItem Value="medicines">Medicines</asp:ListItem>
                    <asp:ListItem Value="foods">Foods</asp:ListItem>

                </asp:DropDownList>

            </div>

            <div class="sea-search-field sea-search-field--grow">

                <label class="sea-label">
                    Search text
                </label>

                <div class="sea-search-input-wrap">

                    <i class="fa-solid fa-magnifying-glass sea-search-icon"></i>

                    <asp:TextBox ID="txtSearchQuery"
                        runat="server"
                        CssClass="sea-search-input"
                        placeholder="Type a name, specialization, description...">
                    </asp:TextBox>

                </div>

            </div>

            <div class="sea-search-field sea-search-field--btn">

                <label class="sea-label sea-label--ghost">
                    &nbsp;
                </label>

                <asp:Button ID="btnSearch"
                    runat="server"
                    Text="Search"
                    CssClass="sea-btn sea-btn--primary"
                    OnClick="btnSearch_Click" />

            </div>

        </div>

    </div>

    <!-- MESSAGE -->
    <asp:Label ID="lblSearchMsg"
        runat="server"
        CssClass="sea-inline-msg"
        Visible="false" />

    <div class="sea-results-grid">

        <!-- DOCTORS -->
        <div class="sea-card" id="cardDoctors" runat="server">

            <div class="sea-card__header">

                <div>
                    <h2 class="sea-card__title">
                        Doctors
                    </h2>

                    <p class="sea-card__subtitle">
                        Find doctors by name or specialization
                    </p>
                </div>

            </div>

            <div class="sea-table-wrap">

                <asp:GridView ID="gvDoctors"
                    runat="server"
                    CssClass="sea-grid"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    EmptyDataText="No doctors found."
                    AllowPaging="true"
                    PageSize="10"
                    OnPageIndexChanging="gvDoctors_PageIndexChanging"
                    OnRowCommand="gvDoctors_RowCommand"
                    DataKeyNames="DoctorId">

                    <Columns>

                        <asp:BoundField DataField="Name"
                            HeaderText="Name" />

                        <asp:BoundField DataField="Specialization"
                            HeaderText="Specialization" />

                        <asp:BoundField DataField="ConnectionStatus"
                            HeaderText="Status" />

                        <asp:TemplateField HeaderText="Actions">

                            <ItemTemplate>

                                <div class="sea-actions-cell">

<asp:Button ID="btnConnect"
    runat="server"
    Text="Connect"
    CssClass="sea-btn sea-btn--small sea-btn--blue"
    CommandName='<%# Eval("ConnectionStatus").ToString() == "Pending" ? "UndoConnect" : "ConnectDoctor" %>'
    CommandArgument='<%# Eval("DoctorId") %>' />

                                </div>

                            </ItemTemplate>

                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

        </div>

        <!-- MEDICINES -->
        <div class="sea-card" id="cardMedicines" runat="server">

            <div class="sea-card__header">

                <div>

                    <h2 class="sea-card__title">
                        Medicines
                    </h2>

                    <p class="sea-card__subtitle">
                        Find medicine names and descriptions
                    </p>

                </div>

            </div>

            <div class="sea-table-wrap">

                <asp:GridView ID="gvMedicines"
                    runat="server"
                    CssClass="sea-grid"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    EmptyDataText="No medicines found."
                    AllowPaging="true"
                    PageSize="10"
                    OnPageIndexChanging="gvMedicines_PageIndexChanging">

                    <Columns>

                        <asp:BoundField DataField="Name"
                            HeaderText="Name" />

                        <asp:BoundField DataField="Description"
                            HeaderText="Description" />

                        <asp:TemplateField HeaderText="">

                            <ItemTemplate>

                                <a href='AddMedicine.aspx?medicineId=<%# Eval("Id") %>'
                                   class="sea-btn sea-btn--small sea-btn--green">
                                    Add
                                </a>

                            </ItemTemplate>

                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>

        </div>

        <!-- FOODS -->
        <div class="sea-card" id="cardFoods" runat="server">

            <div class="sea-card__header">

                <div>

                    <h2 class="sea-card__title">
                        Foods
                    </h2>

                    <p class="sea-card__subtitle">
                        Find foods with nutrition facts
                    </p>

                </div>

            </div>

            <div class="sea-table-wrap">

                <asp:GridView ID="gvFoods"
                    runat="server"
                    CssClass="sea-grid"
                    AutoGenerateColumns="False"
                    GridLines="None"
                    EmptyDataText="No foods found."
                    AllowPaging="true"
                    PageSize="10"
                    OnPageIndexChanging="gvFoods_PageIndexChanging">

                    <Columns>

                        <asp:BoundField DataField="Name"
                            HeaderText="Name" />

                        <asp:BoundField DataField="Calories"
                            HeaderText="Calories" />

                        <asp:BoundField DataField="Protein"
                            HeaderText="Protein" />

                        <asp:BoundField DataField="Carbs"
                            HeaderText="Carbs" />

                        <asp:BoundField DataField="Fat"
                            HeaderText="Fat" />

                    </Columns>

                </asp:GridView>

            </div>

        </div>

    </div>

</div>

</asp:Content>