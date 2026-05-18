<%@ Page Language="C#"
    AutoEventWireup="true"
    CodeBehind="FoodCatalog.aspx.cs"
    Inherits="MediCare.Pages.Admin.FoodCatalog" %>

<!DOCTYPE html>
<html lang="en">

<head runat="server">
    <meta charset="utf-8" />
    <title>Food Catalog</title>

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
            <div class="mc-navbar__logo-icon">
                <i class="fa-solid fa-staff-snake"></i>
            </div>
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
            <h1>Food & Nutrition</h1>
            <p>Manage food database</p>
        </div>

        <div>

            <asp:Button ID="btnOpenAddModal"
                runat="server"
                Text="Add Food Item"
                CssClass="mc-btn mc-btn--primary"
                OnClick="btnOpenAddModal_Click" />

        </div>

    </div>

    <!-- MESSAGE -->
    <asp:Label ID="lblMessage"
        runat="server"
        Visible="false" />

    <!-- TOOLBAR -->
    <div class="mc-toolbar">

        <div class="mc-input-wrap">

            <asp:TextBox ID="txtSearchFood"
                runat="server"
                CssClass="mc-input"
                AutoPostBack="true"
                OnTextChanged="txtSearchFood_TextChanged"
                placeholder="Search food..." />

        </div>

        <asp:DropDownList ID="ddlSortFood"
            runat="server"
            CssClass="mc-select"
            AutoPostBack="true"
            OnSelectedIndexChanged="ddlSortFood_SelectedIndexChanged">

            <asp:ListItem Value="">Sort By</asp:ListItem>
            <asp:ListItem Value="cal_desc">Highest Calories</asp:ListItem>
            <asp:ListItem Value="cal_asc">Lowest Calories</asp:ListItem>
            <asp:ListItem Value="protein">Highest Protein</asp:ListItem>

        </asp:DropDownList>

    </div>

    <!-- GRID -->
    <div class="mc-table-wrap">

        <asp:GridView ID="gvFood"
            runat="server"
            AutoGenerateColumns="False"
            CssClass="mc-table"
            GridLines="None"
            DataKeyNames="id"
            OnRowCommand="gvFood_RowCommand">

            <Columns>

                <asp:BoundField DataField="id" HeaderText="ID" />
                <asp:BoundField DataField="description" HeaderText="Description" />
                <asp:BoundField DataField="calories" HeaderText="Calories" />
                <asp:BoundField DataField="protein" HeaderText="Protein" />

                <asp:TemplateField HeaderText="Actions">

                    <ItemTemplate>

                        <div style="display:flex;gap:0.5rem;">

                            <asp:LinkButton ID="btnEdit"
                                runat="server"
                                Text="Edit"
                                CssClass="mc-btn mc-btn--success mc-btn--sm"
                                CommandName="EditFood"
                                CommandArgument='<%# Eval("id") %>'
                                OnClick="btnEdit_Click" />

                            <asp:LinkButton ID="btnDelete"
                                runat="server"
                                Text="Delete"
                                CssClass="mc-btn mc-btn--danger mc-btn--sm"
                                CommandName="DeleteFood"
                                CommandArgument='<%# Eval("id") %>'
                                OnClick="btnDelete_Click" />

                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

    <!-- MODAL -->
    <div class="mc-modal-overlay">

        <div class="mc-modal">

            <div class="mc-modal__header">
                <h4>Add Food Item</h4>
            </div>

            <div class="mc-form-row">
                <label>ID</label>
                <asp:TextBox ID="txtID" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Calories</label>
                <asp:TextBox ID="txtCalories" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Protein</label>
                <asp:TextBox ID="txtProtein" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Total Fat</label>
                <asp:TextBox ID="txtTotalFat" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Carbohydrate</label>
                <asp:TextBox ID="txtCarbohydrate" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Sodium</label>
                <asp:TextBox ID="txtSodium" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Saturated Fat</label>
                <asp:TextBox ID="txtSaturatedFat" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Cholesterol</label>
                <asp:TextBox ID="txtCholesterol" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Sugar</label>
                <asp:TextBox ID="txtSugar" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Calcium</label>
                <asp:TextBox ID="txtCalcium" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Iron</label>
                <asp:TextBox ID="txtIron" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Potassium</label>
                <asp:TextBox ID="txtPotassium" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Vitamin C</label>
                <asp:TextBox ID="txtVitaminC" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Vitamin E</label>
                <asp:TextBox ID="txtVitaminE" runat="server" CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Vitamin D</label>
                <asp:TextBox ID="txtVitaminD" runat="server" CssClass="mc-input" />
            </div>

            <!-- BUTTONS -->
            <div class="mc-form-actions">

                <asp:Button ID="btnCancelModal"
                    runat="server"
                    Text="Cancel"
                    CssClass="mc-btn mc-btn--outline"
                    OnClick="btnCancelModal_Click" />

                <asp:Button ID="btnAddFood"
                    runat="server"
                    Text="Add Item"
                    CssClass="mc-btn mc-btn--primary"
                    OnClick="btnAddFood_Click" />

            </div>

        </div>

    </div>

</form>

</body>
</html>