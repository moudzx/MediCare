<%@ Page Title="Patient Dashboard – MediCare" Language="C#" MasterPageFile="~/MasterPage/PatientSite.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="MediCare.Patient.Dashboard" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
      <link rel="stylesheet" href="/css/default.css" />
<link runat="server" rel="stylesheet" href="/css/dashboard.css" /></asp:Content>


<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="pd-root">

    <!-- ══════════════════════════════
         TOP WELCOME BAR
    ══════════════════════════════ -->
    <div class="pd-topbar">
        <div class="pd-topbar__left">
            <div class="pd-topbar__avatar">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                </svg>
            </div>
            <div>
                <p class="pd-topbar__greeting">Good morning 👋</p>
                <h1 class="pd-topbar__name">Sara Al-Khalil</h1>
            </div>
        </div>
        <div class="pd-topbar__right">
            <div class="pd-topbar__date">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
                </svg>
                Sunday, May 10, 2025
            </div>
            <div class="pd-topbar__badge">
                <span class="pd-status-dot"></span>
                Active Patient
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════
         QUICK STATS ROW
    ══════════════════════════════ -->
    <div class="pd-quick-stats">
        <div class="pd-qs-card">
            <div class="pd-qs-icon pd-qs-icon--green">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
                </svg>
            </div>
            <div class="pd-qs-body">
                <span class="pd-qs-value">3</span>
                <span class="pd-qs-label">Doses Today</span>
            </div>
        </div>
        <div class="pd-qs-card">
            <div class="pd-qs-icon pd-qs-icon--blue">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M9 12l2 2 4-4"/><path d="M21 12c0 4.97-4.03 9-9 9S3 16.97 3 12 7.03 3 12 3s9 4.03 9 9z"/>
                </svg>
            </div>
            <div class="pd-qs-body">
                <span class="pd-qs-value">1</span>
                <span class="pd-qs-label">Taken So Far</span>
            </div>
        </div>
        <div class="pd-qs-card">
            <div class="pd-qs-icon pd-qs-icon--orange">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                </svg>
            </div>
            <div class="pd-qs-body">
                <span class="pd-qs-value">2</span>
                <span class="pd-qs-label">Remaining</span>
            </div>
        </div>
        <div class="pd-qs-card">
            <div class="pd-qs-icon pd-qs-icon--purple">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                </svg>
            </div>
            <div class="pd-qs-body">
                <span class="pd-qs-value">92%</span>
                <span class="pd-qs-label">Adherence Rate</span>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════
         MAIN GRID
    ══════════════════════════════ -->
    <div class="pd-main-grid">

        <!-- ── LEFT COLUMN ── -->
        <div class="pd-col-left">

            <!-- ════════════════════════════
                 CARD 1 — HEALTH INFORMATION
            ════════════════════════════ -->
            <div class="pd-card" id="cardHealthInfo">
                <div class="pd-card__header">
                    <div class="pd-card__title-group">
                        <div class="pd-card__icon pd-card__icon--green">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>
                        <div>
                            <h2 class="pd-card__title">Health Information</h2>
                            <p class="pd-card__subtitle">Your personal health profile</p>
                        </div>
                    </div>
                    <div class="pd-card__actions">
                        <button class="mc-btn mc-btn--ghost mc-btn--sm pd-edit-btn" id="btnEditHealth" type="button">✏ Edit</button>
                        <button class="mc-btn mc-btn--primary mc-btn--sm pd-save-btn" id="btnSaveHealth" type="button" style="display:none;">Save Changes</button>
                        <button class="mc-btn mc-btn--ghost mc-btn--sm pd-cancel-btn" id="btnCancelHealth" type="button" style="display:none;">Cancel</button>
                    </div>
                </div>

                <div id="healthSuccessMsg" class="pd-inline-msg pd-inline-msg--success" style="display:none; margin: 16px 28px 0;">
                    ✓ Health information updated successfully.
                </div>

                <!-- VIEW MODE -->
                <div id="pnlHealthView" class="pd-health-view">
                    <div class="pd-hv-grid">
                        <div class="pd-hv-item">
                            <div class="pd-hv-icon">📏</div>
                            <div class="pd-hv-body">
                                <span class="pd-hv-label">Height</span>
                                <span class="pd-hv-value" id="viewHeight">172 <small>cm</small></span>
                            </div>
                        </div>
                        <div class="pd-hv-item">
                            <div class="pd-hv-icon">⚖️</div>
                            <div class="pd-hv-body">
                                <span class="pd-hv-label">Weight</span>
                                <span class="pd-hv-value" id="viewWeight">65 <small>kg</small></span>
                            </div>
                        </div>
                        <div class="pd-hv-item">
                            <div class="pd-hv-icon">🔥</div>
                            <div class="pd-hv-body">
                                <span class="pd-hv-label">Daily Calories</span>
                                <span class="pd-hv-value" id="viewCalories">1,850 <small>kcal</small></span>
                            </div>
                        </div>
                        <div class="pd-hv-item">
                            <div class="pd-hv-icon">🩸</div>
                            <div class="pd-hv-body">
                                <span class="pd-hv-label">Blood Type</span>
                                <span class="pd-hv-value" id="viewBloodType">A+</span>
                            </div>
                        </div>
                        <div class="pd-hv-item">
                            <div class="pd-hv-icon">🎂</div>
                            <div class="pd-hv-body">
                                <span class="pd-hv-label">Age</span>
                                <span class="pd-hv-value" id="viewAge">29 <small>yrs</small></span>
                            </div>
                        </div>
                        <div class="pd-hv-item">
                            <div class="pd-hv-icon">💉</div>
                            <div class="pd-hv-body">
                                <span class="pd-hv-label">Chronic Disease</span>
                                <span class="pd-hv-value pd-hv-value--sm" id="viewChronic">Diabetes Type 2</span>
                            </div>
                        </div>
                        <div class="pd-hv-item pd-hv-item--wide">
                            <div class="pd-hv-icon">♿</div>
                            <div class="pd-hv-body">
                                <span class="pd-hv-label">Disability</span>
                                <span class="pd-hv-value pd-hv-value--sm" id="viewDisability">None</span>
                            </div>
                        </div>
                        <div class="pd-hv-item pd-hv-item--wide">
                            <div class="pd-hv-icon">👨‍👩‍👧</div>
                            <div class="pd-hv-body">
                                <span class="pd-hv-label">Family History</span>
                                <span class="pd-hv-value pd-hv-value--sm" id="viewFamily">Father: Hypertension, Mother: Diabetes</span>
                            </div>
                        </div>
                    </div>

                    <!-- BMI Bar -->
                    <div class="pd-bmi-block">
                        <div class="pd-bmi-header">
                            <span class="pd-bmi-label">BMI Index</span>
                            <span class="pd-bmi-value">22.0 — <span class="pd-bmi-cat pd-bmi-cat--ok" id="bmiCatLabel">Normal</span></span>
                        </div>
                        <div class="pd-bmi-track">
                            <div class="pd-bmi-fill" id="bmiFill" style="width:0%"></div>
                        </div>
                        <div class="pd-bmi-scale">
                            <span>Underweight</span><span>Normal</span><span>Overweight</span><span>Obese</span>
                        </div>
                    </div>
                </div>

                <!-- EDIT MODE -->
                <div id="pnlHealthEdit" class="pd-health-edit" style="display:none;">
                    <div class="pd-edit-grid">
                        <div class="pd-edit-field">
                            <label class="mc-label">Height <small>(cm)</small></label>
                            <input type="number" id="editHeight" class="mc-input" placeholder="e.g. 172" value="172" />
                        </div>
                        <div class="pd-edit-field">
                            <label class="mc-label">Weight <small>(kg)</small></label>
                            <input type="number" id="editWeight" class="mc-input" placeholder="e.g. 65" value="65" />
                        </div>
                        <div class="pd-edit-field">
                            <label class="mc-label">Daily Calories <small>(kcal)</small></label>
                            <input type="number" id="editCalories" class="mc-input" placeholder="e.g. 1850" value="1850" />
                        </div>
                        <div class="pd-edit-field">
                            <label class="mc-label">Blood Type</label>
                            <select id="editBloodType" class="mc-input mc-select">
                                <option value="">Select...</option>
                                <option value="A+" selected>A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>
                        <div class="pd-edit-field">
                            <label class="mc-label">Age <small>(years)</small></label>
                            <input type="number" id="editAge" class="mc-input" placeholder="e.g. 29" value="29" />
                        </div>
                        <div class="pd-edit-field">
                            <label class="mc-label">Chronic Disease</label>
                            <input type="text" id="editChronic" class="mc-input" placeholder="e.g. Diabetes Type 2, None" value="Diabetes Type 2" />
                        </div>
                        <div class="pd-edit-field pd-edit-field--full">
                            <label class="mc-label">Disability</label>
                            <input type="text" id="editDisability" class="mc-input" placeholder="e.g. None" value="None" />
                        </div>
                        <div class="pd-edit-field pd-edit-field--full">
                            <label class="mc-label">Family Disease History</label>
                            <textarea id="editFamily" class="mc-input mc-textarea" rows="3" placeholder="e.g. Father: Hypertension, Mother: Diabetes">Father: Hypertension, Mother: Diabetes</textarea>
                        </div>
                    </div>
                </div>

            </div>

        </div>

        <!-- ── RIGHT COLUMN ── -->
        <div class="pd-col-right">

            <!-- ════════════════════════════
                 CARD 2 — TODAY'S DOSES
            ════════════════════════════ -->
            <div class="pd-card pd-card--doses">
                <div class="pd-card__header">
                    <div class="pd-card__title-group">
                        <div class="pd-card__icon pd-card__icon--blue">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M10.5 20H4a2 2 0 0 1-2-2V5c0-1.1.9-2 2-2h3.93a2 2 0 0 1 1.66.9l.82 1.2a2 2 0 0 0 1.66.9H20a2 2 0 0 1 2 2v3"/>
                                <circle cx="18" cy="18" r="3"/><path d="m22 22-1.5-1.5"/>
                            </svg>
                        </div>
                        <div>
                            <h2 class="pd-card__title">Today's Scheduled Doses</h2>
                            <p class="pd-card__subtitle">3 medications scheduled</p>
                        </div>
                    </div>
                    <div class="pd-dpm-ring">
                        <svg viewBox="0 0 36 36" width="52" height="52">
                            <circle cx="18" cy="18" r="15.9" fill="none" stroke="#E5E7EB" stroke-width="3"/>
                            <circle id="dpmArc" cx="18" cy="18" r="15.9" fill="none" stroke="#1A9E5C" stroke-width="3"
                                stroke-dasharray="33 67" stroke-dashoffset="25" stroke-linecap="round"/>
                        </svg>
                        <span class="pd-dpm-pct" id="dpmPct">33%</span>
                    </div>
                </div>

                <!-- Dose Rows -->
                <div class="pd-doses-list" id="dosesList">

                    <div class="pd-dose-row pd-dose-row--taken" id="doseRow1">
                        <label class="pd-custom-check">
                            <input type="checkbox" id="chk1" checked onchange="onDoseChange()" />
                            <span class="pd-check-box"></span>
                        </label>
                        <div class="pd-dose-pill-icon pd-dose-pill-icon--blue">💊</div>
                        <div class="pd-dose-info">
                            <span class="pd-dose-name">Metformin</span>
                            <span class="pd-dose-detail">500mg · With breakfast</span>
                        </div>
                        <div class="pd-dose-time">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            8:00 AM
                        </div>
                        <div class="pd-dose-status pd-dose-status--done" id="status1">✓ Taken</div>
                    </div>

                    <div class="pd-dose-row pd-dose-row--pending" id="doseRow2">
                        <label class="pd-custom-check">
                            <input type="checkbox" id="chk2" onchange="onDoseChange()" />
                            <span class="pd-check-box"></span>
                        </label>
                        <div class="pd-dose-pill-icon pd-dose-pill-icon--orange">💊</div>
                        <div class="pd-dose-info">
                            <span class="pd-dose-name">Lisinopril</span>
                            <span class="pd-dose-detail">10mg · With lunch</span>
                        </div>
                        <div class="pd-dose-time">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            1:00 PM
                        </div>
                        <div class="pd-dose-status pd-dose-status--pending" id="status2">⏱ Pending</div>
                    </div>

                    <div class="pd-dose-row" id="doseRow3">
                        <label class="pd-custom-check">
                            <input type="checkbox" id="chk3" onchange="onDoseChange()" />
                            <span class="pd-check-box"></span>
                        </label>
                        <div class="pd-dose-pill-icon pd-dose-pill-icon--purple">💊</div>
                        <div class="pd-dose-info">
                            <span class="pd-dose-name">Atorvastatin</span>
                            <span class="pd-dose-detail">20mg · With dinner</span>
                        </div>
                        <div class="pd-dose-time">
                            <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                            9:00 PM
                        </div>
                        <div class="pd-dose-status pd-dose-status--upcoming" id="status3">🌙 Tonight</div>
                    </div>

                </div>

                <!-- Doses Footer -->
                <div class="pd-doses-footer">
                    <div class="pd-doses-bar">
                        <div class="pd-doses-bar__fill" id="dosesBarFill" style="width:33%"></div>
                    </div>
                    <div class="pd-doses-footer__text">
                        <span id="dosesSummaryText">1 of 3 doses completed today</span>
                        <button class="mc-btn mc-btn--primary mc-btn--sm" type="button" onclick="saveDoses()">Save Progress</button>
                    </div>
                </div>

                <div id="dosesMsg" class="pd-inline-msg pd-inline-msg--success" style="display:none; margin:12px 28px 16px;">
                    ✓ Dose progress saved successfully.
                </div>

            </div>

            <!-- ════════════════════════════
                 CARD 3 — PILL INVENTORY
            ════════════════════════════ -->
            <div class="pd-card pd-card--inventory">
                <div class="pd-card__header">
                    <div class="pd-card__title-group">
                        <div class="pd-card__icon pd-card__icon--orange">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18"/>
                            </svg>
                        </div>
                        <div>
                            <h2 class="pd-card__title">Pill Inventory</h2>
                            <p class="pd-card__subtitle">Remaining doses per medication</p>
                        </div>
                    </div>
                </div>
                <div class="pd-inventory-list">
                    <div class="pd-inv-item">
                        <div class="pd-inv-left">
                            <span class="pd-inv-dot pd-inv-dot--blue"></span>
                            <div>
                                <span class="pd-inv-name">Metformin 500mg</span>
                                <span class="pd-inv-detail">24 pills remaining</span>
                            </div>
                        </div>
                        <div class="pd-inv-right">
                            <div class="pd-inv-track">
                                <div class="pd-inv-fill pd-inv-fill--blue" style="width:0%" data-target="80%"></div>
                            </div>
                            <span class="pd-inv-count">24</span>
                        </div>
                    </div>
                    <div class="pd-inv-item">
                        <div class="pd-inv-left">
                            <span class="pd-inv-dot pd-inv-dot--orange"></span>
                            <div>
                                <span class="pd-inv-name">Lisinopril 10mg</span>
                                <span class="pd-inv-detail">8 pills remaining</span>
                            </div>
                        </div>
                        <div class="pd-inv-right">
                            <div class="pd-inv-track">
                                <div class="pd-inv-fill pd-inv-fill--orange" style="width:0%" data-target="27%"></div>
                            </div>
                            <span class="pd-inv-count pd-inv-count--low">8 ⚠</span>
                        </div>
                    </div>
                    <div class="pd-inv-item">
                        <div class="pd-inv-left">
                            <span class="pd-inv-dot pd-inv-dot--purple"></span>
                            <div>
                                <span class="pd-inv-name">Atorvastatin 20mg</span>
                                <span class="pd-inv-detail">30 pills remaining</span>
                            </div>
                        </div>
                        <div class="pd-inv-right">
                            <div class="pd-inv-track">
                                <div class="pd-inv-fill pd-inv-fill--purple" style="width:0%" data-target="100%"></div>
                            </div>
                            <span class="pd-inv-count">30</span>
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>
</div>

