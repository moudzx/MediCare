<%@ Page Title="Patient Dashboard – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="MediCare.Patient.Dashboard" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/default.css" />
    <link rel="stylesheet" href="/css/dashboard.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="pd-root">

    <!-- ================= TOP BAR ================= -->
    <div class="pd-topbar">

        <div class="pd-topbar__left">
            <div class="pd-topbar__avatar">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                    <circle cx="12" cy="7" r="4" />
                </svg>
            </div>

            <div>
                <asp:Label ID="lblGreeting" runat="server" CssClass="pd-topbar__greeting" />
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
                <asp:Label ID="lblPatientStatus" runat="server" />
            </div>
        </div>

    </div>

    <!-- ================= MAIN GRID ================= -->
    <div class="pd-main-grid">

        <!-- ================= LEFT: HEALTH INFO ================= -->
        <div class="pd-col-left">

            <div class="pd-card">

                <div class="pd-card__header">
                    <div class="pd-card__title-group">

                        <div class="pd-card__icon pd-card__icon--green">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>

                        <div>
                            <h2 class="pd-card__title">Health Information</h2>
                            <p class="pd-card__subtitle">Your medical profile</p>
                        </div>

                    </div>
                </div>

                <div class="pd-card__body">

                    <div class="pd-hv-grid">

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Height</span>
                            <span class="pd-hv-value"><asp:Label ID="lblHeight" runat="server" /> cm</span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Weight</span>
                            <span class="pd-hv-value"><asp:Label ID="lblWeight" runat="server" /> kg</span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Calories</span>
                            <span class="pd-hv-value"><asp:Label ID="lblCalories" runat="server" /> kcal</span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Blood Type</span>
                            <span class="pd-hv-value"><asp:Label ID="lblBloodType" runat="server" /></span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Age</span>
                            <span class="pd-hv-value"><asp:Label ID="lblAge" runat="server" /> yrs</span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Chronic Disease</span>
                            <span class="pd-hv-value"><asp:Label ID="lblDisease" runat="server" /></span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Disability</span>
                            <span class="pd-hv-value"><asp:Label ID="lblDisability" runat="server" /></span>
                        </div>

                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Family History</span>
                            <span class="pd-hv-value"><asp:Label ID="lblFamilyHistory" runat="server" /></span>
                        </div>

                    </div>

                </div>

            </div>

        </div>

        <!-- ================= RIGHT COLUMN ================= -->
        <div class="pd-col-right">

            <!-- ================= DOSES ================= -->
            <div class="pd-card pd-card--doses">

                <div class="pd-card__header">

                    <div>
                        <h2 class="pd-card__title">Today's Doses</h2>
                        <p class="pd-card__subtitle">
                            <asp:Label ID="lblDoseCount" runat="server" /> my medications
                        </p>
                    </div>

                    <div class="pd-dpm-ring">
                        <svg viewBox="0 0 36 36" width="52" height="52">
                            <circle cx="18" cy="18" r="15.9" fill="none" stroke="#E5E7EB" stroke-width="3"/>
                            <circle cx="18" cy="18" r="15.9" fill="none"
                                    stroke="#1A9E5C" stroke-width="3"
                                    id="dpmArc"
                                    stroke-dasharray="0 100"
                                    stroke-linecap="round"/>
                        </svg>

                        <asp:Label ID="lblDosePct" runat="server" CssClass="pd-dpm-pct" />
                    </div>

                </div>

                <!-- DOSES LIST -->
                <asp:GridView ID="gvDoses" runat="server" AutoGenerateColumns="False" DataKeyNames="DoseId">

                    <Columns>

                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkTaken"
                                        runat="server"
                                        AutoPostBack="true"
                                         />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="MedicineName" HeaderText="Medicine" />

                        <asp:BoundField DataField="Dosage" HeaderText="Dosage" />
                        <asp:BoundField DataField="Instructions" HeaderText="Instructions" />
                        <asp:BoundField DataField="Time" HeaderText="Time" />
                    </Columns>
                </asp:GridView>

                <div class="pd-doses-footer">
                    <asp:Label ID="lblDoseSummary" runat="server" />
                </div>
            </div>

            <!-- ================= INVENTORY ================= -->
            <div class="pd-card pd-card--inventory">

                <div class="pd-card__header">
                    <h2 class="pd-card__title">Pill Inventory</h2>
                </div>

                <asp:GridView ID="GridView1" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="pd-grid"
                    GridLines="None">

                    <Columns>

                        <asp:TemplateField HeaderText="Medication">
                            <ItemTemplate>
                                <asp:Label ID="lblName" runat="server"
                                    Text='<%# Bind("Name") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Details">
                            <ItemTemplate>
                                <asp:Label ID="lblDetail" runat="server"
                                    Text='<%# Bind("Detail") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Remaining">
                            <ItemTemplate>
                                <asp:Label ID="lblRemaining" runat="server"
                                    Text='<%# Bind("Remaining") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>
            </div>

        </div>
        <div class="pd-card pd-card--doctors">

        <div class="pd-card__header">
            <h2 class="pd-card__title">My Doctors</h2>
            <p class="pd-card__subtitle">Doctors you are connected with</p>
        </div>

        <asp:GridView ID="gvDoctors" runat="server"
            AutoGenerateColumns="False"
            ShowHeader="False"
            CssClass="pd-doctors-grid">

            <Columns>

                <asp:TemplateField>
                    <ItemTemplate>

                        <div class="pd-doctor-row">

                            <!-- Avatar -->
                            <div class="pd-doctor-avatar">
                                👨‍⚕️
                            </div>

                            <!-- Info -->
                            <div class="pd-doctor-info">
                                <div class="pd-doctor-name">
                                    <%# Eval("DoctorName") %>
                                </div>

                                <div class="pd-doctor-specialty">
                                    <%# Eval("Specialty") %>
                                </div>
                            </div>

                            <!-- Status -->
                            <div class="pd-doctor-status">
                                <%# Eval("Status") %>
                            </div>

                        </div>

                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>

        <!-- ACTION BUTTON -->
        <div class="pd-doctors-footer">
            <asp:HyperLink ID="lnkFindDoctors" runat="server"
                NavigateUrl="Search.aspx"
                CssClass="mc-btn mc-btn--primary"
                Text="Connect with new doctors" />
        </div>
    </div>

    </div>
</div>

</asp:Content>