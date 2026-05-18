<%@ Page Language="C#" AutoEventWireup="true"
     CodeBehind="MedicineCatalog.aspx.cs"
    Inherits="MediCare.Pages.Admin.MedicineCatalog" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Medicine — MediCare Admin</title>
   <link rel="stylesheet" href="\css\def.css" />
  <link rel="stylesheet" href="\css\admin.css" />

  <!-- Font Awesome CDN -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
  <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='8' fill='%231A9E5C'/><text y='23' x='6' font-size='20'>⚕</text></svg>" />
</head>
<body class="mc-admin-body">
<form id="form4" runat="server">
  <!-- ══ ADMIN NAVBAR ══ -->
  <nav class="mc-navbar">
    <a class="mc-navbar__logo" href="Dashboard.aspx">
      <div class="mc-navbar__logo-icon">  <i class="fa-solid fa-staff-snake"></i></div>
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
          <a href="/Pages/Account/AdminProfile.aspx"> <i class="fa-solid fa-user"></i> My Profile</a>
          <a href="#"><i class="fa-solid fa-gear"></i> Settings</a>
          <a href="Default.aspx" style="color:#DC2626">  <i class="fa-solid fa-right-from-bracket"></i> Logout</a>
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
        <div class="mc-breadcrumb">  <i class="fa-solid fa-staff-snake"></i> MediCare <span>/ Medicine</span></div>
        <h1>Medicine Catalog</h1>
        <p>Browse and manage the complete pharmaceutical database.</p>
      </div>
      <div style="display:flex;gap:0.75rem">
       
       <button type="button" class="mc-btn mc-btn--primary" data-modal-open="addMedModal">
  <i class="fa-solid fa-plus"></i> Add Medicine
</button>
      </div>
    </div>

    <!-- Toolbar -->
    <div class="mc-input-wrap mc-toolbar__search">
    <span class="mc-input-icon">
        <i class="fa-solid fa-magnifying-glass"></i>
    </span>

    <asp:TextBox ID="txtSearch" runat="server"
        CssClass="mc-input mc-input--icon"
        placeholder="Search by name or ATC code"
        AutoPostBack="true"
        OnTextChanged="txtSearch_TextChanged">
    </asp:TextBox>
</div>

    <!-- Medicine Table (GridView) -->
   <div class="mc-table-wrap">

<asp:GridView ID="gvMedicines" runat="server"
    AutoGenerateColumns="False"
    CssClass="mc-table"
    GridLines="None">

    <Columns>

        
        <asp:TemplateField HeaderText="#">
            <ItemTemplate>
                <span style="color:var(--text-muted);font-size:0.82rem">
                    <%# Eval("ID") %>
                </span>
            </ItemTemplate>
        </asp:TemplateField>

        
        <asp:TemplateField HeaderText="Medicine Name">
            <ItemTemplate>
                <div>
                    <div style="font-weight:600;color:var(--text-primary)">
                        <%# Eval("MedicineName") %>
                    </div>
                    <div style="font-size:0.76rem;color:var(--text-muted)">
                        <%# Eval("Description") %>
                    </div>
                </div>
            </ItemTemplate>
        </asp:TemplateField>

        
        <asp:TemplateField HeaderText="ATC Code">
            <ItemTemplate>
                <code style="background:var(--bg-soft);padding:0.2rem 0.5rem;border-radius:6px;font-size:0.8rem;color:var(--primary-dark)">
                    <%# Eval("ATCCode") %>
                </code>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:BoundField DataField="Dosage" HeaderText="Dosage" />

        
        <asp:TemplateField HeaderText="Form">
            <ItemTemplate>
                <span class="mc-med-form">
                    <i class='<%# Eval("FormIcon") %>'></i>
                    <%# Eval("Form") %>
                </span>
            </ItemTemplate>
        </asp:TemplateField>

        
        <asp:TemplateField HeaderText="Ingredients">
            <ItemTemplate>
                <span style="font-size:0.85rem">
                    <%# Eval("Ingredients") %>
                </span>
            </ItemTemplate>
        </asp:TemplateField>

        
        <asp:TemplateField HeaderText="Price">
            <ItemTemplate>
                <strong style="color:var(--text-primary)">
                    $<%# Eval("Price") %>
                </strong>
            </ItemTemplate>
        </asp:TemplateField>

        
        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>

                <div style="display:flex;gap:0.4rem">

                    <button type="button" class="mc-btn mc-btn--success mc-btn--sm">
                        <i class="fa-solid fa-pen-to-square"></i> Edit
                    </button>

                    <asp:Button ID="btnDelete" runat="server"
                        CssClass="mc-btn mc-btn--danger mc-btn--sm"
                        Text=" "
                        CommandArgument='<%# Eval("ID") %>' />

                    <i class="fa-solid fa-trash"></i>

                </div>

            </ItemTemplate>
        </asp:TemplateField>

    </Columns>

</asp:GridView>

</div>
  
   
  </main>

  <!-- ══ ADD MEDICINE MODAL ══ -->

<div class="mc-modal-overlay" id="addMedModal">
  <div class="mc-modal">

    <div class="mc-modal__header">
      <h4>Add Medicine to Catalog</h4>
      <div class="mc-modal__close" data-modal-close="addMedModal">
        <i class="fa-solid fa-xmark"></i>
      </div>
    </div>

    
    <div class="mc-form-row">
      <label class="mc-form-label">Medicine Name</label>
      <asp:TextBox ID="txtMedName" runat="server"
        CssClass="mc-input"
        placeholder="e.g. Metformin HCl" />
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem">

      
      <div class="mc-form-row">
        <label class="mc-form-label">ATC Code</label>
        <asp:TextBox ID="txtATC" runat="server"
          CssClass="mc-input"
          Style="font-family:monospace"
          placeholder="e.g. A10BA02" />
      </div>

     
      <div class="mc-form-row">
        <label class="mc-form-label">Dosage</label>
        <asp:TextBox ID="txtDosage" runat="server"
          CssClass="mc-input"
          placeholder="e.g. 500mg · 3×/day" />
      </div>

    
      <div class="mc-form-row">
        <label class="mc-form-label">Form</label>
        <asp:DropDownList ID="ddlForm" runat="server" CssClass="mc-select" Style="width:100%">
          <asp:ListItem Text="Tablet" />
          <asp:ListItem Text="Capsule" />
          <asp:ListItem Text="Syrup" />
          <asp:ListItem Text="Injection" />
          <asp:ListItem Text="Cream" />
          <asp:ListItem Text="Drops" />
          <asp:ListItem Text="Inhaler" />
        </asp:DropDownList>
      </div>

      
      <div class="mc-form-row">
        <label class="mc-form-label">Price (USD)</label>
        <asp:TextBox ID="txtPrice" runat="server"
          CssClass="mc-input"
          TextMode="Number"
          step="0.01"
          min="0"
          placeholder="e.g. 4.20" />
      </div>

    </div>

    
    <div class="mc-form-row">
      <label class="mc-form-label">Active Ingredients</label>
      <asp:TextBox ID="txtIngredients" runat="server"
        CssClass="mc-input"
        placeholder="e.g. Metformin HCl, Magnesium stearate" />
    </div>

    
    <div class="mc-form-actions">
      <button class="mc-btn mc-btn--outline" data-modal-close="addMedModal">
        Cancel
      </button>

      <asp:Button ID="btnAddMedicine" runat="server"
        Text="Add Medicine"
        CssClass="mc-btn mc-btn--primary"
         />
    </div>

  </div>
</div>
  <script src="\js\def.js"></script>
  </form>
</body>
</html>
