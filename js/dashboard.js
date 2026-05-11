/* ═══════════════════════════════════════════════════════════════════
   FILE: Dashboard.js
   LOCATION: /Scripts/Dashboard.js
   ACTION: Create this new file inside the Scripts folder
   NOTE: This file is loaded AFTER Medicare.js via the ScriptContent
         placeholder in PatientDashboard.aspx
   ═══════════════════════════════════════════════════════════════════ */

(function () {
    'use strict';

    /* ── Helpers ───────────────────────────────────────────────────── */
    var $ = function (id) { return document.getElementById(id); };
    var $$ = function (sel, ctx) { return Array.from((ctx || document).querySelectorAll(sel)); };

    /* ────────────────────────────────────────────────────────────────
       1. BMI fill bar — calculate position from BMI value
    ─────────────────────────────────────────────────────────────────── */
    function initBMIBar() {
        var fill = document.querySelector('.pd-bmi-fill');
        var bmiEl = document.querySelector('.pd-bmi-cat');
        if (!fill || !bmiEl) return;

        // Read BMI text from label next to category
        var bmiTextEl = document.querySelector('.pd-bmi-value');
        if (!bmiTextEl) return;

        var raw = bmiTextEl.textContent.trim().split('—')[0].trim();
        var bmi = parseFloat(raw);
        if (isNaN(bmi)) return;

        // Map BMI 15–40 to 0–100%
        var pct = Math.max(0, Math.min(100, ((bmi - 15) / 25) * 100));

        setTimeout(function () {
            fill.style.width = pct + '%';
        }, 400);
    }

    /* ────────────────────────────────────────────────────────────────
       2. Dose checkboxes — style sync + progress bar + ring update
    ─────────────────────────────────────────────────────────────────── */
    function initDoseCheckboxes() {
        // ASP.NET CheckBox renders as <span><input id="..." /><label for="..."></label></span>
        // We style via the label; the input handles the actual check state.
        // On page load, style the rows and badges correctly.
        syncAllDoseRows();

        // Listen for changes on all checkboxes inside dose rows
        $$('.pd-dose-check input[type="checkbox"]').forEach(function (input) {
            input.addEventListener('change', function () {
                var row = this.closest('.pd-dose-row');
                if (row) {
                    if (this.checked) {
                        row.classList.add('pd-dose-row--taken');
                        row.classList.remove('pd-dose-row--pending');
                        var statusEl = row.querySelector('.pd-dose-status');
                        if (statusEl) {
                            statusEl.className = 'pd-dose-status pd-dose-status--done';
                            statusEl.textContent = '✓ Taken';
                        }
                    } else {
                        row.classList.remove('pd-dose-row--taken');
                        var timeEl = row.querySelector('.pd-dose-time');
                        var statusEl2 = row.querySelector('.pd-dose-status');
                        if (statusEl2 && timeEl) {
                            var timeText = timeEl.textContent.trim();
                            var hour = parseFloat(timeText);
                            var now = new Date().getHours();
                            if (hour <= now) {
                                row.classList.add('pd-dose-row--pending');
                                statusEl2.className = 'pd-dose-status pd-dose-status--pending';
                                statusEl2.textContent = '⏱ Pending';
                            } else {
                                statusEl2.className = 'pd-dose-status pd-dose-status--upcoming';
                                statusEl2.textContent = '🌙 Tonight';
                            }
                        }
                    }
                }
                updateProgressRing();
                updateProgressBar();
            });
        });
    }

    function syncAllDoseRows() {
        $$('.pd-dose-row').forEach(function (row) {
            var input = row.querySelector('input[type="checkbox"]');
            if (!input) return;
            if (input.checked) {
                row.classList.add('pd-dose-row--taken');
                row.classList.remove('pd-dose-row--pending');
            }
        });
        updateProgressRing();
        updateProgressBar();
    }

    function countDoses() {
        var inputs = $$('.pd-dose-check input[type="checkbox"]');
        var total = inputs.length;
        var taken = inputs.filter(function (i) { return i.checked; }).length;
        return { total: total, taken: taken };
    }

    /* ────────────────────────────────────────────────────────────────
       3. Progress Ring (SVG arc in card header)
    ─────────────────────────────────────────────────────────────────── */
    function updateProgressRing() {
        var arc = $('dpmArc');
        var pct = $('dpmPct');
        if (!arc || !pct) return;

        var d = countDoses();
        var ratio = d.total > 0 ? d.taken / d.total : 0;
        var circ = 100;
        var filled = Math.round(ratio * circ);

        arc.setAttribute('stroke-dasharray', filled + ' ' + (circ - filled));
        pct.textContent = Math.round(ratio * 100) + '%';
    }

    /* ────────────────────────────────────────────────────────────────
       4. Progress Bar (footer)
    ─────────────────────────────────────────────────────────────────── */
    function updateProgressBar() {
        var bar = $('dosesBarFill');
        if (!bar) return;
        var d = countDoses();
        var pct = d.total > 0 ? Math.round((d.taken / d.total) * 100) : 0;
        bar.style.width = pct + '%';
    }

    /* ────────────────────────────────────────────────────────────────
       5. Health edit panel — smooth slide toggle
    ─────────────────────────────────────────────────────────────────── */
    function initHealthEditToggle() {
        // Add transition class to edit panel when it appears via postback
        var editPanel = document.querySelector('.pd-health-edit');
        if (editPanel && editPanel.style.display !== 'none' && editPanel.offsetParent !== null) {
            editPanel.style.animation = 'pd-slideDown .3s cubic-bezier(.4,0,.2,1) both';
        }
    }

    /* ────────────────────────────────────────────────────────────────
       6. Inventory bars — animate on scroll into view
    ─────────────────────────────────────────────────────────────────── */
    function initInventoryBars() {
        var fills = $$('.pd-inv-fill');
        if (!fills.length || !('IntersectionObserver' in window)) return;

        var origWidths = fills.map(function (f) {
            var w = f.style.width;
            f.style.width = '0%';
            return w;
        });

        var card = document.querySelector('.pd-card--inventory');
        if (!card) return;

        var observer = new IntersectionObserver(function (entries) {
            if (entries[0].isIntersecting) {
                fills.forEach(function (f, i) {
                    setTimeout(function () { f.style.width = origWidths[i]; }, i * 120);
                });
                observer.disconnect();
            }
        }, { threshold: 0.3 });

        observer.observe(card);
    }

    /* ────────────────────────────────────────────────────────────────
       7. Quick stat cards — count-up animation
    ─────────────────────────────────────────────────────────────────── */
    function initQSCounters() {
        $$('.pd-qs-value').forEach(function (el) {
            var raw = el.textContent.trim();
            // only animate pure numbers
            var num = parseInt(raw.replace('%', ''), 10);
            if (isNaN(num) || num < 2) return;

            var isPct = raw.includes('%');
            var duration = 1200;
            var start = performance.now();

            function step(now) {
                var progress = Math.min((now - start) / duration, 1);
                var eased = 1 - Math.pow(1 - progress, 3);
                var current = Math.round(eased * num);
                // Preserve inner label span if present
                var labelEl = el.querySelector('.pd-qs-label');
                if (labelEl) {
                    el.childNodes[0].textContent = current + (isPct ? '' : '');
                } else {
                    el.textContent = current + (isPct ? '%' : '');
                }
                if (progress < 1) requestAnimationFrame(step);
            }
            requestAnimationFrame(step);
        });
    }

    /* ────────────────────────────────────────────────────────────────
       8. Scroll reveal for cards
    ─────────────────────────────────────────────────────────────────── */
    function initReveal() {
        var cards = $$('.pd-card, .pd-qs-card');
        if (!cards.length || !('IntersectionObserver' in window)) return;

        cards.forEach(function (el, i) {
            el.style.opacity = '0';
            el.style.transform = 'translateY(20px)';
            el.style.transition = 'opacity .5s ease, transform .5s ease';
            el.style.transitionDelay = (i * 60) + 'ms';
        });

        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        cards.forEach(function (el) { observer.observe(el); });
    }

    /* ────────────────────────────────────────────────────────────────
       9. ASP.NET UpdatePanel hook — re-run on partial postback
    ─────────────────────────────────────────────────────────────────── */
    function initUpdatePanelHook() {
        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                initDoseCheckboxes();
                initHealthEditToggle();
                initBMIBar();
                updateProgressRing();
                updateProgressBar();
            });
        }
    }

    /* ────────────────────────────────────────────────────────────────
       CSS keyframe injection for slide-down animation
    ─────────────────────────────────────────────────────────────────── */
    function injectKeyframes() {
        if (document.getElementById('pd-keyframes')) return;
        var style = document.createElement('style');
        style.id = 'pd-keyframes';
        style.textContent = [
            '@keyframes pd-slideDown {',
            '  from { opacity:0; transform:translateY(-12px); }',
            '  to   { opacity:1; transform:translateY(0); }',
            '}'
        ].join('\n');
        document.head.appendChild(style);
    }

    /* ────────────────────────────────────────────────────────────────
       Init
    ─────────────────────────────────────────────────────────────────── */
    function init() {
        injectKeyframes();
        initBMIBar();
        initDoseCheckboxes();
        initHealthEditToggle();
        initInventoryBars();
        initQSCounters();
        initReveal();
        initUpdatePanelHook();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

})();