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

    <!-- MAIN GRID -->
    <div class="pd-main-grid">
        <!-- LEFT -->
        <div class="pd-col-left">
            <div class="pd-card">
                <div class="pd-card__header">
                    <div class="pd-card__title-group">
                        <div class="pd-card__icon pd-card__icon--green">
                            <i class="fa-solid fa-heart-pulse"></i>
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
                            <span class="pd-hv-label">Height (cm)</span>
                            <asp:Label ID="lblHeight" runat="server" CssClass="pd-hv-value" />
                        </div>
                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Weight (kg)</span>
                            <asp:Label ID="lblWeight" runat="server" CssClass="pd-hv-value" />
                        </div>
                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Gender</span>
                            <asp:Label ID="lblGender" runat="server" CssClass="pd-hv-value" />
                        </div>
                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Blood Type</span>
                            <asp:Label ID="lblBloodType" runat="server" CssClass="pd-hv-value" />
                        </div>
                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Age</span>
                            <asp:Label ID="lblAge" runat="server" CssClass="pd-hv-value" />
                        </div>
                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Disease</span>
                            <asp:Label ID="lblDisease" runat="server" CssClass="pd-hv-value" />
                        </div>
                        <div class="pd-hv-item">
                            <span class="pd-hv-label">Disability</span>
                            <asp:Label ID="lblDisability" runat="server" CssClass="pd-hv-value" />
                        </div>
                        <div class="pd-hv-item pd-hv-item--wide">
                            <span class="pd-hv-label">Family History</span>
                            <asp:Label ID="lblFamilyHistory" runat="server" CssClass="pd-hv-value pd-hv-value--multiline" />
                        </div>
                    </div>
                    <asp:Label ID="lblHealthMessage" runat="server" CssClass="pd-success-msg" Visible="false" />
                </div>
            </div>
                        <!-- MY APPOINTMENTS -->
            
        </div>

        <!-- RIGHT -->
        <div class="pd-col-right">
            <!-- DOSES -->
            <div class="pd-card pd-card--doses">
                <div class="pd-card__header">
                    <div>
                        <h2 class="pd-card__title">Today's Doses</h2>
                        <p class="pd-card__subtitle">
                            <asp:Label ID="lblDoseCount" runat="server" />
                            medications today
                        </p>
                    </div>
                </div>

                <div class="pd-table-wrap">
                    <asp:GridView ID="gvDoses"
                        runat="server"
                        AutoGenerateColumns="False"
                        GridLines="None"
                        ShowHeader="False"
                        EmptyDataText="No doses found for today."
                        CssClass="pd-dose-grid"
                        DataKeyNames="DoseId">

                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <div class="pd-dose-row">

                                        <div class="pd-dose-left">
                                            <div class="pd-dose-icon">
                                                <i class="fa-solid fa-pills"></i>
                                            </div>

                                            <div class="pd-dose-main">
                                                <div class="pd-dose-name">
                                                    <%# Eval("MedicineName") %>
                                                </div>

                                                <div class="pd-dose-meta">
                                                    <span class="pd-dose-badge">
                                                        <%# Eval("Dosage") %>
                                                    </span>

                                                    <span class="pd-dose-badge pd-dose-badge--green">
                                                        <%# Eval("Instructions") %>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="pd-dose-time">
                                            <i class="fa-regular fa-clock"></i>
                                            <span><%# Eval("Time") %></span>
                                        </div>

                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <div class="pd-doses-footer">
                    <asp:Label ID="lblDoseSummary" runat="server" />
                </div>
            </div>

            <!-- DOCTORS -->
            <div class="pd-card pd-card--doctors">
                <div class="pd-card__header">
                    <h2 class="pd-card__title">My Doctors</h2>
                    <p class="pd-card__subtitle">Doctors you are connected with</p>
                </div>
                <asp:GridView ID="gvDoctors" runat="server" AutoGenerateColumns="False" ShowHeader="False"
                    CssClass="pd-doctors-grid" GridLines="None" OnRowDataBound="gvDoctors_RowDataBound">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <div class="pd-doctor-row">
                                    <div class="pd-doctor-avatar">
                                        <i class="fa-solid fa-user-doctor"></i>
                                    </div>
                                    <div class="pd-doctor-info">
                                        <div class="pd-doctor-name">
                                            <asp:HyperLink ID="hypDoctorProfile" runat="server" 
                                                NavigateUrl='<%# "~/Pages/Patient/DoctorProfile.aspx?id=" + Eval("DoctorId") %>' 
                                                Text='<%# Eval("DoctorName") %>' 
                                                style="text-decoration:none; color:inherit;">
                                            </asp:HyperLink>
                                        </div>
                                    <div class="pd-doctor-specialty"><%# Eval("Specialty") %></div>
                                    </div>
                                    <asp:Label ID="lblStatus" runat="server" CssClass="pd-doctor-status-badge"
                                        Text='<%# Eval("Status") %>' />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <div class="pd-doctors-footer">
                    <asp:HyperLink ID="lnkFindDoctors" runat="server" NavigateUrl="Search.aspx"
                        CssClass="mc-btn mc-btn--primary" Text="Connect with new doctors" />
                </div>
            </div>
        </div>

    </div>
    <div class="pd-card pd-card--appointments">
    <div class="pd-card__header">
        <h2 class="pd-card__title">My Appointments</h2>
        <p class="pd-card__subtitle">Upcoming and past bookings</p>
    </div>

    <div class="pd-table-wrap">

        <asp:GridView ID="gvAppointments"
            runat="server"
            AutoGenerateColumns="False"
            GridLines="None"
            ShowHeader="True"
            EmptyDataText="No appointments found."
            CssClass="pd-dose-grid">

            <Columns>

                <asp:BoundField DataField="DoctorName" HeaderText="Doctor" />
                <asp:BoundField DataField="AppointmentDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:BoundField DataField="Reason" HeaderText="Reason" />

            </Columns>

        </asp:GridView>

    </div>
</div>
</div>

<script>
    (function () {
        if (!('IntersectionObserver' in window)) return;
        const cards = document.querySelectorAll('.pd-card');
        cards.forEach(function (card, i) {
            var el = card;
            if (!(el instanceof HTMLElement)) return;
            el.style.opacity = '0';
            el.style.transform = 'translateY(20px)';
            el.style.transition = 'opacity .45s ease, transform .45s ease';
            el.style.transitionDelay = (i * 80) + 'ms';
        });
        const observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
                if (entry.isIntersecting) {
                    var target = entry.target;
                    if (!(target instanceof HTMLElement)) return;
                    target.style.opacity = '1';
                    target.style.transform = 'translateY(0)';
                    observer.unobserve(target);
                }
            });
        }, { threshold: 0.12 });
        cards.forEach(function (card) { observer.observe(card); });
    })();
</script>

</asp:Content>