<!-- ══════════════════════════════
     INLINE JAVASCRIPT (frontend only, no postback)
══════════════════════════════ -->
<script>
(function () {

    /* ── Edit / Save / Cancel toggle ─────────────────────────── */
    var btnEdit   = document.getElementById('btnEditHealth');
    var btnSave   = document.getElementById('btnSaveHealth');
    var btnCancel = document.getElementById('btnCancelHealth');
    var viewPanel = document.getElementById('pnlHealthView');
    var editPanel = document.getElementById('pnlHealthEdit');
    var successMsg = document.getElementById('healthSuccessMsg');

    btnEdit.addEventListener('click', function () {
        viewPanel.style.display = 'none';
        editPanel.style.display = 'block';
        editPanel.style.animation = 'pd-slideDown .3s ease both';
        btnEdit.style.display   = 'none';
        btnSave.style.display   = 'inline-flex';
        btnCancel.style.display = 'inline-flex';
        successMsg.style.display = 'none';
    });

    btnCancel.addEventListener('click', function () {
        viewPanel.style.display = 'block';
        editPanel.style.display = 'none';
        btnEdit.style.display   = 'inline-flex';
        btnSave.style.display   = 'none';
        btnCancel.style.display = 'none';
        successMsg.style.display = 'none';
    });

    btnSave.addEventListener('click', function () {
        var h  = document.getElementById('editHeight').value    || '172';
        var w  = document.getElementById('editWeight').value    || '65';
        var cal = document.getElementById('editCalories').value || '1850';
        var bt  = document.getElementById('editBloodType').value || 'A+';
        var age = document.getElementById('editAge').value      || '29';
        var ch  = document.getElementById('editChronic').value  || 'None';
        var dis = document.getElementById('editDisability').value || 'None';
        var fam = document.getElementById('editFamily').value   || 'None';

        document.getElementById('viewHeight').innerHTML    = h + ' <small>cm</small>';
        document.getElementById('viewWeight').innerHTML    = w + ' <small>kg</small>';
        document.getElementById('viewCalories').innerHTML  = Number(cal).toLocaleString() + ' <small>kcal</small>';
        document.getElementById('viewBloodType').textContent = bt;
        document.getElementById('viewAge').innerHTML       = age + ' <small>yrs</small>';
        document.getElementById('viewChronic').textContent = ch;
        document.getElementById('viewDisability').textContent = dis;
        document.getElementById('viewFamily').textContent  = fam;

        // Recalculate BMI
        var bmi = (parseFloat(w) / Math.pow(parseFloat(h) / 100, 2));
        if (!isNaN(bmi)) updateBMI(bmi);

        viewPanel.style.display = 'block';
        editPanel.style.display = 'none';
        btnEdit.style.display   = 'inline-flex';
        btnSave.style.display   = 'none';
        btnCancel.style.display = 'none';
        successMsg.style.display = 'block';
        setTimeout(function () { successMsg.style.display = 'none'; }, 4000);
    });

    /* ── BMI bar ──────────────────────────────────────────────── */
    function updateBMI(bmi) {
        var fill    = document.getElementById('bmiFill');
        var catLabel = document.getElementById('bmiCatLabel');
        var pct     = Math.max(0, Math.min(100, ((bmi - 15) / 25) * 100));
        fill.style.width = pct + '%';

        catLabel.className = 'pd-bmi-cat';
        if (bmi < 18.5) {
            catLabel.textContent = 'Underweight';
            catLabel.classList.add('pd-bmi-cat--low');
        } else if (bmi < 25) {
            catLabel.textContent = 'Normal';
            catLabel.classList.add('pd-bmi-cat--ok');
        } else if (bmi < 30) {
            catLabel.textContent = 'Overweight';
            catLabel.classList.add('pd-bmi-cat--warn');
        } else {
            catLabel.textContent = 'Obese';
            catLabel.classList.add('pd-bmi-cat--danger');
        }
    }

    // Initial BMI bar
    setTimeout(function () { updateBMI(22.0); }, 500);

    /* ── Dose checkbox logic ──────────────────────────────────── */
    window.onDoseChange = function () {
        var rows = [
            { chk: 'chk1', row: 'doseRow1', status: 'status1' },
            { chk: 'chk2', row: 'doseRow2', status: 'status2' },
            { chk: 'chk3', row: 'doseRow3', status: 'status3' }
        ];
        var total = rows.length, taken = 0;

        rows.forEach(function (r) {
            var chk    = document.getElementById(r.chk);
            var rowEl  = document.getElementById(r.row);
            var statEl = document.getElementById(r.status);
            if (chk.checked) {
                taken++;
                rowEl.classList.add('pd-dose-row--taken');
                rowEl.classList.remove('pd-dose-row--pending');
                statEl.className   = 'pd-dose-status pd-dose-status--done';
                statEl.textContent = '✓ Taken';
            } else {
                rowEl.classList.remove('pd-dose-row--taken');
                statEl.className   = 'pd-dose-status pd-dose-status--pending';
                statEl.textContent = '⏱ Pending';
            }
        });

        var pct = Math.round((taken / total) * 100);
        document.getElementById('dosesBarFill').style.width = pct + '%';
        document.getElementById('dpmPct').textContent = pct + '%';
        document.getElementById('dpmArc').setAttribute('stroke-dasharray', pct + ' ' + (100 - pct));
        document.getElementById('dosesSummaryText').textContent = taken + ' of ' + total + ' doses completed today';
    };

    /* ── Save doses button ────────────────────────────────────── */
    window.saveDoses = function () {
        var msg = document.getElementById('dosesMsg');
        msg.style.display = 'block';
        setTimeout(function () { msg.style.display = 'none'; }, 4000);
    };

    /* ── Inventory bars animate on load ──────────────────────── */
    setTimeout(function () {
        document.querySelectorAll('.pd-inv-fill[data-target]').forEach(function (el) {
            el.style.width = el.getAttribute('data-target');
        });
    }, 600);

    /* ── Inject slide-down keyframe ───────────────────────────── */
    var s = document.createElement('style');
    s.textContent = '@keyframes pd-slideDown { from { opacity:0; transform:translateY(-10px); } to { opacity:1; transform:translateY(0); } }';
    document.head.appendChild(s);

})();
</script>

</asp:Content>