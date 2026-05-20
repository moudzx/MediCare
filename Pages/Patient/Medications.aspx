<%@ Page Title="Medications – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="Medications.aspx.cs"
    Inherits="MediCare.Pages.Patient.Medications" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">

    <link rel="stylesheet" href="/css/medications.css" />
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        /* ── Status badges ── */
        .med-status { font-size: 0.78rem; padding: 3px 10px; border-radius: 20px; font-weight: 600; }
        .med-status--active    { background: #d1fae5; color: #065f46; }
        .med-status--stopped   { background: #fee2e2; color: #991b1b; }
        .med-status--completed { background: #e0f2fe; color: #0369a1; }

        /* ── Source badge ── */
        .med-source { font-size: 0.75rem; padding: 2px 8px; border-radius: 20px; display: inline-flex; align-items: center; gap: 4px; white-space: nowrap; }
        .med-source--self   { background: #fef9c3; color: #854d0e; }
        .med-source--doctor { background: #ede9fe; color: #5b21b6; }

        /* ── Stats bar ── */
        .med-stats-bar { display: flex; gap: 12px; margin-bottom: 20px; }
        .med-stat { flex: 1; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 14px; text-align: center; }
        .med-stat__num { display: block; font-size: 1.5rem; font-weight: 700; color: #0284c7; }
        .med-stat__lbl { font-size: 0.75rem; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; }

        /* ── Medication row cards ── */
        .med-list { display: flex; flex-direction: column; gap: 10px; }
        .med-row-card { display: flex; align-items: center; gap: 16px; padding: 14px 18px; border-radius: 10px; border: 1px solid #e2e8f0; background: #fff; transition: box-shadow 0.2s; flex-wrap: wrap; }
        .med-row-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.07); }
        .med-row-card__icon { width: 40px; height: 40px; border-radius: 10px; background: #f0fdf4; color: #16a34a; display: flex; align-items: center; justify-content: center; font-size: 1.1rem; flex-shrink: 0; }
        .med-row-card__main { flex: 1; display: flex; flex-direction: column; gap: 4px; min-width: 140px; }
        .med-row-card__name { font-weight: 600; color: #1e293b; font-size: 0.95rem; }
        .med-row-card__meta { font-size: 0.8rem; color: #64748b; }
        .med-row-card__dates { display: flex; align-items: center; gap: 6px; font-size: 0.8rem; color: #475569; }
        .med-row-card__badges { display: flex; align-items: center; gap: 8px; flex-wrap: wrap; }

        /* ── Empty state ── */
        .med-empty { text-align: center; padding: 40px; color: #94a3b8; }
        .med-empty i { font-size: 2.5rem; margin-bottom: 10px; display: block; }
    </style>

</asp:Content>

<asp:Content ID="PageContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="med-root">

        <!-- PAGE HEADER -->
        <div class="med-page-header">
            <div class="med-page-header__left">
                <div class="med-page-header__icon">
                    <i class="fa-solid fa-pills"></i>
                </div>
                <div>
                    <h1 class="med-page-header__title">My Medications</h1>
                    <p class="med-page-header__sub">Manage your prescriptions and medications</p>
                </div>
            </div>
        </div>

        <!-- MAIN GRID -->
        <div class="med-main-grid">

            <!-- LEFT — MEDICATIONS LIST -->
            <div class="med-card">

                <div class="med-card__header">
                    <div class="med-card__title-group">
                        <div class="med-card__icon med-card__icon--green">
                            <i class="fa-solid fa-clipboard-check"></i>
                        </div>
                        <div>
                            <h2 class="med-card__title">My Medications</h2>
                            <p class="med-card__subtitle">Current treatment plan</p>
                        </div>
                    </div>
                </div>

                <!-- STATS BAR -->
                <div class="med-stats-bar">
                    <div class="med-stat">
                        <span class="med-stat__num"><asp:Label ID="lblTotalMeds" runat="server" Text="0" /></span>
                        <span class="med-stat__lbl">Total</span>
                    </div>
                    <div class="med-stat">
                        <span class="med-stat__num"><asp:Label ID="lblActiveMeds" runat="server" Text="0" /></span>
                        <span class="med-stat__lbl">Active</span>
                    </div>
                    <div class="med-stat">
                        <span class="med-stat__num"><asp:Label ID="lblPrescribed" runat="server" Text="0" /></span>
                        <span class="med-stat__lbl">Prescribed</span>
                    </div>
                </div>

                <!-- SEARCH -->
                <div class="med-search-row">
                    <div class="med-search-wrap">
                        <i class="fa-solid fa-magnifying-glass med-search-icon"></i>
                        <asp:TextBox ID="txtSearchMedication"
                            runat="server"
                            CssClass="med-search-input"
                            placeholder="Search medication..." />
                    </div>
                    <asp:Button ID="btnSearchMedication"
                        runat="server"
                        Text="Search"
                        CssClass="med-btn med-btn--search"
                        OnClick="btnSearchMedication_Click" />
                </div>

                <!-- MESSAGE -->
                <asp:Label ID="lblMessage"
                    runat="server"
                    CssClass="med-inline-msg"
                    Visible="false" />

                <!-- MEDICATION CARDS -->
                <div class="med-list">
                    <asp:Repeater ID="rptMedications" runat="server">
                        <ItemTemplate>
                            <div class="med-row-card">

                                <div class="med-row-card__icon">
                                    <i class="fa-solid fa-pills"></i>
                                </div>

                                <div class="med-row-card__main">
                                    <span class="med-row-card__name"><%# Eval("MedicationName") %></span>
                                    <span class="med-row-card__meta">
                                        <%# Eval("Dosage") %> &bull; <%# Eval("Frequency") %> &bull; <%# Eval("PillsNumber") %> pills
                                    </span>
                                </div>

                                <div class="med-row-card__dates">
                                    <span><%# Eval("StartDate", "{0:MMM dd, yyyy}") %></span>
                                    <i class="fa-solid fa-arrow-right"></i>
                                    <span><%# Eval("EndDate", "{0:MMM dd, yyyy}") %></span>
                                </div>

                                <div class="med-row-card__badges">
                                    <asp:Label runat="server"
                                        CssClass='<%# "med-status med-status--" + Eval("Status").ToString().ToLower() %>'
                                        Text='<%# Eval("Status") %>' />
                                <span class='<%# (Eval("DoctorId") == DBNull.Value || Convert.ToInt32(Eval("DoctorId")) == 0) ? "med-source med-source--self" : "med-source med-source--doctor" %>'>
    <i class='<%# (Eval("DoctorId") == DBNull.Value || Convert.ToInt32(Eval("DoctorId")) == 0) ? "fa-solid fa-user" : "fa-solid fa-user-md" %>'></i>
    <%# (Eval("DoctorId") == DBNull.Value || Convert.ToInt32(Eval("DoctorId")) == 0) ? "Self-added" : "Prescribed" %>
</span>
                                </div>

                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlEmpty" runat="server" CssClass="med-empty" Visible="false">
                        <i class="fa-solid fa-box-open"></i>
                        <p>No medications found.</p>
                    </asp:Panel>
                </div>

                <div class="med-card__footer">
                    <a href="Search.aspx" class="med-btn med-btn--primary">
                        <i class="fa-solid fa-plus"></i>
                        Add Medication
                    </a>
                </div>

            </div>

            <!-- RIGHT — ADD CUSTOM MEDICATION -->
            <div class="med-card">
                <div class="med-card__header">
                    <div class="med-card__title-group">
                        <div class="med-card__icon med-card__icon--purple">
                            <i class="fa-solid fa-capsules"></i>
                        </div>
                        <div>
                            <h2 class="med-card__title">Add Custom Medication</h2>
                            <p class="med-card__subtitle">Save a medication manually</p>
                        </div>
                    </div>
                </div>

                <div class="med-form-body">

                    <div class="med-form-group">
                        <label class="med-label">Medication Name</label>
                        <asp:TextBox ID="txtMedicationName" runat="server" CssClass="med-input" />
                    </div>

                    <div class="med-form-group">
                        <label class="med-label">Dosage</label>
                        <asp:TextBox ID="txtDosage" runat="server" CssClass="med-input" />
                    </div>

                    <div class="med-form-group">
                        <label class="med-label">Frequency</label>
                        <asp:DropDownList ID="ddlFrequency" runat="server" CssClass="med-input">
                            <asp:ListItem Text="Select frequency" Value="" />
                            <asp:ListItem Text="Once Daily"   Value="Once Daily" />
                            <asp:ListItem Text="Twice Daily"  Value="Twice Daily" />
                            <asp:ListItem Text="Every 8 Hours" Value="Every 8 Hours" />
                            <asp:ListItem Text="Weekly"       Value="Weekly" />
                        </asp:DropDownList>
                    </div>

                    <div class="med-form-group">
                        <label class="med-label">Pill Count</label>
                        <asp:TextBox ID="txtPills" runat="server" CssClass="med-input" TextMode="Number" />
                    </div>

                    <div class="med-form-group">
                        <label class="med-label">Start Date</label>
                        <asp:TextBox ID="txtStartDate" runat="server" CssClass="med-input" TextMode="Date" />
                    </div>

                    <div class="med-form-group">
                        <label class="med-label">End Date</label>
                        <asp:TextBox ID="txtEndDate" runat="server" CssClass="med-input" TextMode="Date" />
                    </div>

                    <div class="med-form-footer">
                        <asp:Button ID="btnSaveMedication"
                            runat="server"
                            Text="Save Medication"
                            CssClass="med-btn med-btn--save"
                            OnClick="btnSaveMedication_Click" />
                    </div>

                </div>
            </div>

        </div>
    </div>

</asp:Content>