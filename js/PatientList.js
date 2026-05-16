/* ═══════════════════════════════════════════════════════════════════
   FILE: PatientList.js
   LOCATION: /Scripts/PatientList.js
   Doctor Dashboard — Patient List Logic
   ═══════════════════════════════════════════════════════════════════

   STRUCTURE:
   1.  Sample Data (patients, medications, nutrition plans)
   2.  State Management
   3.  Initialisation
   4.  Render Helpers
   5.  Patient Grid Render
   6.  Search & Filter
   7.  Stats Bar Update
   8.  Remove Patient
   9.  Modal Utilities
   10. Medications Modal Logic
   11. Nutrition Modal Logic
   12. Form Helpers (validation, field get/set)
   13. Toast Notification
   14. View Toggle (grid / list)
   15. Utility Helpers

   NOTE: All database connection points are clearly marked with:
   //  *** DB HOOK: <description> ***
   When integrating with ASP.NET code-behind or Web API, replace the
   marked sections with fetch/axios calls or UpdatePanel triggers.
   ═══════════════════════════════════════════════════════════════════ */


/* ── 1. SAMPLE DATA ─────────────────────────────────────────────── */

/**
 * Sample patients array.
 * *** DB HOOK: Replace this array by fetching from /api/patients or
 *              populating from a hidden ASP.NET Repeater / JSON endpoint.
 */
const samplePatients = [
    {
        id: 1,
        name: "Sarah Johnson",
        age: 34,
        gender: "Female",
        condition: "Hypertension",
        status: "Stable",
        nextAppointment: "2025-06-10",
        phone: "+1 (555) 201-4321",
        bloodType: "A+",
        avatarColor: 1
    },
    {
        id: 2,
        name: "Michael Torres",
        age: 52,
        gender: "Male",
        condition: "Type 2 Diabetes",
        status: "Under Observation",
        nextAppointment: "2025-06-07",
        phone: "+1 (555) 312-9876",
        bloodType: "O-",
        avatarColor: 2
    },
    {
        id: 3,
        name: "Emily Chen",
        age: 28,
        gender: "Female",
        condition: "Asthma",
        status: "Recovering",
        nextAppointment: "2025-06-15",
        phone: "+1 (555) 443-6512",
        bloodType: "B+",
        avatarColor: 3
    },
    {
        id: 4,
        name: "David Kim",
        age: 61,
        gender: "Male",
        condition: "Coronary Artery Disease",
        status: "Critical",
        nextAppointment: "2025-06-05",
        phone: "+1 (555) 567-3309",
        bloodType: "AB+",
        avatarColor: 4
    },
    {
        id: 5,
        name: "Maria Gonzalez",
        age: 45,
        gender: "Female",
        condition: "Arthritis",
        status: "Stable",
        nextAppointment: "2025-06-20",
        phone: "+1 (555) 678-2201",
        bloodType: "O+",
        avatarColor: 5
    },
    {
        id: 6,
        name: "James Patel",
        age: 39,
        gender: "Male",
        condition: "Migraine",
        status: "Recovering",
        nextAppointment: "2025-06-12",
        phone: "+1 (555) 789-4455",
        bloodType: "A-",
        avatarColor: 6
    },
    {
        id: 7,
        name: "Linda Okafor",
        age: 56,
        gender: "Female",
        condition: "Kidney Disease",
        status: "Under Observation",
        nextAppointment: "2025-06-08",
        phone: "+1 (555) 890-1122",
        bloodType: "B-",
        avatarColor: 1
    },
    {
        id: 8,
        name: "Robert Hayes",
        age: 70,
        gender: "Male",
        condition: "COPD",
        status: "Critical",
        nextAppointment: "2025-06-06",
        phone: "+1 (555) 901-3344",
        bloodType: "A+",
        avatarColor: 3
    }
];

/**
 * Medications store: keyed by patient ID → array of medication objects.
 * *** DB HOOK: Fetch from /api/medications?patientId={id} and populate here.
 */
const medicationsStore = {
    1: [
        { id: 101, name: "Lisinopril", dosage: "10mg", frequency: "Once daily", duration: "Ongoing", startDate: "2025-01-15", endDate: "2025-12-31", notes: "Take with water in the morning." },
        { id: 102, name: "Amlodipine", dosage: "5mg", frequency: "Once daily", duration: "6 months", startDate: "2025-03-01", endDate: "2025-09-01", notes: "Monitor blood pressure weekly." }
    ],
    2: [
        { id: 201, name: "Metformin", dosage: "500mg", frequency: "Twice daily", duration: "Ongoing", startDate: "2024-11-01", endDate: "2025-11-01", notes: "Take with meals." }
    ],
    3: [
        { id: 301, name: "Salbutamol Inhaler", dosage: "100mcg", frequency: "As needed", duration: "Ongoing", startDate: "2025-02-10", endDate: "", notes: "Use before exercise or upon onset of symptoms." },
        { id: 302, name: "Fluticasone", dosage: "250mcg", frequency: "Twice daily", duration: "Ongoing", startDate: "2025-02-10", endDate: "", notes: "Preventive inhaler — do not skip." }
    ],
    4: [
        { id: 401, name: "Aspirin", dosage: "81mg", frequency: "Once daily", duration: "Ongoing", startDate: "2024-08-01", endDate: "", notes: "Enteric-coated. Take with food." },
        { id: 402, name: "Atorvastatin", dosage: "40mg", frequency: "Once daily", duration: "Ongoing", startDate: "2024-08-01", endDate: "", notes: "Take at night." }
    ]
};

