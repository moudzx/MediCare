(function () {
    'use strict';

    function initWelcomeAnimation() {
        var cards = document.querySelectorAll('.db-stat-card, .db-schedule-wrap, .db-upcoming-wrap, .db-welcome');

        if (!('IntersectionObserver' in window)) return;

        var observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        cards.forEach(function (card) {
            card.style.opacity = '0';
            card.style.transform = 'translateY(15px)';
            card.style.transition = '0.4s ease';
            observer.observe(card);
        });
    }

    function initGreeting() {
        var hour = new Date().getHours();
        var greeting =
            hour < 12 ? 'Good morning,' :
                hour < 18 ? 'Good afternoon,' :
                    'Good evening,';

        var el = document.querySelector('[id$="lblGreeting"]');
        if (el) el.textContent = greeting;
    }

    function init() {
        initGreeting();
        initWelcomeAnimation();
    }

    document.addEventListener('DOMContentLoaded', init);

})();