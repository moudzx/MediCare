/* ═══════════════════════════════════════════════════════════════════
   FILE:     ProfilePatient.js
   LOCATION: /Scripts/ProfilePatient.js
   PAGE:     Patient Profile — MediCare Healthcare System

   CONTENTS:
   1.  Sample Patient Data
   2.  Application State
   3.  Initialisation  (DOMContentLoaded)
   4.  Render — Full Profile
   5.  Render — Avatar
   6.  Render — Banner
   7.  Render — Left Card
   8.  Render — Fields (view mode)
   9.  Edit Mode  (enter / save / cancel)
   10. Validation
   11. Toast Notification
   12. Utility Helpers

   All database / backend connection points are marked:
       *** DB HOOK: <description> ***
   ═══════════════════════════════════════════════════════════════════ */


/* ─────────────────────────────────────────────────────────────────
   1. SAMPLE PATIENT DATA
   *** DB HOOK: Replace this object with a fetch() call to your API:
       fetch('/api/patients/current')
           .then(r => r.json())
           .then(data => renderProfile(data));
   ───────────────────────────────────────────────────────────────── */
const patientProfile = {
    id: 'PT-20248819',
    username: 'sarah.johnson',
    displayName: 'Sarah Johnson',
    email: 'sarah.johnson@email.com',
    phone: '+1 (555) 201-4321',      /* Required — shown prominently */
    avatarUrl: '',                        /* Set to image path to show photo */
    avatarColor: 1,                         /* 1-6 — selects gradient preset */
    memberSince: '2022-04-18',
    location: 'Boston, MA',
    lastLogin: 'Today at 08:42 AM'
};


/* ─────────────────────────────────────────────────────────────────
   2. APPLICATION STATE
   ───────────────────────────────────────────────────────────────── */
const _state = {
    isEditing: false,
    savedSnapshot: {}   /* values before edit — used for cancel */
};


/* ─────────────────────────────────────────────────────────────────
   3. INITIALISATION
   ───────────────────────────────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', function () {

    /*
     * *** DB HOOK: If loading from server, call:
     *   fetch('/api/patients/me')
     *       .then(r => r.json())
     *       .then(renderProfile)
     *       .catch(() => renderProfile(patientProfile)); // fallback
     *
     * For now, use sample data:
     */
    renderProfile(patientProfile);
});


/* ─────────────────────────────────────────────────────────────────
   4. RENDER — FULL PROFILE
   ───────────────────────────────────────────────────────────────── */

/**
 * Master render function. Populates every section of the page.
 * @param {Object} p  Patient data object.
 */
function renderProfile(p) {
    renderAvatar(p);
    renderBanner(p);
    renderLeftCard(p);
    renderFields(p);
}

/* ─────────────────────────────────────────────────────────────────
   5. RENDER — AVATAR
   ───────────────────────────────────────────────────────────────── */

/**
 * Fills both avatar elements (banner + profile card).
 * If avatarUrl is set, shows an <img>; otherwise shows initials.
 */
function renderAvatar(p) {
    var initials = getInitials(p.displayName);
    var gradients = [
        'linear-gradient(135deg,#2563EB,#0D9488)',
        'linear-gradient(135deg,#1A9E5C,#0F1D2E)',
        'linear-gradient(135deg,#D97706,#DC2626)',
        'linear-gradient(135deg,#7C3AED,#2563EB)',
        'linear-gradient(135deg,#0D9488,#1A9E5C)',
        'linear-gradient(135deg,#EC4899,#7C3AED)'
    ];
    var bg = gradients[(p.avatarColor - 1) % gradients.length];

    /* Both avatar containers */
    ['prpAvatar', 'prpAvatarCard'].forEach(function (id) {
        var wrap = document.getElementById(id);
        if (!wrap) return;

        if (p.avatarUrl) {
            /* Photo mode */
            wrap.innerHTML = '<img src="' + escHtml(p.avatarUrl) + '" alt="Profile photo" />';
            wrap.style.background = 'transparent';
        } else {
            /* Initials mode */
            wrap.innerHTML = '<span class="prp-avatar__initials">' + initials + '</span>';
            wrap.style.background = bg;
        }
    });

    /* Initials-only elements if they still exist */
    setText('prpInitials', initials);
    setText('prpInitialsCard', initials);
}


/* ─────────────────────────────────────────────────────────────────
   6. RENDER — BANNER
   ───────────────────────────────────────────────────────────────── */