/**
 * Nutrition plans store: keyed by patient ID → array of plan objects.
 * *** DB HOOK: Fetch from /api/nutritionplans?patientId={id} and populate here.
 */
const nutritionStore = {
    1: [
        { id: 1001, name: "Low Sodium Plan", calories: 1800, protein: 75, carbs: 220, fat: 55, notes: "Avoid processed foods and canned goods. Max 1500mg sodium/day." }
    ],
    2: [
        { id: 2001, name: "Diabetic-Friendly Diet", calories: 1600, protein: 80, carbs: 160, fat: 50, notes: "Low GI foods only. Avoid sugary drinks. Monitor carb intake per meal." },
        { id: 2002, name: "Evening Snack Plan", calories: 250, protein: 15, carbs: 30, fat: 8, notes: "Light snack: nuts, seeds, or low-fat yogurt." }
    ],
    3: [
        { id: 3001, name: "Anti-Inflammatory Diet", calories: 2000, protein: 90, carbs: 240, fat: 65, notes: "Include omega-3 rich foods. Avoid trigger foods." }
    ]
};


/* ── 2. STATE MANAGEMENT ────────────────────────────────────────── */

let appState = {
    patients: [],           // working copy of patients
    filteredPatients: [],   // result of current search/filter
    currentPatientId: null, // ID of patient whose modal is open
    removeTargetId: null,   // ID of patient pending removal
    currentView: 'grid',    // 'grid' | 'list'
    medIdCounter: 9000,     // local counter for new med IDs
    nutIdCounter: 9100      // local counter for new nutrition plan IDs
};


/* ── 3. INITIALISATION ──────────────────────────────────────────── */

document.addEventListener('DOMContentLoaded', function () {

    // Deep clone sample data so mutations don't affect originals
    appState.patients = JSON.parse(JSON.stringify(samplePatients));

    // *** DB HOOK: Replace the line above with an AJAX fetch:
    // fetch('/api/patients').then(r => r.json()).then(data => {
    //     appState.patients = data;
    //     renderPatients(appState.patients);
    //     updateStats();
    // });

    applyFilters();
    updateStats();
    attachSearchListener();
});


/* ── 4. RENDER HELPERS ──────────────────────────────────────────── */

/** Format a date string to human-readable DD MMM YYYY */
function formatDate(dateStr) {
    if (!dateStr) return 'N/A';
    const d = new Date(dateStr);
    if (isNaN(d)) return dateStr;
    return d.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
}

/** Return CSS class suffix based on patient status */
function statusClass(status) {
    const map = {
        'Stable': 'stable',
        'Critical': 'critical',
        'Recovering': 'recovering',
        'Under Observation': 'observation'
    };
    return map[status] || 'stable';
}

/** Return band colour class based on status */
function bandClass(status) {
    return 'pl-card-band--' + statusClass(status);
}

/** Get initials from full name */
function getInitials(name) {
    return name.split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase();
}

/** Return whether a patient has medications */
function hasMeds(patientId) {
    const meds = medicationsStore[patientId];
    return meds && meds.length > 0;
}

/** Return whether a patient has nutrition plans */
function hasNutrition(patientId) {
    const plans = nutritionStore[patientId];
    return plans && plans.length > 0;
}


/* ── 5. PATIENT GRID RENDER ─────────────────────────────────────── */

/**
 * Renders the patient cards into #patientGrid.
 * @param {Array} patients - array of patient objects to render
 */
function renderPatients(patients) {
    const grid = document.getElementById('patientGrid');
    const empty = document.getElementById('emptyState');
    const resultsCount = document.getElementById('resultsCount');

    grid.innerHTML = '';

    if (!patients || patients.length === 0) {
        grid.style.display = 'none';
        empty.style.display = 'flex';
        resultsCount.innerHTML = 'Showing <strong>0</strong> patients';
        return;
    }

    grid.style.display = 'grid';
    empty.style.display = 'none';
    resultsCount.innerHTML = 'Showing <strong>' + patients.length + '</strong> patient' + (patients.length !== 1 ? 's' : '');

    patients.forEach(function (patient, index) {
        const card = buildPatientCard(patient, index);
        grid.appendChild(card);
    });
}

