<%@ Page Title="Meal Calculator – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="mealCalculator.aspx.cs"
    Inherits="MediCare.Pages.Patient.MealCalculator" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/mealCalculator.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="meal-root">

    <!-- HEADER -->
    <div class="meal-header">
        <div class="meal-header__left">
            <div class="meal-header__icon">
                <i class="fa-solid fa-calculator"></i>
            </div>

            <div>
                <h1 class="meal-header__title">Meal Calculator</h1>
                <p class="meal-header__sub">Evaluate foods vs your nutrition plan</p>
            </div>
        </div>
    </div>

    <!-- FORM CARD -->
    <div class="meal-card">

        <div class="meal-card__header">
            <h2 class="meal-card__title">Food Input</h2>
        </div>

        <div class="meal-form">

            <div class="meal-row">
                <div class="meal-group">
                    <label>Food Name</label>
                    <input type="text" id="txtFood" />
                </div>

                <div class="meal-group">
                    <label>Calories</label>
                    <input type="number" id="txtCalories" />
                </div>
            </div>

            <div class="meal-row">
                <div class="meal-group">
                    <label>Protein (g)</label>
                    <input type="number" id="txtProtein" />
                </div>

                <div class="meal-group">
                    <label>Carbs (g)</label>
                    <input type="number" id="txtCarbs" />
                </div>

                <div class="meal-group">
                    <label>Fat (g)</label>
                    <input type="number" id="txtFat" />
                </div>

                <div class="meal-group">
                    <label>Fiber (g)</label>
                    <input type="number" id="txtFiber" />
                </div>
            </div>

            <!-- ACTION BUTTONS -->
            <div class="meal-actions">

                <button type="button" class="meal-btn meal-btn--primary" onclick="saveFood()">
                    <i class="fa-solid fa-floppy-disk"></i>
                    Save to My Foods
                </button>

                <button type="button" class="meal-btn meal-btn--green" onclick="calculateAccuracy()">
                    <i class="fa-solid fa-bullseye"></i>
                    Calculate Accuracy
                </button>

                <button type="button" class="meal-btn meal-btn--gray" onclick="resetForm()">
                    <i class="fa-solid fa-rotate-left"></i>
                    Reset
                </button>

            </div>

            <!-- RESULT -->
            <div class="meal-result" id="resultBox" style="display:none;"></div>

        </div>
    </div>

</div>

<script src="/js/mealCalculator.js"></script>

</asp:Content>