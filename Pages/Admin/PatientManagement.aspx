<%@ Page Title="Patients — MediCare Admin"
    Language="C#"
    MasterPageFile="~/MasterPage/AdminSite.Master"
    AutoEventWireup="true"
    CodeBehind="PatientManagement.aspx.cs"
    Inherits="MediCare.Pages.Admin.PatientManagement" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

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

</asp:Content>