/**
 * Build a single patient card DOM element.
 * @param {Object} p - patient object
 * @param {number} idx - index for animation delay
 * @returns {HTMLElement}
 */
function buildPatientCard(p, idx) {
    const card = document.createElement('div');
    card.className = 'pl-patient-card';
    card.dataset.id = p.id;
    // Stagger animation
    card.style.animationDelay = (idx * 0.06) + 's';

    const sc = statusClass(p.status);
    const medBadge = hasMeds(p.id) ? '<span class="pl-tag pl-tag--blue" style="background:#DBEAFE;color:#1D4ED8;"><i class="fas fa-pills" style="margin-right:3px;font-size:10px;"></i>' + medicationsStore[p.id].length + ' Meds</span>' : '';
    const nutBadge = hasNutrition(p.id) ? '<span class="pl-tag pl-tag--green"><i class="fas fa-apple-alt" style="margin-right:3px;font-size:10px;"></i>' + nutritionStore[p.id].length + ' Plans</span>' : '';

    card.innerHTML = `
        <!-- Color band -->
        <div class="pl-patient-card__band ${bandClass(p.status)}"></div>

        <!-- Body -->
        <div class="pl-patient-card__body">
            <div class="pl-patient-avatar pl-avatar--${p.avatarColor}">${getInitials(p.name)}</div>
            <div class="pl-patient-info">
                <h3 class="pl-patient-info__name">${escHtml(p.name)}</h3>
                <div class="pl-patient-info__meta">
                    <span class="pl-patient-info__meta-item">
                        <i class="fas fa-birthday-cake"></i> ${p.age} yrs
                    </span>
                    <span class="pl-patient-info__meta-item">
                        <i class="fas fa-${p.gender === 'Male' ? 'mars' : 'venus'}"></i> ${p.gender}
                    </span>
                    <span class="pl-patient-info__meta-item">
                        <i class="fas fa-tint"></i> ${p.bloodType}
                    </span>
                </div>
                <span class="pl-status-badge pl-status--${sc}">${p.status}</span>
                <div class="pl-patient-info__meta" style="margin-top:8px;gap:6px;">
                    ${medBadge}
                    ${nutBadge}
                </div>
            </div>
        </div>

        <!-- Details -->
        <div class="pl-patient-card__details">
            <div class="pl-patient-card__detail-row">
                <i class="fas fa-stethoscope"></i>
                <span><strong>Condition:</strong> ${escHtml(p.condition)}</span>
            </div>
            <div class="pl-patient-card__detail-row">
                <i class="fas fa-calendar-check"></i>
                <span><strong>Next Appt:</strong> ${formatDate(p.nextAppointment)}</span>
            </div>
            <div class="pl-patient-card__detail-row">
                <i class="fas fa-phone"></i>
                <span>${escHtml(p.phone)}</span>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="pl-patient-card__actions">
            <button class="pl-btn pl-btn--sm pl-btn--blue"
                onclick="openMedicationsModal(${p.id})">
                <i class="fas fa-pills"></i> Medications
            </button>
            <button class="pl-btn pl-btn--sm pl-btn--teal"
                onclick="openNutritionModal(${p.id})">
                <i class="fas fa-apple-alt"></i> Nutrition
            </button>
            <button class="pl-btn pl-btn--sm pl-btn--danger"
                onclick="requestRemovePatient(${p.id}, '${escHtml(p.name).replace(/'/g, "\\'")}')">
                <i class="fas fa-user-minus"></i> Remove
            </button>
        </div>
    `;

    return card;
}


/* ── 6. SEARCH & FILTER ─────────────────────────────────────────── */

/** Attach real-time listener to search input */
function attachSearchListener() {
    // ASP.NET TextBox renders as <input> — use clientID fallback
    const searchInput = document.getElementById('<%=txtSearch.ClientID%>') ||
        document.querySelector('.pl-search-input');
    if (searchInput) {
        searchInput.addEventListener('input', applyFilters);
    }
}

/** Read search + filter values and re-render */
function applyFilters() {
    const searchInput = document.getElementById('<%=txtSearch.ClientID%>') ||
        document.querySelector('.pl-search-input');
    const genderSelect = document.getElementById('<%=ddlGender.ClientID%>') ||
        document.querySelector('#ddlGender');
    const statusSelect = document.getElementById('<%=ddlStatus.ClientID%>') ||
        document.querySelector('#ddlStatus');

    const query = (searchInput ? searchInput.value : '').trim().toLowerCase();
    const gender = genderSelect ? genderSelect.value : '';
    const status = statusSelect ? statusSelect.value : '';

    appState.filteredPatients = appState.patients.filter(function (p) {
        const matchQuery = !query ||
            p.name.toLowerCase().includes(query) ||
            p.condition.toLowerCase().includes(query) ||
            p.gender.toLowerCase().includes(query) ||
            p.status.toLowerCase().includes(query);

        const matchGender = !gender || p.gender === gender;
        const matchStatus = !status || p.status === status;

        return matchQuery && matchGender && matchStatus;
    });

    renderPatients(appState.filteredPatients);
}

