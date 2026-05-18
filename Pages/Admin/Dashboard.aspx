<%@ Page Title="Admin Dashboard – MediCare"
    Language="C#"
    AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="MediCare.Pages.Admin.Dashboard" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Dashboard — MediCare Admin</title>
  <link rel="stylesheet" href="/css/admin.css" />
  <link rel="stylesheet" href="/css/def.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Crect width='32' height='32' rx='8' fill='%231A9E5C'/%3E%3Ctext x='6' y='23' font-size='20'%3E%E2%9A%95%3C/text%3E%3C/svg%3E" />
</head>

<body class="mc-admin-body">
<form id="form1" runat="server">

<!-- NAVBAR -->
<nav class="mc-navbar">
  <a class="mc-navbar__logo" href="Dashboard.aspx">
    <div class="mc-navbar__logo-icon"><i class="fa-solid fa-staff-snake"></i></div>
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

<main class="mc-admin-main">

  <!-- HEADER -->
  <div class="mc-page-header">
    <h1>Dashboard</h1>
  </div>

  <!-- MESSAGE LABEL -->
  <asp:Label ID="lblMessage" runat="server" Visible="false" />

  <!-- STATS -->
  <div class="mc-stat-cards-grid">

    <div class="mc-stat-card mc-stat-card--green">
      <div class="mc-stat-card__icon"><i class="fa-solid fa-user-doctor"></i></div>
      <div class="mc-stat-card__body">
        <div class="mc-stat-card__label">Total Doctors</div>
        <asp:Label ID="lblDoctors" runat="server" CssClass="mc-stat-card__value" />
      </div>
    </div>

    <div class="mc-stat-card mc-stat-card--blue">
      <div class="mc-stat-card__icon"><i class="fa-solid fa-users"></i></div>
      <div class="mc-stat-card__body">
        <div class="mc-stat-card__label">Total Patients</div>
        <asp:Label ID="lblPatients" runat="server" CssClass="mc-stat-card__value" />
      </div>
    </div>

    <div class="mc-stat-card mc-stat-card--orange">
      <div class="mc-stat-card__icon"><i class="fa-solid fa-apple-whole"></i></div>
      <div class="mc-stat-card__body">
        <div class="mc-stat-card__label">Total Foods</div>
        <asp:Label ID="lblFoods" runat="server" CssClass="mc-stat-card__value" />
      </div>
    </div>

    <div class="mc-stat-card mc-stat-card--purple">
      <div class="mc-stat-card__icon"><i class="fa-solid fa-pills"></i></div>
      <div class="mc-stat-card__body">
        <div class="mc-stat-card__label">Total Medicines</div>
        <asp:Label ID="lblMedicines" runat="server" CssClass="mc-stat-card__value" />
      </div>
    </div>

  </div>

  <!-- GRID -->
  <div class="mc-dashboard-grid">
    <div class="mc-card mc-card--flat">

      <div class="mc-card-header">
        <h4>Recent Patients</h4>
        <a href="/Pages/Admin/PatientManagement.aspx" class="mc-btn mc-btn--outline mc-btn--sm">View All</a>
      </div>

      <div class="mc-table-wrap">
        <asp:GridView ID="gvPatients" runat="server"
          AutoGenerateColumns="False"
          CssClass="mc-table"
          GridLines="None">
          <Columns>
            <asp:TemplateField HeaderText="Patient">
              <ItemTemplate>
                <div class="mc-table-name">
                  <div class="mc-avatar"><%# Eval("Initials") %></div>
                  <%# Eval("Name") %>
                </div>
              </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Age"     HeaderText="Age"     />
            <asp:BoundField DataField="Contact" HeaderText="Contact" />
          </Columns>
        </asp:GridView>
      </div>

    </div>
  </div>

</main>
</form>
<script src="/js/def.js"></script>
</body>
</html>