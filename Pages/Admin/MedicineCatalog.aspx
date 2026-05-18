<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="MedicineCatalog.aspx.cs"
    Inherits="MediCare.Pages.Admin.MedicineCatalog" %>

<!DOCTYPE html>
<html lang="en">

<head runat="server">
    <meta charset="utf-8" />
    <title>Medicine Catalog</title>

    <link rel="stylesheet" href="/css/def.css" />
    <link rel="stylesheet" href="/css/admin.css" />
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
</head>

<body class="mc-admin-body">

<form id="form1" runat="server">

    <!-- NAVBAR -->
    <nav class="mc-navbar">

        <a class="mc-navbar__logo" href="Dashboard.aspx">
            <i class="fa-solid fa-staff-snake"></i>
            MediCare
        </a>

        <ul class="mc-navbar__links">
            <li><a href="/Pages/Admin/Dashboard.aspx">Dashboard</a></li>
            <li><a href="/Pages/Admin/DoctorManagement.aspx">Doctors</a></li>
            <li><a href="/Pages/Admin/PatientManagement.aspx">Patients</a></li>
            <li><a href="/Pages/Admin/FoodCatalog.aspx">Food</a></li>
            <li><a href="/Pages/Admin/MedicineCatalog.aspx">Medicine</a></li>
        </ul>

        <div class="mc-navbar__actions">

            <asp:Button ID="btnHamburger"
                runat="server"
                Text="☰"
                CssClass="mc-navbar__hamburger"
                OnClick="btnHamburger_Click" />

        </div>

    </nav>

    <!-- HEADER -->
    <div class="mc-page-header">

        <div>
            <h1>Medicine Catalog</h1>
            <p>Manage pharmaceutical database</p>
        </div>

        <asp:Button ID="btnOpenAddModal"
            runat="server"
            Text="Add Medicine"
            CssClass="mc-btn mc-btn--primary"
            OnClick="btnOpenAddModal_Click" />

    </div>

    <!-- MESSAGE -->
    <asp:Label ID="lblMessage" runat="server" Visible="false" />

    <!-- SEARCH -->
    <asp:TextBox ID="txtSearch"
        runat="server"
        CssClass="mc-input"
        AutoPostBack="true"
        OnTextChanged="txtSearch_TextChanged"
        placeholder="Search medicine..." />

    <!-- GRID -->
    <asp:GridView ID="gvMedicines"
        runat="server"
        AutoGenerateColumns="False"
        CssClass="mc-table"
        DataKeyNames="atc"
        OnRowCommand="gvMedicines_RowCommand">

        <Columns>

            <asp:BoundField DataField="atc" HeaderText="ATC Code" />
            <asp:BoundField DataField="name" HeaderText="Name" />
            <asp:BoundField DataField="b_g" HeaderText="BG" />
            <asp:BoundField DataField="ingredients" HeaderText="Ingredients" />
            <asp:BoundField DataField="dosage" HeaderText="Dosage" />
            <asp:BoundField DataField="form" HeaderText="Form" />
            <asp:BoundField DataField="price" HeaderText="Price" />

            <asp:TemplateField HeaderText="Actions">

                <ItemTemplate>

                    <asp:Button ID="btnEdit"
                        runat="server"
                        Text="Edit"
                        CssClass="mc-btn mc-btn--success mc-btn--sm"
                        CommandName="EditMed"
                        CommandArgument='<%# Eval("atc") %>'
                        OnClick="btnEdit_Click" />

                    <asp:Button ID="btnDelete"
                        runat="server"
                        Text="Delete"
                        CssClass="mc-btn mc-btn--danger mc-btn--sm"
                        CommandName="DeleteMed"
                        CommandArgument='<%# Eval("atc") %>'
                        OnClick="btnDelete_Click" />

                </ItemTemplate>

            </asp:TemplateField>

        </Columns>

    </asp:GridView>

    <!-- MODAL -->
    <div class="mc-modal-overlay" id="addMedModal">

        <div class="mc-modal">

            <h3>Add Medicine</h3>

            <asp:TextBox ID="txtATC" runat="server" CssClass="mc-input" placeholder="ATC Code" />
            <asp:TextBox ID="txtName" runat="server" CssClass="mc-input" placeholder="Name" />
            <asp:TextBox ID="txtBG" runat="server" CssClass="mc-input" placeholder="B/G" />
            <asp:TextBox ID="txtIngredients" runat="server" CssClass="mc-input" placeholder="Ingredients" />
            <asp:TextBox ID="txtDosage" runat="server" CssClass="mc-input" placeholder="Dosage" />
            <asp:TextBox ID="txtForm" runat="server" CssClass="mc-input" placeholder="Form" />
            <asp:TextBox ID="txtPrice" runat="server" CssClass="mc-input" placeholder="Price" />

            <asp:Button ID="btnAddMedicine"
                runat="server"
                Text="Add"
                CssClass="mc-btn mc-btn--primary"
                OnClick="btnAddMedicine_Click" />

            <asp:Button ID="btnCancelModal"
                runat="server"
                Text="Cancel"
                CssClass="mc-btn mc-btn--outline"
                OnClick="btnCancelModal_Click" />

        </div>

    </div>

</form>

</body>
</html>