/** Clear search field and re-render all */
function clearSearch() {
    const searchInput = document.getElementById('<%=txtSearch.ClientID%>') ||
        document.querySelector('.pl-search-input');
    if (searchInput) searchInput.value = '';
    applyFilters();
}


/* ── 7. STATS BAR UPDATE ────────────────────────────────────────── */

/** Recalculate and display stats counts */
function updateStats() {
    const total = appState.patients.length;
    const active = appState.patients.filter(p => p.status === 'Stable' || p.status === 'Recovering').length;
    const upcoming = appState.patients.filter(p => {
        const d = new Date(p.nextAppointment);
        const now = new Date();
        const diff = (d - now) / (1000 * 60 * 60 * 24);
        return diff >= 0 && diff <= 14;
    }).length;
    const onMeds = appState.patients.filter(p => hasMeds(p.id)).length;

    setInner('statTotal', total);
    setInner('statActive', active);
    setInner('statUpcoming', upcoming);
    setInner('statOnMeds', onMeds);
}


/* ── 8. REMOVE PATIENT ──────────────────────────────────────────── */

/**
 * Open the remove confirmation modal.
 * @param {number} id - patient ID
 * @param {string} name - patient display name
 */
function requestRemovePatient(id, name) {
    appState.removeTargetId = id;
    setInner('removePatientName', name);
    openModal('removeModal');
}

/**
 * Confirm and execute patient removal.
 * *** DB HOOK: Replace splice logic with:
 *   fetch('/api/patients/' + id, { method: 'DELETE' })
 *   .then(() => { removeFromState(id); });
 */
function confirmRemovePatient() {
    const id = appState.removeTargetId;
    if (!id) return;

    // Animate the card out
    const card = document.querySelector('.pl-patient-card[data-id="' + id + '"]');
    if (card) {
        card.classList.add('pl-patient-card--removing');
        setTimeout(function () {
            removeFromState(id);
        }, 380);
    } else {
        removeFromState(id);
    }

    closeModal('removeModal');
    showToast('Patient removed successfully.');
}

/** Remove patient from all state arrays and re-render */
function removeFromState(id) {
    appState.patients = appState.patients.filter(p => p.id !== id);
    appState.filteredPatients = appState.filteredPatients.filter(p => p.id !== id);

    // Re-render without the removed patient already handled by animation,
    // but update the count/stats
    const card = document.querySelector('.pl-patient-card[data-id="' + id + '"]');
    if (card) card.remove();

    const grid = document.getElementById('patientGrid');
    const remaining = grid.querySelectorAll('.pl-patient-card').length;
    const el = document.getElementById('resultsCount');
    if (el) el.innerHTML = 'Showing <strong>' + remaining + '</strong> patient' + (remaining !== 1 ? 's' : '');

    if (remaining === 0) {
        grid.style.display = 'none';
        document.getElementById('emptyState').style.display = 'flex';
    }

    updateStats();
}


/* ── 9. MODAL UTILITIES ─────────────────────────────────────────── */

/** Open a modal by its element ID */
function openModal(modalId) {
    const overlay = document.getElementById(modalId);
    if (!overlay) return;
    overlay.classList.add('pl-modal-overlay--open');
    document.body.style.overflow = 'hidden';
}

/** Close a modal by its element ID */
function closeModal(modalId) {
    const overlay = document.getElementById(modalId);
    if (!overlay) return;
    overlay.classList.remove('pl-modal-overlay--open');
    document.body.style.overflow = '';
}

/** Close modal when clicking outside the modal box */
document.addEventListener('click', function (e) {
    if (e.target.classList.contains('pl-modal-overlay')) {
        closeModal(e.target.id);
    }
});

/** Close modals on Escape key */
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        document.querySelectorAll('.pl-modal-overlay--open').forEach(function (el) {
            closeModal(el.id);
        });
    }
});


/* ── 10. MEDICATIONS MODAL LOGIC ────────────────────────────────── */

/**
 * Open Medications modal for a given patient.
 * @param {number} patientId
 */
function openMedicationsModal(patientId) {
    appState.currentPatientId = patientId;

    const patient = appState.patients.find(p => p.id === patientId);
    if (!patient) return;

    // Set patient banner
    setInner('medPatientBanner', '<i class="fas fa-user-injured"></i> ' + escHtml(patient.name));

    // Initialise medication list for patient if empty
    if (!medicationsStore[patientId]) {
        medicationsStore[patientId] = [];
    }

    // Show list tab first
    switchMedTab('list', null);
    renderMedList(patientId);
    clearMedForm();

    openModal('medModal');
}

