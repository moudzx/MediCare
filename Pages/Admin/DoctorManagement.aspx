<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="DoctorManagement.aspx.cs"
    Inherits="MediCare.Pages.Admin.DoctorManagement"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Doctors — MediCare Admin</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="\css\def.css" />
  <link rel="stylesheet" href="\css\admin.css" />
  <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='8' fill='%231A9E5C'/><text y='23' x='6' font-size='20'>⚕</text></svg>" />
</head>
<body class="mc-admin-body">
<form id="form2" runat="server">

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
          <a href="/Pages/Account/AdminProfile.aspx"><i class="fa-solid fa-user"></i> My Profile</a>
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
        <div class="mc-breadcrumb"><i class="fa-solid fa-staff-snake"></i> MediCare <span>/ Doctors</span></div>
        <h1>Doctors</h1>
        <p>Manage physician profiles, specialties, and contact information.</p>
      </div>
    </div>

    <!-- MESSAGE LABEL -->
    <asp:Label ID="lblMessage" runat="server" Visible="false" />

    <!-- Toolbar -->
    <div class="mc-toolbar">
      <div class="mc-input-wrap mc-toolbar__search">
        <span class="mc-input-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
        <asp:TextBox ID="txtSearchDoctors" runat="server"
          CssClass="mc-input mc-input--icon"
          placeholder="Search doctors by name or specialty"
          AutoPostBack="true"
          OnTextChanged="txtSearchDoctors_TextChanged" />
      </div>
    </div>

    <!-- Doctors Table -->
    <div class="mc-table-wrap">
      <asp:GridView ID="gvDoctors" runat="server"
          AutoGenerateColumns="False"
          CssClass="mc-table"
          GridLines="None">
        <Columns>

          <asp:BoundField DataField="DoctorId" HeaderText="#" />

          <asp:TemplateField HeaderText="Doctor">
            <ItemTemplate>
              <div class="mc-table-name">
                <div class="mc-avatar"><i class="fa-solid fa-user-doctor"></i></div>
                <%# Eval("FullName") %>
              </div>
            </ItemTemplate>
          </asp:TemplateField>

          <asp:TemplateField HeaderText="Specialty">
            <ItemTemplate>
              <i class="fa-solid fa-stethoscope"></i>
              <%# Eval("Speciality") %>
            </ItemTemplate>
          </asp:TemplateField>

          <asp:TemplateField HeaderText="Email">
            <ItemTemplate>
              <i class="fa-solid fa-envelope"></i>
              <%# Eval("Email") %>
            </ItemTemplate>
          </asp:TemplateField>

          <asp:TemplateField HeaderText="Phone">
            <ItemTemplate>
              <i class="fa-solid fa-phone"></i>
              <%# Eval("PhoneNumber") %>
            </ItemTemplate>
          </asp:TemplateField>

          <asp:TemplateField HeaderText="">
            <ItemTemplate>
              <div style="display:flex;gap:0.4rem">
                <asp:Button ID="btnDelete" runat="server"
                    CssClass="mc-btn mc-btn--danger mc-btn--sm"
                    Text="Delete"
                    CommandArgument='<%# Eval("DoctorId") %>'
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