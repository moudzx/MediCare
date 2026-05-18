/* ═══════════════════════════════════════════════════════════════════
   FILE: DoctorProfile.js  |  LOCATION: /Scripts/DoctorProfile.js
   Doctor Profile — MediCare Healthcare System

   SECTIONS:
   1. Sample Doctor Data
   2. State
   3. Initialisation
   4. Render Functions
   5. Edit Mode
   6. Toast
   7. Utilities

   *** DB HOOK markers show where backend calls connect later ***
   ═══════════════════════════════════════════════════════════════════ */

/* ── 1. SAMPLE DOCTOR DATA ──────────────────────────────────────── */

/**
 * *** DB HOOK: Replace this object with:
 *   fetch('/api/doctors/{id}')
 *     .then(r => r.json())
 *     .then(data => renderDoctorProfile(data));
 */
const doctorData = {
    id: 2001,
    fullName: "Dr. Michael A. Torres",
    shortName: "Torres",
    specialty: "Cardiology",
    department: "Cardiology Dept.",
    licenseNo: "MD-TX-20498",
    yearsExperience: 18,
    hospital: "MediCare General Hospital",
    office: "Room 4B, Floor 3",

    /* Contact — phone is required */
    phoneNumber: "+1 (555) 312-9876",
    email: "dr.torres@medicare-hospital.com",

    /* Availability */
    availabilityStatus: "available",  /* available | busy | away | unavailable */

    /* Bio */
    bio: "Dr. Michael Torres is a board-certified cardiologist with over 18 years of experience in interventional cardiology and heart failure management. He completed his residency at Johns Hopkins Hospital and his fellowship at the Cleveland Clinic. Dr. Torres is known for his patient-centred approach, combining the latest evidence-based treatments with compassionate care. He has published over 40 peer-reviewed articles and is a regular speaker at international cardiology conferences.",

    /* Statistics */
    stats: {
        totalPatients: 1247,
        totalAppointments: 3892,
        rating: "4.9 ★",
        yearsActive: 18
    },

    /* Professional Details */
    professional: [
        { label: "Full Name", val: "Dr. Michael A. Torres" },
        { label: "Specialty", val: "Cardiology" },
        { label: "Sub-Specialty", val: "Interventional Cardiology" },
        { label: "License No.", val: "MD-TX-20498" },
        { label: "NPI Number", val: "1234567890" },
        { label: "Department", val: "Cardiology Department" },
        { label: "Years Experience", val: "18 years" },
        { label: "Languages", val: "English, Spanish" },
        { label: "Consultation Fee", val: "$250 / session" }
    ],

    /* Specialisations tags */
    specialisations: [
        "Interventional Cardiology",
        "Heart Failure",
        "Echocardiography",
        "Cardiac Imaging",
        "Hypertension",
        "Arrhythmia",
        "Preventive Cardiology"
    ],

    /* Working hours */
    workingHours: [
        { day: "Monday", time: "08:00 – 16:00", off: false },
        { day: "Tuesday", time: "08:00 – 16:00", off: false },
        { day: "Wednesday", time: "10:00 – 18:00", off: false },
        { day: "Thursday", time: "08:00 – 16:00", off: false },
        { day: "Friday", time: "08:00 – 14:00", off: false },
        { day: "Saturday", time: "09:00 – 13:00", off: false },
        { day: "Sunday", time: "Off", off: true }
    ],

    /* Education */
    education: [
        { degree: "MD – Doctor of Medicine", school: "Harvard Medical School", year: "2001 – 2005", icon: "fas fa-graduation-cap" },
        { degree: "Residency – Internal Medicine", school: "Johns Hopkins Hospital", year: "2005 – 2008", icon: "fas fa-hospital" },
        { degree: "Fellowship – Cardiology", school: "Cleveland Clinic", year: "2008 – 2010", icon: "fas fa-heart" },
        { degree: "Board Certification – FACC", school: "American College of Cardiology", year: "2011", icon: "fas fa-certificate" }
    ],

    /* Recent patients */
    recentPatients: [
        { name: "Sarah Johnson", detail: "Hypertension · Last visit May 10", status: "stable", avatarColor: 1 },
        { name: "David Kim", detail: "CAD · Last visit May 8", status: "critical", avatarColor: 4 },
        { name: "Linda Okafor", detail: "Heart Failure · Last visit May 5", status: "recovering", avatarColor: 5 },
        { name: "Robert Hayes", detail: "COPD · Last visit Apr 28", status: "observation", avatarColor: 3 },
        { name: "Maria Gonzalez", detail: "Arrhythmia · Last visit Apr 20", status: "stable", avatarColor: 2 }
    ]
};


/* ── 2. STATE ───────────────────────────────────────────────────── */
let _dpEditMode = false;
let _dpOriginal = {};


/* ── 3. INITIALISATION ──────────────────────────────────────────── */

document.addEventListener('DOMContentLoaded', function () {
    /*
     * *** DB HOOK: Replace with fetch('/api/doctors/2001')
     *   .then(r => r.json()).then(renderDoctorProfile);
     */
    renderDoctorProfile(doctorData);
});