/** Render medication list cards for the current patient */
function renderMedList(patientId) {
    const container = document.getElementById('medListContainer');
    const meds = medicationsStore[patientId] || [];

    if (meds.length === 0) {
        container.innerHTML = '<div style="text-align:center;padding:40px;color:#9CA3AF;font-size:14px;"><i class="fas fa-pills" style="font-size:32px;margin-bottom:12px;display:block;"></i>No medications recorded. Click <strong>Add Medication</strong> to begin.</div>';
        return;
    }

    container.innerHTML = meds.map(function (med) {
        return `
            <div class="pl-med-card" data-med-id="${med.id}">
                <div class="pl-med-card__icon"><i class="fas fa-capsules"></i></div>
                <div class="pl-med-card__info">
                    <div class="pl-med-card__name">${escHtml(med.name)}</div>
                    <div class="pl-med-card__tags">
                        <span class="pl-tag">${escHtml(med.dosage)}</span>
                        <span class="pl-tag pl-tag--orange">${escHtml(med.frequency)}</span>
                        ${med.duration ? '<span class="pl-tag pl-tag--gray">' + escHtml(med.duration) + '</span>' : ''}
                        ${med.startDate ? '<span class="pl-tag pl-tag--gray"><i class="fas fa-calendar" style="margin-right:3px;font-size:9px;"></i>' + formatDate(med.startDate) + ' → ' + (med.endDate ? formatDate(med.endDate) : 'Ongoing') + '</span>' : ''}
                    </div>
                    ${med.notes ? '<div style="font-size:12px;color:#6B7280;margin-top:8px;"><i class="fas fa-sticky-note" style="margin-right:4px;"></i>' + escHtml(med.notes) + '</div>' : ''}
                </div>
                <div class="pl-med-card__actions">
                    <button class="pl-btn pl-btn--sm pl-btn--ghost"
                        onclick="editMedication(${med.id})">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="pl-btn pl-btn--sm pl-btn--danger"
                        onclick="deleteMedication(${med.id})">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </div>
            </div>
        `;
    }).join('');
}

/** Load medication data into form for editing */
function editMedication(medId) {
    const patientId = appState.currentPatientId;
    const meds = medicationsStore[patientId] || [];
    const med = meds.find(m => m.id === medId);
    if (!med) return;

    setVal('hdnEditMedId', med.id);
    setVal('<%=txtMedName.ClientID%>', med.name);
    setVal('<%=txtMedDosage.ClientID%>', med.dosage);
    setSelectVal('<%=ddlMedFrequency.ClientID%>', med.frequency);
    setVal('<%=txtMedDuration.ClientID%>', med.duration);
    setVal('<%=txtMedStartDate.ClientID%>', med.startDate);
    setVal('<%=txtMedEndDate.ClientID%>', med.endDate);
    setVal('<%=txtMedNotes.ClientID%>', med.notes);

    setInner('medFormTitle', 'Edit Medication');
    switchMedTab('add', null);
}

/**
 * Save new or edited medication.
 * *** DB HOOK: On save, call:
 *   fetch('/api/medications', { method: 'POST'/'PUT', body: JSON.stringify(medObj) })
 */
function saveMedication() {
    // Validate
    if (!validateMedForm()) return;

    const patientId = appState.currentPatientId;
    const editId = parseInt(getVal('hdnEditMedId')) || null;

    const medObj = {
        id: editId || (++appState.medIdCounter),
        name: getVal('<%=txtMedName.ClientID%>'),
        dosage: getVal('<%=txtMedDosage.ClientID%>'),
        frequency: getSelectVal('<%=ddlMedFrequency.ClientID%>'),
        duration: getVal('<%=txtMedDuration.ClientID%>'),
        startDate: getVal('<%=txtMedStartDate.ClientID%>'),
        endDate: getVal('<%=txtMedEndDate.ClientID%>'),
        notes: getVal('<%=txtMedNotes.ClientID%>')
    };

    if (!medicationsStore[patientId]) medicationsStore[patientId] = [];

    if (editId) {
        // Update existing
        const idx = medicationsStore[patientId].findIndex(m => m.id === editId);
        if (idx !== -1) medicationsStore[patientId][idx] = medObj;
        showToast('Medication updated successfully.');
    } else {
        // Add new
        medicationsStore[patientId].push(medObj);
        showToast('Medication added successfully.');
    }

    clearMedForm();
    renderMedList(patientId);
    switchMedTab('list', null);
    updateStats();

    // Refresh the card badge counts
    refreshPatientCard(patientId);
}

/**
 * Delete a medication.
 * *** DB HOOK: Call fetch('/api/medications/' + medId, { method: 'DELETE' })
 */
