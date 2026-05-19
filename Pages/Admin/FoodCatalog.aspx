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

    </nav>

    <!-- HEADER -->
    <div class="mc-page-header">

        <div>
            <h1>Food Catalog</h1>
            <p>Manage food database</p>
        </div>

        <asp:Button ID="btnOpenAddModal"
            runat="server"
            Text="Add New Item"
            CssClass="mc-btn mc-btn--primary"
            OnClick="btnOpenAddModal_Click" />

    </div>

    <!-- MESSAGE -->
    <asp:Label ID="lblMessage"
        runat="server"
        Visible="false" />

    <!-- TOOLBAR -->
    <div class="mc-toolbar">

        <asp:TextBox ID="txtSearchFood"
            runat="server"
            CssClass="mc-input"
            AutoPostBack="true"
            OnTextChanged="txtSearchFood_TextChanged"
            placeholder="Search food..." />

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

    <!-- TABLE -->
    <div class="mc-table-wrap">

        <asp:GridView ID="gvFood"
            runat="server"
            AutoGenerateColumns="False"
            CssClass="mc-table"
            GridLines="None">

            <Columns>

                <asp:BoundField DataField="id" HeaderText="ID" />
                <asp:BoundField DataField="description" HeaderText="Description" />
                <asp:BoundField DataField="calories" HeaderText="Calories" />
                <asp:BoundField DataField="protein" HeaderText="Protein" />
                <asp:BoundField DataField="total_fat" HeaderText="Total Fat" />
                <asp:BoundField DataField="carbohydrate" HeaderText="Carbohydrate" />
                <asp:BoundField DataField="sodium" HeaderText="Sodium" />
                <asp:BoundField DataField="saturated_fat" HeaderText="Saturated Fat" />
                <asp:BoundField DataField="cholesterol" HeaderText="Cholesterol" />
                <asp:BoundField DataField="sugar" HeaderText="Sugar" />
                <asp:BoundField DataField="calcium" HeaderText="Calcium" />
                <asp:BoundField DataField="iron" HeaderText="Iron" />
                <asp:BoundField DataField="potassium" HeaderText="Potassium" />
                <asp:BoundField DataField="vitamin_c" HeaderText="Vitamin C" />
                <asp:BoundField DataField="vitamin_e" HeaderText="Vitamin E" />
                <asp:BoundField DataField="vitamin_d" HeaderText="Vitamin D" />

                <asp:TemplateField HeaderText="Actions">

                    <ItemTemplate>

                        <div style="display:flex;gap:0.5rem;">

                            <asp:LinkButton ID="btnEdit"
                                runat="server"
                                Text="Edit"
                                CssClass="mc-btn mc-btn--success mc-btn--sm"
                                CommandArgument='<%# Eval("id") %>'
                                OnClick="btnEdit_Click" />

                            <asp:LinkButton ID="btnDelete"
                                runat="server"
                                Text="Delete"
                                CssClass="mc-btn mc-btn--danger mc-btn--sm"
                                CommandArgument='<%# Eval("id") %>'
                                OnClick="btnDelete_Click"
                                OnClientClick="return confirm('Delete this item?');" />

                        </div>

                    </ItemTemplate>

                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>

    <!-- FORM -->
    <asp:Panel ID="pnlForm"
        runat="server"
        Visible="false"
        CssClass="mc-card"
        Style="margin-top:2rem;">

        <div class="mc-card-header">
            <h3>
                <asp:Label ID="lblFormTitle"
                    runat="server"
                    Text="Add Food Item" />
            </h3>
        </div>

        <div class="mc-form-grid">

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

        </div>

        <div class="mc-form-actions">

            <asp:Button ID="btnCancel"
                runat="server"
                Text="Cancel"
                CssClass="mc-btn mc-btn--outline"
                OnClick="btnCancel_Click" />

            <asp:Button ID="btnSave"
                runat="server"
                Text="Save Item"
                CssClass="mc-btn mc-btn--primary"
                OnClick="btnSave_Click" />

        </div>

    </asp:Panel>

</form>

<script>
    function scrollToForm() {
        const form = document.getElementById('<%= pnlForm.ClientID %>');

        if (form) {
            form.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    }
</script>

</body>
</html>