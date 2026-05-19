<%@ Page Title="Manage Nutrition – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="ManageNutrition.aspx.cs"
    Inherits="MediCare.Pages.Doctor.ManageNutrition" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/ManageNutrition.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        .mn-toast { position: fixed; bottom: 20px; right: 20px; background: #10b981; color: #fff; padding: 15px 25px; border-radius: 6px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); display: flex; align-items: center; gap: 10px; z-index: 1000; font-weight: 500; }
        .mn-plan-card { background: #fff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); padding: 20px; border: 1px solid #eef2f5; display: flex; flex-direction: column; gap: 15px; }
        .mn-plan-card__header { display: flex; justify-content: space-between; align-items: flex-start; border-bottom: 1px solid #f1f5f9; padding-bottom: 10px; }
        .mn-plan-card__title { font-size: 1.1rem; margin: 0; color: #1e293b; font-weight: 600; }
        .mn-plan-card__badge { font-size: 0.8rem; background: #e0f2fe; color: #0369a1; padding: 3px 8px; border-radius: 12px; font-weight: bold; }
        
        .mn-grid-container { display: grid; grid-template-columns: repeat(4, 1fr); gap: 8px; background: #f8fafc; padding: 12px; border-radius: 6px; text-align: center; }
        .mn-macro-val { font-weight: bold; color: #334155; font-size: 0.9rem; }
        .mn-macro-lbl { font-size: 0.7rem; color: #64748b; text-transform: uppercase; }
        .mn-validation-summary { background-color: #fef2f2; border-left: 4px solid #ef4444; color: #991b1b; padding: 12px; margin-bottom: 15px; border-radius: 4px; font-size: 0.9rem; }
    </style>
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="mn-root">
    <div class="mn-page-header">
        <div class="mn-page-header__left">
            <div class="mn-page-header__icon">
                <i class="fa-solid fa-bowl-food"></i>
            </div>
            <div>
                <h1 class="mn-page-header__title">Manage Nutrition</h1>
                <p class="mn-page-header__sub">
                    Patient: <strong><asp:Label ID="lblPatientName" runat="server" Text="--" /></strong>
                    &nbsp;·&nbsp; Full-Spectrum Nutrient Dashboard
                </p>
            </div>
        </div>
        <div class="mn-page-header__right">
            <div class="mn-header-stat">
                <span class="mn-header-stat__num"><asp:Label ID="lblStatPlans" runat="server" Text="0" /></span>
                <span class="mn-header-stat__label">Plans</span>
            </div>
            <div class="mn-header-stat">
                <span class="mn-header-stat__num"><asp:Label ID="lblStatAvgCal" runat="server" Text="0" /></span>
                <span class="mn-header-stat__label">Avg kcal</span>
            </div>
            <button type="button" class="mn-btn mn-btn--primary" onclick="openAddPlanModal()">
                <i class="fa-solid fa-plus"></i> Add Plan
            </button>
        </div>
    </div>

    <div class="mn-plans-grid" id="mnPlansGrid">
        <asp:Repeater ID="rptPlans" runat="server" OnItemCommand="rptPlans_ItemCommand">
            <ItemTemplate>
                <div class="mn-plan-card">
                    <div class="mn-plan-card__header">
                        <div>
                            <h3 class="mn-plan-card__title">Nutrition Targets Summary</h3>
                        </div>
                        <span class="mn-plan-card__badge"><%# Eval("calories") %> kcal</span>
                    </div>
                    
                    <div class="mn-grid-container">
                        <div><div class="mn-macro-val"><%# Eval("protein") %>g</div><div class="mn-macro-lbl">Protein</div></div>
                        <div><div class="mn-macro-val"><%# Eval("carbohydrate") %>g</div><div class="mn-macro-lbl">Carbs</div></div>
                        <div><div class="mn-macro-val"><%# Eval("total_fat") %>g</div><div class="mn-macro-lbl">Total Fat</div></div>
                        <div><div class="mn-macro-val"><%# Eval("saturated_fat") %>g</div><div class="mn-macro-lbl">Sat. Fat</div></div>
                        
                        <div><div class="mn-macro-val"><%# Eval("sugar") %>g</div><div class="mn-macro-lbl">Sugar</div></div>
                        <div><div class="mn-macro-val"><%# Eval("sodium") %>mg</div><div class="mn-macro-lbl">Sodium</div></div>
                        <div><div class="mn-macro-val"><%# Eval("cholesterol") %>mg</div><div class="mn-macro-lbl">Cholest.</div></div>
                        <div><div class="mn-macro-val"><%# Eval("potassium") %>mg</div><div class="mn-macro-lbl">Potass.</div></div>

                        <div><div class="mn-macro-val"><%# Eval("calcium") %>mg</div><div class="mn-macro-lbl">Calcium</div></div>
                        <div><div class="mn-macro-val"><%# Eval("iron") %>mg</div><div class="mn-macro-lbl">Iron</div></div>
                        <div><div class="mn-macro-val"><%# Eval("vitamin_c") %>mg</div><div class="mn-macro-lbl">Vit C</div></div>
                        <div><div class="mn-macro-val"><%# Eval("vitamin_d") %>µg</div><div class="mn-macro-lbl">Vit D</div></div>
                    </div>

                    <div style="font-size: 0.85rem; color: #475569; background: #fff; padding: 8px; border-radius: 4px; border-left: 3px solid #cbd5e1;">
                        <strong>Notes:</strong> <%# string.IsNullOrEmpty(Eval("Notes").ToString()) ? "No notes added." : Eval("Notes") %>
                    </div>

                    <div style="text-align: right; margin-top: auto; padding-top: 10px; border-top: 1px dashed #e2e8f0;">
                        <asp:LinkButton ID="btnDeletePlan" runat="server" CommandName="DeletePlan" CommandArgument='<%# Eval("PlanId") %>' ForeColor="#ef4444" style="font-size: 0.85rem;" OnClientClick="return confirm('Remove this nutrition plan?');">
                            <i class="fa-solid fa-trash-can"></i> Delete Plan
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:Panel ID="pnlEmptyState" runat="server" CssClass="mn-empty" Visible="false">
        <div class="mn-empty__icon"><i class="fa-solid fa-bowl-food"></i></div>
        <p class="mn-empty__text">No nutrition plans assigned yet.</p>
        <button type="button" class="mn-btn mn-btn--primary" onclick="openAddPlanModal()" style="margin-top:16px;">
            Create Plan
        </button>
    </asp:Panel>
</div>

<div class="mn-modal-overlay" id="planModal" style='<%= IsPostBack && pnlValidationError.Visible ? "display: flex;" : "display: none;" %>'>
    <div class="mn-modal" style="max-width: 700px;" role="dialog" aria-modal="true">
        <div class="mn-modal__header">
            <div class="mn-modal__title-group">
                <div class="mn-modal__icon"><i class="fa-solid fa-bowl-food"></i></div>
                <div>
                    <h3 class="mn-modal__title">Create Full Nutrition Profile</h3>
                    <p class="mn-modal__sub">All targets will be committed directly to database as Float elements</p>
                </div>
            </div>
            <button type="button" class="mn-modal__close" onclick="closePlanModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>

        <div class="mn-modal__body">
            <asp:Panel ID="pnlValidationError" runat="server" CssClass="mn-validation-summary" Visible="false">
                <i class="fas fa-exclamation-triangle"></i> <asp:Label ID="lblValidationError" runat="server" />
            </asp:Panel>

            <div class="mn-modal-section">
                <div class="mn-modal-section__title"><i class="fa-solid fa-chart-pie"></i> Core Macronutrients</div>
                <div class="mn-form-grid mn-form-grid--4">
                    <div class="mn-form-group">
                        <label class="mn-label">Calories (kcal) *</label>
                        <asp:TextBox ID="inputCalories" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Protein (g)</label>
                        <asp:TextBox ID="inputProtein" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Carbohydrates (g)</label>
                        <asp:TextBox ID="inputCarbs" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Total Fat (g)</label>
                        <asp:TextBox ID="inputTotalFat" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                </div>
            </div>

            <div class="mn-modal-section">
                <div class="mn-modal-section__title"><i class="fa-solid fa-dna"></i> Specific Elements</div>
                <div class="mn-form-grid mn-form-grid--4">
                    <div class="mn-form-group">
                        <label class="mn-label">Saturated Fat (g)</label>
                        <asp:TextBox ID="inputSatFat" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Sugar (g)</label>
                        <asp:TextBox ID="inputSugar" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Sodium (mg)</label>
                        <asp:TextBox ID="inputSodium" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Cholesterol (mg)</label>
                        <asp:TextBox ID="inputCholesterol" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                </div>
            </div>

            <div class="mn-modal-section">
                <div class="mn-modal-section__title"><i class="fa-solid fa-capsules"></i> Micronutrients</div>
                <div class="mn-form-grid mn-form-grid--3">
                    <div class="mn-form-group">
                        <label class="mn-label">Potassium (mg)</label>
                        <asp:TextBox ID="inputPotassium" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Calcium (mg)</label>
                        <asp:TextBox ID="inputCalcium" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Iron (mg)</label>
                        <asp:TextBox ID="inputIron" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                </div>
                <div class="mn-form-grid mn-form-grid--3" style="margin-top: 10px;">
                    <div class="mn-form-group">
                        <label class="mn-label">Vitamin C (mg)</label>
                        <asp:TextBox ID="inputVitC" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Vitamin D (µg)</label>
                        <asp:TextBox ID="inputVitD" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                    <div class="mn-form-group">
                        <label class="mn-label">Vitamin E (mg)</label>
                        <asp:TextBox ID="inputVitE" runat="server" TextMode="Number" step="any" CssClass="mn-input" placeholder="0.0" />
                    </div>
                </div>
            </div>

            <div class="mn-modal-section">
                <div class="mn-form-group" style="width: 100%;">
                    <label class="mn-label">Plan Notes & Instructions</label>
                    <asp:TextBox ID="inputNotes" runat="server" TextMode="MultiLine" Rows="3" CssClass="mn-input mn-textarea" placeholder="Enter specific eating instructions here..." />
                </div>
            </div>
        </div>

        <div class="mn-modal__footer">
            <button type="button" class="mn-btn mn-btn--ghost" onclick="closePlanModal()">Cancel</button>
            <asp:Button ID="btnConfirmSave" runat="server" OnClick="btnConfirmSave_Click" CssClass="mn-btn mn-btn--primary" Text="Save Plan" />
        </div>
    </div>
</div>

<script type="text/javascript">
function openAddPlanModal() {
    var modal = document.getElementById('planModal');
    if (modal) { modal.style.display = 'flex'; }
}
function closePlanModal() {
    var modal = document.getElementById('planModal');
    if (modal) { modal.style.display = 'none'; }
}
</script>

<asp:Panel ID="pnlToast" runat="server" CssClass="mn-toast" Visible="false">
    <i class="fas fa-check-circle"></i> <asp:Label ID="lblToastMsg" runat="server" Text="" />
</asp:Panel>

</asp:Content>