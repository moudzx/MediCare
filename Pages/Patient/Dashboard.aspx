<%@ Page Title="Patient Dashboard – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="MediCare.Patient.Dashboard" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/default.css" />
    <link rel="stylesheet" href="/css/dashboard.css" />
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="pd-root">
    <!-- TOPBAR -->
    <div class="pd-topbar">
        <div class="pd-topbar__left">
            <div class="pd-topbar__avatar">
                <i class="fa-solid fa-user"></i>
            </div>
            <div>
                <asp:Label ID="lblGreeting"
                    runat="server"
                    CssClass="pd-topbar__greeting" />

                <h1 class="pd-topbar__name">
                    <asp:Label ID="lblPatientName" runat="server" />
                </h1>
            </div>
        </div>
        <div class="pd-topbar__right">

            <div class="pd-topbar__date">
                <asp:Label ID="lblCurrentDate" runat="server" />
            </div>

            <div class="pd-topbar__badge">
                <span class="pd-status-dot"></span>

                <asp:Label ID="lblPatientStatus"
                    runat="server" />
            </div>
        </div>
    </div>

    <!-- MAIN GRID -->
    <div class="pd-main-grid">
        <!-- LEFT -->
        <div class="pd-col-left">
            <!-- HEALTH INFO -->
            <div class="pd-card">
                <div class="pd-card__header">
                    <div class="pd-card__title-group">
                        <div class="pd-card__icon pd-card__icon--green">
                            <i class="fa-solid fa-heart-pulse"></i>
                        </div>
                        <div>
                            <h2 class="pd-card__title">
                                Health Information
                            </h2>
                            <p class="pd-card__subtitle">
                                Your medical profile
                            </p>
                        </div>
                    </div>
                </div>
                <div class="pd-card__body">
                    <div class="pd-hv-grid">
                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Height</span>
                            <span class="pd-hv-value">
                                <asp:Label ID="lblHeight" runat="server" /> cm
                            </span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Weight</span>
                            <span class="pd-hv-value">
                                <asp:Label ID="lblWeight" runat="server" /> kg
                            </span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Calories</span>
                            <span class="pd-hv-value">
                                <asp:Label ID="lblCalories" runat="server" /> kcal
                            </span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Blood Type</span>
                            <span class="pd-hv-value">
                                <asp:Label ID="lblBloodType" runat="server" />
                            </span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Age</span>
                            <span class="pd-hv-value">
                                <asp:Label ID="lblAge" runat="server" /> yrs
                            </span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Disease</span>
                            <span class="pd-hv-value">
                                <asp:Label ID="lblDisease" runat="server" />
                            </span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Disability</span>
                            <span class="pd-hv-value">
                                <asp:Label ID="lblDisability" runat="server" />
                            </span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Family History</span>
                            <span class="pd-hv-value">
                                <asp:Label ID="lblFamilyHistory" runat="server" />
                            </span>
                        </div>

                    </div>

                </div>

            </div>

        </div>

        <!-- RIGHT -->
        <div class="pd-col-right">

            <!-- DOSES -->
            <div class="pd-card pd-card--doses">
                <div class="pd-card__header">
                    <div>
                        <h2 class="pd-card__title">
                            Today's Doses
                        </h2>

                        <p class="pd-card__subtitle">
                            <asp:Label ID="lblDoseCount" runat="server" />
                            medications today
                        </p>

                    </div>
                    <div class="pd-dpm-ring">
                        <svg viewBox="0 0 36 36" width="52" height="52">
                            <circle cx="18"
                                    cy="18"
                                    r="15.9"
                                    fill="none"
                                    stroke="#E5E7EB"
                                    stroke-width="3" />

                            <circle cx="18"
                                    cy="18"
                                    r="15.9"
                                    fill="none"
                                    stroke="#1A9E5C"
                                    stroke-width="3"
                                    stroke-dasharray="0 100"
                                    stroke-linecap="round"
                                    id="dpmArc"
                                    runat="server" />
                        </svg>

                        <asp:Label ID="lblDosePct"
                            runat="server"
                            CssClass="pd-dpm-pct" />

                    </div>

                </div>

                <div class="pd-table-wrap">

                    <asp:GridView ID="gvDoses"
                        runat="server"
                        AutoGenerateColumns="False"
                        GridLines="None"
                        CssClass="pd-grid"
                        DataKeyNames="DoseId"
                        OnRowDataBound="gvDoses_RowDataBound">

                        <Columns>

                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>

                                    <asp:CheckBox ID="chkTaken"
                                        runat="server"
                                        AutoPostBack="true"
                                        Checked='<%# Eval("IsTaken") %>'
                                        OnCheckedChanged="chkTaken_CheckedChanged" />

                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="MedicineName"
                                HeaderText="Medicine" />

                            <asp:BoundField DataField="Dosage"
                                HeaderText="Dosage" />

                            <asp:BoundField DataField="Instructions"
                                HeaderText="Instructions" />

                            <asp:BoundField DataField="Time"
                                HeaderText="Time" />

                        </Columns>

                    </asp:GridView>

                </div>

                <div class="pd-doses-footer">
                    <asp:Label ID="lblDoseSummary"
                        runat="server" />
                </div>

            </div>

            <!-- INVENTORY -->
            <!-- FIXED: REPEATER → GRIDVIEW -->
            <div class="pd-card pd-card--inventory">

                <div class="pd-card__header">

                    <div class="pd-card__title-group">

                        <div class="pd-card__icon pd-card__icon--purple">
                            <i class="fa-solid fa-capsules"></i>
                        </div>

                        <div>

                            <h2 class="pd-card__title">
                                Pill Inventory
                            </h2>

                            <p class="pd-card__subtitle">
                                Remaining medication stock
                            </p>

                        </div>

                    </div>

                </div>

                <div class="pd-table-wrap">

                    <asp:GridView ID="gvInventory"
                        runat="server"
                        AutoGenerateColumns="False"
                        GridLines="None"
                        ShowHeader="False"
                        CssClass="pd-inventory-grid">

                        <Columns>

                            <asp:TemplateField>

                                <ItemTemplate>

                                    <div class="pd-inv-row">

                                        <div class="pd-inv-label">
                                            <%# Eval("Name") %>
                                        </div>

                                        <div class="pd-inv-bar-wrap">

                                            <div class="pd-inv-bar"
                                                 style='width:<%# Eval("Percentage") %>%'>
                                            </div>

                                        </div>

                                        <div class="pd-inv-value">
                                            <%# Eval("Remaining") %> /
                                            <%# Eval("Total") %>
                                        </div>

                                    </div>

                                </ItemTemplate>

                            </asp:TemplateField>

                        </Columns>

                    </asp:GridView>

                </div>

            </div>

            <!-- DOCTORS -->
            <div class="pd-card pd-card--doctors">
                <div class="pd-card__header">
                    <h2 class="pd-card__title">My Doctors</h2>
                    <p class="pd-card__subtitle">Doctors you are connected with</p>
                </div>

                <asp:GridView ID="gvDoctors" runat="server"
                    AutoGenerateColumns="False"
                    ShowHeader="False"
                    CssClass="pd-doctors-grid"
                    GridLines="None"
                    OnRowDataBound="gvDoctors_RowDataBound">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <div class="pd-doctor-row">
                                    <div class="pd-doctor-avatar">
                                        <i class="fa-solid fa-user-doctor"></i>
                                    </div>
                                    <div class="pd-doctor-info">
                                        <div class="pd-doctor-name"><%# Eval("DoctorName") %></div>
                                        <div class="pd-doctor-specialty"><%# Eval("Specialty") %></div>
                                    </div>
                                    <asp:Label ID="lblStatus" runat="server"
                                        CssClass="pd-doctor-status-badge"
                                        Text='<%# Eval("Status") %>' />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <div class="pd-doctors-footer">
                    <asp:HyperLink ID="lnkFindDoctors" runat="server"
                        NavigateUrl="Search.aspx"
                        CssClass="mc-btn mc-btn--primary"
                        Text="Connect with new doctors" />
                </div>
            </div>

        </div>

    </div>

</div>

<script>
    (function () {

        if (!('IntersectionObserver' in window)) return;

        const cards = document.querySelectorAll('.pd-card');

        cards.forEach(function (card, i) {

            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            card.style.transition =
                'opacity .45s ease, transform .45s ease';

            card.style.transitionDelay = (i * 80) + 'ms';
        });

        const observer = new IntersectionObserver(function (entries) {

            entries.forEach(function (entry) {

                if (entry.isIntersecting) {

                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';

                    observer.unobserve(entry.target);
                }

            });

        }, { threshold: 0.12 });

        cards.forEach(function (card) {
            observer.observe(card);
        });

    })();
</script>

</asp:Content>