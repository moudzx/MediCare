<%@ Page Language="C#"
    AutoEventWireup="true"
    CodeBehind="FoodCatalog.aspx.cs"
    Inherits="MediCare.Pages.Admin.FoodCatalog" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Food & Nutrition — MediCare Admin</title>
  <link rel="stylesheet" href="\css\def.css" />
  <link rel="stylesheet" href="\css\admin.css" />

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

  <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='8' fill='%231A9E5C'/><text y='23' x='6' font-size='20'>⚕</text></svg>" />
</head>
<body class="mc-admin-body">
<form id="form3" runat="server">
  <!-- ══ ADMIN NAVBAR ══ -->
  <nav class="mc-navbar">
    <a class="mc-navbar__logo" href="Dashboard.aspx">
      <div class="mc-navbar__logo-icon"><i class="fa-solid fa-staff-snake"></i></div>
      MediCare
    </a>
    <ul class="mc-navbar__links">
      <li><a href="/Pages/Admin/Dashboard.aspx"    data-page="dashboard"   >Dashboard</a></li>
   
      <li><a href="/Pages/Admin/DoctorManagement.aspx"      data-page="doctors"     >Doctors</a></li>
      <li><a href="/Pages/Admin/PatientManagement.aspx"     data-page="patients"    >Patients</a></li>
      <li><a href="/Pages/Admin/FoodCatalog.aspx"         data-page="food"        >Food</a></li>
      <li><a href="/Pages/Admin/MedicineCatalog.aspx"     data-page="medicine"    >Medicine</a></li>
    </ul>
    <div class="mc-navbar__actions">
      <div class="mc-profile-dropdown">
        <div class="mc-profile-trigger">
          <div class="mc-avatar" style="background:linear-gradient(135deg,#34C679,#1A9E5C);width:30px;height:30px;font-size:0.75rem">AD</div>
          <span>Admin</span>
          <span style="color:var(--text-muted);font-size:0.75rem"><i class="fa-solid fa-chevron-down" style="color:var(--text-muted);font-size:0.75rem"></i></span>
        </div>
        <div class="mc-dropdown-menu">
          <a href="/Pages/Admin/Profile.aspx"><i class="fa-solid fa-user"></i> My Profile</a>
          <a href="#"><i class="fa-solid fa-gear"></i> Settings</a>
          <a href="Default.aspx" style="color:#DC2626"> <i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
      </div>
      <button class="mc-navbar__hamburger" id="hamburgerBtn"><span></span><span></span><span></span></button>
    </div>
  </nav>
  <div class="mc-navbar__mobile" id="mobileNav">
    <a href="Dashboard.aspx">Dashboard</a>
    <a href="Appointments.aspx">Appointments</a>
    <a href="Doctors.aspx">Doctors</a>
    <a href="Patients.aspx">Patients</a>
    <a href="Food.aspx">Food</a>
    <a href="Medicine.aspx">Medicine</a>
  </div>

  <main class="mc-admin-main">

    <!-- Page Header -->
    <div class="mc-page-header">
      <div>
        <div class="mc-breadcrumb"><i class="fa-solid fa-staff-snake"></i> MediCare <span>/ Food & Nutrition</span></div>
        <h1>Food & Nutrition</h1>
        <p>Manage the nutritional database for patient dietary planning.</p>
      </div>
      <div style="display:flex;gap:0.75rem">
       
       <button type="button" class="mc-btn mc-btn--primary" data-modal-open="addFoodModal">
  <i class="fa-solid fa-plus"></i> Add Food Item
</button>
      </div>
    </div>

    <!-- Toolbar -->
<div class="mc-toolbar">

    <!-- SEARCH -->
    <div class="mc-input-wrap mc-toolbar__search">
        <span class="mc-input-icon">
            <i class="fa-solid fa-magnifying-glass"></i>
        </span>

        <asp:TextBox ID="txtSearchFood" runat="server"
            CssClass="mc-input mc-input--icon"
            placeholder="Search food items"
            AutoPostBack="true"
            OnTextChanged="txtSearchFood_TextChanged" />
    </div>

    <!-- SORT -->
    <asp:DropDownList ID="ddlSortFood" runat="server"
        CssClass="mc-select"
        AutoPostBack="true"
        OnSelectedIndexChanged="ddlSortFood_SelectedIndexChanged">

        <asp:ListItem Value="">Sort by</asp:ListItem>
        <asp:ListItem Value="cal_desc">Highest Calories</asp:ListItem>
        <asp:ListItem Value="cal_asc">Lowest Calories</asp:ListItem>
        <asp:ListItem Value="protein">Highest Protein</asp:ListItem>
        <asp:ListItem Value="az">Alphabetical</asp:ListItem>

    </asp:DropDownList>

   

</div>

<!-- TABLE -->
<div class="mc-table-wrap">

