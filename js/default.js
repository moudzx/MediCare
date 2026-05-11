/* ═══════════════════════════════════════════════════════════════════
   FILE: Medicare.js
   LOCATION: /Scripts/Medicare.js  (create a "Scripts" folder in project root)
   ACTION: Create this new file at the path above
   ═══════════════════════════════════════════════════════════════════ */

(function () {
    'use strict';

    /* ── Helpers ───────────────────────────────────────────────────── */
    var $ = function (sel, ctx) { return (ctx || document).querySelector(sel); };
    var $$ = function (sel, ctx) { return Array.from((ctx || document).querySelectorAll(sel)); };

    /* ────────────────────────────────────────────────────────────────
       1. Navbar — scroll shadow + sticky highlight
    ─────────────────────────────────────────────────────────────────── */
    function initNavbar() {
        var navbar = $('#mcNavbar');
        if (!navbar) return;

        var ticking = false;

        function onScroll() {
            if (ticking) return;
            ticking = true;
            requestAnimationFrame(function () {
                if (window.scrollY > 16) {
                    navbar.classList.add('mc-navbar--scrolled');
                } else {
                    navbar.classList.remove('mc-navbar--scrolled');
                }
                ticking = false;
            });
        }

        window.addEventListener('scroll', onScroll, { passive: true });
    }

    /* ────────────────────────────────────────────────────────────────
       2. Mobile Menu — hamburger toggle
    ─────────────────────────────────────────────────────────────────── */
    function initMobileMenu() {
        var btn = $('#mcHamburger');
        var menu = $('#mcMobileMenu');
        if (!btn || !menu) return;

        function toggle() {
            var isOpen = menu.classList.contains('mc-mobile-menu--open');
            menu.classList.toggle('mc-mobile-menu--open', !isOpen);
            btn.setAttribute('aria-expanded', String(!isOpen));
            menu.setAttribute('aria-hidden', String(isOpen));
            document.body.style.overflow = isOpen ? '' : 'hidden';
        }

        function close() {
            menu.classList.remove('mc-mobile-menu--open');
            btn.setAttribute('aria-expanded', 'false');
            menu.setAttribute('aria-hidden', 'true');
            document.body.style.overflow = '';
        }

        btn.addEventListener('click', toggle);

        // Close on link click
        $$('.mc-mobile-link, .mc-mobile-actions .mc-btn', menu).forEach(function (link) {
            link.addEventListener('click', close);
        });

        // Close on outside click
        document.addEventListener('click', function (e) {
            if (!menu.contains(e.target) && !btn.contains(e.target)) {
                close();
            }
        });

        // Close on Escape
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape') close();
        });
    }

    /* ────────────────────────────────────────────────────────────────
       3. Portal Tabs — Patient / Doctor form switcher
    ─────────────────────────────────────────────────────────────────── */
    function initPortalTabs() {

        var tabs = $$('.mc-portal-tab');

        if (!tabs.length) return;

        tabs.forEach(function (tab) {

            tab.addEventListener('click', function (e) {

                e.preventDefault();

                var target = this.dataset.target;

                // Tabs
                tabs.forEach(function (t) {
                    t.classList.remove('mc-portal-tab--active');
                    t.setAttribute('aria-selected', 'false');
                });

                this.classList.add('mc-portal-tab--active');
                this.setAttribute('aria-selected', 'true');

                // Panels
                $$('.mc-form-panel').forEach(function (panel) {
                    panel.classList.add('mc-form-panel--hidden');
                });

                var activePanel = $('#panel' + capitalize(target));

                if (activePanel) {
                    activePanel.classList.remove('mc-form-panel--hidden');
                }

            });

        });

    }

    function capitalize(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    /* ────────────────────────────────────────────────────────────────
       4. Password Visibility Toggle
    ─────────────────────────────────────────────────────────────────── */
    function initPasswordToggles() {
        $$('.mc-eye-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var targetId = this.dataset.target;
                var input = document.getElementById(targetId);
                if (!input) return;

                var isPassword = input.type === 'password';
                input.type = isPassword ? 'text' : 'password';

                // Swap icon
                var svg = this.querySelector('svg');
                if (svg) {
                    if (isPassword) {
                        // Eye-off icon
                        svg.innerHTML = '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>';
                    } else {
                        // Eye icon
                        svg.innerHTML = '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>';
                    }
                }
                this.setAttribute('aria-label', isPassword ? 'Hide password' : 'Show password');
            });
        });
    }

    /* ────────────────────────────────────────────────────────────────
       5. File Upload — custom drag & drop UI
    ─────────────────────────────────────────────────────────────────── */
    function initFileUpload() {
        var zone = $('#uploadZone');
        var preview = $('#uploadPreview');
        var nameEl = $('#uploadFileName');
        var removeBtn = $('#btnRemoveFile');
        var fileInputs = $$('.mc-file-input');
        if (!zone || !fileInputs.length) return;

        var fileInput = fileInputs[0];

        function showPreview(name) {
            zone.style.display = 'none';
            if (preview) {
                preview.style.display = 'flex';
                if (nameEl) nameEl.textContent = name;
            }
        }

        function resetUpload() {
            zone.style.display = '';
            if (preview) preview.style.display = 'none';
            fileInput.value = '';
        }

        fileInput.addEventListener('change', function () {
            if (this.files && this.files[0]) {
                showPreview(this.files[0].name);
            }
        });

        if (removeBtn) {
            removeBtn.addEventListener('click', resetUpload);
        }

        // Drag & drop support
        ['dragenter', 'dragover'].forEach(function (evt) {
            zone.addEventListener(evt, function (e) {
                e.preventDefault();
                zone.classList.add('mc-upload-zone--dragover');
            });
        });

        ['dragleave', 'drop'].forEach(function (evt) {
            zone.addEventListener(evt, function (e) {
                e.preventDefault();
                zone.classList.remove('mc-upload-zone--dragover');
                if (evt === 'drop' && e.dataTransfer.files[0]) {
                    // Assign dropped file to input (best-effort; may not work in all browsers for hidden inputs)
                    try {
                        var dt = new DataTransfer();
                        dt.items.add(e.dataTransfer.files[0]);
                        fileInput.files = dt.files;
                        showPreview(e.dataTransfer.files[0].name);
                    } catch (_) {
                        // Fallback: just show the name
                        showPreview(e.dataTransfer.files[0].name);
                    }
                }
            });
        });

        // Keyboard accessibility for upload zone
        zone.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                fileInput.click();
            }
        });
    }

    /* ────────────────────────────────────────────────────────────────
       6. Animated Counter — stats section
    ─────────────────────────────────────────────────────────────────── */
    function initCounters() {
        var counters = $$('[data-count]');
        if (!counters.length) return;

        var hasAnimated = false;

        function formatNumber(num) {
            if (num >= 1000000) return (num / 1000000).toFixed(1).replace('.0', '') + 'M+';
            if (num >= 1000) return (num / 1000).toFixed(0) + 'K+';
            if (num === 99) return num + '%';
            return num.toLocaleString();
        }

        function animateCounter(el) {
            var target = parseInt(el.dataset.count, 10);
            var duration = 2000; // ms
            var start = performance.now();

            function step(now) {
                var elapsed = now - start;
                var progress = Math.min(elapsed / duration, 1);
                // Ease-out cubic
                var eased = 1 - Math.pow(1 - progress, 3);
                var current = Math.round(eased * target);
                el.textContent = formatNumber(current);
                if (progress < 1) requestAnimationFrame(step);
            }

            requestAnimationFrame(step);
        }

        // Trigger when stats section enters viewport
        var statsSection = $('.mc-stats');
        if (!statsSection) return;

        var observer = new IntersectionObserver(function (entries) {
            if (entries[0].isIntersecting && !hasAnimated) {
                hasAnimated = true;
                counters.forEach(function (el) { animateCounter(el); });
                observer.disconnect();
            }
        }, { threshold: 0.3 });

        observer.observe(statsSection);
    }

    /* ────────────────────────────────────────────────────────────────
       7. Scroll Reveal — fade-in-up on scroll
    ─────────────────────────────────────────────────────────────────── */
    function initScrollReveal() {
        // Mark elements to animate
        var targets = [
            '.mc-stat-card',
            '.mc-step-card',
            '.mc-feature-card',
            '.mc-testimonial-card',
            '.mc-portal-tab'
        ];

        var elements = targets.reduce(function (acc, sel) {
            return acc.concat($$(sel));
        }, []);

        if (!elements.length || !('IntersectionObserver' in window)) return;

        elements.forEach(function (el, i) {
            el.classList.add('mc-animate-up');
            el.style.transitionDelay = (Math.min(i % 4, 3) * 80) + 'ms';
        });

        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.classList.add('mc-in');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.12 });

        elements.forEach(function (el) { observer.observe(el); });
    }

    /* ────────────────────────────────────────────────────────────────
       8. Smooth Scroll for anchor links
    ─────────────────────────────────────────────────────────────────── */
    function initSmoothScroll() {
        $$('a[href^="#"]').forEach(function (anchor) {
            anchor.addEventListener('click', function (e) {
                var href = this.getAttribute('href');
                if (href === '#') return;

                var target = document.querySelector(href);
                if (!target) return;

                e.preventDefault();

                var navH = parseInt(getComputedStyle(document.documentElement).getPropertyValue('--mc-nav-h'), 10) || 72;
                var top = target.getBoundingClientRect().top + window.scrollY - navH - 16;

                window.scrollTo({ top: top, behavior: 'smooth' });
            });
        });
    }

    /* ────────────────────────────────────────────────────────────────
       9. Progress bar animation on hero card load
    ─────────────────────────────────────────────────────────────────── */
    function initProgressBar() {
        var fill = $('.mc-progress-fill');
        if (!fill) return;
        var targetWidth = fill.style.width;
        fill.style.width = '0%';
        setTimeout(function () {
            fill.style.transition = 'width 1.2s cubic-bezier(.4,0,.2,1)';
            fill.style.width = targetWidth;
        }, 600);
    }

    /* ────────────────────────────────────────────────────────────────
       10. ASP.NET WebForms — handle UpdatePanel partial postbacks
    ─────────────────────────────────────────────────────────────────── */
    function initUpdatePanelHook() {
        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {
                // Re-run JS enhancements after partial postbacks
                initPasswordToggles();
                initFileUpload();
            });
        }
    }

    /* ────────────────────────────────────────────────────────────────
       11. Hero card — live clock (updates pill card date)
    ─────────────────────────────────────────────────────────────────── */
    function initHeroClock() {
        var el = document.querySelector('.mc-card-date-text');
        if (!el || !el.textContent.trim()) return; // Already set server-side

        var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        var now = new Date();
        el.textContent = days[now.getDay()] + ', ' + months[now.getMonth()] + ' ' + now.getDate() + ', ' + now.getFullYear();
    }

    /* ────────────────────────────────────────────────────────────────
       Init — DOMContentLoaded
    ─────────────────────────────────────────────────────────────────── */
    function init() {
        initNavbar();
        initMobileMenu();
        initPortalTabs();
        initPasswordToggles();
        initFileUpload();
        initCounters();
        initScrollReveal();
        initSmoothScroll();
        initProgressBar();
        initUpdatePanelHook();
        initHeroClock();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

})();