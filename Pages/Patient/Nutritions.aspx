<%@ Page Title="Nutritions – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="Nutritions.aspx.cs"
    Inherits="MediCare.Pages.Patient.Nutritions" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/nutritions.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="nut-root">

    <!-- PAGE HEADER -->
    <div class="nut-page-header">
        <div class="nut-page-header__left">
            <div class="nut-page-header__icon">
                <i class="fa-solid fa-bowl-food"></i>
            </div>
            <div>
                <h1 class="nut-page-header__title">Nutritions</h1>
                <p class="nut-page-header__sub">Meal plans, nutrition targets, and your personal food log</p>
            </div>
        </div>
        <div class="nut-page-header__right">
            <div class="nut-header-stat">
                <span class="nut-header-stat__num">3</span>
                <span class="nut-header-stat__label">Meals</span>
            </div>
            <div class="nut-header-stat">
                <span class="nut-header-stat__num">12</span>
                <span class="nut-header-stat__label">Foods</span>
            </div>
            <div class="nut-header-stat">
                <span class="nut-header-stat__num">1,850</span>
                <span class="nut-header-stat__label">Target kcal</span>
            </div>
        </div>
    </div>

    <!-- TOP CONTROLS -->
    <div class="nut-toolbar">
        <div class="nut-toolbar__left">
            <div class="nut-filter-group">
                <label class="nut-label">Filter by nutrition</label>
                <select id="ddlNutFilter" class="nut-select" onchange="filterNutritionPlan()">
                    <option value="">All foods</option>
                    <option value="lowcarb">Low carb</option>
                    <option value="highprotein">High protein</option>
                    <option value="highfiber">High fiber</option>
                    <option value="lowfat">Low fat</option>
                    <option value="lowcal">Low calorie</option>
                </select>
            </div>
        </div>
        <div class="nut-toolbar__right">
            <span class="nut-toolbar__hint">
                <i class="fa-solid fa-circle-info"></i>
                Meals can be populated from the database later
            </span>
        </div>
    </div>

    <!-- MAIN GRID -->
    <div class="nut-main-grid">

        <!-- NUTRITION PLAN -->
        <div class="nut-card">
            <div class="nut-card__header">
                <div class="nut-card__title-group">
                    <div class="nut-card__icon nut-card__icon--green">
                        <i class="fa-solid fa-plate-wheat"></i>
                    </div>
                    <div>
                        <h2 class="nut-card__title">Nutrition Plan</h2>
                        <p class="nut-card__subtitle">Breakfast, lunch, and snack suggestions based on patient needs</p>
                    </div>
                </div>
                <div class="nut-badge nut-badge--green">
                    <i class="fa-solid fa-bolt"></i> Personalized
                </div>
            </div>

            <div class="nut-plan-section">
                <h3 class="nut-section-title">Breakfast</h3>
                <table class="nut-grid" id="tblBreakfast">
                    <thead>
                        <tr>
                            <th>Food</th>
                            <th>Quantity</th>
                            <th>Calories</th>
                            <th>Protein</th>
                            <th>Carbs</th>
                            <th>Fiber</th>
                            <th>Fat</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr data-tags="highprotein lowcal">
                            <td>Greek yogurt with berries</td>
                            <td>1 bowl</td>
                            <td>220</td>
                            <td>18g</td>
                            <td>20g</td>
                            <td>4g</td>
                            <td>6g</td>
                        </tr>
                        <tr data-tags="lowcarb highprotein">
                            <td>Boiled eggs with cucumber</td>
                            <td>2 eggs + 1 cup</td>
                            <td>180</td>
                            <td>14g</td>
                            <td>5g</td>
                            <td>1g</td>
                            <td>11g</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="nut-plan-section">
                <h3 class="nut-section-title">Lunch</h3>
                <table class="nut-grid" id="tblLunch">
                    <thead>
                        <tr>
                            <th>Food</th>
                            <th>Quantity</th>
                            <th>Calories</th>
                            <th>Protein</th>
                            <th>Carbs</th>
                            <th>Fiber</th>
                            <th>Fat</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr data-tags="highprotein highfiber">
                            <td>Grilled chicken with quinoa</td>
                            <td>1 plate</td>
                            <td>450</td>
                            <td>38g</td>
                            <td>34g</td>
                            <td>6g</td>
                            <td>14g</td>
                        </tr>
                        <tr data-tags="lowfat lowcal">
                            <td>Turkey wrap with salad</td>
                            <td>1 wrap</td>
                            <td>330</td>
                            <td>24g</td>
                            <td>28g</td>
                            <td>5g</td>
                            <td>9g</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="nut-plan-section">
                <h3 class="nut-section-title">Snack</h3>
                <table class="nut-grid" id="tblSnack">
                    <thead>
                        <tr>
                            <th>Food</th>
                            <th>Quantity</th>
                            <th>Calories</th>
                            <th>Protein</th>
                            <th>Carbs</th>
                            <th>Fiber</th>
                            <th>Fat</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr data-tags="highfiber lowcal">
                            <td>Apple slices with peanut butter</td>
                            <td>1 small plate</td>
                            <td>190</td>
                            <td>5g</td>
                            <td>18g</td>
                            <td>4g</td>
                            <td>10g</td>
                        </tr>
                        <tr data-tags="lowcarb lowfat">
                            <td>Carrot sticks with hummus</td>
                            <td>1 cup</td>
                            <td>140</td>
                            <td>4g</td>
                            <td>15g</td>
                            <td>3g</td>
                            <td>6g</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- MY OWN FOODS -->
        <div class="nut-card">
            <div class="nut-card__header">
                <div class="nut-card__title-group">
                    <div class="nut-card__icon nut-card__icon--blue">
                        <i class="fa-solid fa-utensils"></i>
                    </div>
                    <div>
                        <h2 class="nut-card__title">My Own Foods</h2>
                        <p class="nut-card__subtitle">Foods you add manually with nutrition facts</p>
                    </div>
                </div>
                <div class="nut-badge nut-badge--blue">
                    <i class="fa-solid fa-list"></i> 2 Entries
                </div>
            </div>

            <div class="nut-table-wrap">
                <table class="nut-grid" id="tblOwnFoods">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Calories</th>
                            <th>Protein</th>
                            <th>Carbs</th>
                            <th>Fiber</th>
                            <th>Fat</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Homemade smoothie</td>
                            <td>210</td>
                            <td>8g</td>
                            <td>24g</td>
                            <td>6g</td>
                            <td>7g</td>
                            <td><button type="button" class="nut-delete-btn" onclick="deleteOwnFood(this)"><i class="fa-solid fa-trash-can"></i></button></td>
                        </tr>
                        <tr>
                            <td>Oatmeal bowl</td>
                            <td>280</td>
                            <td>10g</td>
                            <td>42g</td>
                            <td>7g</td>
                            <td>8g</td>
                            <td><button type="button" class="nut-delete-btn" onclick="deleteOwnFood(this)"><i class="fa-solid fa-trash-can"></i></button></td>
                        </tr>
                    </tbody>
                </table>

                <div class="nut-empty-state" id="emptyOwnFoods" style="display:none;">
                    <div class="nut-empty-state__icon"><i class="fa-solid fa-utensils"></i></div>
                    <p class="nut-empty-state__text">No personal foods added.</p>
                    <p class="nut-empty-state__sub">Use the button below to add your own food item.</p>
                </div>
            </div>

            <div class="nut-card__footer">
                <button type="button" class="nut-btn nut-btn--primary" onclick="toggleFoodPanel()">
                    <i class="fa-solid fa-plus"></i>
                    Add Food to Own Plan
                </button>
            </div>
        </div>
    </div>

    <!-- ADD FOOD PANEL -->
    <div class="nut-card nut-card--collapsible">
        <div class="nut-card__header nut-card__header--clickable"
             id="btnToggleFoodPanel"
             onclick="toggleFoodPanel()"
             role="button"
             tabindex="0"
             aria-expanded="false"
             aria-controls="foodPanelBody">
            <div class="nut-card__title-group">
                <div class="nut-card__icon nut-card__icon--purple">
                    <i class="fa-solid fa-wand-magic-sparkles"></i>
                </div>
                <div>
                    <h2 class="nut-card__title">Add Custom Food</h2>
                    <p class="nut-card__subtitle">Enter a food that is not in the database</p>
                </div>
            </div>
            <div class="nut-collapse-arrow" id="foodCollapseArrow">
                <i class="fa-solid fa-chevron-down"></i>
            </div>
        </div>

        <div class="nut-collapse-body" id="foodPanelBody" aria-hidden="true">
            <div class="nut-custom-form">

                <div class="nut-form-row">
                    <div class="nut-form-group">
                        <label class="nut-label">Food Name <span class="nut-required">*</span></label>
                        <input type="text" id="txtFoodName" class="nut-input" placeholder="e.g. Homemade smoothie" />
                    </div>
                    <div class="nut-form-group">
                        <label class="nut-label">Calories <span class="nut-required">*</span></label>
                        <input type="number" id="txtFoodCalories" class="nut-input" placeholder="e.g. 210" />
                    </div>
                </div>

                <div class="nut-form-row">
                    <div class="nut-form-group">
                        <label class="nut-label">Protein (g)</label>
                        <input type="number" id="txtFoodProtein" class="nut-input" placeholder="e.g. 8" />
                    </div>
                    <div class="nut-form-group">
                        <label class="nut-label">Carbs (g)</label>
                        <input type="number" id="txtFoodCarbs" class="nut-input" placeholder="e.g. 24" />
                    </div>
                    <div class="nut-form-group">
                        <label class="nut-label">Fiber (g)</label>
                        <input type="number" id="txtFoodFiber" class="nut-input" placeholder="e.g. 6" />
                    </div>
                    <div class="nut-form-group">
                        <label class="nut-label">Fat (g)</label>
                        <input type="number" id="txtFoodFat" class="nut-input" placeholder="e.g. 7" />
                    </div>
                </div>

                <div class="nut-form-footer">
                    <div id="foodMsg" class="nut-inline-msg" style="display:none;"></div>
                    <button type="button" class="nut-btn nut-btn--save" onclick="saveCustomFood()">
                        <i class="fa-solid fa-floppy-disk"></i>
                        Save Food
                    </button>
                </div>

            </div>
        </div>
    </div>

</div>

<script src="/js/Nutritions.js"></script>

</asp:Content>

