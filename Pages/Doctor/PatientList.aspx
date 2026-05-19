<%-- PatientList.aspx --%>
<%@ Page Title="Patient List"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="PatientList.aspx.cs"
    Inherits="MediCare.Pages.Doctor.PatientList" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/PatientList.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pl-root">

        <div class="pl-page-header">
            <div class="pl-page-header__left">
                <div class="pl-page-header__icon">
                    <i class="fas fa-users"></i>
                </div>
                <div>
                    <h1 class="pl-page-header__title">Patient Network</h1>
                    <p class="pl-page-header__sub">Manage your active patient connections and requests</p>
                </div>
            </div>
        </div>

        <div class="pl-stats-bar">
            <div class="pl-stat-pill pl-stat-pill--blue">
                <i class="fas fa-users"></i>
                <asp:Label ID="lblStatTotal" runat="server" CssClass="pl-stat-pill__num" Text="0" />
                <span class="pl-stat-pill__label">Total Patients</span>
            </div>
            <div class="pl-stat-pill pl-stat-pill--green">
                <i class="fas fa-heart"></i>
                <asp:Label ID="lblStatActive" runat="server" CssClass="pl-stat-pill__num" Text="0" />
                <span class="pl-stat-pill__label">Active Network</span>
            </div>
            <div class="pl-stat-pill pl-stat-pill--orange">
                <i class="fas fa-phone"></i>
                <asp:Label ID="lblStatUpcoming" runat="server" CssClass="pl-stat-pill__num" Text="0" />
                <span class="pl-stat-pill__label">With Phone</span>
            </div>
            <div class="pl-stat-pill pl-stat-pill--teal">
                <i class="fas fa-notes-medical"></i>
                <asp:Label ID="lblStatOnMeds" runat="server" CssClass="pl-stat-pill__num" Text="0" />
                <span class="pl-stat-pill__label">Chronic Disease</span>
            </div>
        </div>

        <asp:Panel ID="pnlPendingSection" runat="server" CssClass="pl-pending-section" Visible="false" style="margin-bottom: 30px; background: #fff; padding: 20px; border-radius: 8px; border-left: 4px solid #f0ad4e; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
            <h2 style="font-size: 1.25rem; margin-top: 0; margin-bottom: 15px; color: #333;"><i class="fas fa-clock" style="color: #f0ad4e; margin-right: 8px;"></i> Pending Connection Requests</h2>
            
            <div class="pl-patient-grid">
                <asp:Repeater ID="rptPendingRequests" runat="server" OnItemCommand="rptPendingRequests_ItemCommand">
                    <ItemTemplate>
                        <div class="pl-patient-card" style="border: 1px solid #e0e0e0;">
                            <div class="pl-patient-card__body">
                                <div class="pl-patient-avatar" style="background-color: #f0ad4e;">
                                    <%# Eval("Initials") %>
                                </div>
                                <div class="pl-patient-info">
                                    <h3 class="pl-patient-info__name"><%# Eval("FullName") %></h3>
                                    <div class="pl-patient-info__meta">
                                        <span class="pl-patient-info__meta-item"><i class="fas fa-birthday-cake"></i> <%# Eval("Age") %> yrs</span>
                                        <span class="pl-patient-info__meta-item"><i class="fas fa-venus-mars"></i> <%# Eval("Gender") %></span>
                                        <span class="pl-patient-info__meta-item"><i class="fas fa-tint"></i> <%# Eval("BloodType") %></span>
                                    </div>
                                </div>
                            </div>
                            <div class="pl-patient-card__details">
                                <div class="pl-patient-card__detail-row">
                                    <i class="fas fa-notes-medical"></i>
                                    <span><strong>Condition:</strong> <%# Eval("ChronicDisease") %></span>
                                </div>
                                <div class="pl-patient-card__detail-row">
                                    <i class="fas fa-phone"></i>
                                    <span><%# Eval("PhoneNumber") %></span>
                                </div>
                            </div>
                            <div class="pl-patient-card__actions" style="grid-template-columns: 1fr 1fr; gap: 8px;">
                                <asp:LinkButton ID="btnAccept" runat="server" CssClass="pl-btn pl-btn--sm pl-btn--green" CommandName="AcceptRequest" CommandArgument='<%# Eval("PatientId") %>'>
                                    <i class="fas fa-check"></i> Accept
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnReject" runat="server" CssClass="pl-btn pl-btn--sm pl-btn--danger" CommandName="RejectRequest" CommandArgument='<%# Eval("PatientId") %>' OnClientClick="return confirm('Reject this connection request?');">
                                    <i class="fas fa-times"></i> Reject
                                </asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>

        <h2 style="font-size: 1.25rem; margin-bottom: 15px; color: #333;"><i class="fas fa-check-circle" style="color: #28a745; margin-right: 8px;"></i> My Active Patients</h2>

        <div class="pl-toolbar">
            <div class="pl-search-wrap">
                <i class="fas fa-search pl-search-wrap__icon"></i>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="pl-search-input" placeholder="Search patients..." AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" />
                <asp:Button ID="btnClearSearch" runat="server" Text="X" CssClass="pl-search-clear" OnClick="btnClearSearch_Click" />
            </div>
            <div class="pl-filter-group">
                <asp:DropDownList ID="ddlGender" runat="server" CssClass="pl-select" AutoPostBack="true" OnSelectedIndexChanged="ddlGender_SelectedIndexChanged">
                    <asp:ListItem Value="">All Genders</asp:ListItem>
                    <asp:ListItem Value="Male">Male</asp:ListItem>
                    <asp:ListItem Value="Female">Female</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <div class="pl-results-info">
            <asp:Label ID="lblResultsCount" runat="server" Text="Showing 0 patients" />
        </div>

        <div class="pl-patient-grid">
            <asp:Repeater ID="rptPatients" runat="server" OnItemCommand="rptPatients_ItemCommand">
                <ItemTemplate>
                    <div class="pl-patient-card">
                        <div class="pl-patient-card__body">
                            <div class="pl-patient-avatar">
                                <%# Eval("Initials") %>
                            </div>
                            <div class="pl-patient-info">
                                <h3 class="pl-patient-info__name"><%# Eval("FullName") %></h3>
                                <div class="pl-patient-info__meta">
                                    <span class="pl-patient-info__meta-item"><i class="fas fa-birthday-cake"></i> <%# Eval("Age") %> yrs</span>
                                    <span class="pl-patient-info__meta-item"><i class="fas fa-venus-mars"></i> <%# Eval("Gender") %></span>
                                    <span class="pl-patient-info__meta-item"><i class="fas fa-tint"></i> <%# Eval("BloodType") %></span>
                                </div>
                            </div>
                        </div>
                        <div class="pl-patient-card__details">
                            <div class="pl-patient-card__detail-row">
                                <i class="fas fa-notes-medical"></i>
                                <span><strong>Condition:</strong> <%# Eval("ChronicDisease") %></span>
                            </div>
                            <div class="pl-patient-card__detail-row">
                                <i class="fas fa-phone"></i>
                                <span><%# Eval("PhoneNumber") %></span>
                            </div>
                        </div>
                        <div class="pl-patient-card__actions">
                            <asp:LinkButton ID="btnMedications" runat="server" CssClass="pl-btn pl-btn--sm pl-btn--blue" CommandName="OpenMedications" CommandArgument='<%# Eval("PatientId") %>'>
                                <i class="fas fa-pills"></i> Manage Medications
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnNutrition" runat="server" CssClass="pl-btn pl-btn--sm pl-btn--teal" CommandName="OpenNutrition" CommandArgument='<%# Eval("PatientId") %>'>
                                <i class="fas fa-apple-whole"></i> Manage Nutritions
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnRemove" runat="server" CssClass="pl-btn pl-btn--sm pl-btn--danger" CommandName="RequestRemove" CommandArgument='<%# Eval("PatientId") %>' OnClientClick="return confirm('Remove this patient connection?');">
                                <i class="fas fa-trash"></i> Remove
                            </asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlEmptyState" runat="server" CssClass="pl-empty-state" Visible="false">
            <div class="pl-empty-state__icon"><i class="fas fa-user-slash"></i></div>
            <h3 class="pl-empty-state__title">No Active Patients Found</h3>
            <p class="pl-empty-state__sub">There are no active patients to display.</p>
        </asp:Panel>

    </div>

    <asp:Panel ID="pnlToast" runat="server" CssClass="pl-toast" Visible="false">
        <i class="fas fa-check-circle pl-toast__icon"></i>
        <asp:Label ID="lblToastMsg" runat="server" CssClass="pl-toast__msg" Text="Success" />
    </asp:Panel>

    <script src="/js/PatientList.js"></script>
</asp:Content>