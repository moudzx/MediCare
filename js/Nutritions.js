(function () {
    window.toggleFoodPanel = function () {
        var body = document.getElementById('foodPanelBody');
        var arrow = document.getElementById('foodCollapseArrow');
        var header = document.getElementById('btnToggleFoodPanel');
        var isOpen = body.classList.contains('nut-collapse-body--open');

        if (isOpen) {
            body.style.maxHeight = body.scrollHeight + 'px';
            requestAnimationFrame(function () { body.style.maxHeight = '0px'; });
            setTimeout(function () {
                body.classList.remove('nut-collapse-body--open');
                body.setAttribute('aria-hidden', 'true');
            }, 350);
            arrow.classList.remove('nut-collapse-arrow--open');
            header.setAttribute('aria-expanded', 'false');
        } else {
            body.classList.add('nut-collapse-body--open');
            body.setAttribute('aria-hidden', 'false');
            body.style.maxHeight = '0px';
            requestAnimationFrame(function () {
                body.style.maxHeight = body.scrollHeight + 'px';
            });
            setTimeout(function () { body.style.maxHeight = 'none'; }, 360);
            arrow.classList.add('nut-collapse-arrow--open');
            header.setAttribute('aria-expanded', 'true');
        }
    };

    window.filterNutritionPlan = function () {

        var filter = document.getElementById('ddlNutFilter').value;

        var rows = document.querySelectorAll(
            '#tblBreakfast tbody tr, ' +
            '#tblLunch tbody tr, ' +
            '#tblSnack tbody tr'
        );

        rows.forEach(function (row) {

            if (!filter) {
                row.style.display = '';
                return;
            }

            // Get numeric values from table cells
            var calories = parseInt(row.children[2].textContent);
            var protein = parseInt(row.children[3].textContent);
            var carbs = parseInt(row.children[4].textContent);
            var fiber = parseInt(row.children[5].textContent);
            var fat = parseInt(row.children[6].textContent);

            var show = false;

            switch (filter) {

                case 'highprotein':
                    show = protein > 10;
                    break;

                case 'lowcarb':
                    show = carbs < 15;
                    break;

                case 'highfiber':
                    show = fiber > 5;
                    break;

                case 'lowfat':
                    show = fat < 8;
                    break;

                case 'lowcal':
                    show = calories < 200;
                    break;
            }

            row.style.display = show ? '' : 'none';
        });
    };

    window.deleteOwnFood = function (btn) {
        if (!confirm('Remove this food item?')) return;
        var row = btn.closest('tr');
        var tbody = document.querySelector('#tblOwnFoods tbody');
        row.remove();

        var empty = document.getElementById('emptyOwnFoods');
        if (tbody.querySelectorAll('tr').length === 0) {
            empty.style.display = 'block';
        }
    };

    window.saveCustomFood = function () {
        var name = document.getElementById('txtFoodName').value.trim();
        var cal = document.getElementById('txtFoodCalories').value.trim();
        var protein = document.getElementById('txtFoodProtein').value.trim() || '0';
        var carbs = document.getElementById('txtFoodCarbs').value.trim() || '0';
        var fiber = document.getElementById('txtFoodFiber').value.trim() || '0';
        var fat = document.getElementById('txtFoodFat').value.trim() || '0';
        var msg = document.getElementById('foodMsg');

        if (!name || !cal) {
            msg.className = 'nut-inline-msg nut-inline-msg--error';
            msg.textContent = 'Food name and calories are required.';
            msg.style.display = 'inline-flex';
            return;
        }

        var tbody = document.querySelector('#tblOwnFoods tbody');
        var empty = document.getElementById('emptyOwnFoods');
        var tr = document.createElement('tr');
        tr.innerHTML =
            '<td>' + escapeHtml(name) + '</td>' +
            '<td>' + escapeHtml(cal) + '</td>' +
            '<td>' + escapeHtml(protein) + 'g</td>' +
            '<td>' + escapeHtml(carbs) + 'g</td>' +
            '<td>' + escapeHtml(fiber) + 'g</td>' +
            '<td>' + escapeHtml(fat) + 'g</td>' +
            '<td><button type="button" class="nut-delete-btn" onclick="deleteOwnFood(this)"><i class="fa-solid fa-trash-can"></i></button></td>';

        tbody.appendChild(tr);
        empty.style.display = 'none';

        msg.className = 'nut-inline-msg nut-inline-msg--success';
        msg.textContent = 'Food added successfully.';
        msg.style.display = 'inline-flex';

        document.getElementById('txtFoodName').value = '';
        document.getElementById('txtFoodCalories').value = '';
        document.getElementById('txtFoodProtein').value = '';
        document.getElementById('txtFoodCarbs').value = '';
        document.getElementById('txtFoodFiber').value = '';
        document.getElementById('txtFoodFat').value = '';
    };

    function escapeHtml(str) {
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }
})();