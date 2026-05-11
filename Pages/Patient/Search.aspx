<%@ Page Title="Search – MediCare" Language="C#" MasterPageFile="~/MasterPage/PatientSite.Master" AutoEventWireup="true" CodeBehind="Search.aspx.cs" Inherits="MediCare.Pages.Patient.Search" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/search.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="sea-root">

    <!-- HEADER -->
    <div class="sea-page-header">
        <div class="sea-page-header__left">
            <div class="sea-page-header__icon">
                <i class="fa-solid fa-magnifying-glass"></i>
            </div>
            <div>
                <h1 class="sea-page-header__title">Search</h1>
                <p class="sea-page-header__sub">Search across doctors, medicines, and foods</p>
            </div>
        </div>

        <div class="sea-page-header__right">
            <div class="sea-header-stat">
                <span class="sea-header-stat__num">3</span>
                <span class="sea-header-stat__label">Categories</span>
            </div>
            <div class="sea-header-stat">
                <span class="sea-header-stat__num">12</span>
                <span class="sea-header-stat__label">Results</span>
            </div>
            <div class="sea-header-stat">
                <span class="sea-header-stat__num">1</span>
                <span class="sea-header-stat__label">Search bar</span>
            </div>
        </div>
    </div>

    <!-- SEARCH BAR -->
    <div class="sea-toolbar">
        <div class="sea-search-panel">
            <div class="sea-search-field">
                <label class="sea-label" for="ddlSearchScope">Search scope</label>
                <select id="ddlSearchScope" class="sea-select">
                    <option value="all">Search everything</option>
                    <option value="doctors">Doctors</option>
                    <option value="medicines">Medicines</option>
                    <option value="foods">Foods</option>
                </select>
            </div>

            <div class="sea-search-field sea-search-field--grow">
                <label class="sea-label" for="txtSearchQuery">Search text</label>
                <div class="sea-search-input-wrap">
                    <i class="fa-solid fa-magnifying-glass sea-search-icon"></i>
                    <input type="text" id="txtSearchQuery" class="sea-search-input" placeholder="Type a name, specialization, description, or food..." />
                </div>
            </div>

            <div class="sea-search-field sea-search-field--btn">
                <label class="sea-label sea-label--ghost"> </label>
                <button type="button" class="sea-btn sea-btn--primary" onclick="performSearch()">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    Search
                </button>
            </div>
        </div>
    </div>

    <div id="searchMsg" class="sea-inline-msg" style="display:none;"></div>

    <!-- RESULTS GRID -->
    <div class="sea-results-grid">

        <!-- DOCTORS -->
        <div class="sea-card" data-section="doctors" id="cardDoctors">
            <div class="sea-card__header">
                <div class="sea-card__title-group">
                    <div class="sea-card__icon sea-card__icon--blue">
                        <i class="fa-solid fa-user-doctor"></i>
                    </div>
                    <div>
                        <h2 class="sea-card__title">Doctors</h2>
                        <p class="sea-card__subtitle">Find doctors by name or specialization</p>
                    </div>
                </div>
                <div class="sea-badge sea-badge--blue">
                    <i class="fa-solid fa-stethoscope"></i> <span id="countDoctors">3</span>
                </div>
            </div>

            <div class="sea-table-wrap">
                <table class="sea-grid" id="tblDoctors">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Specialization</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Dr. Ahmad Karimi</td>
                            <td>Cardiology</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--blue" onclick="requestApproval(this)">
                                    Request Approval
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Dr. Sara Hassan</td>
                            <td>Endocrinology</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--blue" onclick="requestApproval(this)">
                                    Request Approval
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Dr. Karim Mansour</td>
                            <td>Nutrition & Dietetics</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--blue" onclick="requestApproval(this)">
                                    Request Approval
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="sea-empty-state" id="emptyDoctors" style="display:none;">
                    <div class="sea-empty-state__icon"><i class="fa-solid fa-user-doctor"></i></div>
                    <p class="sea-empty-state__text">No doctors found.</p>
                    <p class="sea-empty-state__sub">Try a different search term.</p>
                </div>
            </div>
        </div>

        <!-- MEDICINES -->
        <div class="sea-card" data-section="medicines" id="cardMedicines">
            <div class="sea-card__header">
                <div class="sea-card__title-group">
                    <div class="sea-card__icon sea-card__icon--green">
                        <i class="fa-solid fa-pills"></i>
                    </div>
                    <div>
                        <h2 class="sea-card__title">Medicines</h2>
                        <p class="sea-card__subtitle">Find medicine names and descriptions</p>
                    </div>
                </div>
                <div class="sea-badge sea-badge--green">
                    <i class="fa-solid fa-capsules"></i> <span id="countMedicines">4</span>
                </div>
            </div>

            <div class="sea-table-wrap">
                <table class="sea-grid" id="tblMedicines">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Description</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Metformin</td>
                            <td>Used to help control blood sugar.</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--green" onclick="addMedicine(this)">
                                    Add
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Lisinopril</td>
                            <td>Treats high blood pressure.</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--green" onclick="addMedicine(this)">
                                    Add
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Atorvastatin</td>
                            <td>Helps lower cholesterol.</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--green" onclick="addMedicine(this)">
                                    Add
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Vitamin D3</td>
                            <td>Supports bone and immune health.</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--green" onclick="addMedicine(this)">
                                    Add
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="sea-empty-state" id="emptyMedicines" style="display:none;">
                    <div class="sea-empty-state__icon"><i class="fa-solid fa-pills"></i></div>
                    <p class="sea-empty-state__text">No medicines found.</p>
                    <p class="sea-empty-state__sub">Try a different search term.</p>
                </div>
            </div>
        </div>

        <!-- FOODS -->
        <div class="sea-card" data-section="foods" id="cardFoods">
            <div class="sea-card__header">
                <div class="sea-card__title-group">
                    <div class="sea-card__icon sea-card__icon--purple">
                        <i class="fa-solid fa-bowl-food"></i>
                    </div>
                    <div>
                        <h2 class="sea-card__title">Foods</h2>
                        <p class="sea-card__subtitle">Find foods with nutrition facts</p>
                    </div>
                </div>
                <div class="sea-badge sea-badge--purple">
                    <i class="fa-solid fa-apple-whole"></i> <span id="countFoods">4</span>
                </div>
            </div>

            <div class="sea-table-wrap">
                <table class="sea-grid" id="tblFoods">
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
                            <td>Greek yogurt with berries</td>
                            <td>220</td>
                            <td>18g</td>
                            <td>20g</td>
                            <td>4g</td>
                            <td>6g</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--purple" onclick="addFood(this)">
                                    Add
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Grilled chicken with quinoa</td>
                            <td>450</td>
                            <td>38g</td>
                            <td>34g</td>
                            <td>6g</td>
                            <td>14g</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--purple" onclick="addFood(this)">
                                    Add
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Apple slices with peanut butter</td>
                            <td>190</td>
                            <td>5g</td>
                            <td>18g</td>
                            <td>4g</td>
                            <td>10g</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--purple" onclick="addFood(this)">
                                    Add
                                </button>
                            </td>
                        </tr>
                        <tr>
                            <td>Carrot sticks with hummus</td>
                            <td>140</td>
                            <td>4g</td>
                            <td>15g</td>
                            <td>3g</td>
                            <td>6g</td>
                            <td>
                                <button type="button" class="sea-btn sea-btn--small sea-btn--purple" onclick="addFood(this)">
                                    Add
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="sea-empty-state" id="emptyFoods" style="display:none;">
                    <div class="sea-empty-state__icon"><i class="fa-solid fa-bowl-food"></i></div>
                    <p class="sea-empty-state__text">No foods found.</p>
                    <p class="sea-empty-state__sub">Try a different search term.</p>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="/js/search.js"></script>

</asp:Content>