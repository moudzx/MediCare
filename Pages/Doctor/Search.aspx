<%@ Page Title="Search – MediCare" 
    Language="C#" 
    MasterPageFile="~/MasterPage/DoctorSite.Master" 
    AutoEventWireup="true" 
    CodeBehind="Search.aspx.cs" 
    Inherits="MediCare.Pages.Doctor.Search" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/DcSearch.css" />
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
                    Search across medicines and foods
                </p>
            </div>
        </div>
    </div>

    <!-- SEARCH BAR -->
    <div class="sea-toolbar">
        <div class="sea-search-panel">

            <div class="sea-search-field">
                <label class="sea-label" for="ddlSearchScope">
                    Search scope
                </label>
                <asp:DropDownList ID="ddlSearchScope" runat="server" CssClass="sea-select">
                    <asp:ListItem Value="all" Text="Search everything" />
                    <asp:ListItem Value="medicines" Text="Medicines" />
                    <asp:ListItem Value="foods" Text="Foods" />
                </asp:DropDownList>
            </div>

            <div class="sea-search-field sea-search-field--grow">
                <label class="sea-label" for="txtSearchQuery">
                    Search text
                </label>
                <div class="sea-search-input-wrap">
                    <i class="fa-solid fa-magnifying-glass sea-search-icon"></i>
                    <asp:TextBox ID="txtSearchQuery" runat="server"
                        CssClass="sea-search-input"
                        placeholder="Type a name, description, or food..." />
                </div>
            </div>

            <div class="sea-search-field sea-search-field--btn">
                <label class="sea-label sea-label--ghost">.</label>
                <asp:Button ID="btnSearch" runat="server"
                    CssClass="sea-btn sea-btn--primary"
                    Text="Search"
                    OnClick="btnSearch_Click" />
            </div>

        </div>
    </div>

    <!-- Message -->
    <asp:Panel ID="pnlMessage" runat="server" CssClass="sea-inline-msg" Visible="false">
        <asp:Label ID="lblMessage" runat="server" />
    </asp:Panel>

    <div class="sea-results-grid">

        <!-- MEDICINES -->
        <div class="sea-card" id="cardMedicines" runat="server">
            <div class="sea-card__header">
                <div>
                    <h2 class="sea-card__title">Medicines</h2>
                    <p class="sea-card__subtitle">
                        Find medicine names and descriptions
                    </p>
                </div>
            </div>
            <div class="sea-table-wrap">
                <asp:GridView ID="gvMedicines" runat="server"
                    CssClass="sea-grid"
                    AutoGenerateColumns="False"
                    ShowHeader="True"
                    GridLines="None"
                    EmptyDataText="No medicines found."
                    OnRowCommand="gvMedicines_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="name" HeaderText="Name" />
                        <asp:BoundField DataField="ingredients" HeaderText="Description" />
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
                                    CommandName="AddMedicine"
                                    CommandArgument='<%# Eval("id") %>' />
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
                    <h2 class="sea-card__title">Foods</h2>
                    <p class="sea-card__subtitle">
                        Find foods with nutrition facts
                    </p>
                </div>
            </div>
            <div class="sea-table-wrap">
                <asp:GridView ID="gvFoods" runat="server"
                    CssClass="sea-grid"
                    AutoGenerateColumns="False"
                    ShowHeader="True"
                    GridLines="None"
                    EmptyDataText="No foods found."
                    OnRowCommand="gvFoods_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="description" HeaderText="Name" />
                        <asp:BoundField DataField="calories" HeaderText="Calories" />
                        <asp:BoundField DataField="protein" HeaderText="Protein" />
                        <asp:BoundField DataField="carbohydrate" HeaderText="Carbs" />
                        <asp:BoundField DataField="total_fat" HeaderText="Fat" />
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button ID="btnAddFood" runat="server"
                                    Text="Add"
                                    CssClass="sea-btn sea-btn--small sea-btn--purple"
                                    CommandName="AddFood"
                                    CommandArgument='<%# Eval("id") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </div>
</div>

</asp:Content>