(function () {
    function getText(el) {
        return (el.textContent || el.innerText || '').toLowerCase();
    }

    function showMessage(type, text) {
        var msg = document.getElementById('searchMsg');
        if (!msg) return;

        msg.className = 'sea-inline-msg sea-inline-msg--' + type;
        msg.textContent = text;
        msg.style.display = 'inline-flex';

        clearTimeout(window.__seaMsgTimer);
        window.__seaMsgTimer = setTimeout(function () {
            msg.style.display = 'none';
        }, 3000);
    }

    function setCardVisible(cardId, visible) {
        var card = document.getElementById(cardId);
        if (card) card.style.display = visible ? '' : 'none';
    }

    function filterTable(tableId, emptyId, query) {
        var table = document.getElementById(tableId);
        var empty = document.getElementById(emptyId);
        if (!table) return 0;

        var rows = table.querySelectorAll('tbody tr');
        var shown = 0;

        rows.forEach(function (row) {
            var match = !query || getText(row).indexOf(query) !== -1;
            row.style.display = match ? '' : 'none';
            if (match) shown++;
        });

        if (empty) {
            empty.style.display = shown === 0 ? 'block' : 'none';
        }

        return shown;
    }

    window.performSearch = function () {
        var scope = (document.getElementById('ddlSearchScope') || {}).value || 'all';
        var query = ((document.getElementById('txtSearchQuery') || {}).value || '').trim().toLowerCase();

        var searchDoctors = scope === 'all' || scope === 'doctors';
        var searchMedicines = scope === 'all' || scope === 'medicines';
        var searchFoods = scope === 'all' || scope === 'foods';

        setCardVisible('cardDoctors', searchDoctors);
        setCardVisible('cardMedicines', searchMedicines);
        setCardVisible('cardFoods', searchFoods);

        var d = searchDoctors ? filterTable('tblDoctors', 'emptyDoctors', query) : 0;
        var m = searchMedicines ? filterTable('tblMedicines', 'emptyMedicines', query) : 0;
        var f = searchFoods ? filterTable('tblFoods', 'emptyFoods', query) : 0;

        var total = d + m + f;
        showMessage(
            total > 0 ? 'success' : 'error',
            total > 0 ? ('Found ' + total + ' result(s).') : 'No results found.'
        );
    };

    window.requestApproval = function (btn) {
        var row = btn.closest('tr');
        var doctorName = row ? row.children[0].textContent.trim() : 'the selected doctor';
        showMessage('success', 'Approval request sent to ' + doctorName + '.');
    };

    window.addMedicine = function (btn) {
        var row = btn.closest('tr');
        var medName = row ? row.children[0].textContent.trim() : 'the selected medicine';
        showMessage('success', medName + ' added to your medicines.');
    };

    window.addFood = function (btn) {
        var row = btn.closest('tr');
        var foodName = row ? row.children[0].textContent.trim() : 'the selected food';
        showMessage('success', foodName + ' added to your foods.');
    };

    document.addEventListener('DOMContentLoaded', function () {
        var queryInput = document.getElementById('txtSearchQuery');
        var scopeSelect = document.getElementById('ddlSearchScope');

        if (queryInput) {
            queryInput.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    window.performSearch();
                }
            });
        }

        if (scopeSelect) {
            scopeSelect.addEventListener('change', function () {
                window.performSearch();
            });
        }

        window.performSearch();
    });
})();