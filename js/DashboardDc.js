/* ═══════════════════════════════════════════════════════════════════
   FILE: Dashboard.js
   LOCATION: /Scripts/Dashboard.js
   Doctor Dashboard — full scheduling logic
   ═══════════════════════════════════════════════════════════════════ */

(function () {
    'use strict';

    /* ═══════════════════════════════════════════════════════════════
       1. SAMPLE APPOINTMENT DATA
       Each appointment is tied to a specific date offset from today.
       offset: 0 = today, 1 = tomorrow, -1 = yesterday, etc.
       hour: 0–23 (24-hour format)
       status: 'booked' | 'done' | 'break'
    ═══════════════════════════════════════════════════════════════════ */
    var APPOINTMENTS = [

        /* ── Today (offset: 0) ─────────────────────────────── */
        { offset: 0, hour: 8, name: 'Sara Al-Khalil', reason: 'Blood pressure check', type: 'Cardiology', status: 'done', avatar: 'S', color: '#6D28D9' },
        { offset: 0, hour: 9, name: 'Omar Mansour', reason: 'Follow-up consultation', type: 'Cardiology', status: 'done', avatar: 'O', color: '#0D9488' },
        { offset: 0, hour: 10, name: 'Lara Hassan', reason: 'ECG & heart monitoring', type: 'Cardiology', status: 'done', avatar: 'L', color: '#2563EB' },
        { offset: 0, hour: 11, name: '', reason: '', type: '', status: 'break', avatar: '', color: '' },
        { offset: 0, hour: 12, name: 'Ahmad Khalil', reason: 'Chest pain evaluation', type: 'Cardiology', status: 'booked', avatar: 'A', color: '#DC2626' },
        { offset: 0, hour: 13, name: 'Hana Younis', reason: 'Palpitations check-up', type: 'Cardiology', status: 'booked', avatar: 'H', color: '#059669' },
        { offset: 0, hour: 15, name: 'Rami Nassar', reason: 'Post-op follow-up', type: 'Cardiology', status: 'booked', avatar: 'R', color: '#7C3AED' },
        { offset: 0, hour: 16, name: 'Dana Saad', reason: 'Annual cardiac review', type: 'Cardiology', status: 'booked', avatar: 'D', color: '#1D4ED8' },

        /* ── Tomorrow (offset: 1) ──────────────────────────── */
        { offset: 1, hour: 8, name: 'Tarek Ibrahim', reason: 'New patient intake', type: 'Cardiology', status: 'booked', avatar: 'T', color: '#0D9488' },
        { offset: 1, hour: 9, name: 'Maya Khoury', reason: 'Stress test review', type: 'Cardiology', status: 'booked', avatar: 'M', color: '#D97706' },
        { offset: 1, hour: 10, name: 'Jad Nasser', reason: 'Cholesterol management', type: 'Cardiology', status: 'booked', avatar: 'J', color: '#6D28D9' },
        { offset: 1, hour: 11, name: '', reason: '', type: '', status: 'break', avatar: '', color: '' },
        { offset: 1, hour: 14, name: 'Rola Fares', reason: 'Heart failure monitoring', type: 'Cardiology', status: 'booked', avatar: 'R', color: '#DC2626' },
        { offset: 1, hour: 15, name: 'Samir Obeid', reason: 'Medication adjustment', type: 'Cardiology', status: 'booked', avatar: 'S', color: '#059669' },

        /* ── Yesterday (offset: -1) ────────────────────────── */
        { offset: -1, hour: 8, name: 'Carla Aoun', reason: 'Blood work review', type: 'Cardiology', status: 'done', avatar: 'C', color: '#2563EB' },
        { offset: -1, hour: 9, name: 'Eli Gemayel', reason: 'Arrhythmia consultation', type: 'Cardiology', status: 'done', avatar: 'E', color: '#D97706' },
        { offset: -1, hour: 10, name: 'Zeina Barakat', reason: 'Echocardiogram review', type: 'Cardiology', status: 'done', avatar: 'Z', color: '#7C3AED' },
        { offset: -1, hour: 13, name: '', reason: '', type: '', status: 'break', avatar: '', color: '' },
        { offset: -1, hour: 14, name: 'Fadi Rizk', reason: 'Post-angio follow-up', type: 'Cardiology', status: 'done', avatar: 'F', color: '#059669' },
        { offset: -1, hour: 15, name: 'Nada Abi Khalil', reason: 'Hypertension management', type: 'Cardiology', status: 'done', avatar: 'N', color: '#0D9488' },

        /* ── Day after tomorrow (offset: 2) ───────────────── */
        { offset: 2, hour: 9, name: 'George Abi Raad', reason: 'Cardiac catheterization', type: 'Cardiology', status: 'booked', avatar: 'G', color: '#DC2626' },
        { offset: 2, hour: 10, name: 'Rita Khazen', reason: 'Valve disease check', type: 'Cardiology', status: 'booked', avatar: 'R', color: '#6D28D9' },
        { offset: 2, hour: 14, name: 'Paul Lahoud', reason: 'Pacemaker check-up', type: 'Cardiology', status: 'booked', avatar: 'P', color: '#0D9488' },
        { offset: 2, hour: 15, name: '', reason: '', type: '', status: 'break', avatar: '', color: '' },
        { offset: 2, hour: 16, name: 'Carole Hajj', reason: 'New patient consultation', type: 'Cardiology', status: 'booked', avatar: 'C', color: '#D97706' },
    ];

    /* Working hours displayed (8 AM to 6 PM = hours 8–18) */
    var WORK_START = 8;
    var WORK_END = 18;

    /* ═══════════════════════════════════════════════════════════════
       2. STATE
    ═══════════════════════════════════════════════════════════════════ */
    var today = new Date();
    today.setHours(0, 0, 0, 0);
    var currentDate = new Date(today); /* displayed date */

    /* ═══════════════════════════════════════════════════════════════
       3. HELPERS
    ═══════════════════════════════════════════════════════════════════ */
    function getDayOffset(date) {
        var ms = date.getTime() - today.getTime();
        return Math.round(ms / (1000 * 60 * 60 * 24));
    }

    function formatDate(date) {
        var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        var months = ['January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'];
        return days[date.getDay()] + ', ' + months[date.getMonth()] + ' ' +
            date.getDate() + ', ' + date.getFullYear();
    }

    function formatTime(hour) {
        var h = hour % 12 || 12;
        var per = hour < 12 ? 'AM' : 'PM';
        return { main: String(h), period: per };
    }

    function getAppointmentsForOffset(offset) {
        return APPOINTMENTS.filter(function (a) { return a.offset === offset; });
    }

    function escHtml(s) {
        if (!s) return '';
        return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    /* ═══════════════════════════════════════════════════════════════
       4. WELCOME SECTION
    ═══════════════════════════════════════════════════════════════════ */
    function initWelcome() {
        /* Greeting based on time */
        var h = new Date().getHours();
        var gr = h < 12 ? 'Good morning,' : h < 17 ? 'Good afternoon,' : 'Good evening,';
        var el = document.getElementById('welcomeGreeting');
        if (el) el.textContent = gr;

        /* Date */
        var dateEl = document.getElementById('welcomeDate');
        if (dateEl) dateEl.textContent = formatDate(new Date());
    }

    /* ═══════════════════════════════════════════════════════════════
       5. STATISTICS CARDS (animated count-up)
    ═══════════════════════════════════════════════════════════════════ */
    function updateStats(offset) {
        var appts = getAppointmentsForOffset(offset);
        var booked = appts.filter(function (a) { return a.status === 'booked'; }).length;
        var done = appts.filter(function (a) { return a.status === 'done'; }).length;
        var patients = booked + done;
        var totalWork = WORK_END - WORK_START;
        var breakHrs = appts.filter(function (a) { return a.status === 'break'; }).length;
        var usedHrs = patients + breakHrs;
        var freeHrs = Math.max(0, totalWork - usedHrs);

        /* Completed this week (always a nice bigger number) */
        var weekDone = APPOINTMENTS.filter(function (a) { return a.status === 'done'; }).length;

        countUp('statPatients', patients);
        countUp('statBooked', booked + done);
        countUp('statAvailable', freeHrs);
        countUp('statCompleted', weekDone);
    }

    function countUp(id, target) {
        var el = document.getElementById(id);
        if (!el) return;
        var dur = 900;
        var start = performance.now();

        function step(now) {
            var p = Math.min((now - start) / dur, 1);
            var val = Math.round((1 - Math.pow(1 - p, 3)) * target);
            el.textContent = val;
            if (p < 1) requestAnimationFrame(step);
        }
        requestAnimationFrame(step);
    }

    /* ═══════════════════════════════════════════════════════════════
       6. SCHEDULE GRID RENDER
    ═══════════════════════════════════════════════════════════════════ */
    function renderSchedule(date) {
        var grid = document.getElementById('scheduleGrid');
        var sub = document.getElementById('scheduleSubtitle');
        var datePillText = document.getElementById('datePillText');
        var summaryEl = document.getElementById('scheduleSummary');

        if (!grid) return;

        var offset = getDayOffset(date);
        var appts = getAppointmentsForOffset(offset);

        /* Build appointment map keyed by hour */
        var apptMap = {};
        appts.forEach(function (a) { apptMap[a.hour] = a; });

        /* Subtitle */
        var isToday = offset === 0;
        var isTomorrow = offset === 1;
        var isYesterday = offset === -1;
        var label = isToday ? 'Today' : isTomorrow ? 'Tomorrow' : isYesterday ? 'Yesterday' : formatDate(date);

        if (sub) sub.textContent = label + ' · ' + appts.filter(function (a) { return a.status !== 'break'; }).length + ' appointments';
        if (datePillText) datePillText.textContent = isToday ? 'Today — ' + formatDate(date) : formatDate(date);

        /* Current hour for highlight */
        var nowHour = new Date().getHours();

        /* Clear + render */
        grid.innerHTML = '';

        var html = '';
        var bookedCount = 0;
        var freeCount = 0;
        var doneCount = 0;

        for (var h = WORK_START; h <= WORK_END; h++) {
            var t = formatTime(h);
            var appt = apptMap[h];
            var isCurr = isToday && h === nowHour;

            var slotClass = 'db-slot' + (isCurr ? ' db-slot--current' : '');

            if (appt) {
                if (appt.status === 'break') {
                    /* Break slot */
                    html += buildSlot(slotClass, t, 'break', h,
                        '<div class="db-slot__icon"><i class="fa-solid fa-mug-hot"></i></div>' +
                        '<div class="db-slot__info">' +
                        '<div class="db-slot__patient-name">Break / Lunch</div>' +
                        '<div class="db-slot__detail">Personal time — no appointments</div>' +
                        '</div>' +
                        '<span class="db-slot__badge db-slot__badge--break">Break</span>');
                } else {
                    /* Patient appointment */
                    var statusClass = appt.status === 'done' ? 'done' : 'booked';
                    var icon = appt.status === 'done'
                        ? '<i class="fa-solid fa-circle-check"></i>'
                        : '<i class="fa-solid fa-user-injured"></i>';
                    var badge = appt.status === 'done'
                        ? '<span class="db-slot__badge db-slot__badge--done">Completed</span>'
                        : '<span class="db-slot__badge db-slot__badge--booked">Booked</span>';

                    if (appt.status === 'done') doneCount++;
                    else bookedCount++;

                    html += buildSlot(slotClass, t, statusClass, h,
                        '<div class="db-slot__icon" style="background:' + appt.color + '22;color:' + appt.color + '">' + icon + '</div>' +
                        '<div class="db-slot__info">' +
                        '<div class="db-slot__patient-name">' + escHtml(appt.name) + '</div>' +
                        '<div class="db-slot__detail">' +
                        '<i class="fa-solid fa-stethoscope" style="font-size:10px;margin-right:4px;"></i>' +
                        escHtml(appt.reason) + ' · ' + escHtml(appt.type) +
                        '</div>' +
                        '</div>' +
                        badge);
                }
            } else {
                /* Free slot */
                freeCount++;
                html += buildSlot(slotClass, t, 'free', h,
                    '<div class="db-slot__icon"><i class="fa-solid fa-plus"></i></div>' +
                    '<div class="db-slot__info">' +
                    '<div class="db-slot__free-label">Available Slot</div>' +
                    '</div>' +
                    '<span class="db-slot__badge db-slot__badge--free">Open</span>');
            }
        }

        grid.innerHTML = html;

        /* Apply staggered animation delay */
        var slots = grid.querySelectorAll('.db-slot');
        slots.forEach(function (slot, i) {
            slot.style.animationDelay = (i * 35) + 'ms';
        });

        /* Scroll current hour into view */
        if (isToday) {
            setTimeout(function () {
                var curEl = grid.querySelector('.db-slot--current');
                if (curEl) curEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }, 400);
        }

        /* Summary */
        if (summaryEl) {
            summaryEl.innerHTML =
                '<div class="db-summary-item">' +
                '<span class="db-summary-dot" style="background:#2563EB"></span>' +
                bookedCount + ' booked' +
                '</div>' +
                '<div class="db-summary-item">' +
                '<span class="db-summary-dot" style="background:#1A9E5C"></span>' +
                doneCount + ' completed' +
                '</div>' +
                '<div class="db-summary-item">' +
                '<span class="db-summary-dot" style="background:#D1D5DB"></span>' +
                freeCount + ' available' +
                '</div>';
        }
    }

    function buildSlot(slotClass, t, cardType, hour, inner) {
        return (
            '<div class="' + slotClass + '" role="row">' +
            '<div class="db-slot__time">' +
            '<span class="db-slot__time-main">' + t.main + '</span>' +
            '<span class="db-slot__time-period">' + t.period + '</span>' +
            '</div>' +
            '<div class="db-slot__line"></div>' +
            '<div class="db-slot__card db-slot__card--' + cardType + '">' +
            inner +
            '</div>' +
            '</div>'
        );
    }

    /* ═══════════════════════════════════════════════════════════════
       7. DAY NAVIGATION
    ═══════════════════════════════════════════════════════════════════ */
    window.goToDay = function (delta) {
        currentDate = new Date(currentDate);
        currentDate.setDate(currentDate.getDate() + delta);

        /* Slide-out then slide-in animation */
        var grid = document.getElementById('scheduleGrid');
        if (grid) {
            grid.style.opacity = '0';
            grid.style.transform = delta > 0 ? 'translateX(20px)' : 'translateX(-20px)';
            grid.style.transition = 'opacity .2s ease, transform .2s ease';

            setTimeout(function () {
                renderSchedule(currentDate);
                updateStats(getDayOffset(currentDate));
                renderUpcoming(getDayOffset(currentDate));
                grid.style.opacity = '1';
                grid.style.transform = 'translateX(0)';
            }, 200);
        } else {
            renderSchedule(currentDate);
            updateStats(getDayOffset(currentDate));
        }
    };

    window.goToToday = function () {
        currentDate = new Date(today);
        renderSchedule(currentDate);
        updateStats(0);
        renderUpcoming(0);
    };

    /* ═══════════════════════════════════════════════════════════════
       8. UPCOMING APPOINTMENTS LIST
    ═══════════════════════════════════════════════════════════════════ */
    function renderUpcoming(currentOffset) {
        var list = document.getElementById('upcomingList');
        if (!list) return;

        /* Show next appointments from today onward, status = booked */
        var upcoming = APPOINTMENTS
            .filter(function (a) {
                return a.status === 'booked' && a.offset >= 0;
            })
            .sort(function (a, b) {
                return (a.offset * 100 + a.hour) - (b.offset * 100 + b.hour);
            })
            .slice(0, 5);

        if (upcoming.length === 0) {
            list.innerHTML = '<div style="text-align:center;padding:32px;color:#9CA3AF;font-size:14px;">No upcoming appointments.</div>';
            return;
        }

        var avatarColors = ['#6D28D9', '#0D9488', '#2563EB', '#DC2626', '#D97706', '#059669', '#7C3AED'];

        var html = '';
        upcoming.forEach(function (a, i) {
            var t = formatTime(a.hour);
            var isNow = a.offset === 0 && a.hour === new Date().getHours();
            var isSoon = a.offset === 0 && a.hour <= new Date().getHours() + 2 && !isNow;

            var statusLabel = isNow ? 'Now' : isSoon ? 'Soon' : a.offset === 0 ? 'Today' : a.offset === 1 ? 'Tomorrow' : 'Day +' + a.offset;
            var statusClass = isNow ? 'db-upcoming-status--soon' : isSoon ? 'db-upcoming-status--soon' : 'db-upcoming-status--confirmed';
            var bgColor = avatarColors[i % avatarColors.length];

            html +=
                '<div class="db-upcoming-item">' +
                '<div class="db-upcoming-avatar" style="background:' + bgColor + '">' + escHtml(a.avatar) + '</div>' +
                '<div class="db-upcoming-info">' +
                '<div class="db-upcoming-name">' + escHtml(a.name) + '</div>' +
                '<div class="db-upcoming-reason">' + escHtml(a.reason) + '</div>' +
                '</div>' +
                '<div class="db-upcoming-time">' +
                t.main + ':00 ' + t.period +
                '<small>' + statusLabel + '</small>' +
                '</div>' +
                '<span class="db-upcoming-status ' + statusClass + '">' + statusLabel + '</span>' +
                '</div>';
        });

        list.innerHTML = html;
    }

    /* ═══════════════════════════════════════════════════════════════
       9. CARD ENTRANCE ANIMATIONS
    ═══════════════════════════════════════════════════════════════════ */
    function initCardAnimations() {
        var cards = document.querySelectorAll('.db-stat-card, .db-schedule-wrap, .db-upcoming-wrap, .db-welcome');
        if (!('IntersectionObserver' in window)) return;

        cards.forEach(function (card, i) {
            card.style.opacity = '0';
            card.style.transform = 'translateY(18px)';
            card.style.transition = 'opacity .5s ease, transform .5s ease';
            card.style.transitionDelay = (i * 80) + 'ms';
        });

        var obs = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                    obs.unobserve(entry.target);
                }
            });
        }, { threshold: 0.08 });

        cards.forEach(function (c) { obs.observe(c); });
    }

    /* ═══════════════════════════════════════════════════════════════
       10. INIT
    ═══════════════════════════════════════════════════════════════════ */
    function init() {
        initWelcome();
        initCardAnimations();

        /* Initial render */
        updateStats(0);
        renderSchedule(currentDate);
        renderUpcoming(0);
    }

    /* Boot */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

})();