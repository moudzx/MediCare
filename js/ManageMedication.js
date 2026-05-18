/* ═══════════════════════════════════════════════════════════════════
   FILE: ManageMedication.js
   LOCATION: /Scripts/ManageMedication.js
   ═══════════════════════════════════════════════════════════════════ */

(function () {
    'use strict';

    /* ═══════════════════════════════════════════════════════════════
       1. SAMPLE MEDICATION DATABASE
       *** DB HOOK: Replace this array with an API/AJAX call to your
           medication database (e.g. /api/medications/search?q=term) ***
    ═══════════════════════════════════════════════════════════════════ */
    var MED_DATABASE = [
        { id: 'db1', name: 'Metformin', category: 'Antidiabetic', color: '#2563EB' },
        { id: 'db2', name: 'Lisinopril', category: 'ACE Inhibitor', color: '#7C3AED' },
        { id: 'db3', name: 'Atorvastatin', category: 'Statin', color: '#0D9488' },
        { id: 'db4', name: 'Amoxicillin', category: 'Antibiotic', color: '#DC2626' },
        { id: 'db5', name: 'Omeprazole', category: 'PPI', color: '#D97706' },
        { id: 'db6', name: 'Aspirin', category: 'Antiplatelet', color: '#059669' },
        { id: 'db7', name: 'Amlodipine', category: 'Calcium Blocker', color: '#2563EB' },
        { id: 'db8', name: 'Levothyroxine', category: 'Thyroid Hormone', color: '#7C3AED' },
        { id: 'db9', name: 'Sertraline', category: 'Antidepressant', color: '#0D9488' },
        { id: 'db10', name: 'Salbutamol', category: 'Bronchodilator', color: '#D97706' },
        { id: 'db11', name: 'Ibuprofen', category: 'NSAID', color: '#DC2626' },
        { id: 'db12', name: 'Paracetamol', category: 'Analgesic', color: '#059669' },
        { id: 'db13', name: 'Warfarin', category: 'Anticoagulant', color: '#991B1B' },
        { id: 'db14', name: 'Insulin Glargine', category: 'Insulin', color: '#1D4ED8' },
        { id: 'db15', name: 'Furosemide', category: 'Diuretic', color: '#6D28D9' },
    ];

    /* ═══════════════════════════════════════════════════════════════
       2. PATIENT MEDICATIONS (current prescriptions)
       *** DB HOOK: Replace with GET /api/patient/{id}/medications ***
    ═══════════════════════════════════════════════════════════════════ */
    var medications = [
        { id: 1, name: 'Metformin', category: 'Antidiabetic', dosage: '500mg', frequency: 'Twice daily', duration: 'Ongoing', status: 'active', color: '#2563EB', notes: '' },
        { id: 2, name: 'Lisinopril', category: 'ACE Inhibitor', dosage: '10mg', frequency: 'Once daily', duration: 'Ongoing', status: 'active', color: '#7C3AED', notes: '' },
        { id: 3, name: 'Atorvastatin', category: 'Statin', dosage: '20mg', frequency: 'Once at night', duration: 'Ongoing', status: 'active', color: '#0D9488', notes: 'Take with evening meal' },
        { id: 4, name: 'Amoxicillin', category: 'Antibiotic', dosage: '500mg', frequency: 'Three times daily', duration: '7 days', status: 'completed', color: '#DC2626', notes: '' },
    ];

    /* ── State ──────────────────────────────────────────────────── */
    var nextId = 10;
    var currentFilter = 'all';
    var currentSearch = '';
    var editingId = null;
    var selectedMedDb = null;

    /* ═══════════════════════════════════════════════════════════════
       3. RENDER
    ═══════════════════════════════════════════════════════════════════ */
    function render() {
        var filtered = medications.filter(function (m) {
            var matchFilter = currentFilter === 'all' || m.status === currentFilter;
            var matchSearch = m.name.toLowerCase().indexOf(currentSearch.toLowerCase()) !== -1;
            return matchFilter && matchSearch;
        });

        renderTable(filtered);
        renderSummary(filtered);
        updateStats();
    }

    function renderTable(list) {
        var tbody = document.getElementById('mmTableBody');
        var emptyEl = document.getElementById('mmEmpty');
        var badge = document.getElementById('medCountBadge');

        if (!tbody) return;

        badge.textContent = list.length + ' medication' + (list.length !== 1 ? 's' : '');

        if (list.length === 0) {
            tbody.innerHTML = '';
            emptyEl.style.display = 'block';
            return;
        }
        emptyEl.style.display = 'none';

        tbody.innerHTML = list.map(function (m) {
            return (
                '<tr class="mm-tr" id="row-' + m.id + '">' +
                '<td>' +
                '<div class="mm-med-name-cell">' +
                '<div class="mm-med-dot" style="background:' + m.color + '"></div>' +
                '<div>' +
                '<div class="mm-med-name">' + esc(m.name) + '</div>' +
                '<span class="mm-med-category">' + esc(m.category) + '</span>' +
                '</div>' +
                '</div>' +
                '</td>' +
                '<td class="mm-dosage-cell">' + esc(m.dosage) + '</td>' +
                '<td class="mm-freq-cell">' + esc(m.frequency) + '</td>' +
                '<td class="mm-dur-cell">' + esc(m.duration) + '</td>' +
                '<td>' + buildStatusBadge(m.status) + '</td>' +
                '<td>' +
                '<div class="mm-action-group">' +
                '<button class="mm-action-btn mm-action-btn--edit" onclick="openEditModal(' + m.id + ')">' +
                '<i class="fa-solid fa-pen-to-square"></i> Edit Dosage' +
                '</button>' +
                '<button class="mm-action-btn mm-action-btn--delete" onclick="deleteMedication(' + m.id + ')">' +
                '<i class="fa-solid fa-trash-can"></i> Delete' +
                '</button>' +
                '</div>' +
                '</td>' +
                '</tr>'
            );
        }).join('');
    }

    function renderSummary(list) {
        var grid = document.getElementById('mmSummaryGrid');
        if (!grid) return;
        var active = list.filter(function (m) { return m.status === 'active'; });
        grid.innerHTML = active.map(function (m, i) {
            return (
                '<div class="mm-summary-card" style="animation-delay:' + (i * 60) + 'ms">' +
                '<div class="mm-summary-icon" style="background:' + m.color + '22;color:' + m.color + '">' +
                '<i class="fa-solid fa-pills"></i>' +
                '</div>' +
                '<div class="mm-summary-info">' +
                '<div class="mm-summary-name">' + esc(m.name) + '</div>' +
                '<div class="mm-summary-dosage">' + esc(m.dosage) + '</div>' +
                '<div class="mm-summary-freq">' + esc(m.frequency) + '</div>' +
                '</div>' +
                '</div>'
            );
        }).join('');
    }

    function updateStats() {
        var active = medications.filter(function (m) { return m.status === 'active'; }).length;
        var statT = document.getElementById('statTotal');
        var statA = document.getElementById('statActive');
        if (statT) statT.textContent = medications.length;
        if (statA) statA.textContent = active;
    }

    function buildStatusBadge(status) {
        var map = {
            active: { cls: 'mm-status-badge--active', icon: 'fa-circle-check', label: 'Active' },
            completed: { cls: 'mm-status-badge--completed', icon: 'fa-circle-xmark', label: 'Completed' },
            paused: { cls: 'mm-status-badge--paused', icon: 'fa-pause-circle', label: 'Paused' }
        };
        var s = map[status] || map.active;
        return '<span class="mm-status-badge ' + s.cls + '"><i class="fa-solid ' + s.icon + '"></i> ' + s.label + '</span>';
    }

    /* ═══════════════════════════════════════════════════════════════
       4. FILTER & SEARCH
    ═══════════════════════════════════════════════════════════════════ */
    window.setFilter = function (filter, btn) {
        currentFilter = filter;
        document.querySelectorAll('.mm-filter-btn').forEach(function (b) {
            b.classList.remove('mm-filter-btn--active');
        });
        if (btn) btn.classList.add('mm-filter-btn--active');
        render();
    };

    window.filterMedications = function (val) {
        currentSearch = val;
        render();
    };

    /* ═══════════════════════════════════════════════════════════════
       5. ADD MEDICATION — MODAL
    ═══════════════════════════════════════════════════════════════════ */
    window.openAddModal = function () {
        selectedMedDb = null;
        document.getElementById('modalSearchInput').value = '';
        document.getElementById('modalSearchResults').innerHTML =
            '<p class="mm-search-hint"><i class="fa-solid fa-circle-info"></i> Start typing to search medications.</p>';
        document.getElementById('modalStep1').style.display = 'block';
        document.getElementById('modalStep2').style.display = 'none';
        openModal('addMedModal');
    };

    window.closeAddModal = function () { closeModal('addMedModal'); };

    /* Live search in modal */
    window.searchMedications = function (query) {
        var resultsEl = document.getElementById('modalSearchResults');
        if (!query.trim()) {
            resultsEl.innerHTML = '<p class="mm-search-hint"><i class="fa-solid fa-circle-info"></i> Start typing to search medications.</p>';
            return;
        }
        /* *** DB HOOK: Replace filter with API call:
           fetch('/api/medications/search?q=' + encodeURIComponent(query))
             .then(r => r.json()).then(data => renderResults(data)); *** */
        var results = MED_DATABASE.filter(function (m) {
            return m.name.toLowerCase().indexOf(query.toLowerCase()) !== -1;
        });

        if (results.length === 0) {
            resultsEl.innerHTML = '<p class="mm-search-hint">No medications found matching "<strong>' + esc(query) + '</strong>".</p>';
            return;
        }

        resultsEl.innerHTML = results.map(function (m) {
            return (
                '<div class="mm-search-result-item" onclick="selectMedication(\'' + m.id + '\')">' +
                '<div>' +
                '<div class="mm-result-name">' + esc(m.name) + '</div>' +
                '<span class="mm-result-cat">' + esc(m.category) + '</span>' +
                '</div>' +
                '<span class="mm-result-select">Select →</span>' +
                '</div>'
            );
        }).join('');
    };

    window.selectMedication = function (dbId) {
        selectedMedDb = MED_DATABASE.find(function (m) { return m.id === dbId; });
        if (!selectedMedDb) return;

        document.getElementById('step2SelectedMed').textContent = selectedMedDb.name + ' · ' + selectedMedDb.category;
        document.getElementById('inputDosage').value = '';
        document.getElementById('inputFrequency').value = '';
        document.getElementById('inputDuration').value = '';
        document.getElementById('inputNotes').value = '';
        hideErr(['errDosage', 'errFrequency', 'errDuration']);

        document.getElementById('modalStep1').style.display = 'none';
        document.getElementById('modalStep2').style.display = 'block';
    };

    window.backToStep1 = function () {
        document.getElementById('modalStep1').style.display = 'block';
        document.getElementById('modalStep2').style.display = 'none';
    };

    window.confirmAddMedication = function () {
        var dosage = document.getElementById('inputDosage').value.trim();
        var frequency = document.getElementById('inputFrequency').value;
        var duration = document.getElementById('inputDuration').value;
        var notes = document.getElementById('inputNotes').value.trim();
        var valid = true;

        hideErr(['errDosage', 'errFrequency', 'errDuration']);
        if (!dosage) { showErr('errDosage'); valid = false; }
        if (!frequency) { showErr('errFrequency'); valid = false; }
        if (!duration) { showErr('errDuration'); valid = false; }
        if (!valid) return;

        /* *** DB HOOK: POST /api/patient/{id}/medications with payload *** */
        var newMed = {
            id: nextId++,
            name: selectedMedDb.name,
            category: selectedMedDb.category,
            color: selectedMedDb.color,
            dosage: dosage,
            frequency: frequency,
            duration: duration,
            status: 'active',
            notes: notes
        };
        medications.push(newMed);
        closeAddModal();
        render();
        showToast('Medication added successfully!', 'success');
    };

    /* ═══════════════════════════════════════════════════════════════
       6. EDIT DOSAGE
    ═══════════════════════════════════════════════════════════════════ */
    window.openEditModal = function (id) {
        var med = medications.find(function (m) { return m.id === id; });
        if (!med) return;
        editingId = id;
        document.getElementById('editModalMedName').textContent = med.name + ' · Current: ' + med.dosage;
        document.getElementById('editDosageInput').value = med.dosage;
        hideErr(['errEditDosage']);
        openModal('editDosageModal');
    };

    window.closeEditModal = function () { closeModal('editDosageModal'); };

    window.confirmEditDosage = function () {
        var newDosage = document.getElementById('editDosageInput').value.trim();
        hideErr(['errEditDosage']);
        if (!newDosage) { showErr('errEditDosage'); return; }

        /* *** DB HOOK: PATCH /api/medications/{id} with { dosage: newDosage } *** */
        var med = medications.find(function (m) { return m.id === editingId; });
        if (med) { med.dosage = newDosage; }

        closeEditModal();
        render();
        showToast('Dosage updated!', 'success');
    };

    /* ═══════════════════════════════════════════════════════════════
       7. DELETE MEDICATION
    ═══════════════════════════════════════════════════════════════════ */
    window.deleteMedication = function (id) {
        if (!confirm('Remove this medication from the patient\'s prescription?')) return;

        var row = document.getElementById('row-' + id);
        if (row) {
            row.classList.add('mm-tr--removing');
            setTimeout(function () {
                /* *** DB HOOK: DELETE /api/medications/{id} *** */
                medications = medications.filter(function (m) { return m.id !== id; });
                render();
                showToast('Medication removed.', 'info');
            }, 300);
        }
    };

    /* ═══════════════════════════════════════════════════════════════
       8. MODAL HELPERS
    ═══════════════════════════════════════════════════════════════════ */
    function openModal(id) {
        var el = document.getElementById(id);
        if (el) {
            el.classList.add('mm-modal-overlay--open');
            document.body.style.overflow = 'hidden';
        }
    }
    function closeModal(id) {
        var el = document.getElementById(id);
        if (el) {
            el.classList.remove('mm-modal-overlay--open');
            document.body.style.overflow = '';
        }
    }
    window.handleOverlayClick = function (e, id) {
        if (e.target === document.getElementById(id)) closeModal(id);
    };
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            closeModal('addMedModal');
            closeModal('editDosageModal');
        }
    });

    /* ═══════════════════════════════════════════════════════════════
       9. TOAST NOTIFICATION
    ═══════════════════════════════════════════════════════════════════ */
    function showToast(msg, type) {
        var existing = document.getElementById('mmToast');
        if (existing) existing.remove();

        var colors = {
            success: { bg: '#065F46', icon: 'fa-circle-check', color: '#34D399' },
            info: { bg: '#1D4ED8', icon: 'fa-circle-info', color: '#93C5FD' },
            error: { bg: '#991B1B', icon: 'fa-circle-xmark', color: '#FCA5A5' }
        };
        var c = colors[type] || colors.info;
        var toast = document.createElement('div');
        toast.id = 'mmToast';
        toast.style.cssText =
            'position:fixed;bottom:28px;right:28px;background:' + c.bg + ';color:#fff;' +
            'border-radius:50px;padding:13px 22px;display:flex;align-items:center;gap:10px;' +
            'font-family:DM Sans,sans-serif;font-size:14px;font-weight:600;' +
            'box-shadow:0 8px 32px rgba(0,0,0,.25);z-index:3000;' +
            'transform:translateY(80px);opacity:0;transition:all .36s cubic-bezier(.34,1.56,.64,1);';
        toast.innerHTML = '<i class="fa-solid ' + c.icon + '" style="color:' + c.color + ';font-size:16px;"></i>' + esc(msg);
        document.body.appendChild(toast);
        requestAnimationFrame(function () {
            toast.style.transform = 'translateY(0)';
            toast.style.opacity = '1';
        });
        setTimeout(function () {
            toast.style.transform = 'translateY(80px)';
            toast.style.opacity = '0';
            setTimeout(function () { toast.remove(); }, 400);
        }, 3500);
    }

    /* ── Helpers ──────────────────────────────────────────────── */
    function showErr(id) { var el = document.getElementById(id); if (el) el.style.display = 'block'; }
    function hideErr(ids) { ids.forEach(function (id) { var el = document.getElementById(id); if (el) el.style.display = 'none'; }); }
    function esc(s) { if (!s) return ''; return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;'); }

    /* ═══════════════════════════════════════════════════════════════
       10. INIT
    ═══════════════════════════════════════════════════════════════════ */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', render);
    } else {
        render();
    }

})();