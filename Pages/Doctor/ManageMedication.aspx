<%@ Page Title="Manage Medication – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="ManageMedication.aspx.cs"
    Inherits="MediCare.Pages.Doctor.ManageMedication" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/ManageMedication.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<!-- ═══════════════════════════════════════════════════════════
     MANAGE MEDICATION PAGE ROOT
═══════════════════════════════════════════════════════════ -->
<div class="mm-root">

    <!-- ── PAGE HEADER ────────────────────────────────────────── -->
    <div class="mm-page-header">
        <div class="mm-page-header__left">
            <div class="mm-page-header__icon">
                <i class="fa-solid fa-pills"></i>
            </div>
            <div>
                <h1 class="mm-page-header__title">Manage Medication</h1>
                <p class="mm-page-header__sub">
                    Patient: <strong id="mmPatientName">Sarah Johnson</strong>
                    &nbsp;·&nbsp; ID: <span id="mmPatientId">PT-20248819</span>
                </p>
            </div>
        </div>
        <div class="mm-page-header__right">
            <div class="mm-header-stat">
                <span class="mm-header-stat__num" id="statTotal">0</span>
                <span class="mm-header-stat__label">Total Meds</span>
            </div>
            <div class="mm-header-stat">
                <span class="mm-header-stat__num" id="statActive">0</span>
                <span class="mm-header-stat__label">Active</span>
            </div>
            <button class="mm-btn mm-btn--primary" id="btnOpenAddMed" onclick="openAddModal()">
                <i class="fa-solid fa-plus"></i> Add Medication
            </button>
        </div>
    </div>

    <!-- ── FILTER / SEARCH BAR ────────────────────────────────── -->
    <div class="mm-toolbar">
        <div class="mm-search-wrap">
            <i class="fa-solid fa-magnifying-glass mm-search-icon"></i>
            <input type="text" id="mmSearchInput" class="mm-search-input"
                placeholder="Search medications..."
                oninput="filterMedications(this.value)" />
        </div>
        <div class="mm-toolbar__filters">
            <button class="mm-filter-btn mm-filter-btn--active" onclick="setFilter('all', this)">All</button>
            <button class="mm-filter-btn" onclick="setFilter('active', this)">Active</button>
            <button class="mm-filter-btn" onclick="setFilter('completed', this)">Completed</button>
        </div>
    </div>

    <!-- ── MEDICATIONS TABLE CARD ──────────────────────────────── -->
    <div class="mm-card">
        <div class="mm-card__header">
            <div class="mm-card__title-group">
                <i class="fa-solid fa-clipboard-list mm-card__hdr-icon"></i>
                <div>
                    <h2 class="mm-card__title">Current Medications</h2>
                    <p class="mm-card__sub">Prescribed medications for this patient</p>
                </div>
            </div>
            <span class="mm-count-badge" id="medCountBadge">0 medications</span>
        </div>

        <!-- Table wrapper (scrollable on mobile) -->
        <div class="mm-table-wrap">
            <table class="mm-table" id="mmTable">
                <thead>
                    <tr class="mm-table__head">
                        <th><i class="fa-solid fa-pills"></i> Medication</th>
                        <th><i class="fa-solid fa-weight-scale"></i> Dosage</th>
                        <th><i class="fa-solid fa-clock"></i> Frequency</th>
                        <th><i class="fa-solid fa-calendar-days"></i> Duration</th>
                        <th><i class="fa-solid fa-circle-dot"></i> Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="mmTableBody">
                    <!-- Filled by JavaScript -->
                </tbody>
            </table>

            <!-- Empty state -->
            <div class="mm-empty" id="mmEmpty" style="display:none;">
                <div class="mm-empty__icon"><i class="fa-solid fa-pills"></i></div>
                <p class="mm-empty__text">No medications found.</p>
                <p class="mm-empty__sub">Click "Add Medication" to prescribe a new medication.</p>
            </div>
        </div>
    </div>

    <!-- ── MEDICATION SUMMARY CARDS ────────────────────────────── -->
    <div class="mm-summary-grid" id="mmSummaryGrid">
        <!-- Filled by JavaScript -->
    </div>

</div>
<!-- end mm-root -->

<!-- ═══════════════════════════════════════════════════════════
     ADD MEDICATION MODAL
