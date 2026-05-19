/* ═══════════════════════════════════════════════════════════════════
   FILE: PatientList.js  (MINIMAL — UI effects only)
   LOCATION: /js/PatientList.js

   ALL business logic has been moved to PatientList.aspx.cs.
   This file retains only the two functions that cannot be done
   server-side without a full postback:

     1. setView()  — swaps the grid/list CSS class in-place.

   Everything else (data loading, filtering, modal logic, form
   validation, CRUD, toast, stats) is now handled in C# code-behind.
   ═══════════════════════════════════════════════════════════════════ */


/* ── VIEW TOGGLE (grid ↔ list) ──────────────────────────────────── */

/**
 * Switch between card-grid and compact-list layout.
 * This is a pure CSS class swap — no data involved — so it stays in JS.
 * @param {'grid'|'list'} view
 */
function setView(view) {
    var grid = document.getElementById('patientGrid');
    var gridBtn = document.getElementById('btnGridView');
    var listBtn = document.getElementById('btnListView');

    if (!grid) return;

    if (view === 'list') {
        grid.classList.add('pl-patient-grid--list');
    } else {
        grid.classList.remove('pl-patient-grid--list');
    }

    if (gridBtn) gridBtn.classList.toggle('pl-view-btn--active', view === 'grid');
    if (listBtn) listBtn.classList.toggle('pl-view-btn--active', view === 'list');
}