function renderBanner(p) {
    setText('prpDisplayName', p.displayName);
}


/* ─────────────────────────────────────────────────────────────────
   7. RENDER — LEFT CARD
   ───────────────────────────────────────────────────────────────── */
function renderLeftCard(p) {
    setText('prpCardName', p.displayName);
    setText('prpPatientId', p.id);
    setText('prpMemberSince', formatDate(p.memberSince));
    setText('prpLocation', p.location);
    setText('prpLastLogin', p.lastLogin);
}


/* ─────────────────────────────────────────────────────────────────
   8. RENDER — FIELDS (view mode)
   ───────────────────────────────────────────────────────────────── */
function renderFields(p) {
    setText('prpUsername', p.username);
    setText('prpEmail', p.email);
    setText('prpPhone', p.phone);
}


/* ─────────────────────────────────────────────────────────────────
   9. EDIT MODE
   ───────────────────────────────────────────────────────────────── */

/**
 * Switch the page into edit mode:
 *  - Hides view spans, shows input fields.
 *  - Pre-fills inputs with current values.
 *  - Snapshots current values for cancel.
 *  - Swaps Edit button for Save + Cancel.
 */
function enterEditMode() {
    if (_state.isEditing) return;
    _state.isEditing = true;

    /* Snapshot for cancel */
    _state.savedSnapshot = {
        username: getText('prpUsername'),
        email: getText('prpEmail'),
        phone: getText('prpPhone')
    };

    /* Pre-fill inputs */
    setVal('inputUsername', _state.savedSnapshot.username);
    setVal('inputEmail', _state.savedSnapshot.email);

    /* Phone: strip code prefix if present */
    var rawPhone = _state.savedSnapshot.phone;
    setVal('inputPhone', rawPhone);

    /* Show edit panels, hide view panels */
    toggleFieldMode(true);

    /* Swap buttons */
    showEditButtons(true);

    /* Focus first input */
    focusEl('inputUsername');

    showToast('Edit mode — make your changes and click Save.');
}

/**
 * Validate and save edited values.
 * *** DB HOOK: After collecting payload, call:
 *   fetch('/api/patients/me', {
 *       method: 'PUT',
 *       headers: { 'Content-Type': 'application/json' },
 *       body: JSON.stringify(payload)
 *   }).then(r => r.json()).then(() => {
 *       applyEditedValues(payload);
 *       exitEditMode();
 *       showToast('Profile saved to server.');
 *   }).catch(() => showToast('Save failed — please try again.'));
 */
function saveProfile() {
    /* Clear previous errors */
    clearAllErrors();

    /* Collect values */
    var username = getVal('inputUsername').trim();
    var email = getVal('inputEmail').trim();
    var phone = getVal('inputPhone').trim();

    /* Validate */
    var valid = true;

    if (!username || username.length < 3) {
        showError('inputUsername', 'Username must be at least 3 characters.');
        valid = false;
    }

    if (!email || !isValidEmail(email)) {
        showError('inputEmail', 'Please enter a valid email address.');
        valid = false;
    }

    if (!phone || phone.length < 6) {
        showError('inputPhone', 'Phone number is required.');
        valid = false;
    }

    if (!valid) {
        showToast('Please fix the errors before saving.');
        return;
    }

    /* Build updated data object */
    var updated = {
        username: username,
        email: email,
        phone: phone
    };

    /* Apply to view */
    applyEditedValues(updated);
    exitEditMode();

    showToast('Profile updated successfully.');
}

/**
 * Cancel edit — restore previous values.
 */
function cancelEdit() {
    clearAllErrors();
    exitEditMode();
    showToast('Edit cancelled. No changes made.');
}

/**
 * Push new values into view-mode spans and update patientProfile object.
 * *** DB HOOK: This is called after a successful API response.
 */
function applyEditedValues(updated) {
    /* Update display spans */
    setText('prpUsername', updated.username);
    setText('prpEmail', updated.email);
    setText('prpPhone', updated.phone);

    /* Update banner name if username changed */
    setText('prpDisplayName', updated.username);
    setText('prpCardName', updated.username);

    /* Sync sample data object (in-memory) */
    patientProfile.username = updated.username;
    patientProfile.email = updated.email;
    patientProfile.phone = updated.phone;
    patientProfile.displayName = updated.username;

    /* Refresh initials */
    renderAvatar(patientProfile);
}

/**
 * Common teardown: hide inputs, show view, swap buttons back.
 */
