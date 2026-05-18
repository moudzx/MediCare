<%@ Page Title="Manage Nutrition – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="ManageNutrition.aspx.cs"
    Inherits="MediCare.Pages.Doctor.ManageNutrition" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/ManageNutrition.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<!-- ═══════════════════════════════════════════════════════════
     MANAGE NUTRITION PAGE ROOT
═══════════════════════════════════════════════════════════ -->
<div class="mn-root">

    <!-- ── PAGE HEADER ────────────────────────────────────────── -->
    <div class="mn-page-header">
        <div class="mn-page-header__left">
            <div class="mn-page-header__icon">
                <i class="fa-solid fa-bowl-food"></i>
            </div>
            <div>
                <h1 class="mn-page-header__title">Manage Nutrition</h1>
                <p class="mn-page-header__sub">
                    Patient: <strong id="mnPatientName">Sarah Johnson</strong>
                    &nbsp;·&nbsp; Daily nutrition plans
                </p>
            </div>
        </div>
        <div class="mn-page-header__right">
            <div class="mn-header-stat">
                <span class="mn-header-stat__num" id="statPlans">0</span>
                <span class="mn-header-stat__label">Plans</span>
            </div>
            <div class="mn-header-stat">
                <span class="mn-header-stat__num" id="statAvgCal">0</span>
                <span class="mn-header-stat__label">Avg kcal</span>
            </div>
            <button class="mn-btn mn-btn--primary" onclick="openAddPlanModal()">
                <i class="fa-solid fa-plus"></i> Add Plan
            </button>
        </div>
    </div>

    <!-- ── NUTRITION PLANS GRID ───────────────────────────────── -->
    <div class="mn-plans-grid" id="mnPlansGrid">
        <!-- Filled by JavaScript -->
    </div>

    <!-- Empty state -->
    <div class="mn-empty" id="mnEmpty" style="display:none;">
        <div class="mn-empty__icon"><i class="fa-solid fa-bowl-food"></i></div>
        <p class="mn-empty__text">No nutrition plans yet.</p>
        <p class="mn-empty__sub">Click "Add Plan" to create a daily nutrition plan for this patient.</p>
        <button class="mn-btn mn-btn--primary" onclick="openAddPlanModal()" style="margin-top:16px;">
            <i class="fa-solid fa-plus"></i> Create First Plan
        </button>
    </div>

</div>
<!-- end mn-root -->

<!-- ═══════════════════════════════════════════════════════════
     ADD / EDIT PLAN MODAL
