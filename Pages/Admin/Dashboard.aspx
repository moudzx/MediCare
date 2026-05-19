<%@ Page Title="Dashboard — MediCare Admin"
    Language="C#"
    MasterPageFile="~/MasterPage/AdminSite.Master"
    AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="MediCare.Pages.Admin.Dashboard" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

  <!-- HEADER -->
  <div class="mc-page-header">
    <div>
      <div class="mc-breadcrumb"><i class="fa-solid fa-staff-snake"></i> MediCare <span>/ Dashboard</span></div>
      <h1>Dashboard</h1>
    </div>
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

</asp:Content>
