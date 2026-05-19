<%@ Page Title="Medicine Catalog — MediCare Admin"
    Language="C#"
    MasterPageFile="~/MasterPage/AdminSite.Master"
    AutoEventWireup="true"
    CodeBehind="MedicineCatalog.aspx.cs"
    Inherits="MediCare.Pages.Admin.MedicineCatalog" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

  <!-- HEADER -->
  <div class="mc-page-header">
    <div>
      <div class="mc-breadcrumb"><i class="fa-solid fa-staff-snake"></i> MediCare <span>/ Medicine Catalog</span></div>
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
  <asp:Label ID="lblMessage" runat="server" Visible="false" />

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
        <asp:BoundField DataField="atc"         HeaderText="ATC Code"    />
        <asp:BoundField DataField="name"        HeaderText="Name"        />
        <asp:BoundField DataField="b_g"         HeaderText="B/G"         />
        <asp:BoundField DataField="ingredients" HeaderText="Ingredients" />
        <asp:BoundField DataField="dosage"      HeaderText="Dosage"      />
        <asp:BoundField DataField="form"        HeaderText="Form"        />
        <asp:BoundField DataField="price"       HeaderText="Price"       />

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
      <h3><asp:Label ID="lblFormTitle" runat="server" Text="Add Medicine" /></h3>
    </div>

    <div class="mc-form-grid">
      <div class="mc-form-row"><label>ATC Code</label>    <asp:TextBox ID="txtATC"         runat="server" CssClass="mc-input" /></div>
      <div class="mc-form-row"><label>Name</label>        <asp:TextBox ID="txtName"        runat="server" CssClass="mc-input" /></div>
      <div class="mc-form-row"><label>B/G</label>         <asp:TextBox ID="txtBG"          runat="server" CssClass="mc-input" /></div>
      <div class="mc-form-row"><label>Ingredients</label> <asp:TextBox ID="txtIngredients" runat="server" CssClass="mc-input" TextMode="MultiLine" Rows="4" /></div>
      <div class="mc-form-row"><label>Dosage</label>      <asp:TextBox ID="txtDosage"      runat="server" CssClass="mc-input" /></div>
      <div class="mc-form-row"><label>Form</label>        <asp:TextBox ID="txtForm"        runat="server" CssClass="mc-input" /></div>
      <div class="mc-form-row"><label>Price</label>       <asp:TextBox ID="txtPrice"       runat="server" CssClass="mc-input" /></div>
    </div>

    <div class="mc-form-actions">
      <asp:Button ID="btnCancel" runat="server" Text="Cancel"        CssClass="mc-btn mc-btn--outline" OnClick="btnCancel_Click" />
      <asp:Button ID="btnSave"   runat="server" Text="Save Medicine" CssClass="mc-btn mc-btn--primary" OnClick="btnSave_Click"   />
    </div>

  </asp:Panel>

</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="ScriptContent" runat="server">
  <script>
    function scrollToForm() {
    const form = document.getElementById('<%= pnlForm.ClientID %>');
    if (form) form.scrollIntoView({ behavior: 'smooth', block: 'start' });
}
</script>
</asp:Content>
