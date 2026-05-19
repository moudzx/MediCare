<%@ Page Title="Doctors — MediCare Admin"
    Language="C#"
    MasterPageFile="~/MasterPage/AdminSite.Master"
    AutoEventWireup="true"
    CodeBehind="DoctorManagement.aspx.cs"
    Inherits="MediCare.Pages.Admin.DoctorManagement" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

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

</asp:Content>
