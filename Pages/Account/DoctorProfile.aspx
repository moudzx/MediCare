<%@ Page Title="Doctor Profile" Language="C#" MasterPageFile="~/MasterPage/DoctorSite.Master" AutoEventWireup="true" CodeBehind="DoctorProfile.aspx.cs" Inherits="MediCare.Pages.Account.DoctorProfile" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/DoctorProfile.css" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- ═══════════════════════════════════════════════════
         DOCTOR PROFILE ROOTaddaasda
         Plain HTML throughout — no runat=server inputs.
         DB integration points are marked in DoctorProfile.js
         ═══════════════════════════════════════════════════ --%>
    <div class="dp-root" id="dpRoot">

        <%-- ── PROFILE BANNER ───────────────────────────── --%>
        <div class="dp-banner">
            <div class="dp-banner__bg"></div>
            <div class="dp-banner__content">

                <%-- Avatar --%>
                <div class="dp-avatar-wrap">
                    <div class="dp-avatar" id="dpAvatar">
                        <span class="dp-avatar__initials" id="dpInitials">--</span>
                    </div>
                    <div class="dp-avatar__availability" id="dpAvailabilityDot" title="Available"></div>
                </div>

                <%-- Info --%>
                <div class="dp-banner__info">
                    <div class="dp-banner__specialty-tag" id="dpSpecialtyTag">
                        <i class="fas fa-stethoscope"></i> <span id="dpSpecialty">--</span>
                    </div>
                    <h1 class="dp-banner__name" id="dpFullName">Loading…</h1>
                    <div class="dp-banner__meta">
                        <span class="dp-meta-chip" id="dpExperience"><i class="fas fa-award"></i> -- yrs experience</span>
                        <span class="dp-meta-chip" id="dpDept"><i class="fas fa-hospital"></i> --</span>
                        <span class="dp-meta-chip" id="dpLicense"><i class="fas fa-id-badge"></i> --</span>
                    </div>
                </div>

                <%-- Actions --%>
                <div class="dp-banner__actions">
                    <button type="button" class="dp-btn dp-btn--outline" id="btnDpEdit" onclick="toggleDpEdit()">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                    <button type="button" class="dp-btn dp-btn--primary" id="btnDpSave" style="display:none;" onclick="saveDpProfile()">
                        <i class="fas fa-save"></i> Save
                    </button>
                    <button type="button" class="dp-btn dp-btn--ghost" id="btnDpCancel" style="display:none;" onclick="cancelDpEdit()">
                        Cancel
                    </button>
                </div>
            </div>

            <%-- Quick stat bar inside banner --%>
            <div class="dp-banner__stats">
                <div class="dp-bstat">
                    <span class="dp-bstat__num" id="dpStatPatients">0</span>
                    <span class="dp-bstat__label">Total Patients</span>
                </div>
                <div class="dp-bstat__divider"></div>
                <div class="dp-bstat">
                    <span class="dp-bstat__num" id="dpStatAppts">0</span>
                    <span class="dp-bstat__label">Appointments</span>
                </div>
                <div class="dp-bstat__divider"></div>
                <div class="dp-bstat">
                    <span class="dp-bstat__num" id="dpStatRating">0</span>
                    <span class="dp-bstat__label">Rating</span>
                </div>
                <div class="dp-bstat__divider"></div>
                <div class="dp-bstat">
                    <span class="dp-bstat__num" id="dpStatYears">0</span>
                    <span class="dp-bstat__label">Years Active</span>
                </div>
            </div>
        </div>

        <%-- ── MAIN LAYOUT ───────────────────────────────── --%>
        <div class="dp-layout">

            <%-- LEFT SIDEBAR --%>
            <aside class="dp-sidebar">

                <%-- Contact card --%>
                <div class="dp-card dp-card--contact">
                    <div class="dp-card__header">
                        <i class="fas fa-address-card"></i>
                        <h3>Contact Details</h3>
                    </div>
                    <div class="dp-card__body">
                        <div class="dp-info-row dp-info-row--highlight">
                            <i class="fas fa-phone-alt"></i>
                            <div>
                                <span class="dp-info-row__label">Phone Number</span>
                                <span class="dp-info-row__value" id="dpPhone">--</span>
                            </div>
                        </div>
                        <div class="dp-info-row">
                            <i class="fas fa-envelope"></i>
                            <div>
                                <span class="dp-info-row__label">Email Address</span>
                                <span class="dp-info-row__value" id="dpEmail">--</span>
                            </div>
                        </div>
                        <div class="dp-info-row">
                            <i class="fas fa-building"></i>
                            <div>
                                <span class="dp-info-row__label">Office / Room</span>
                                <span class="dp-info-row__value" id="dpOffice">--</span>
                            </div>
                        </div>
                        <div class="dp-info-row">
                            <i class="fas fa-hospital-alt"></i>
                            <div>
                                <span class="dp-info-row__label">Hospital</span>
                                <span class="dp-info-row__value" id="dpHospital">--</span>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- Availability / Working Hours --%>
                <div class="dp-card">
                    <div class="dp-card__header dp-card__header--green">
                        <i class="fas fa-clock"></i>
                        <h3>Working Hours</h3>
                    </div>
                    <div class="dp-card__body">
                        <div class="dp-availability-badge" id="dpAvailBadge">
                            <i class="fas fa-circle"></i> Available Now
                        </div>
                        <div class="dp-hours-list" id="dpHoursList">
                            <%-- Populated by JS --%>
                        </div>
                    </div>
                </div>

                <%-- Specialisations tags --%>
                <div class="dp-card">
                    <div class="dp-card__header">
                        <i class="fas fa-tags"></i>
                        <h3>Specialisations</h3>
                    </div>
                    <div class="dp-card__body">
                        <div class="dp-tags" id="dpSpecTags">
                            <%-- Populated by JS --%>
                        </div>
                    </div>
                </div>

            </aside>

            <%-- MAIN CONTENT --%>
            <main class="dp-main">

                <%-- About / Bio --%>
                <div class="dp-card">
                    <div class="dp-card__header">
                        <i class="fas fa-user-md"></i>
                        <h3>About Dr. <span id="dpShortName">--</span></h3>
                    </div>
                    <div class="dp-card__body">
                        <p class="dp-bio" id="dpBio">--</p>
                    </div>
                </div>

                <%-- Professional Details --%>
                <div class="dp-card">
                    <div class="dp-card__header">
                        <i class="fas fa-briefcase-medical"></i>
                        <h3>Professional Details</h3>
                    </div>
                    <div class="dp-card__body">
                        <div class="dp-info-grid" id="dpProfGrid">
                            <%-- Populated by JS --%>
                        </div>
                    </div>
                </div>

                <%-- Education & Certifications --%>
                <div class="dp-card">
                    <div class="dp-card__header dp-card__header--blue">
                        <i class="fas fa-graduation-cap"></i>
                        <h3>Education &amp; Certifications</h3>
                    </div>
                    <div class="dp-card__body">
                        <div class="dp-edu-list" id="dpEduList">
                            <%-- Populated by JS --%>
                        </div>
                    </div>
                </div>

                <%-- Recent Patients --%>
                <div class="dp-card">
                    <div class="dp-card__header">
                        <i class="fas fa-users"></i>
                        <h3>Recent Patients</h3>
                    </div>
                    <div class="dp-card__body">
                        <div class="dp-patient-list" id="dpPatientList">
                            <%-- Populated by JS --%>
                        </div>
                    </div>
                </div>

            </main>
        </div><%-- end dp-layout --%>

    </div><%-- end dp-root --%>

    <%-- Toast --%>
    <div class="dp-toast" id="dpToast">
        <i class="fas fa-check-circle"></i>
        <span id="dpToastMsg">Action completed.</span>
    </div>

    <script src="/js/DoctorProfile.js"></script>
</asp:Content>