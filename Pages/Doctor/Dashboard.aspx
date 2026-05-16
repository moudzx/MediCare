<%@ Page Title="Dashboard – MediCare Doctor" Language="C#" MasterPageFile="~/MasterPage/DoctorSite.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="MediCare.Pages.Doctor.Dashboard" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/DashboardDc.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<!-- ═══════════════════════════════════════════════════════════
     DOCTOR DASHBOARD ROOT
═══════════════════════════════════════════════════════════ -->
<div class="db-root">

    <!-- ══════════════════════════════════════════
         WELCOME BANNER
    ══════════════════════════════════════════ -->
    <div class="db-welcome">
        <div class="db-welcome__left">
            <div class="db-welcome__icon" aria-hidden="true">
                <i class="fa-solid fa-user-doctor"></i>
            </div>
            <div>
                <p class="db-welcome__greeting" id="welcomeGreeting">Good morning,</p>
                <h1 class="db-welcome__name">Dr. Ahmad Karimi</h1>
                <p class="db-welcome__role">
                    <i class="fa-solid fa-heart-pulse" aria-hidden="true"></i>
                    Cardiologist &nbsp;·&nbsp;
                    <span id="welcomeDate"></span>
                </p>
            </div>
        </div>
        <div class="db-welcome__right">
            <div class="db-welcome__weather">
                <i class="fa-solid fa-sun" aria-hidden="true"></i>
                <div>
                    <span class="db-welcome__weather-city">Beirut, Lebanon</span>
                    <span class="db-welcome__weather-note">Have a great shift!</span>
                </div>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════
         STATISTICS CARDS
    ══════════════════════════════════════════ -->
    <div class="db-stats-grid">

        <div class="db-stat-card db-stat-card--green">
            <div class="db-stat-card__icon">
                <i class="fa-solid fa-users" aria-hidden="true"></i>
            </div>
            <div class="db-stat-card__body">
                <span class="db-stat-card__num" id="statPatients">0</span>
                <span class="db-stat-card__label">Patients Today</span>
            </div>
            <div class="db-stat-card__trend db-stat-card__trend--up">
                <i class="fa-solid fa-arrow-trend-up"></i> +2 vs yesterday
            </div>
        </div>

        <div class="db-stat-card db-stat-card--blue">
            <div class="db-stat-card__icon">
                <i class="fa-solid fa-clock" aria-hidden="true"></i>
            </div>
            <div class="db-stat-card__body">
                <span class="db-stat-card__num" id="statBooked">0</span>
                <span class="db-stat-card__label">Booked Hours</span>
            </div>
            <div class="db-stat-card__trend db-stat-card__trend--up">
                <i class="fa-solid fa-clock"></i> of 8 working hrs
            </div>
        </div>

        <div class="db-stat-card db-stat-card--teal">
            <div class="db-stat-card__icon">
                <i class="fa-solid fa-calendar-check" aria-hidden="true"></i>
            </div>
            <div class="db-stat-card__body">
                <span class="db-stat-card__num" id="statAvailable">0</span>
                <span class="db-stat-card__label">Available Hours</span>
            </div>
            <div class="db-stat-card__trend db-stat-card__trend--neutral">
                <i class="fa-solid fa-circle-check"></i> Open for booking
            </div>
        </div>

        <div class="db-stat-card db-stat-card--orange">
            <div class="db-stat-card__icon">
                <i class="fa-solid fa-star-of-life" aria-hidden="true"></i>
            </div>
            <div class="db-stat-card__body">
                <span class="db-stat-card__num" id="statCompleted">0</span>
                <span class="db-stat-card__label">Completed</span>
            </div>
            <div class="db-stat-card__trend db-stat-card__trend--up">
                <i class="fa-solid fa-check-double"></i> Done this week
            </div>
        </div>

    </div>

    <!-- ══════════════════════════════════════════
         SCHEDULE SECTION
    ══════════════════════════════════════════ -->
    <div class="db-schedule-wrap">

        <!-- Schedule header -->
        <div class="db-schedule-header">
            <div class="db-schedule-header__left">
                <div class="db-schedule-header__icon" aria-hidden="true">
                    <i class="fa-solid fa-calendar-days"></i>
                </div>
                <div>
                    <h2 class="db-schedule-header__title">Daily Schedule</h2>
                    <p class="db-schedule-header__sub" id="scheduleSubtitle">Loading...</p>
                </div>
            </div>
            <div class="db-schedule-header__actions">
                <!-- Day navigation -->
                <button class="db-nav-btn" id="btnPrevDay" onclick="goToDay(-1)" aria-label="Previous day">
                    <i class="fa-solid fa-chevron-left"></i>
                    Previous
                </button>
                <div class="db-date-pill" id="datePill">
                    <i class="fa-solid fa-calendar" aria-hidden="true"></i>
                    <span id="datePillText">Today</span>
                </div>
                <button class="db-nav-btn db-nav-btn--primary" id="btnNextDay" onclick="goToDay(1)" aria-label="Next day">
                    Next
                    <i class="fa-solid fa-chevron-right"></i>
                </button>
            </div>
        </div>

        <!-- Legend -->
        <div class="db-legend">
            <div class="db-legend-item">
                <span class="db-legend-dot db-legend-dot--booked"></span> Booked
            </div>
            <div class="db-legend-item">
                <span class="db-legend-dot db-legend-dot--free"></span> Available
            </div>
            <div class="db-legend-item">
                <span class="db-legend-dot db-legend-dot--break"></span> Break
            </div>
            <div class="db-legend-item">
                <span class="db-legend-dot db-legend-dot--done"></span> Completed
            </div>
        </div>

        <!-- Daily schedule grid -->
        <div class="db-schedule-grid" id="scheduleGrid" role="grid" aria-label="Daily appointments">
            <!-- Filled by JavaScript -->
            <div class="db-schedule-loading" id="scheduleLoading">
                <i class="fa-solid fa-spinner fa-spin" aria-hidden="true"></i>
                Loading schedule...
            </div>
        </div>

        <!-- Schedule footer summary -->
        <div class="db-schedule-footer">
            <div class="db-schedule-footer__summary" id="scheduleSummary">
                <!-- Filled by JavaScript -->
            </div>
            <button class="db-btn-today" onclick="goToToday()" id="btnToday">
                <i class="fa-solid fa-rotate-left" aria-hidden="true"></i>
                Jump to Today
            </button>
        </div>

    </div>

    <!-- ══════════════════════════════════════════
         UPCOMING APPOINTMENTS MINI LIST
    ══════════════════════════════════════════ -->
    <div class="db-upcoming-wrap">

        <div class="db-upcoming-header">
            <div class="db-upcoming-title">
                <i class="fa-solid fa-clock-rotate-left" aria-hidden="true"></i>
                Next Appointments
            </div>
            <a href="/Pages/Doctor/Appointments.aspx" class="db-see-all">
                See all <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>

        <div class="db-upcoming-list" id="upcomingList">
            <!-- Filled by JavaScript -->
        </div>

    </div>

</div>

</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="ScriptContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <script src="/js/DashboardDc.js"></script>
</asp:Content>