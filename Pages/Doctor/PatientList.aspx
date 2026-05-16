<%@ Page Title="Patient List" Language="C#" MasterPageFile="~/MasterPage/DoctorSite.Master" AutoEventWireup="true" CodeBehind="PatientList.aspx.cs" Inherits="MediCare.Pages.Doctor.PatientList" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%-- Link the PatientList stylesheet --%>
    <link rel="stylesheet" href="/css/PatientList.css" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- ═══════════════════════════════════════════════════════════
         PATIENT LIST PAGE ROOT
         ═══════════════════════════════════════════════════════════ --%>
    <div class="pl-root">

        <%-- ── Page Header ─────────────────────────────────────── --%>
        <div class="pl-page-header">
            <div class="pl-page-header__left">
                <div class="pl-page-header__icon">
                    <i class="fas fa-users"></i>
                </div>
                <div>
                    <h1 class="pl-page-header__title">Patient List</h1>
                    <p class="pl-page-header__sub">Manage your registered patients, medications &amp; nutrition plans</p>
                </div>
            </div>
            <div class="pl-page-header__right">
                <%-- ASP.NET Button (can be wired to code-behind for DB add later) --%>
                <asp:Button ID="btnAddPatient" runat="server" Text="+ Add Patient"
                    CssClass="pl-btn pl-btn--primary" OnClientClick="openAddPatientModal(); return false;" />
            </div>
        </div>

        <%-- ── Stats Bar ───────────────────────────────────────── --%>
        <div class="pl-stats-bar">
            <div class="pl-stat-pill pl-stat-pill--blue">
                <i class="fas fa-users"></i>
                <span class="pl-stat-pill__num" id="statTotal">0</span>
                <span class="pl-stat-pill__label">Total Patients</span>
            </div>
            <div class="pl-stat-pill pl-stat-pill--green">
                <i class="fas fa-heartbeat"></i>
                <span class="pl-stat-pill__num" id="statActive">0</span>
                <span class="pl-stat-pill__label">Active</span>
            </div>
            <div class="pl-stat-pill pl-stat-pill--orange">
                <i class="fas fa-clock"></i>
                <span class="pl-stat-pill__num" id="statUpcoming">0</span>
                <span class="pl-stat-pill__label">Upcoming Appts</span>
            </div>
            <div class="pl-stat-pill pl-stat-pill--teal">
                <i class="fas fa-pills"></i>
                <span class="pl-stat-pill__num" id="statOnMeds">0</span>
                <span class="pl-stat-pill__label">On Medication</span>
            </div>
        </div>

        <%-- ── Search & Filter Bar ────────────────────────────── --%>
        <div class="pl-toolbar">
            <div class="pl-search-wrap">
                <i class="fas fa-search pl-search-wrap__icon"></i>
                <%-- ASP.NET TextBox for search (client-side filtering via JS) --%>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="pl-search-input"
                    placeholder="Search patients by name, condition, gender…"
                    AutoPostBack="false" />
                <button class="pl-search-clear" id="btnClearSearch" onclick="clearSearch(); return false;" title="Clear">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="pl-filter-group">
                <%-- Gender filter --%>
                <asp:DropDownList ID="ddlGender" runat="server" CssClass="pl-select"
                    onchange="applyFilters()">
                    <asp:ListItem Value="">All Genders</asp:ListItem>
                    <asp:ListItem Value="Male">Male</asp:ListItem>
                    <asp:ListItem Value="Female">Female</asp:ListItem>
                </asp:DropDownList>
                <%-- Status filter --%>
                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="pl-select"
                    onchange="applyFilters()">
                    <asp:ListItem Value="">All Statuses</asp:ListItem>
                    <asp:ListItem Value="Stable">Stable</asp:ListItem>
                    <asp:ListItem Value="Critical">Critical</asp:ListItem>
                    <asp:ListItem Value="Recovering">Recovering</asp:ListItem>
                    <asp:ListItem Value="Under Observation">Under Observation</asp:ListItem>
                </asp:DropDownList>
                <%-- View toggle --%>
                <div class="pl-view-toggle">
                    <button class="pl-view-btn pl-view-btn--active" id="btnGridView"
                        onclick="setView('grid'); return false;" title="Grid View">
                        <i class="fas fa-th-large"></i>
                    </button>
                    <button class="pl-view-btn" id="btnListView"
                        onclick="setView('list'); return false;" title="List View">
                        <i class="fas fa-list"></i>
                    </button>
                </div>
            </div>
        </div>

        <%-- ── Results Info ────────────────────────────────────── --%>
        <div class="pl-results-info">
            <span id="resultsCount">Showing <strong>0</strong> patients</span>
        </div>

        <%-- ── Patient Grid (rendered by JS) ─────────────────── --%>
        <div class="pl-patient-grid" id="patientGrid">
            <%-- Patient cards injected here dynamically by PatientList.js --%>
        </div>

        <%-- Empty state shown when no results --%>
        <div class="pl-empty-state" id="emptyState" style="display:none;">
            <div class="pl-empty-state__icon"><i class="fas fa-user-slash"></i></div>
            <h3 class="pl-empty-state__title">No Patients Found</h3>
            <p class="pl-empty-state__sub">Try adjusting your search or filter criteria.</p>
        </div>

    </div><%-- end pl-root --%>


    <%-- ═══════════════════════════════════════════════════════════
         REMOVE CONFIRMATION MODAL
         ═══════════════════════════════════════════════════════════ --%>
    <div class="pl-modal-overlay" id="removeModal">
        <div class="pl-modal pl-modal--sm">
            <div class="pl-modal__header pl-modal__header--danger">
                <div class="pl-modal__header-icon"><i class="fas fa-user-minus"></i></div>
                <h2 class="pl-modal__title">Remove Patient</h2>
                <button class="pl-modal__close" onclick="closeModal('removeModal')">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="pl-modal__body">
                <p class="pl-confirm-text">Are you sure you want to remove
                    <strong id="removePatientName"></strong> from your patient list?
                    This action cannot be undone.</p>
            </div>
            <div class="pl-modal__footer">
                <button class="pl-btn pl-btn--ghost" onclick="closeModal('removeModal')">Cancel</button>
                <button class="pl-btn pl-btn--danger" id="btnConfirmRemove"
                    onclick="confirmRemovePatient()">
                    <i class="fas fa-trash-alt"></i> Remove Patient
                </button>
            </div>
        </div>
    </div>


    <%-- ═══════════════════════════════════════════════════════════
         MEDICATIONS MODAL
         ═══════════════════════════════════════════════════════════ --%>
    <div class="pl-modal-overlay" id="medModal">
        <div class="pl-modal pl-modal--lg">
            <div class="pl-modal__header pl-modal__header--blue">
                <div class="pl-modal__header-icon"><i class="fas fa-pills"></i></div>
                <h2 class="pl-modal__title">Manage Medications</h2>
                <button class="pl-modal__close" onclick="closeModal('medModal')">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="pl-modal__body">
                <%-- Patient name banner --%>
                <div class="pl-modal-patient-banner" id="medPatientBanner"></div>

                <%-- Tabs --%>
                <div class="pl-tabs">
                    <button class="pl-tab pl-tab--active" onclick="switchMedTab('list', this)">
                        <i class="fas fa-list-ul"></i> Current Medications
                    </button>
                    <button class="pl-tab" onclick="switchMedTab('add', this)">
                        <i class="fas fa-plus-circle"></i> Add Medication
                    </button>
                </div>

                <%-- Tab: Medication List --%>
                <div class="pl-tab-panel" id="medTabList">
                    <div class="pl-med-list" id="medListContainer">
                        <%-- Medication cards rendered by JS --%>
                    </div>
                </div>

                <%-- Tab: Add / Edit Medication Form --%>
                <div class="pl-tab-panel pl-tab-panel--hidden" id="medTabAdd">
                    <div class="pl-form-card">
                        <h3 class="pl-form-card__title" id="medFormTitle">Add New Medication</h3>

                        <%-- Hidden field to store editing medication ID --%>
                        <%-- TODO: When integrating with DB, use this ID for UPDATE query --%>
                        <input type="hidden" id="hdnEditMedId" value="" />

                        <div class="pl-form-grid">
                            <%-- Medication Name --%>
                            <div class="pl-form-group pl-form-group--full">
                                <label class="pl-label">
                                    <i class="fas fa-capsules"></i> Medication Name
                                </label>
                                <asp:TextBox ID="txtMedName" runat="server" CssClass="pl-input"
                                    placeholder="e.g. Amoxicillin" AutoPostBack="false" />
                                <span class="pl-form-error" id="errMedName"></span>
                            </div>
                            <%-- Dosage --%>
                            <div class="pl-form-group">
                                <label class="pl-label">
                                    <i class="fas fa-weight"></i> Dosage
                                </label>
                                <asp:TextBox ID="txtMedDosage" runat="server" CssClass="pl-input"
                                    placeholder="e.g. 500mg" AutoPostBack="false" />
                                <span class="pl-form-error" id="errMedDosage"></span>
                            </div>
                            <%-- Frequency --%>
                            <div class="pl-form-group">
                                <label class="pl-label">
                                    <i class="fas fa-clock"></i> Frequency
                                </label>
                                <asp:DropDownList ID="ddlMedFrequency" runat="server" CssClass="pl-select pl-input">
                                    <asp:ListItem Value="">Select frequency…</asp:ListItem>
                                    <asp:ListItem Value="Once daily">Once daily</asp:ListItem>
                                    <asp:ListItem Value="Twice daily">Twice daily</asp:ListItem>
                                    <asp:ListItem Value="Three times daily">Three times daily</asp:ListItem>
                                    <asp:ListItem Value="Every 6 hours">Every 6 hours</asp:ListItem>
                                    <asp:ListItem Value="Every 8 hours">Every 8 hours</asp:ListItem>
                                    <asp:ListItem Value="As needed">As needed</asp:ListItem>
                                    <asp:ListItem Value="Weekly">Weekly</asp:ListItem>
                                </asp:DropDownList>
                                <span class="pl-form-error" id="errMedFrequency"></span>
                            </div>
                            <%-- Duration --%>
                            <div class="pl-form-group">
                                <label class="pl-label">
                                    <i class="fas fa-hourglass-half"></i> Duration
                                </label>
                                <asp:TextBox ID="txtMedDuration" runat="server" CssClass="pl-input"
                                    placeholder="e.g. 7 days" AutoPostBack="false" />
                            </div>
                            <%-- Start Date --%>
                            <div class="pl-form-group">
                                <label class="pl-label">
                                    <i class="fas fa-calendar-plus"></i> Start Date
                                </label>
                                <asp:TextBox ID="txtMedStartDate" runat="server" CssClass="pl-input"
                                    TextMode="Date" AutoPostBack="false" />
                                <span class="pl-form-error" id="errMedStart"></span>
                            </div>
                            <%-- End Date --%>
                            <div class="pl-form-group">
                                <label class="pl-label">
                                    <i class="fas fa-calendar-minus"></i> End Date
                                </label>
                                <asp:TextBox ID="txtMedEndDate" runat="server" CssClass="pl-input"
                                    TextMode="Date" AutoPostBack="false" />
                                <span class="pl-form-error" id="errMedEnd"></span>
                            </div>
                            <%-- Notes --%>
                            <div class="pl-form-group pl-form-group--full">
                                <label class="pl-label">
                                    <i class="fas fa-sticky-note"></i> Notes (Optional)
                                </label>
                                <asp:TextBox ID="txtMedNotes" runat="server" CssClass="pl-input pl-textarea"
                                    TextMode="MultiLine" Rows="3"
                                    placeholder="Additional instructions or notes…" AutoPostBack="false" />
                            </div>
                        </div><%-- end pl-form-grid --%>

                        <div class="pl-form-actions">
                            <button class="pl-btn pl-btn--ghost" onclick="switchMedTab('list', null); return false;">
                                <i class="fas fa-arrow-left"></i> Back to List
                            </button>
                            <button class="pl-btn pl-btn--blue" onclick="saveMedication(); return false;">
                                <i class="fas fa-save"></i> Save Medication
                            </button>
                        </div>
                    </div>
                </div>

            </div><%-- end modal body --%>
        </div>
    </div>


    <%-- ═══════════════════════════════════════════════════════════
         NUTRITION MODAL
         ═══════════════════════════════════════════════════════════ --%>
    <div class="pl-modal-overlay" id="nutModal">
        <div class="pl-modal pl-modal--lg">
            <div class="pl-modal__header pl-modal__header--green">
                <div class="pl-modal__header-icon"><i class="fas fa-apple-alt"></i></div>
                <h2 class="pl-modal__title">Manage Nutrition Plans</h2>
                <button class="pl-modal__close" onclick="closeModal('nutModal')">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="pl-modal__body">
                <%-- Patient name banner --%>
                <div class="pl-modal-patient-banner" id="nutPatientBanner"></div>

                <%-- Tabs --%>
                <div class="pl-tabs">
                    <button class="pl-tab pl-tab--active" onclick="switchNutTab('list', this)">
                        <i class="fas fa-list-ul"></i> Nutrition Plans
                    </button>
                    <button class="pl-tab" onclick="switchNutTab('add', this)">
                        <i class="fas fa-plus-circle"></i> Add Plan
                    </button>
                </div>

                <%-- Tab: Nutrition Plan List --%>
                <div class="pl-tab-panel" id="nutTabList">
                    <div class="pl-nut-list" id="nutListContainer">
                        <%-- Nutrition plan cards rendered by JS --%>
                    </div>
                </div>

                <%-- Tab: Add / Edit Nutrition Form --%>
                <div class="pl-tab-panel pl-tab-panel--hidden" id="nutTabAdd">
                    <div class="pl-form-card">
                        <h3 class="pl-form-card__title" id="nutFormTitle">Add Nutrition Plan</h3>

                        <%-- TODO: When integrating with DB, use hdnEditNutId for UPDATE query --%>
                        <input type="hidden" id="hdnEditNutId" value="" />

                        <div class="pl-form-grid">
                            <%-- Plan Name --%>
                            <div class="pl-form-group pl-form-group--full">
                                <label class="pl-label">
                                    <i class="fas fa-tag"></i> Plan Name
                                </label>
                                <asp:TextBox ID="txtNutPlanName" runat="server" CssClass="pl-input"
                                    placeholder="e.g. Low Carb Recovery Plan" AutoPostBack="false" />
                                <span class="pl-form-error" id="errNutName"></span>
                            </div>
                            <%-- Calories --%>
                            <div class="pl-form-group">
                                <label class="pl-label">
                                    <i class="fas fa-fire"></i> Daily Calories (kcal)
                                </label>
                                <asp:TextBox ID="txtNutCalories" runat="server" CssClass="pl-input"
                                    placeholder="e.g. 1800" TextMode="Number" AutoPostBack="false" />
                                <span class="pl-form-error" id="errNutCal"></span>
                            </div>
                            <%-- Protein --%>
                            <div class="pl-form-group">
                                <label class="pl-label">
                                    <i class="fas fa-drumstick-bite"></i> Protein (g)
                                </label>
                                <asp:TextBox ID="txtNutProtein" runat="server" CssClass="pl-input"
                                    placeholder="e.g. 80" TextMode="Number" AutoPostBack="false" />
                            </div>
                            <%-- Carbs --%>
                            <div class="pl-form-group">
                                <label class="pl-label">
                                    <i class="fas fa-bread-slice"></i> Carbohydrates (g)
                                </label>
                                <asp:TextBox ID="txtNutCarbs" runat="server" CssClass="pl-input"
                                    placeholder="e.g. 200" TextMode="Number" AutoPostBack="false" />
                            </div>
                            <%-- Fat --%>
                            <div class="pl-form-group">
                                <label class="pl-label">
                                    <i class="fas fa-cheese"></i> Fat (g)
                                </label>
                                <asp:TextBox ID="txtNutFat" runat="server" CssClass="pl-input"
                                    placeholder="e.g. 60" TextMode="Number" AutoPostBack="false" />
                            </div>
                            <%-- Notes --%>
                            <div class="pl-form-group pl-form-group--full">
                                <label class="pl-label">
                                    <i class="fas fa-sticky-note"></i> Notes / Dietary Restrictions
                                </label>
                                <asp:TextBox ID="txtNutNotes" runat="server" CssClass="pl-input pl-textarea"
                                    TextMode="MultiLine" Rows="3"
                                    placeholder="Allergies, restrictions, meal timing…" AutoPostBack="false" />
                            </div>
                        </div><%-- end pl-form-grid --%>

                        <div class="pl-form-actions">
                            <button class="pl-btn pl-btn--ghost" onclick="switchNutTab('list', null); return false;">
                                <i class="fas fa-arrow-left"></i> Back to Plans
                            </button>
                            <button class="pl-btn pl-btn--green" onclick="saveNutritionPlan(); return false;">
                                <i class="fas fa-save"></i> Save Plan
                            </button>
                        </div>
                    </div>
                </div>

            </div><%-- end modal body --%>
        </div>
    </div>


    <%-- ═══════════════════════════════════════════════════════════
         SUCCESS / TOAST NOTIFICATION
         ═══════════════════════════════════════════════════════════ --%>
    <div class="pl-toast" id="toastNotif">
        <i class="fas fa-check-circle pl-toast__icon"></i>
        <span class="pl-toast__msg" id="toastMsg">Action completed successfully.</span>
    </div>


    <%-- Link the PatientList JavaScript (placed at bottom for DOM-ready) --%>
    <script src="/js/PatientList.js"></script>

</asp:Content>