═══════════════════════════════════════════════════════════ -->
<div class="mn-modal-overlay" id="planModal" onclick="handlePlanOverlay(event)">
    <div class="mn-modal" role="dialog" aria-modal="true" aria-label="Nutrition Plan">

        <div class="mn-modal__header">
            <div class="mn-modal__title-group">
                <div class="mn-modal__icon">
                    <i class="fa-solid fa-bowl-food"></i>
                </div>
                <div>
                    <h3 class="mn-modal__title" id="planModalTitle">Add Nutrition Plan</h3>
                    <p class="mn-modal__sub">Fill in the nutritional details for this daily plan</p>
                </div>
            </div>
            <button class="mn-modal__close" onclick="closePlanModal()" aria-label="Close">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <div class="mn-modal__body">

            <!-- Plan meta -->
            <div class="mn-modal-section">
                <div class="mn-modal-section__title">
                    <i class="fa-solid fa-calendar-day"></i> Plan Details
                </div>
                <div class="mn-form-grid mn-form-grid--3">
                    <div class="mn-form-group">
                        <label class="mn-label">
                            <i class="fa-solid fa-tag"></i> Plan Name <span class="mn-req">*</span>
                        </label>
                        <input type="text" id="inputPlanName" class="mn-input"
                            placeholder="e.g. Low-Carb Day Plan" />
                        <span class="mn-error" id="errPlanName" style="display:none;">Name is required.</span>
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">
                            <i class="fa-solid fa-calendar"></i> Day / Label
                        </label>
                        <select id="inputPlanDay" class="mn-input mn-select">
                            <option value="Monday">Monday</option>
                            <option value="Tuesday">Tuesday</option>
                            <option value="Wednesday">Wednesday</option>
                            <option value="Thursday">Thursday</option>
                            <option value="Friday">Friday</option>
                            <option value="Saturday">Saturday</option>
                            <option value="Sunday">Sunday</option>
                            <option value="Daily">Daily (Repeat)</option>
                            <option value="Weekdays">Weekdays</option>
                            <option value="Weekends">Weekends</option>
                        </select>
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">
                            <i class="fa-solid fa-circle-dot"></i> Goal
                        </label>
                        <select id="inputPlanGoal" class="mn-input mn-select">
                            <option value="Weight Loss">Weight Loss</option>
                            <option value="Maintenance">Maintenance</option>
                            <option value="Muscle Gain">Muscle Gain</option>
                            <option value="Heart Health">Heart Health</option>
                            <option value="Diabetes Control">Diabetes Control</option>
                            <option value="General Health">General Health</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Macronutrients -->
            <div class="mn-modal-section">
                <div class="mn-modal-section__title">
                    <i class="fa-solid fa-chart-pie"></i> Macronutrients
                </div>
                <div class="mn-form-grid mn-form-grid--4">
                    <div class="mn-form-group">
                        <label class="mn-label"><i class="fa-solid fa-fire"></i> Calories (kcal) <span class="mn-req">*</span></label>
                        <input type="number" id="inputCalories" class="mn-input" placeholder="e.g. 1800" min="0" />
                        <span class="mn-error" id="errCalories" style="display:none;">Required.</span>
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label"><i class="fa-solid fa-drumstick-bite"></i> Protein (g)</label>
                        <input type="number" id="inputProtein" class="mn-input" placeholder="e.g. 60" min="0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label"><i class="fa-solid fa-droplet"></i> Total Fat (g)</label>
                        <input type="number" id="inputFat" class="mn-input" placeholder="e.g. 55" min="0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label"><i class="fa-solid fa-wheat-awn"></i> Carbohydrate (g)</label>
                        <input type="number" id="inputCarbs" class="mn-input" placeholder="e.g. 220" min="0" />
                    </div>
                </div>
            </div>

            <!-- Detailed nutrients -->
            <div class="mn-modal-section">
                <div class="mn-modal-section__title">
                    <i class="fa-solid fa-flask"></i> Detailed Nutrients
                </div>
                <div class="mn-form-grid mn-form-grid--4">
                    <div class="mn-form-group">
                        <label class="mn-label"><i class="fa-solid fa-salt-shaker" style="font-size:10px;"></i> Sodium (mg)</label>
                        <input type="number" id="inputSodium" class="mn-input" placeholder="e.g. 1500" min="0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label"><i class="fa-solid fa-droplet-slash"></i> Saturated Fat (g)</label>
                        <input type="number" id="inputSatFat" class="mn-input" placeholder="e.g. 12" min="0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label"><i class="fa-solid fa-heart-pulse"></i> Cholesterol (mg)</label>
                        <input type="number" id="inputCholesterol" class="mn-input" placeholder="e.g. 200" min="0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label"><i class="fa-solid fa-candy-cane" style="font-size:10px;"></i> Sugar (g)</label>
                        <input type="number" id="inputSugar" class="mn-input" placeholder="e.g. 35" min="0" />
                    </div>
                </div>
            </div>

            <!-- Micronutrients -->
            <div class="mn-modal-section">
                <div class="mn-modal-section__title">
                    <i class="fa-solid fa-microscope"></i> Micronutrients
                </div>
                <div class="mn-form-grid mn-form-grid--4">
                    <div class="mn-form-group">
                        <label class="mn-label">Calcium (mg)</label>
                        <input type="number" id="inputCalcium" class="mn-input" placeholder="e.g. 800" min="0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Iron (mg)</label>
                        <input type="number" id="inputIron" class="mn-input" placeholder="e.g. 14" min="0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Potassium (mg)</label>
                        <input type="number" id="inputPotassium" class="mn-input" placeholder="e.g. 3500" min="0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Vitamin C (mg)</label>
                        <input type="number" id="inputVitC" class="mn-input" placeholder="e.g. 90" min="0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Vitamin E (mg)</label>
                        <input type="number" id="inputVitE" class="mn-input" placeholder="e.g. 15" min="0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Vitamin D (µg)</label>
                        <input type="number" id="inputVitD" class="mn-input" placeholder="e.g. 20" min="0" />
                    </div>
                    <div class="mn-form-group mn-form-group--span2">
                        <label class="mn-label"><i class="fa-solid fa-note-sticky"></i> Notes for Patient</label>
                        <textarea id="inputPlanNotes" class="mn-input mn-textarea" rows="2"
                            placeholder="Any dietary instructions or advice..."></textarea>
                    </div>
                </div>
            </div>

        </div>

        <div class="mn-modal__footer">
            <button class="mn-btn mn-btn--ghost" onclick="closePlanModal()">Cancel</button>
            <button class="mn-btn mn-btn--primary" onclick="confirmSavePlan()">
                <i class="fa-solid fa-floppy-disk"></i>
                <span id="planSaveBtnLabel">Save Plan</span>
            </button>
        </div>

    </div>
</div>

</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="/js/ManageNutrition.js"></script>
</asp:Content>