function deleteMedication(medId) {
    const patientId = appState.currentPatientId;
    medicationsStore[patientId] = (medicationsStore[patientId] || []).filter(m => m.id !== medId);
    renderMedList(patientId);
    refreshPatientCard(patientId);
    showToast('Medication removed.');
}

/** Clear the medication form fields and errors */
function clearMedForm() {
    setVal('hdnEditMedId', '');
    setVal('<%=txtMedName.ClientID%>', '');
    setVal('<%=txtMedDosage.ClientID%>', '');
    setSelectVal('<%=ddlMedFrequency.ClientID%>', '');
    setVal('<%=txtMedDuration.ClientID%>', '');
    setVal('<%=txtMedStartDate.ClientID%>', '');
    setVal('<%=txtMedEndDate.ClientID%>', '');
    setVal('<%=txtMedNotes.ClientID%>', '');
    setInner('medFormTitle', 'Add New Medication');
    ['errMedName', 'errMedDosage', 'errMedFrequency', 'errMedStart'].forEach(hideErr);
}

/** Validate medication form; returns true if valid */
function validateMedForm() {
    let valid = true;
    if (!getVal('<%=txtMedName.ClientID%>').trim()) { showErr('errMedName', 'Medication name is required.'); valid = false; } else hideErr('errMedName');
    if (!getVal('<%=txtMedDosage.ClientID%>').trim()) { showErr('errMedDosage', 'Dosage is required.'); valid = false; } else hideErr('errMedDosage');
    if (!getSelectVal('<%=ddlMedFrequency.ClientID%>')) { showErr('errMedFrequency', 'Please select frequency.'); valid = false; } else hideErr('errMedFrequency');
    const start = getVal('<%=txtMedStartDate.ClientID%>');
    if (!start) { showErr('errMedStart', 'Start date is required.'); valid = false; } else hideErr('errMedStart');
    return valid;
}

/** Switch medication modal tabs */
function switchMedTab(tabName, btn) {
    document.getElementById('medTabList').classList.toggle('pl-tab-panel--hidden', tabName !== 'list');
    document.getElementById('medTabAdd').classList.toggle('pl-tab-panel--hidden', tabName !== 'add');
    document.querySelectorAll('#medModal .pl-tab').forEach(function (t) { t.classList.remove('pl-tab--active'); });
    if (btn) btn.classList.add('pl-tab--active');
    else {
        const tabs = document.querySelectorAll('#medModal .pl-tab');
        if (tabName === 'list' && tabs[0]) tabs[0].classList.add('pl-tab--active');
        if (tabName === 'add' && tabs[1]) tabs[1].classList.add('pl-tab--active');
    }
    if (tabName === 'add') clearMedForm();
}


/* ── 11. NUTRITION MODAL LOGIC ──────────────────────────────────── */

/**
 * Open Nutrition modal for a given patient.
 * @param {number} patientId
 */
function openNutritionModal(patientId) {
    appState.currentPatientId = patientId;

    const patient = appState.patients.find(p => p.id === patientId);
    if (!patient) return;

    setInner('nutPatientBanner', '<i class="fas fa-user-injured"></i> ' + escHtml(patient.name));

    if (!nutritionStore[patientId]) {
        nutritionStore[patientId] = [];
    }

    switchNutTab('list', null);
    renderNutList(patientId);
    clearNutForm();

    openModal('nutModal');
}

/** Render nutrition plan cards for the current patient */
function renderNutList(patientId) {
    const container = document.getElementById('nutListContainer');
    const plans = nutritionStore[patientId] || [];

    if (plans.length === 0) {
        container.innerHTML = '<div style="text-align:center;padding:40px;color:#9CA3AF;font-size:14px;"><i class="fas fa-apple-alt" style="font-size:32px;margin-bottom:12px;display:block;"></i>No nutrition plans recorded. Click <strong>Add Plan</strong> to begin.</div>';
        return;
    }

    container.innerHTML = plans.map(function (plan) {
        return `
            <div class="pl-nut-card" data-nut-id="${plan.id}">
                <div class="pl-nut-card__icon"><i class="fas fa-leaf"></i></div>
                <div class="pl-nut-card__info">
                    <div class="pl-nut-card__name">${escHtml(plan.name)}</div>
                    <div class="pl-macro-bar">
                        <div class="pl-macro">
                            <span class="pl-macro__val">${plan.calories}</span>
                            <span class="pl-macro__label">kcal</span>
                        </div>
                        <div class="pl-macro">
                            <span class="pl-macro__val">${plan.protein}g</span>
                            <span class="pl-macro__label">Protein</span>
                        </div>
                        <div class="pl-macro">
                            <span class="pl-macro__val">${plan.carbs}g</span>
                            <span class="pl-macro__label">Carbs</span>
                        </div>
                        <div class="pl-macro">
                            <span class="pl-macro__val">${plan.fat}g</span>
                            <span class="pl-macro__label">Fat</span>
                        </div>
                    </div>
                    ${plan.notes ? '<div style="font-size:12px;color:#6B7280;margin-top:10px;"><i class="fas fa-sticky-note" style="margin-right:4px;"></i>' + escHtml(plan.notes) + '</div>' : ''}
                </div>
                <div class="pl-nut-card__actions">
                    <button class="pl-btn pl-btn--sm pl-btn--ghost"
                        onclick="editNutritionPlan(${plan.id})">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="pl-btn pl-btn--sm pl-btn--danger"
                        onclick="deleteNutritionPlan(${plan.id})">
                        <i class="fas fa-trash-alt"></i>
                    </button>
                </div>
            </div>
        `;
    }).join('');
}

