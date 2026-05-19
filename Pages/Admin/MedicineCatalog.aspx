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
    <asp:Label ID="lblMessage"
        runat="server"
        Visible="false" />

    <!-- SEARCH -->
    <div class="mc-toolbar">

        <asp:TextBox ID="txtSearch"
            runat="server"
            CssClass="mc-input"
            AutoPostBack="true"
            OnTextChanged="txtSearch_TextChanged"
            placeholder="Search medicine..." />

    </div>

    <!-- TABLE -->
    <div class="mc-table-wrap">

        <asp:GridView ID="gvMedicines"
            runat="server"
            AutoGenerateColumns="False"
            CssClass="mc-table"
            GridLines="None"
            AllowPaging="true"
            PageSize="25"
            OnPageIndexChanging="gvMedicines_PageIndexChanging">

            <PagerStyle CssClass="mc-table-pager" />

            <Columns>

                <asp:BoundField DataField="atc" HeaderText="ATC Code" />
                <asp:BoundField DataField="name" HeaderText="Name" />
                <asp:BoundField DataField="b_g" HeaderText="B/G" />
                <asp:BoundField DataField="ingredients" HeaderText="Ingredients" />
                <asp:BoundField DataField="dosage" HeaderText="Dosage" />
                <asp:BoundField DataField="form" HeaderText="Form" />
                <asp:BoundField DataField="price" HeaderText="Price" />

                <asp:TemplateField HeaderText="Actions">

                    <ItemTemplate>

                        <div style="display:flex;gap:0.5rem;">

                            <asp:LinkButton ID="btnEdit"
                                runat="server"
                                Text="Edit"
                                CssClass="mc-btn mc-btn--success mc-btn--sm"
                                CommandArgument='<%# Eval("atc") %>'
                                OnClick="btnEdit_Click" />

                            <asp:LinkButton ID="btnDelete"
                                runat="server"
                                Text="Delete"
                                CssClass="mc-btn mc-btn--danger mc-btn--sm"
                                CommandArgument='<%# Eval("atc") %>'
                                OnClick="btnDelete_Click"
                                OnClientClick="return confirm('Delete this medicine?');" />

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
                    Text="Add Medicine" />

            </h3>

        </div>

        <div class="mc-form-grid">

            <div class="mc-form-row">
                <label>ATC Code</label>
                <asp:TextBox ID="txtATC"
                    runat="server"
                    CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Name</label>
                <asp:TextBox ID="txtName"
                    runat="server"
                    CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>B/G</label>
                <asp:TextBox ID="txtBG"
                    runat="server"
                    CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Ingredients</label>
                <asp:TextBox ID="txtIngredients"
                    runat="server"
                    CssClass="mc-input"
                    TextMode="MultiLine"
                    Rows="4" />
            </div>

            <div class="mc-form-row">
                <label>Dosage</label>
                <asp:TextBox ID="txtDosage"
                    runat="server"
                    CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Form</label>
                <asp:TextBox ID="txtForm"
                    runat="server"
                    CssClass="mc-input" />
            </div>

            <div class="mc-form-row">
                <label>Price</label>
                <asp:TextBox ID="txtPrice"
                    runat="server"
                    CssClass="mc-input" />
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
                Text="Save Medicine"
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