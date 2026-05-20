<%@ Page Title="Nutritions – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="Nutritions.aspx.cs"
    Inherits="MediCare.Pages.Patient.Nutritions" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/nutritions.css" />
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="nut-root">

        <!-- HEADER -->
        <div class="nut-page-header">
            <div class="nut-page-header__left">
                <div class="nut-page-header__icon">
                    <i class="fa-solid fa-bowl-food"></i>
                </div>

                <div>
                    <h1 class="nut-page-header__title">Nutrition Center</h1>
                    <p class="nut-page-header__sub">
                        Smart nutrition search and custom plans
                    </p>
                </div>
            </div>
        </div>

        <!-- SMART SEARCH -->
        <div class="nut-card">
            <div class="nut-card__header">
                <div class="nut-card__title-group">
                    <div class="nut-card__icon nut-card__icon--purple">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </div>

                    <div>
                        <h2 class="nut-card__title">Smart Food Search</h2>
                        <p class="nut-card__subtitle">
                            0 means ignore this attribute. Search range is ±5.
                        </p>
                    </div>
                </div>
            </div>

            <div class="nut-custom-form">

                <!-- ROW 1 -->
                <div class="nut-form-row">
                    <div class="nut-form-group">
                        <label class="nut-label">Calories</label>
                        <asp:TextBox ID="txtCalories"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Protein</label>
                        <asp:TextBox ID="txtProtein"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Total Fat</label>
                        <asp:TextBox ID="txtFat"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Carbohydrate</label>
                        <asp:TextBox ID="txtCarbs"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>
                </div>

                <!-- ROW 2 -->
                <div class="nut-form-row">
                    <div class="nut-form-group">
                        <label class="nut-label">Sodium</label>
                        <asp:TextBox ID="txtSodium"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Saturated Fat</label>
                        <asp:TextBox ID="txtSaturatedFat"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Cholesterol</label>
                        <asp:TextBox ID="txtCholesterol"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Sugar</label>
                        <asp:TextBox ID="txtSugar"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>
                </div>

                <!-- ROW 3 -->
                <div class="nut-form-row">
                    <div class="nut-form-group">
                        <label class="nut-label">Calcium</label>
                        <asp:TextBox ID="txtCalcium"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Iron</label>
                        <asp:TextBox ID="txtIron"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Potassium</label>
                        <asp:TextBox ID="txtPotassium"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>
                </div>

                <!-- ROW 4 -->
                <div class="nut-form-row">
                    <div class="nut-form-group">
                        <label class="nut-label">Vitamin C</label>
                        <asp:TextBox ID="txtVitaminC"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Vitamin E</label>
                        <asp:TextBox ID="txtVitaminE"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Vitamin D</label>
                        <asp:TextBox ID="txtVitaminD"
                            runat="server"
                            CssClass="nut-input"
                            TextMode="Number" />
                    </div>
                </div>

                <div class="nut-form-footer">
                    <asp:Label ID="lblSearchMsg"
                        runat="server"
                        CssClass="nut-inline-msg"
                        Visible="false" />

                    <asp:Button ID="btnSearchFoods"
                        runat="server"
                        Text="Search Foods"
                        CssClass="nut-btn nut-btn--primary"
                        OnClick="btnSearchFoods_Click" />
                </div>

            </div>
        </div>

        <!-- SEARCH RESULTS -->
        <div class="nut-card">
            <div class="nut-card__header">
                <h2 class="nut-card__title">Search Results</h2>
            </div>

            <asp:GridView ID="gvSearchResults"
                runat="server"
                CssClass="nut-grid"
                AutoGenerateColumns="True"
                GridLines="None"
                EmptyDataText="No foods found." />
        </div>

        <!-- NUTRITION PLAN -->
        <div class="nut-card">
            <div class="nut-card__header">
                <div class="nut-card__title-group">
                    <div class="nut-card__icon nut-card__icon--green">
                        <i class="fa-solid fa-clipboard-list"></i>
                    </div>

                    <div>
                        <h2 class="nut-card__title">Nutrition Plan</h2>
                        <p class="nut-card__subtitle">
                            Personal and doctor plans
                        </p>
                    </div>
                </div>
            </div>

            <div class="nut-scroll-x">
                <asp:GridView ID="gvNutritionPlan"
                    runat="server"
                    CssClass="nut-grid nut-grid--scroll"
                    AutoGenerateColumns="True"
                    GridLines="None"
                    EmptyDataText="No nutrition plans found." />
            </div>
        </div>

        <!-- MY PLAN -->
        <div class="nut-card">
            <div class="nut-card__header">
                <div class="nut-card__title-group">
                    <div class="nut-card__icon nut-card__icon--blue">
                        <i class="fa-solid fa-user-pen"></i>
                    </div>

                    <div>
                        <h2 class="nut-card__title">My Nutrition Plan</h2>
                        <p class="nut-card__subtitle">
                            Create personal targets
                        </p>
                    </div>
                </div>
            </div>

            <div class="nut-custom-form">

                <!-- ROW 1 -->
                <div class="nut-form-row">
                    <div class="nut-form-group">
                        <label class="nut-label">Calories</label>
                        <asp:TextBox ID="txtMyCalories" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Protein</label>
                        <asp:TextBox ID="txtMyProtein" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Total Fat</label>
                        <asp:TextBox ID="txtMyFat" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Carbohydrate</label>
                        <asp:TextBox ID="txtMyCarbs" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>
                </div>

                <!-- ROW 2 -->
                <div class="nut-form-row">
                    <div class="nut-form-group">
                        <label class="nut-label">Sodium</label>
                        <asp:TextBox ID="txtMySodium" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Saturated Fat</label>
                        <asp:TextBox ID="txtMySaturatedFat" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Cholesterol</label>
                        <asp:TextBox ID="txtMyCholesterol" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Sugar</label>
                        <asp:TextBox ID="txtMySugar" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>
                </div>

                <!-- ROW 3 -->
                <div class="nut-form-row">
                    <div class="nut-form-group">
                        <label class="nut-label">Calcium</label>
                        <asp:TextBox ID="txtMyCalcium" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Iron</label>
                        <asp:TextBox ID="txtMyIron" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Potassium</label>
                        <asp:TextBox ID="txtMyPotassium" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>
                </div>

                <!-- ROW 4 -->
                <div class="nut-form-row">
                    <div class="nut-form-group">
                        <label class="nut-label">Vitamin C</label>
                        <asp:TextBox ID="txtMyVitaminC" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Vitamin E</label>
                        <asp:TextBox ID="txtMyVitaminE" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>

                    <div class="nut-form-group">
                        <label class="nut-label">Vitamin D</label>
                        <asp:TextBox ID="txtMyVitaminD" runat="server" CssClass="nut-input" TextMode="Number" />
                    </div>
                </div>

                <div class="nut-form-footer">
                    <asp:Button ID="btnSaveMyPlan"
                        runat="server"
                        Text="Save My Plan"
                        CssClass="nut-btn nut-btn--primary"
                        OnClick="btnSaveMyPlan_Click" />
                </div>

            </div>
        </div>

    </div>

</asp:Content>