/* ── 4. RENDER FUNCTIONS ────────────────────────────────────────── */

function renderDoctorProfile(d) {
    /* Avatar */
    dpSetText('dpInitials', getInitials(d.fullName));

    /* Availability dot */
    const dot = document.getElementById('dpAvailabilityDot');
    if (dot) {
        dot.className = 'dp-avatar__availability';
        if (d.availabilityStatus === 'busy') dot.classList.add('dp-avatar__availability--busy');
        else if (d.availabilityStatus === 'away') dot.classList.add('dp-avatar__availability--away');
        else if (d.availabilityStatus === 'unavailable') dot.classList.add('dp-avatar__availability--unavail');
        dot.title = capitalise(d.availabilityStatus);
    }

    /* Banner */
    dpSetText('dpSpecialty', d.specialty);
    dpSetText('dpFullName', d.fullName);
    dpSetText('dpShortName', d.shortName);
    dpSetHTML('dpExperience', '<i class="fas fa-award"></i> ' + d.yearsExperience + ' yrs experience');
    dpSetHTML('dpDept', '<i class="fas fa-hospital"></i> ' + d.department);
    dpSetHTML('dpLicense', '<i class="fas fa-id-badge"></i> ' + d.licenseNo);

    /* Stats bar */
    animateCounter('dpStatPatients', d.stats.totalPatients);
    animateCounter('dpStatAppts', d.stats.totalAppointments);
    dpSetText('dpStatRating', d.stats.rating);
    dpSetText('dpStatYears', d.stats.yearsActive);

    /* Contact */
    dpSetText('dpPhone', d.phoneNumber);
    dpSetText('dpEmail', d.email);
    dpSetText('dpOffice', d.office);
    dpSetText('dpHospital', d.hospital);

    /* Availability badge */
    renderAvailabilityBadge(d.availabilityStatus);

    /* Working hours */
    renderWorkingHours(d.workingHours);

    /* Specialisation tags */
    renderSpecTags(d.specialisations);

    /* Bio */
    dpSetText('dpBio', d.bio);

    /* Professional grid */
    renderProfessionalGrid(d.professional);

    /* Education */
    renderEducation(d.education);

    /* Recent patients */
    renderRecentPatients(d.recentPatients);
}

function renderAvailabilityBadge(status) {
    const badge = document.getElementById('dpAvailBadge');
    if (!badge) return;
    const map = {
        available: { cls: '', label: 'Available Now' },
        busy: { cls: '--busy', label: 'Currently Busy' },
        away: { cls: '--away', label: 'Away' },
        unavailable: { cls: '--unavail', label: 'Unavailable Today' }
    };
    const cfg = map[status] || map['available'];
    badge.className = 'dp-availability-badge' + (cfg.cls ? ' dp-availability-badge' + cfg.cls : '');
    badge.innerHTML = '<i class="fas fa-circle"></i> ' + cfg.label;
}

function renderWorkingHours(hours) {
    const list = document.getElementById('dpHoursList');
    if (!list || !hours) return;
    list.innerHTML = hours.map(function (h) {
        return '<div class="dp-hours-row' + (h.off ? ' dp-hours-row--off' : '') + '">'
            + '<span class="dp-hours-row__day">' + h.day + '</span>'
            + '<span class="dp-hours-row__time">' + h.time + '</span>'
            + '</div>';
    }).join('');
}

function renderSpecTags(tags) {
    const wrap = document.getElementById('dpSpecTags');
    if (!wrap || !tags) return;
    wrap.innerHTML = tags.map(function (t) {
        return '<span class="dp-tag">' + escHtml(t) + '</span>';
    }).join('');
}

function renderProfessionalGrid(fields) {
    const grid = document.getElementById('dpProfGrid');
    if (!grid || !fields) return;
    grid.innerHTML = fields.map(function (f) {
        return '<div class="dp-info-cell">'
            + '<span class="dp-info-cell__label">' + f.label + '</span>'
            + '<span class="dp-info-cell__val" data-field="' + f.label + '">' + escHtml(f.val) + '</span>'
            + '</div>';
    }).join('');
}

function renderEducation(edu) {
    const list = document.getElementById('dpEduList');
    if (!list || !edu) return;
    list.innerHTML = edu.map(function (e) {
        return '<div class="dp-edu-item">'
            + '<div class="dp-edu-item__icon"><i class="' + e.icon + '"></i></div>'
            + '<div>'
            + '<div class="dp-edu-item__degree">' + escHtml(e.degree) + '</div>'
            + '<div class="dp-edu-item__school">' + escHtml(e.school) + '</div>'
            + '<div class="dp-edu-item__year">' + escHtml(e.year) + '</div>'
            + '</div>'
            + '</div>';
    }).join('');
}