/** Load nutrition plan into form for editing */
function editNutritionPlan(planId) {
    const patientId = appState.currentPatientId;
    const plans = nutritionStore[patientId] || [];
    const plan = plans.find(p => p.id === planId);
    if (!plan) return;

    setVal('hdnEditNutId', plan.id);
    setVal('<%=txtNutPlanName.ClientID%>', plan.name);
    setVal('<%=txtNutCalories.ClientID%>', plan.calories);
    setVal('<%=txtNutProtein.ClientID%>', plan.protein);
    setVal('<%=txtNutCarbs.ClientID%>', plan.carbs);
    setVal('<%=txtNutFat.ClientID%>', plan.fat);
    setVal('<%=txtNutNotes.ClientID%>', plan.notes);

    setInner('nutFormTitle', 'Edit Nutrition Plan');
    switchNutTab('add', null);
}

/**
 * Save new or edited nutrition plan.
 * *** DB HOOK: Call fetch('/api/nutritionplans', { method: 'POST'/'PUT', body: JSON.stringify(planObj) })
 */
function saveNutritionPlan() {
    if (!validateNutForm()) return;

    const patientId = appState.currentPatientId;
    const editId = parseInt(getVal('hdnEditNutId')) || null;

    const planObj = {
        id: editId || (++appState.nutIdCounter),
        name: getVal('<%=txtNutPlanName.ClientID%>'),
        calories: parseInt(getVal('<%=txtNutCalories.ClientID%>')) || 0,
        protein: parseInt(getVal('<%=txtNutProtein.ClientID%>')) || 0,
        carbs: parseInt(getVal('<%=txtNutCarbs.ClientID%>')) || 0,
        fat: parseInt(getVal('<%=txtNutFat.ClientID%>')) || 0,
        notes: getVal('<%=txtNutNotes.ClientID%>')
    };

    if (!nutritionStore[patientId]) nutritionStore[patientId] = [];

    if (editId) {
        const idx = nutritionStore[patientId].findIndex(p => p.id === editId);
        if (idx !== -1) nutritionStore[patientId][idx] = planObj;
        showToast('Nutrition plan updated.');
    } else {
        nutritionStore[patientId].push(planObj);
        showToast('Nutrition plan added.');
    }

    clearNutForm();
    renderNutList(patientId);
    switchNutTab('list', null);
    refreshPatientCard(patientId);
}

/**
 * Delete a nutrition plan.
 * *** DB HOOK: Call fetch('/api/nutritionplans/' + planId, { method: 'DELETE' })
 */
function deleteNutritionPlan(planId) {
    const patientId = appState.currentPatientId;
    nutritionStore[patientId] = (nutritionStore[patientId] || []).filter(p => p.id !== planId);
    renderNutList(patientId);
    refreshPatientCard(patientId);
    showToast('Nutrition plan removed.');
}

/** Clear nutrition form fields */
function clearNutForm() {
    setVal('hdnEditNutId', '');
    setVal('<%=txtNutPlanName.ClientID%>', '');
    setVal('<%=txtNutCalories.ClientID%>', '');
    setVal('<%=txtNutProtein.ClientID%>', '');
    setVal('<%=txtNutCarbs.ClientID%>', '');
    setVal('<%=txtNutFat.ClientID%>', '');
    setVal('<%=txtNutNotes.ClientID%>', '');
    setInner('nutFormTitle', 'Add Nutrition Plan');
    ['errNutName', 'errNutCal'].forEach(hideErr);
}

/** Validate nutrition form */
function validateNutForm() {
    let valid = true;
    if (!getVal('<%=txtNutPlanName.ClientID%>').trim()) { showErr('errNutName', 'Plan name is required.'); valid = false; } else hideErr('errNutName');
    if (!getVal('<%=txtNutCalories.ClientID%>').toString().trim()) { showErr('errNutCal', 'Calories are required.'); valid = false; } else hideErr('errNutCal');
    return valid;
}

