/* ============================================================
   MediCare — default.js
   UI interactions only — no backend logic
============================================================ */

(function () {
    'use strict';

    /* ── Navbar scroll shadow ── */
    const navbar = document.querySelector('.mc-navbar');
    if (navbar) {
        const onScroll = () => {
            navbar.classList.toggle('scrolled', window.scrollY > 10);
        };
        window.addEventListener('scroll', onScroll, { passive: true });
        onScroll();
    }

    /* ── Mobile hamburger toggle ── */
    const hamburger = document.querySelector('.mc-navbar__hamburger');
    const mobileNav = document.querySelector('.mc-navbar__mobile');
    if (hamburger && mobileNav) {
        hamburger.addEventListener('click', () => {
            hamburger.classList.toggle('open');
            mobileNav.classList.toggle('open');
        });
        // Close on outside click
        document.addEventListener('click', (e) => {
            if (!navbar.contains(e.target)) {
                hamburger.classList.remove('open');
                mobileNav.classList.remove('open');
            }
        });
    }

    /* ── Profile dropdown ── */
    const profileTrigger = document.querySelector('.mc-profile-trigger');
    const dropdownMenu = document.querySelector('.mc-dropdown-menu');
    if (profileTrigger && dropdownMenu) {
        profileTrigger.addEventListener('click', (e) => {
            e.stopPropagation();
            dropdownMenu.classList.toggle('open');
        });
        document.addEventListener('click', () => dropdownMenu.classList.remove('open'));
    }

    /* ── Modal helpers ── */
    function openModal(id) {
        const overlay = document.getElementById(id);
        if (overlay) overlay.classList.add('open');
    }
    function closeModal(id) {
        const overlay = document.getElementById(id);
        if (overlay) overlay.classList.remove('open');
    }
    // Wire up all [data-modal-open] and [data-modal-close]
    document.querySelectorAll('[data-modal-open]').forEach(el => {
        el.addEventListener('click', () => openModal(el.dataset.modalOpen));
    });
    document.querySelectorAll('[data-modal-close]').forEach(el => {
        el.addEventListener('click', () => closeModal(el.dataset.modalClose));
    });
    // Close on overlay click
    document.querySelectorAll('.mc-modal-overlay').forEach(overlay => {
        overlay.addEventListener('click', (e) => {
            if (e.target === overlay) overlay.classList.remove('open');
        });
    });

    /* ── Table search filter ── */
    

    /* ── Animate stat numbers (counter) ── */
    function animateCounter(el) {
        const target = parseFloat(el.dataset.count || el.textContent.replace(/[^0-9.]/g, ''));
        const suffix = el.dataset.suffix || '';
        const prefix = el.dataset.prefix || '';
        const duration = 1800;
        const start = performance.now();
        const isFloat = String(target).includes('.');

        (function tick(now) {
            const elapsed = now - start;
            const progress = Math.min(elapsed / duration, 1);
            const ease = 1 - Math.pow(1 - progress, 3);
            const current = target * ease;
            el.textContent = prefix + (isFloat ? current.toFixed(1) : Math.round(current)) + suffix;
            if (progress < 1) requestAnimationFrame(tick);
        })(start);
    }

    // Intersection observer for stat items
   
    /* ── Fade-up on scroll ── */
    const fadeEls = document.querySelectorAll('.mc-feature-card, .mc-testimonial-card, .mc-stat-item');
    if (fadeEls.length) {
        const fadeIO = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                    fadeIO.unobserve(entry.target);
                }
            });
        }, { threshold: 0.15 });
        fadeEls.forEach((el, i) => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(24px)';
            el.style.transition = `opacity 0.6s ease ${i * 0.08}s, transform 0.6s ease ${i * 0.08}s`;
            fadeIO.observe(el);
        });
    }

    /* ── Delete row confirmation ── */
    

    /* ── Active nav link (admin) ── */
    const currentPath = window.location.pathname.toLowerCase();
    document.querySelectorAll('.mc-navbar__links a').forEach(link => {
        const href = link.getAttribute('href');
        if (href && currentPath.includes(href.toLowerCase().replace('.aspx', ''))) {
            link.classList.add('active');
        }
    });

    /* ── Toast notification helper ── */
    window.mcToast = function (message, type = 'success') {
        const toast = document.createElement('div');
        toast.className = 'mc-toast mc-toast--' + type;
        toast.innerHTML = `<span>${type === 'success' ? '✓' : '✕'}</span> ${message}`;
        Object.assign(toast.style, {
            position: 'fixed', bottom: '2rem', right: '2rem', zIndex: 9999,
            background: type === 'success' ? 'var(--primary)' : '#DC2626',
            color: 'white', borderRadius: '12px', padding: '0.85rem 1.4rem',
            fontFamily: 'var(--font-body)', fontWeight: '500', fontSize: '0.9rem',
            boxShadow: '0 8px 24px rgba(0,0,0,0.16)', display: 'flex', gap: '0.6rem',
            alignItems: 'center', animation: 'fadeUp 0.4s ease',
        });
        document.body.appendChild(toast);
        setTimeout(() => { toast.style.opacity = '0'; toast.style.transition = 'opacity 0.4s'; setTimeout(() => toast.remove(), 400); }, 3200);
    };

})();