function renderRecentPatients(patients) {
    const list = document.getElementById('dpPatientList');
    if (!list || !patients) return;
    list.innerHTML = patients.map(function (p) {
        return '<div class="dp-patient-item">'
            + '<div class="dp-patient-avatar dp-patient-avatar--' + p.avatarColor + '">'
            + getInitials(p.name) + '</div>'
            + '<div>'
            + '<div class="dp-patient-item__name">' + escHtml(p.name) + '</div>'
            + '<div class="dp-patient-item__detail">' + escHtml(p.detail) + '</div>'
            + '</div>'
            + '<span class="dp-patient-item__badge dp-patient-item__badge--' + p.status + '">'
            + capitalise(p.status) + '</span>'
            + '</div>';
    }).join('');
}


/* ── 5. EDIT MODE ───────────────────────────────────────────────── */

function toggleDpEdit() {
    _dpEditMode = true;
    _dpOriginal = dpSnapshotEditables();

    /* Make professional grid cells editable */
    document.querySelectorAll('#dpProfGrid .dp-info-cell__val').forEach(function (el) {
        el.setAttribute('contenteditable', 'true');
    });

    /* Make bio editable */
    var bio = document.getElementById('dpBio');
    if (bio) bio.setAttribute('contenteditable', 'true');

    dpToggleEditButtons(true);
    showDpToast('Edit mode enabled. Make your changes and click Save.');
}

function saveDpProfile() {
    document.querySelectorAll('[contenteditable="true"]').forEach(function (el) {
        el.removeAttribute('contenteditable');
    });

    _dpEditMode = false;
    dpToggleEditButtons(false);

    /*
     * *** DB HOOK: Collect and POST updated values:
     *   const payload = dpCollectValues();
     *   fetch('/api/doctors/2001', {
     *       method: 'PUT',
     *       headers: { 'Content-Type': 'application/json' },
     *       body: JSON.stringify(payload)
     *   }).then(() => showDpToast('Profile saved to database.'));
     */

    showDpToast('Doctor profile updated successfully.');
}

function cancelDpEdit() {
    document.querySelectorAll('[contenteditable="true"]').forEach(function (el) {
        el.removeAttribute('contenteditable');
        var key = el.dataset.field;
        if (key && _dpOriginal[key] !== undefined) el.textContent = _dpOriginal[key];
    });

    /* Restore bio */
    var bio = document.getElementById('dpBio');
    if (bio && _dpOriginal['__bio'] !== undefined) bio.textContent = _dpOriginal['__bio'];

    _dpEditMode = false;
    dpToggleEditButtons(false);
    showDpToast('Edit cancelled. Changes discarded.');
}

function dpToggleEditButtons(editing) {
    var show = function (id, vis) {
        var el = document.getElementById(id);
        if (el) el.style.display = vis ? 'inline-flex' : 'none';
    };
    show('btnDpEdit', !editing);
    show('btnDpSave', editing);
    show('btnDpCancel', editing);
}

function dpSnapshotEditables() {
    var snap = {};
    document.querySelectorAll('#dpProfGrid .dp-info-cell__val').forEach(function (el) {
        snap[el.dataset.field] = el.textContent;
    });
    var bio = document.getElementById('dpBio');
    if (bio) snap['__bio'] = bio.textContent;
    return snap;
}


/* ── 6. TOAST ───────────────────────────────────────────────────── */
var _dpToastTimer = null;

function showDpToast(msg) {
    var toast = document.getElementById('dpToast');
    var msgEl = document.getElementById('dpToastMsg');
    if (!toast || !msgEl) return;
    msgEl.textContent = msg;
    toast.classList.add('dp-toast--show');
    if (_dpToastTimer) clearTimeout(_dpToastTimer);
    _dpToastTimer = setTimeout(function () { toast.classList.remove('dp-toast--show'); }, 3200);
}


/* ── 7. UTILITIES ───────────────────────────────────────────────── */

function dpSetText(id, val) {
    var el = document.getElementById(id);
    if (el) el.textContent = val || '--';
}

function dpSetHTML(id, html) {
    var el = document.getElementById(id);
    if (el) el.innerHTML = html;
}

function getInitials(name) {
    return (name || '').replace(/^Dr\.\s*/i, '').split(' ').map(function (n) { return n[0]; }).slice(0, 2).join('').toUpperCase();
}

function capitalise(str) {
    return str ? str.charAt(0).toUpperCase() + str.slice(1) : '';
}

function escHtml(str) {
    return String(str || '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

/**
 * Animate a number counting up from 0 to target.
 * *** DB HOOK: values come from the data object fetched from the server.
 */
function animateCounter(id, target) {
    var el = document.getElementById(id);
    if (!el) return;
    var start = 0;
    var duration = 1200;
    var startTime = null;

    function step(timestamp) {
        if (!startTime) startTime = timestamp;
        var progress = Math.min((timestamp - startTime) / duration, 1);
        var eased = 1 - Math.pow(1 - progress, 3);
        el.textContent = Math.floor(eased * target).toLocaleString();
        if (progress < 1) requestAnimationFrame(step);
    }

    requestAnimationFrame(step);
}