/** Switch nutrition modal tabs */
function switchNutTab(tabName, btn) {
    document.getElementById('nutTabList').classList.toggle('pl-tab-panel--hidden', tabName !== 'list');
    document.getElementById('nutTabAdd').classList.toggle('pl-tab-panel--hidden', tabName !== 'add');
    document.querySelectorAll('#nutModal .pl-tab').forEach(function (t) { t.classList.remove('pl-tab--active'); });
    if (btn) btn.classList.add('pl-tab--active');
    else {
        const tabs = document.querySelectorAll('#nutModal .pl-tab');
        if (tabName === 'list' && tabs[0]) tabs[0].classList.add('pl-tab--active');
        if (tabName === 'add' && tabs[1]) tabs[1].classList.add('pl-tab--active');
    }
    if (tabName === 'add') clearNutForm();
}

/** Refresh a patient card's badge counts in-place (without full re-render) */
function refreshPatientCard(patientId) {
    const card = document.querySelector('.pl-patient-card[data-id="' + patientId + '"]');
    if (!card) return;

    const medBadge = card.querySelector('[data-med-badge]');
    const nutBadge = card.querySelector('[data-nut-badge]');

    // Full re-render of just this card
    const patient = appState.patients.find(p => p.id === patientId);
    if (!patient) return;
    const idx = Array.from(card.parentNode.children).indexOf(card);
    const newCard = buildPatientCard(patient, idx);
    card.parentNode.replaceChild(newCard, card);
}


/* ── 12. FORM HELPERS ───────────────────────────────────────────── */

/** Safely get input/field value by ID (handles ASP.NET ClientID fallback) */
function getVal(idOrClientId) {
    const el = document.getElementById(idOrClientId) || document.querySelector('[id$="' + idOrClientId + '"]');
    return el ? el.value : '';
}

/** Set value on an element */
function setVal(idOrClientId, value) {
    const el = document.getElementById(idOrClientId) || document.querySelector('[id$="' + idOrClientId + '"]');
    if (el) el.value = value !== undefined && value !== null ? value : '';
}

/** Get selected value of a select element */
function getSelectVal(idOrClientId) {
    const el = document.getElementById(idOrClientId) || document.querySelector('[id$="' + idOrClientId + '"]');
    return el ? el.value : '';
}

/** Set selected value of a select element */
function setSelectVal(idOrClientId, value) {
    const el = document.getElementById(idOrClientId) || document.querySelector('[id$="' + idOrClientId + '"]');
    if (el) el.value = value || '';
}

/** Set innerHTML of an element by ID */
function setInner(id, html) {
    const el = document.getElementById(id);
    if (el) el.innerHTML = html;
}

/** Show a form error message */
function showErr(id, msg) {
    const el = document.getElementById(id);
    if (!el) return;
    el.textContent = msg;
    el.classList.add('pl-form-error--visible');
}

/** Hide a form error message */
function hideErr(id) {
    const el = document.getElementById(id);
    if (!el) return;
    el.textContent = '';
    el.classList.remove('pl-form-error--visible');
}


/* ── 13. TOAST NOTIFICATION ─────────────────────────────────────── */

let _toastTimer = null;

/**
 * Display a toast notification.
 * @param {string} message
 */
function showToast(message) {
    const toast = document.getElementById('toastNotif');
    const msg = document.getElementById('toastMsg');
    if (!toast || !msg) return;

    msg.textContent = message;
    toast.classList.add('pl-toast--show');

    if (_toastTimer) clearTimeout(_toastTimer);
    _toastTimer = setTimeout(function () {
        toast.classList.remove('pl-toast--show');
    }, 3200);
}


/* ── 14. VIEW TOGGLE ────────────────────────────────────────────── */

/**
 * Switch between grid and list view.
 * @param {'grid'|'list'} view
 */
function setView(view) {
    appState.currentView = view;
    const grid = document.getElementById('patientGrid');

    if (view === 'list') {
        grid.classList.add('pl-patient-grid--list');
    } else {
        grid.classList.remove('pl-patient-grid--list');
    }

    // Update toggle button states
    const gridBtn = document.getElementById('btnGridView');
    const listBtn = document.getElementById('btnListView');
    if (gridBtn) gridBtn.classList.toggle('pl-view-btn--active', view === 'grid');
    if (listBtn) listBtn.classList.toggle('pl-view-btn--active', view === 'list');
}


/* ── 15. UTILITY HELPERS ────────────────────────────────────────── */

/**
 * Escape HTML special characters to prevent XSS.
 * @param {string} str
 * @returns {string}
 */
function escHtml(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

/** Placeholder for "Add Patient" modal (hook for future expansion) */
function openAddPatientModal() {
    // *** DB HOOK: Build an Add Patient form modal here.
    // POST new patient to /api/patients and push to appState.patients.
    showToast('Add Patient — connect to backend to enable this feature.');
}