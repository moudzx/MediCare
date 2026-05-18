<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="PatientManagement.aspx.cs"
    Inherits="MediCare.Pages.Admin.PatientManagement" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Patients — MediCare Admin</title>
  <link rel="stylesheet" href="\css\def.css" />
  <link rel="stylesheet" href="\css\admin.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
  <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='8' fill='%231A9E5C'/><text y='23' x='6' font-size='20'>⚕</text></svg>" />
</head>
<body class="mc-admin-body">
<form id="form3" runat="server">

  <!-- NAVBAR -->
  <nav class="mc-navbar">
    <a class="mc-navbar__logo" href="Dashboard.aspx">
      <div class="mc-navbar__logo-icon"><i class="fa-solid fa-staff-snake"></i></div>
      MediCare
    </a>
    <ul class="mc-navbar__links">
      <li><a href="/Pages/Admin/Dashboard.aspx"         data-page="dashboard">Dashboard</a></li>
      <li><a href="/Pages/Admin/DoctorManagement.aspx"  data-page="doctors"  >Doctors</a></li>
      <li><a href="/Pages/Admin/PatientManagement.aspx" data-page="patients" >Patients</a></li>
      <li><a href="/Pages/Admin/FoodCatalog.aspx"       data-page="food"     >Food</a></li>
      <li><a href="/Pages/Admin/MedicineCatalog.aspx"   data-page="medicine" >Medicine</a></li>
    </ul>
    <div class="mc-navbar__actions">
      <div class="mc-profile-dropdown">
        <div class="mc-profile-trigger">
          <div class="mc-avatar" style="background:linear-gradient(135deg,#34C679,#1A9E5C);width:30px;height:30px;font-size:0.75rem">AD</div>
          <span>Admin</span>
          <span style="color:var(--text-muted);font-size:0.75rem">
            <i class="fa-solid fa-chevron-down" style="color:var(--text-muted);font-size:0.75rem"></i>
          </span>
        </div>
        <div class="mc-dropdown-menu">
          <a href="Profile.aspx"><i class="fa-solid fa-user"></i> My Profile</a>
          <a href="#"><i class="fa-solid fa-gear"></i> Settings</a>
          <a href="Default.aspx" style="color:#DC2626"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
      </div>
      <button class="mc-navbar__hamburger" id="hamburgerBtn"><span></span><span></span><span></span></button>
    </div>
  </nav>

  <div class="mc-navbar__mobile" id="mobileNav">
    <a href="Dashboard.aspx">Dashboard</a>
    <a href="Doctors.aspx">Doctors</a>
    <a href="Patients.aspx">Patients</a>
    <a href="Food.aspx">Food</a>
    <a href="Medicine.aspx">Medicine</a>
  </div>

  <main class="mc-admin-main">

    <!-- Page Header -->
    <div class="mc-page-header">
      <div>
        <div class="mc-breadcrumb"><i class="fa-solid fa-staff-snake"></i> MediCare <span>/ Patients</span></div>
        <h1>Patients</h1>
        <p>View and manage all registered patient records.</p>
      </div>
    </div>

    <!-- MESSAGE LABEL -->
    <asp:Label ID="lblMessage" runat="server" Visible="false" />

    <!-- Mini Stat Row -->
    <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:1rem;margin-bottom:2rem">

      <!-- Total Patients -->
      <div class="mc-card mc-card--flat" style="display:flex;align-items:center;gap:1rem;padding:1.1rem 1.4rem">
        <div style="width:44px;height:44px;background:#E8FAF1;border-radius:12px;display:flex;align-items:center;justify-content:center;color:#1A9E5C">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
            <path d="M16 11a4 4 0 1 0-8 0a4 4 0 0 0 8 0z" stroke="currentColor" stroke-width="2"/>
            <path d="M4 20c1.5-4 14.5-4 16 0" stroke="currentColor" stroke-width="2"/>
          </svg>
        </div>
        <div>
          <div style="font-size:0.78rem;font-weight:600;text-transform:uppercase;letter-spacing:.07em;color:var(--text-muted)">Total Patients</div>
          <asp:Label ID="lblPatientsCount" runat="server"
            Style="font-family:var(--font-heading);font-size:1.75rem;line-height:1.1;color:var(--text-primary);" />
        </div>
      </div>

      <!-- New This Month -->
      <div class="mc-card mc-card--flat" style="display:flex;align-items:center;gap:1rem;padding:1.1rem 1.4rem">
        <div style="width:44px;height:44px;background:#EFF6FF;border-radius:12px;display:flex;align-items:center;justify-content:center;color:#2563EB">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none">
            <path d="M7 2v3M17 2v3" stroke="currentColor" stroke-width="2"/>
            <path d="M3 8h18" stroke="currentColor" stroke-width="2"/>
            <path d="M5 5h14a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7a2 2 0 0 1 2-2z" stroke="currentColor" stroke-width="2"/>
          </svg>
        </div>
        <div>
          <div style="font-size:0.78rem;font-weight:600;text-transform:uppercase;letter-spacing:.07em;color:var(--text-muted)">New This Month</div>
          <asp:Label ID="lblNewPatients" runat="server"
            Style="font-family:var(--font-heading);font-size:1.75rem;line-height:1.1;color:var(--text-primary);" />
        </div>
      </div>

    </div>

    <!-- Toolbar -->
    <div class="mc-toolbar">
      <div class="mc-input-wrap mc-toolbar__search">
        <span class="mc-input-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
        <asp:TextBox ID="txtSearchPatients" runat="server"
          CssClass="mc-input mc-input--icon"
          placeholder="Search patients by name"
          AutoPostBack="true"
          OnTextChanged="txtSearchPatients_TextChanged" />
      </div>
    </div>

    <!-- Patients Table -->
    <div class="mc-table-wrap">
   <asp:GridView ID="gvPatients" runat="server"
    CssClass="mc-table"
    AutoGenerateColumns="False"
    GridLines="None">
        <Columns>

          <asp:BoundField DataField="PatientId" HeaderText="#" />

          <asp:TemplateField HeaderText="Patient">
            <ItemTemplate>
              <div class="mc-table-name">
                <div class="mc-avatar"><%# Eval("Initials") %></div>
                <%# Eval("FullName") %>
              </div>
            </ItemTemplate>
          </asp:TemplateField>

          <asp:BoundField DataField="Age" HeaderText="Age" />

          <asp:TemplateField HeaderText="Contact">
            <ItemTemplate>
              <%# Eval("PhoneNumber") %>
            </ItemTemplate>
          </asp:TemplateField>

         <asp:TemplateField HeaderText="">
  <ItemTemplate>
    <div style="display:flex;gap:0.4rem">
      <asp:Button ID="btnDelete" runat="server"
          CssClass="mc-btn mc-btn--danger mc-btn--sm"
          CommandName="DeletePatient"
          CommandArgument='<%# Eval("PatientId") %>'
          Text="Delete"
          OnClick="btnDelete_Click" />
    </div>
  </ItemTemplate>
</asp:TemplateField>
          

        </Columns>
      </asp:GridView>
    </div>

  </main>

  <script src="\js\def.js"></script>
</form>
</body>
</html>