═══════════════════════════════════════════════════════════ -->
<div class="mm-modal-overlay" id="addMedModal" onclick="handleOverlayClick(event,'addMedModal')">
    <div class="mm-modal" role="dialog" aria-modal="true" aria-label="Add Medication">

        <!-- Step 1: Search -->
        <div id="modalStep1">
            <div class="mm-modal__header">
                <div class="mm-modal__title-group">
                    <div class="mm-modal__icon mm-modal__icon--blue">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </div>
                    <div>
                        <h3 class="mm-modal__title">Search Medication</h3>
                        <p class="mm-modal__sub">Type to search the medication database</p>
                    </div>
                </div>
                <button class="mm-modal__close" onclick="closeAddModal()" aria-label="Close">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <div class="mm-modal__body">
                <div class="mm-modal-search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" id="modalSearchInput" class="mm-modal-search"
                        placeholder="Search medication name..."
                        oninput="searchMedications(this.value)"
                        autocomplete="off" />
                </div>

                <!-- Search results list -->
                <div class="mm-search-results" id="modalSearchResults">
                    <p class="mm-search-hint">
                        <i class="fa-solid fa-circle-info"></i>
                        Start typing to search from the medication database.
                        <!-- *** DB HOOK: Replace sample data with API call to medication DB *** -->
                    </p>
                </div>
            </div>
        </div>

        <!-- Step 2: Set dosage / frequency / duration -->
        <div id="modalStep2" style="display:none;">
            <div class="mm-modal__header">
                <div class="mm-modal__title-group">
                    <div class="mm-modal__icon mm-modal__icon--green">
                        <i class="fa-solid fa-prescription-bottle-medical"></i>
                    </div>
                    <div>
                        <h3 class="mm-modal__title">Set Prescription Details</h3>
                        <p class="mm-modal__sub" id="step2SelectedMed">Medication selected</p>
                    </div>
                </div>
                <button class="mm-modal__close" onclick="closeAddModal()" aria-label="Close">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>

            <div class="mm-modal__body">
                <div class="mm-form-grid">
                    <div class="mm-form-group mm-form-group--full">
                        <label class="mm-label">
                            <i class="fa-solid fa-weight-scale"></i>
                            Dosage <span class="mm-required">*</span>
                        </label>
                        <input type="text" id="inputDosage" class="mm-input"
                            placeholder="e.g. 500mg, 10mg, 1 tablet" />
                        <span class="mm-error" id="errDosage" style="display:none;">Dosage is required.</span>
                    </div>
                    <div class="mm-form-group">
                        <label class="mm-label">
                            <i class="fa-solid fa-clock"></i>
                            Frequency <span class="mm-required">*</span>
                        </label>
                        <select id="inputFrequency" class="mm-input mm-select">
                            <option value="">Select frequency...</option>
                            <option>Once daily</option>
                            <option>Twice daily</option>
                            <option>Three times daily</option>
                            <option>Every 8 hours</option>
                            <option>Every 12 hours</option>
                            <option>As needed (PRN)</option>
                            <option>Weekly</option>
                            <option>Monthly</option>
                        </select>
                        <span class="mm-error" id="errFrequency" style="display:none;">Frequency is required.</span>
                    </div>
                    <div class="mm-form-group">
                        <label class="mm-label">
                            <i class="fa-solid fa-calendar-days"></i>
                            Duration <span class="mm-required">*</span>
                        </label>
                        <select id="inputDuration" class="mm-input mm-select">
                            <option value="">Select duration...</option>
                            <option>7 days</option>
                            <option>14 days</option>
                            <option>30 days</option>
                            <option>60 days</option>
                            <option>90 days</option>
                            <option>6 months</option>
                            <option>1 year</option>
                            <option>Ongoing</option>
                        </select>
                        <span class="mm-error" id="errDuration" style="display:none;">Duration is required.</span>
                    </div>
                    <div class="mm-form-group mm-form-group--full">
                        <label class="mm-label">
                            <i class="fa-solid fa-note-sticky"></i>
                            Doctor Notes <small>(optional)</small>
                        </label>
                        <textarea id="inputNotes" class="mm-input mm-textarea" rows="3"
                            placeholder="Any special instructions for the patient..."></textarea>
                    </div>
                </div>
            </div>

            <div class="mm-modal__footer">
                <button class="mm-btn mm-btn--ghost" onclick="backToStep1()">
                    <i class="fa-solid fa-arrow-left"></i> Back
                </button>
                <button class="mm-btn mm-btn--primary" onclick="confirmAddMedication()">
                    <i class="fa-solid fa-check"></i> Add Medication
                </button>
            </div>
        </div>

    </div>
</div>

<!-- ═══════════════════════════════════════════════════════════
     EDIT DOSAGE MODAL
═══════════════════════════════════════════════════════════ -->
<div class="mm-modal-overlay" id="editDosageModal" onclick="handleOverlayClick(event,'editDosageModal')">
    <div class="mm-modal mm-modal--sm" role="dialog" aria-modal="true" aria-label="Edit Dosage">
        <div class="mm-modal__header">
            <div class="mm-modal__title-group">
                <div class="mm-modal__icon mm-modal__icon--orange">
                    <i class="fa-solid fa-pen-to-square"></i>
                </div>
                <div>
                    <h3 class="mm-modal__title">Edit Dosage</h3>
                    <p class="mm-modal__sub" id="editModalMedName">Medication name</p>
                </div>
            </div>
            <button class="mm-modal__close" onclick="closeEditModal()" aria-label="Close">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        <div class="mm-modal__body">
            <div class="mm-form-group">
                <label class="mm-label">
                    <i class="fa-solid fa-weight-scale"></i>
                    New Dosage <span class="mm-required">*</span>
                </label>
                <input type="text" id="editDosageInput" class="mm-input"
                    placeholder="e.g. 500mg" />
                <span class="mm-error" id="errEditDosage" style="display:none;">Dosage is required.</span>
            </div>
        </div>
        <div class="mm-modal__footer">
            <button class="mm-btn mm-btn--ghost" onclick="closeEditModal()">Cancel</button>
            <button class="mm-btn mm-btn--orange" onclick="confirmEditDosage()">
                <i class="fa-solid fa-floppy-disk"></i> Save Dosage
            </button>
        </div>
    </div>
</div>

</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="/js/ManageMedication.js"></script>
</asp:Content>