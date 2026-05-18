<%@ Page Title="Dashboard – MediCare Doctor"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="MediCare.Pages.Doctor.Dashboard" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/DashboardDc.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="db-root">

    <!-- ═════════════ WELCOME ═════════════ -->
    <div class="db-welcome">

        <div class="db-welcome__left">
            <div class="db-welcome__icon">
                <i class="fa-solid fa-user-doctor"></i>
            </div>

            <div>
                <p class="db-welcome__greeting">
                    <asp:Label ID="lblGreeting" runat="server" />
                </p>

                <h1 class="db-welcome__name">
                    <asp:Label ID="lblDoctorName" runat="server" />
                </h1>

                <p class="db-welcome__role">
                    <i class="fa-solid fa-heart-pulse"></i>
                    <asp:Label ID="lblSpecialty" runat="server" />
                </p>
            </div>
        </div>

    </div>

    <!-- ═════════════ SCHEDULE (FIXED - NO GRIDVIEW) ═════════════ -->
    <div class="db-schedule-wrap">

        <div class="db-schedule-header">
            <h2>Daily Schedule</h2>
        </div>

        <div class="db-schedule-grid">
            <asp:PlaceHolder ID="phSchedule" runat="server" />
        </div>

    </div>

    <!-- ═════════════ UPCOMING (FIXED - NO GRIDVIEW) ═════════════ -->
    <div class="db-upcoming-wrap">

        <div class="db-upcoming-header">
            <h2>Next Appointments</h2>
        </div>

        <div class="db-upcoming-list">
            <asp:PlaceHolder ID="phUpcoming" runat="server" />
        </div>

    </div>

</div>

</asp:Content>