function exitEditMode() {
    _state.isEditing = false;
    toggleFieldMode(false);
    showEditButtons(false);
}

/**
 * Toggle between view and edit panels for all three fields.
 * @param {boolean} editing  true = show inputs; false = show spans.
 */
function toggleFieldMode(editing) {
    var fields = [
        { view: 'viewUsername', edit: 'editUsername' },
        { view: 'viewEmail', edit: 'editEmail' },
        { view: 'viewPhone', edit: 'editPhone' }
    ];

    fields.forEach(function (f) {
        var viewEl = document.getElementById(f.view);
        var editEl = document.getElementById(f.edit);
        if (viewEl) viewEl.style.display = editing ? 'none' : 'flex';
        if (editEl) editEl.style.display = editing ? 'block' : 'none';
    });
}

/**
 * Show/hide Edit vs Save+Cancel buttons.
 * @param {boolean} editing
 */
function showEditButtons(editing) {
    display('btnEdit', !editing);
    display('btnSave', editing);
    display('btnCancel', editing);
}


/* ─────────────────────────────────────────────────────────────────
   10. VALIDATION HELPERS
   ───────────────────────────────────────────────────────────────── */

function isValidEmail(val) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
}

/**
 * Show an inline error below an input.
 * Adds a .prp-error-msg element after the input.
 */
function showError(inputId, msg) {
    var input = document.getElementById(inputId);
    if (!input) return;
    input.classList.add('prp-input--error');

    /* Remove any existing error for this input */
    var existing = input.parentNode.querySelector('.prp-error-msg');
    if (existing) existing.remove();

    var errEl = document.createElement('span');
    errEl.className = 'prp-error-msg prp-error-msg--visible';
    errEl.textContent = msg;
    input.parentNode.appendChild(errEl);
}

function clearAllErrors() {
    /* Remove error class from all inputs */
    document.querySelectorAll('.prp-input--error').forEach(function (el) {
        el.classList.remove('prp-input--error');
    });
    /* Remove error messages */
    document.querySelectorAll('.prp-error-msg').forEach(function (el) {
        el.remove();
    });
}


/* ─────────────────────────────────────────────────────────────────
   11. TOAST NOTIFICATION
   ───────────────────────────────────────────────────────────────── */
var _toastTimer = null;

/**
 * Display a bottom-right toast message for 3 seconds.
 * @param {string} msg
 */
function showToast(msg) {
    var toast = document.getElementById('prpToast');
    var msgEl = document.getElementById('prpToastMsg');
    if (!toast || !msgEl) return;

    msgEl.textContent = msg;
    toast.classList.add('prp-toast--show');

    if (_toastTimer) clearTimeout(_toastTimer);
    _toastTimer = setTimeout(function () {
        toast.classList.remove('prp-toast--show');
    }, 3200);
}


/* ─────────────────────────────────────────────────────────────────
   12. UTILITY HELPERS
   ───────────────────────────────────────────────────────────────── */

/** Set textContent of element by ID. */
function setText(id, val) {
    var el = document.getElementById(id);
    if (el) el.textContent = val || '--';
}

/** Get textContent of element by ID. */
function getText(id) {
    var el = document.getElementById(id);
    return el ? el.textContent.trim() : '';
}

/** Set value of an input by ID. */
function setVal(id, val) {
    var el = document.getElementById(id);
    if (el) el.value = (val !== null && val !== undefined) ? val : '';
}

/** Get value of an input by ID. */
function getVal(id) {
    var el = document.getElementById(id);
    return el ? el.value : '';
}

/** Show or hide an element (inline-flex / none). */
function display(id, show) {
    var el = document.getElementById(id);
    if (!el) return;
    el.style.display = show ? 'inline-flex' : 'none';
}

/** Focus an input. */
function focusEl(id) {
    var el = document.getElementById(id);
    if (el) setTimeout(function () { el.focus(); }, 60);
}

/** Return two-letter initials from a full name. */
function getInitials(name) {
    return (name || '')
        .split(' ')
        .map(function (n) { return n.charAt(0); })
        .slice(0, 2)
        .join('')
        .toUpperCase();
}

/** Format ISO date string to "18 Apr 2022". */
function formatDate(str) {
    if (!str) return '--';
    var d = new Date(str);
    return isNaN(d.getTime())
        ? str
        : d.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
}

/** Escape HTML special characters (used when building innerHTML). */
function escHtml(str) {
    return String(str || '')
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}