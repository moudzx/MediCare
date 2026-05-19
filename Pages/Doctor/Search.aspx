<%-- Search.aspx --%>
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

    <div class="sea-toolbar">
        <div class="sea-search-panel">

            <div class="sea-search-field">
                <label class="sea-label" for="<%= ddlSearchScope.ClientID %>">
                    Search scope
                </label>
                <asp:DropDownList ID="ddlSearchScope" runat="server" CssClass="sea-select">
                    <asp:ListItem Value="all" Text="Search everything" />
                    <asp:ListItem Value="medicines" Text="Medicines" />
                    <asp:ListItem Value="foods" Text="Foods" />
                </asp:DropDownList>
            </div>

            <div class="sea-search-field sea-search-field--grow">
                <label class="sea-label" for="<%= txtSearchQuery.ClientID %>">
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
                <span class="sea-label sea-label--ghost" style="visibility:hidden; display:block;">.</span>
                <asp:Button ID="btnSearch" runat="server"
                    CssClass="sea-btn sea-btn--primary"
                    Text="Search"
                    OnClick="btnSearch_Click" />
            </div>

        </div>
    </div>

    <asp:Panel ID="pnlMessage" runat="server" CssClass="sea-inline-msg" Visible="false">
        <asp:Label ID="lblMessage" runat="server" />
    </asp:Panel>

    <div class="sea-results-grid">

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
                    AllowPaging="True"
                    PageSize="10"
                    EmptyDataText="No medicines found."
                    OnPageIndexChanging="gvMedicines_PageIndexChanging">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" />
                        <asp:BoundField DataField="atc" HeaderText="ATC Code" />
                        <asp:BoundField DataField="name" HeaderText="Name" />
                        <asp:BoundField DataField="b_g" HeaderText="B/G" />
                        <asp:BoundField DataField="ingredients" HeaderText="Ingredients" />
                        <asp:BoundField DataField="dosage" HeaderText="Dosage" />
                        <asp:BoundField DataField="form" HeaderText="Form" />
                        <asp:BoundField DataField="price" HeaderText="Price" />
                    </Columns>
                    <PagerStyle CssClass="sea-pager" />
                </asp:GridView>
            </div>
        </div>

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
                    AllowPaging="True"
                    PageSize="10"
                    EmptyDataText="No foods found."
                    OnPageIndexChanging="gvFoods_PageIndexChanging">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" />
                        <asp:BoundField DataField="description" HeaderText="Description" />
                        <asp:BoundField DataField="calories" HeaderText="Calories" />
                        <asp:BoundField DataField="protein" HeaderText="Protein (g)" />
                        <asp:BoundField DataField="total_fat" HeaderText="Total Fat (g)" />
                        <asp:BoundField DataField="carbohydrate" HeaderText="Carbs (g)" />
                        <asp:BoundField DataField="sodium" HeaderText="Sodium (mg)" />
                        <asp:BoundField DataField="saturated_fat" HeaderText="Saturated Fat (g)" />
                        <asp:BoundField DataField="cholesterol" HeaderText="Cholesterol (mg)" />
                        <asp:BoundField DataField="sugar" HeaderText="Sugar (g)" />
                        <asp:BoundField DataField="calcium" HeaderText="Calcium (mg)" />
                        <asp:BoundField DataField="iron" HeaderText="Iron (mg)" />
                        <asp:BoundField DataField="potassium" HeaderText="Potassium (mg)" />
                        <asp:BoundField DataField="vitamin_c" HeaderText="Vitamin C (mg)" />
                        <asp:BoundField DataField="vitamin_e" HeaderText="Vitamin E (mg)" />
                        <asp:BoundField DataField="vitamin_d" HeaderText="Vitamin D (mcg)" />
                    </Columns>
                    <PagerStyle CssClass="sea-pager" />
                </asp:GridView>
            </div>
        </div>

    </div>
</div>

</asp:Content>