<asp:GridView ID="gvFood" runat="server"
    AutoGenerateColumns="False"
    CssClass="mc-table"
    GridLines="None"
    DataKeyNames="ID">

    <Columns>

        <asp:TemplateField HeaderText="#">
            <ItemTemplate>
                <span style="color:var(--text-muted);font-size:0.82rem">
                    <%# Eval("ID") %>
                </span>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Description">
            <ItemTemplate>
                <div style="display:flex;align-items:center;gap:0.6rem">
                    <div>
                        <div style="font-weight:600;font-size:0.9rem;color:var(--text-primary)">
                            <%# Eval("Description") %>
                        </div>
                        <div style="font-size:0.76rem;color:var(--text-muted)">
                            100g serving
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:BoundField DataField="Calories" HeaderText="Calories" />
        <asp:BoundField DataField="Protein" HeaderText="Protein" />
        <asp:BoundField DataField="TotalFat" HeaderText="Total Fat" />
        <asp:BoundField DataField="Carbohydrate" HeaderText="Carbohydrate" />
        <asp:BoundField DataField="Sodium" HeaderText="Sodium" />
        <asp:BoundField DataField="SaturatedFat" HeaderText="Saturated Fat" />
        <asp:BoundField DataField="Cholesterol" HeaderText="Cholesterol" />
        <asp:BoundField DataField="Sugar" HeaderText="Sugar" />
        <asp:BoundField DataField="Calcium" HeaderText="Calcium" />
        <asp:BoundField DataField="Iron" HeaderText="Iron" />
        <asp:BoundField DataField="Potassium" HeaderText="Potassium" />
        <asp:BoundField DataField="VitaminC" HeaderText="Vitamin C" />
        <asp:BoundField DataField="VitaminE" HeaderText="Vitamin E" />
        <asp:BoundField DataField="VitaminD" HeaderText="Vitamin D" />

        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>

                <div style="display:flex;gap:0.4rem">

                    <button type="button" class="mc-btn mc-btn--success mc-btn--sm">
                        <i class="fa-solid fa-pen-to-square"></i> Edit
                    </button>

                    <asp:Button ID="btnDelete" runat="server"
                        CssClass="mc-btn mc-btn--danger mc-btn--sm"
                        Text="Delete"
                        CommandArgument='<%# Eval("ID") %>' />

                    <i class="fa-solid fa-trash"></i>

                </div>

            </ItemTemplate>
        </asp:TemplateField>

    </Columns>

</asp:GridView>

</div>

 

  </main>

  <!-- ══ ADD FOOD MODAL ══ -->
 <div class="mc-modal-overlay" id="addFoodModal">
  <div class="mc-modal" style="width:750px;max-width:95%;max-height:90vh;overflow:hidden;display:flex;flex-direction:column;">

    <div class="mc-modal__header">
      <h4>Add Food Item</h4>
      <div class="mc-modal__close" data-modal-close="addFoodModal">
        <i class="fa-solid fa-xmark"></i>
      </div>
    </div>

    <!-- scroll area -->
    <div style="overflow-y:auto;flex:1;padding-right:8px">

      <div class="mc-form-row">
        <label class="mc-form-label">ID</label>
        <asp:TextBox ID="txtID" runat="server" CssClass="mc-input" />
      </div>

      <div class="mc-form-row">
        <label class="mc-form-label">Description</label>
        <asp:TextBox ID="txtDescription" runat="server" CssClass="mc-input" />
      </div>

      <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem">

        <div class="mc-form-row">
          <label class="mc-form-label">Calories</label>
          <asp:TextBox ID="txtCalories" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Protein</label>
          <asp:TextBox ID="txtProtein" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Total Fat</label>
          <asp:TextBox ID="txtTotalFat" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Carbohydrate</label>
          <asp:TextBox ID="txtCarbohydrate" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Sodium</label>
          <asp:TextBox ID="txtSodium" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Saturated Fat</label>
          <asp:TextBox ID="txtSaturatedFat" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Cholesterol</label>
          <asp:TextBox ID="txtCholesterol" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Sugar</label>
          <asp:TextBox ID="txtSugar" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Calcium</label>
          <asp:TextBox ID="txtCalcium" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Iron</label>
          <asp:TextBox ID="txtIron" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Potassium</label>
          <asp:TextBox ID="txtPotassium" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Vitamin C</label>
          <asp:TextBox ID="txtVitaminC" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Vitamin E</label>
          <asp:TextBox ID="txtVitaminE" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

        <div class="mc-form-row">
          <label class="mc-form-label">Vitamin D</label>
          <asp:TextBox ID="txtVitaminD" runat="server" CssClass="mc-input" TextMode="Number" />
        </div>

      </div>
    </div>

    <div class="mc-form-actions">
      <button class="mc-btn mc-btn--outline" data-modal-close="addFoodModal">
        Cancel
      </button>

      <asp:Button ID="btnAddFood" runat="server"
        Text="Add Item"
        CssClass="mc-btn mc-btn--primary"
         />
    </div>

  </div>
</div>
</form>
    <script src="\js\def.js"></script>
</body>
</html>
