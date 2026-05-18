/* ═══════════════════════════════════════════════════════════════════
   FILE: ManageNutrition.js
   LOCATION: /Scripts/ManageNutrition.js
   ═══════════════════════════════════════════════════════════════════ */

(function () {
    'use strict';

    /* ═══════════════════════════════════════════════════════════════
       1. SAMPLE NUTRITION PLANS
       *** DB HOOK: Replace with GET /api/patient/{id}/nutrition-plans ***
    ═══════════════════════════════════════════════════════════════════ */
    var plans = [
        {
            id: 1,
            name: 'Low-Carb Diabetic Day',
            day: 'Daily',
            goal: 'Diabetes Control',
            calories: 1650,
            protein: 85,
            fat: 72,
            carbs: 130,
            sodium: 1400,
            satFat: 14,
            cholesterol: 180,
            sugar: 22,
            calcium: 900,
            iron: 12,
            potassium: 3200,
            vitC: 80,
            vitE: 14,
            vitD: 18,
            notes: 'Avoid refined sugars. Eat small frequent meals.'
        },
        {
            id: 2,
            name: 'Heart-Healthy Plan',
            day: 'Weekdays',
            goal: 'Heart Health',
            calories: 1900,
            protein: 75,
            fat: 60,
            carbs: 240,
            sodium: 1200,
            satFat: 10,
            cholesterol: 150,
            sugar: 30,
            calcium: 1000,
            iron: 15,
            potassium: 4000,
            vitC: 100,
            vitE: 15,
            vitD: 20,
            notes: 'Include omega-3 rich foods. Limit saturated fats.'
        },
        {
            id: 3,
            name: 'Weekend Light Plan',
            day: 'Weekends',
            goal: 'Weight Loss',
            calories: 1400,
            protein: 65,
            fat: 45,
            carbs: 175,
            sodium: 1100,
            satFat: 8,
            cholesterol: 130,
            sugar: 25,
            calcium: 800,
            iron: 11,
            potassium: 3000,
            vitC: 70,
            vitE: 12,
            vitD: 15,
            notes: 'Increase water intake. Light exercise recommended.'
        }
    ];

    /* ── State ──────────────────────────────────────────────────── */
    var nextPlanId = 10;
    var editingPlan = null;

    /* ═══════════════════════════════════════════════════════════════
       2. RENDER ALL PLANS
    ═══════════════════════════════════════════════════════════════════ */
    function render() {
        var grid = document.getElementById('mnPlansGrid');
        var emptyEl = document.getElementById('mnEmpty');
        if (!grid) return;

        updateStats();

        if (plans.length === 0) {
            grid.innerHTML = '';
            emptyEl.style.display = 'block';
            return;
        }
        emptyEl.style.display = 'none';

        grid.innerHTML = plans.map(function (p, i) {
            return buildPlanCard(p, i);
        }).join('');
    }

    function buildPlanCard(p, idx) {
        /* Macro percentages for bar widths (relative to calories) */
        var proteinCal = (p.protein || 0) * 4;
        var fatCal = (p.fat || 0) * 9;
        var carbsCal = (p.carbs || 0) * 4;
        var total = proteinCal + fatCal + carbsCal || 1;
        var pPct = Math.round(proteinCal / total * 100);
        var fPct = Math.round(fatCal / total * 100);
        var cPct = Math.round(carbsCal / total * 100);

        var goalColors = {
            'Diabetes Control': '#8B5CF6',
            'Heart Health': '#EF4444',
            'Weight Loss': '#1A9E5C',
            'Muscle Gain': '#2563EB',
            'Maintenance': '#D97706',
            'General Health': '#0D9488'
        };
        var accentColor = goalColors[p.goal] || '#1A9E5C';

        return (
            '<div class="mn-plan-card" id="plan-' + p.id + '" style="animation-delay:' + (idx * 80) + 'ms">' +
            '<div class="mn-plan-card__accent" style="background:linear-gradient(90deg,' + accentColor + ',#1A9E5C)"></div>' +

            /* Header */
            '<div class="mn-plan-card__header">' +
            '<div class="mn-plan-card__header-left">' +
            '<div class="mn-plan-card__emoji" aria-hidden="true">🥗</div>' +
            '<div>' +
            '<div class="mn-plan-card__name">' + esc(p.name) + '</div>' +
            '<div class="mn-plan-card__meta">' +
            '<span class="mn-plan-meta-pill mn-plan-meta-pill--day"><i class="fa-solid fa-calendar-day" style="font-size:9px;"></i> ' + esc(p.day) + '</span>' +
            '<span class="mn-plan-meta-pill" style="background:#F0F9FF;color:#0369A1;border-color:#BAE6FD;">' + esc(p.goal) + '</span>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="mn-plan-card__actions">' +
            '<button class="mn-icon-btn mn-icon-btn--edit" onclick="openEditPlanModal(' + p.id + ')" title="Edit Plan"><i class="fa-solid fa-pen-to-square"></i></button>' +
            '<button class="mn-icon-btn mn-icon-btn--delete" onclick="deletePlan(' + p.id + ')" title="Delete Plan"><i class="fa-solid fa-trash-can"></i></button>' +
            '</div>' +
            '</div>' +

            /* Calorie + macro bars */
            '<div class="mn-plan-card__calorie">' +
            '<div>' +
            '<div class="mn-calorie-num">' + (p.calories || 0).toLocaleString() + '</div>' +
            '<div class="mn-calorie-label">kcal / day</div>' +
            '</div>' +
            '<div class="mn-macro-bars">' +
            buildMacroBar('Protein', pPct, (p.protein || 0) + 'g', 'protein') +
            buildMacroBar('Fat', fPct, (p.fat || 0) + 'g', 'fat') +
            buildMacroBar('Carbs', cPct, (p.carbs || 0) + 'g', 'carbs') +
            '</div>' +
            '</div>' +

            /* Detailed nutrients */
            '<div class="mn-plan-card__nutrients">' +
            buildNutrient((p.sodium || 0) + 'mg', 'Sodium') +
            buildNutrient((p.cholesterol || 0) + 'mg', 'Cholesterol') +
            buildNutrient((p.sugar || 0) + 'g', 'Sugar') +
            buildNutrient((p.calcium || 0) + 'mg', 'Calcium') +
            buildNutrient((p.iron || 0) + 'mg', 'Iron') +
            buildNutrient((p.potassium || 0) + 'mg', 'Potassium') +
            buildNutrient((p.vitC || 0) + 'mg', 'Vit C') +
            buildNutrient((p.vitE || 0) + 'mg', 'Vit E') +
            buildNutrient((p.vitD || 0) + 'µg', 'Vit D') +
            '</div>' +

            /* Notes */
            (p.notes
                ? '<div class="mn-plan-card__notes"><i class="fa-solid fa-note-sticky"></i>' + esc(p.notes) + '</div>'
                : '') +

            '</div>'
        );
    }

    function buildMacroBar(label, pct, val, cls) {
        return (
            '<div class="mn-macro-row">' +
            '<span class="mn-macro-label">' + label + '</span>' +
            '<div class="mn-macro-bar-wrap">' +
            '<div class="mn-macro-bar-fill mn-macro-bar-fill--' + cls + '" style="width:' + pct + '%"></div>' +
            '</div>' +
            '<span class="mn-macro-val">' + val + '</span>' +
            '</div>'
        );
    }

    function buildNutrient(val, label) {
        return (
            '<div class="mn-nutrient-item">' +
            '<span class="mn-nutrient-val">' + esc(val) + '</span>' +
            '<span class="mn-nutrient-label">' + esc(label) + '</span>' +
            '</div>'
        );
    }

    function updateStats() {
        var plansStat = document.getElementById('statPlans');
        var calStat = document.getElementById('statAvgCal');
        if (plansStat) plansStat.textContent = plans.length;
        if (calStat) {
            var avg = plans.length
                ? Math.round(plans.reduce(function (s, p) { return s + (p.calories || 0); }, 0) / plans.length)
                : 0;
            calStat.textContent = avg.toLocaleString();
        }
    }

    /* ═══════════════════════════════════════════════════════════════
       3. ADD PLAN MODAL
    ═══════════════════════════════════════════════════════════════════ */
    window.openAddPlanModal = function () {
        editingPlan = null;
        document.getElementById('planModalTitle').textContent = 'Add Nutrition Plan';
        document.getElementById('planSaveBtnLabel').textContent = 'Save Plan';
        clearPlanForm();
        openModal('planModal');
    };

    window.openEditPlanModal = function (id) {
        var plan = plans.find(function (p) { return p.id === id; });
        if (!plan) return;
        editingPlan = id;

        document.getElementById('planModalTitle').textContent = 'Edit Plan';
        document.getElementById('planSaveBtnLabel').textContent = 'Update Plan';

        /* Pre-fill form */
        setVal('inputPlanName', plan.name);
        setVal('inputPlanDay', plan.day);
        setVal('inputPlanGoal', plan.goal);
        setVal('inputCalories', plan.calories);
        setVal('inputProtein', plan.protein);
        setVal('inputFat', plan.fat);
        setVal('inputCarbs', plan.carbs);
        setVal('inputSodium', plan.sodium);
        setVal('inputSatFat', plan.satFat);
        setVal('inputCholesterol', plan.cholesterol);
        setVal('inputSugar', plan.sugar);
        setVal('inputCalcium', plan.calcium);
        setVal('inputIron', plan.iron);
        setVal('inputPotassium', plan.potassium);
        setVal('inputVitC', plan.vitC);
        setVal('inputVitE', plan.vitE);
        setVal('inputVitD', plan.vitD);
        setVal('inputPlanNotes', plan.notes);

        openModal('planModal');
    };

    window.closePlanModal = function () { closeModal('planModal'); };

    window.handlePlanOverlay = function (e) {
        if (e.target === document.getElementById('planModal')) closeModal('planModal');
    };

    window.confirmSavePlan = function () {
        var name = getVal('inputPlanName');
        var calories = getVal('inputCalories');
        var valid = true;

        hideErr(['errPlanName', 'errCalories']);
        if (!name) { showErr('errPlanName'); valid = false; }
        if (!calories) { showErr('errCalories'); valid = false; }
        if (!valid) return;

        var data = {
            name: name,
            day: getVal('inputPlanDay'),
            goal: getVal('inputPlanGoal'),
            calories: num('inputCalories'),
            protein: num('inputProtein'),
            fat: num('inputFat'),
            carbs: num('inputCarbs'),
            sodium: num('inputSodium'),
            satFat: num('inputSatFat'),
            cholesterol: num('inputCholesterol'),
            sugar: num('inputSugar'),
            calcium: num('inputCalcium'),
            iron: num('inputIron'),
            potassium: num('inputPotassium'),
            vitC: num('inputVitC'),
            vitE: num('inputVitE'),
            vitD: num('inputVitD'),
            notes: getVal('inputPlanNotes')
        };

        if (editingPlan) {
            /* *** DB HOOK: PUT /api/nutrition-plans/{editingPlan} with data *** */
            var idx = plans.findIndex(function (p) { return p.id === editingPlan; });
            if (idx !== -1) { plans[idx] = Object.assign({ id: editingPlan }, data); }
            showToast('Plan updated successfully!', 'success');
        } else {
            /* *** DB HOOK: POST /api/patient/{id}/nutrition-plans with data *** */
            data.id = nextPlanId++;
            plans.push(data);
            showToast('Plan added successfully!', 'success');
        }

        closeModal('planModal');
        render();
    };

    /* ═══════════════════════════════════════════════════════════════
       4. DELETE PLAN
    ═══════════════════════════════════════════════════════════════════ */
    window.deletePlan = function (id) {
        if (!confirm('Delete this nutrition plan?')) return;
        var el = document.getElementById('plan-' + id);
        if (el) {
            el.classList.add('mn-plan-card--removing');
            setTimeout(function () {
                /* *** DB HOOK: DELETE /api/nutrition-plans/{id} *** */
                plans = plans.filter(function (p) { return p.id !== id; });
                render();
                showToast('Plan deleted.', 'info');
            }, 300);
        }
    };

    /* ═══════════════════════════════════════════════════════════════
       5. MODAL HELPERS
    ═══════════════════════════════════════════════════════════════════ */
    function openModal(id) {
        var el = document.getElementById(id);
        if (el) {
            el.classList.add('mn-modal-overlay--open');
            document.body.style.overflow = 'hidden';
        }
    }
    function closeModal(id) {
        var el = document.getElementById(id);
        if (el) {
            el.classList.remove('mn-modal-overlay--open');
            document.body.style.overflow = '';
        }
    }
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeModal('planModal');
    });

    function clearPlanForm() {
        var ids = ['inputPlanName', 'inputPlanDay', 'inputPlanGoal', 'inputCalories',
            'inputProtein', 'inputFat', 'inputCarbs', 'inputSodium', 'inputSatFat',
            'inputCholesterol', 'inputSugar', 'inputCalcium', 'inputIron',
            'inputPotassium', 'inputVitC', 'inputVitE', 'inputVitD', 'inputPlanNotes'];
        ids.forEach(function (id) { var el = document.getElementById(id); if (el) el.value = ''; });
        hideErr(['errPlanName', 'errCalories']);
    }

    /* ═══════════════════════════════════════════════════════════════
       6. TOAST
    ═══════════════════════════════════════════════════════════════════ */
    function showToast(msg, type) {
        var existing = document.getElementById('mnToast');
        if (existing) existing.remove();
        var colors = {
            success: { bg: '#065F46', icon: 'fa-circle-check', color: '#34D399' },
            info: { bg: '#1D4ED8', icon: 'fa-circle-info', color: '#93C5FD' },
            error: { bg: '#991B1B', icon: 'fa-circle-xmark', color: '#FCA5A5' }
        };
        var c = colors[type] || colors.info;
        var t = document.createElement('div');
        t.id = 'mnToast';
        t.style.cssText =
            'position:fixed;bottom:28px;right:28px;background:' + c.bg + ';color:#fff;' +
            'border-radius:50px;padding:13px 22px;display:flex;align-items:center;gap:10px;' +
            'font-family:DM Sans,sans-serif;font-size:14px;font-weight:600;' +
            'box-shadow:0 8px 32px rgba(0,0,0,.25);z-index:3000;' +
            'transform:translateY(80px);opacity:0;transition:all .36s cubic-bezier(.34,1.56,.64,1);';
        t.innerHTML = '<i class="fa-solid ' + c.icon + '" style="color:' + c.color + ';font-size:16px;"></i>' + esc(msg);
        document.body.appendChild(t);
        requestAnimationFrame(function () {
            t.style.transform = 'translateY(0)'; t.style.opacity = '1';
        });
        setTimeout(function () {
            t.style.transform = 'translateY(80px)'; t.style.opacity = '0';
            setTimeout(function () { t.remove(); }, 400);
        }, 3500);
    }

    /* ── DOM Helpers ──────────────────────────────────────────── */
    function getVal(id) { var el = document.getElementById(id); return el ? el.value.trim() : ''; }
    function setVal(id, val) { var el = document.getElementById(id); if (el) el.value = val !== undefined ? val : ''; }
    function num(id) { var v = parseFloat(getVal(id)); return isNaN(v) ? 0 : v; }
    function showErr(id) { var el = document.getElementById(id); if (el) el.style.display = 'block'; }
    function hideErr(ids) { ids.forEach(function (id) { var el = document.getElementById(id); if (el) el.style.display = 'none'; }); }
    function esc(s) { if (!s) return ''; return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }

    /* ═══════════════════════════════════════════════════════════════
       7. INIT
    ═══════════════════════════════════════════════════════════════════ */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', render);
    } else {
        render();
    }

})();