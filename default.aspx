<%@ Page Title="MediCare – Smart Health Tracking" Language="C#" MasterPageFile="~/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MediCare.Default" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- ══════════════════════════════════════════════════
         SECTION 1 — HERO
    ══════════════════════════════════════════════════ -->
    <section class="mc-hero" id="home">
        <div class="mc-hero__bg-blob" aria-hidden="true"></div>
        <div class="mc-hero__bg-dots" aria-hidden="true"></div>

        <div class="mc-container mc-hero__inner">

            <!-- Left: Text -->
            <div class="mc-hero__text">
                <div class="mc-hero__badge">
                    <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
                        <circle cx="7" cy="7" r="7" fill="#1A9E5C" opacity="0.15"/>
                        <circle cx="7" cy="7" r="4" fill="#1A9E5C"/>
                    </svg>
                    Trusted by 12,000+ patients worldwide
                </div>

                <h1 class="mc-hero__heading">
                    Your Health,<br />
                    <em>Tracked &amp; Managed</em><br />
                    Intelligently.
                </h1>

                <p class="mc-hero__sub">
                    MediCare helps you stay on top of medications, monitor remaining doses,
                    and connect seamlessly with your doctor — all in one secure platform.
                </p>

                <div class="mc-hero__cta-group">
                    <a href="#auth-section" class="mc-btn mc-btn--primary mc-btn--lg">
                        Start for Free
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M12 5l7 7-7 7"/></svg>
                    </a>
                    <a href="#about" class="mc-btn mc-btn--outline mc-btn--lg">Learn More</a>
                </div>

                <div class="mc-hero__trust">
                    <div class="mc-trust-avatars">
                        <div class="mc-avatar" style="background:#D1FAE5;">👩‍⚕️</div>
                        <div class="mc-avatar" style="background:#A7F3D0;">👨‍⚕️</div>
                        <div class="mc-avatar" style="background:#6EE7B7;">🧑‍⚕️</div>
                    </div>
                    <span>Join thousands of patients &amp; doctors</span>
                </div>
            </div>

            <!-- Right: Illustration Card -->
            <div class="mc-hero__visual">
                <div class="mc-hero__card mc-hero__card--main">
                    <div class="mc-hero__card-header">
                        <div class="mc-pill-icon">
                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M10.5 20H4a2 2 0 0 1-2-2V5c0-1.1.9-2 2-2h3.93a2 2 0 0 1 1.66.9l.82 1.2a2 2 0 0 0 1.66.9H20a2 2 0 0 1 2 2v3"/>
                                <circle cx="18" cy="18" r="3"/>
                                <path d="m22 22-1.5-1.5"/>
                            </svg>
                        </div>
                        <div>
                            <p class="mc-card-label">Today's Schedule</p>
                            <p class="mc-card-date">
                                <asp:Label ID="lblTodayDate" runat="server" CssClass="mc-card-date-text" />
                            </p>
                        </div>
                        <div class="mc-card-badge mc-card-badge--green">On Track</div>
                    </div>

                    <div class="mc-med-list">
                        <div class="mc-med-item mc-med-item--taken">
                            <div class="mc-med-icon mc-med-icon--blue">💊</div>
                            <div class="mc-med-info">
                                <span class="mc-med-name">Metformin 500mg</span>
                                <span class="mc-med-time">8:00 AM · Breakfast</span>
                            </div>
                            <div class="mc-med-status mc-med-status--done">✓</div>
                        </div>
                        <div class="mc-med-item mc-med-item--pending">
                            <div class="mc-med-icon mc-med-icon--orange">💊</div>
                            <div class="mc-med-info">
                                <span class="mc-med-name">Lisinopril 10mg</span>
                                <span class="mc-med-time">1:00 PM · Lunch</span>
                            </div>
                            <div class="mc-med-status mc-med-status--pending">⏱</div>
                        </div>
                        <div class="mc-med-item">
                            <div class="mc-med-icon mc-med-icon--purple">💊</div>
                            <div class="mc-med-info">
                                <span class="mc-med-name">Atorvastatin 20mg</span>
                                <span class="mc-med-time">9:00 PM · Dinner</span>
                            </div>
                            <div class="mc-med-status mc-med-status--upcoming">🌙</div>
                        </div>
                    </div>

                    <div class="mc-progress-block">
                        <div class="mc-progress-label">
                            <span>Daily Progress</span>
                            <span class="mc-progress-pct">1 / 3 doses</span>
                        </div>
                        <div class="mc-progress-bar" role="progressbar" aria-valuenow="33" aria-valuemin="0" aria-valuemax="100">
                            <div class="mc-progress-fill" style="width:33%"></div>
                        </div>
                    </div>
                </div>

                <!-- Floating badge cards -->
                <div class="mc-hero__badge-card mc-hero__badge-card--pills">
                    <span class="mc-badge-icon">💊</span>
                    <div>
                        <strong>24 pills</strong>
                        <small>remaining</small>
                    </div>
                </div>
                <div class="mc-hero__badge-card mc-hero__badge-card--doctor">
                    <span class="mc-badge-icon">🩺</span>
                    <div>
                        <strong>Dr. Hassan</strong>
                        <small>Connected</small>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ══════════════════════════════════════════════════
         SECTION 2 — STATISTICS
    ══════════════════════════════════════════════════ -->
    <section class="mc-stats" id="stats">
        <div class="mc-container">
            <div class="mc-stats__grid">

                <div class="mc-stat-card">
                    <div class="mc-stat-icon">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
                        </svg>
                    </div>
                    <div class="mc-stat-number" data-count="3400">0</div>
                    <div class="mc-stat-label">Verified Doctors</div>
                    <div class="mc-stat-sub">Across 28 specialties</div>
                </div>

                <div class="mc-stat-card mc-stat-card--featured">
                    <div class="mc-stat-icon mc-stat-icon--white">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                    </div>
                    <div class="mc-stat-number" data-count="124000">0</div>
                    <div class="mc-stat-label">Active Patients</div>
                    <div class="mc-stat-sub">Trusting our platform daily</div>
                </div>

                <div class="mc-stat-card">
                    <div class="mc-stat-icon">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18"/>
                        </svg>
                    </div>
                    <div class="mc-stat-number" data-count="890000">0</div>
                    <div class="mc-stat-label">Medications Tracked</div>
                    <div class="mc-stat-sub">Doses logged &amp; confirmed</div>
                </div>

                <div class="mc-stat-card">
                    <div class="mc-stat-icon">
                        <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                        </svg>
                    </div>
                    <div class="mc-stat-number" data-count="99">0</div>
                    <div class="mc-stat-label">% Uptime</div>
                    <div class="mc-stat-sub">Secure &amp; always available</div>
                </div>

            </div>
        </div>
    </section>

    <!-- ══════════════════════════════════════════════════
         SECTION 3 — HOW IT WORKS
    ══════════════════════════════════════════════════ -->
    <section class="mc-how" id="about">
        <div class="mc-container">
            <div class="mc-section-header">
                <span class="mc-section-tag">How It Works</span>
                <h2 class="mc-section-title">Simple steps to better<br /><em>health management</em></h2>
                <p class="mc-section-sub">MediCare brings medication tracking, doctor collaboration, and health records together in one intuitive platform.</p>
            </div>

            <div class="mc-how__steps">
                <div class="mc-step-card" data-step="01">
                    <div class="mc-step-icon">
                        <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                        </svg>
                    </div>
                    <h3>Create Your Profile</h3>
                    <p>Sign up as a patient or doctor. Enter your health information securely. Your data is encrypted and private.</p>
                </div>

                <div class="mc-step-connector">→</div>

                <div class="mc-step-card" data-step="02">
                    <div class="mc-step-icon">
                        <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                    </div>
                    <h3>Add Your Medications</h3>
                    <p>Log your prescriptions, set dosage schedules, and get smart reminders so you never miss a dose again.</p>
                </div>

                <div class="mc-step-connector">→</div>

                <div class="mc-step-card" data-step="03">
                    <div class="mc-step-icon">
                        <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
                        </svg>
                    </div>
                    <h3>Track &amp; Stay Healthy</h3>
                    <p>Monitor pill counts, view health trends, and share reports with your doctor for smarter, connected care.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ══════════════════════════════════════════════════
         SECTION 4 — FEATURES
    ══════════════════════════════════════════════════ -->
    <section class="mc-features">
        <div class="mc-container">
            <div class="mc-features__grid">
                <!-- Smart Reminders -->
                <div class="mc-feature-card">
                    <div class="mc-feature-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    </div>
                    <h4>Smart Reminders</h4>
                    <p>Never miss a dose. Get timely alerts for every medication on your schedule.</p>
                </div>

                <!-- Pill Inventory -->
                <div class="mc-feature-card">
                    <div class="mc-feature-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m10.5 20.5 10-10a4.95 4.95 0 1 0-7-7l-10 10a4.95 4.95 0 1 0 7 7Z"/><path d="m8.5 8.5 7 7"/></svg>
                    </div>
                    <h4>Pill Inventory</h4>
                    <p>Track remaining pills automatically and get refill alerts before you run out.</p>
                </div>

                <!-- Doctor Connect -->
                <div class="mc-feature-card">
                    <div class="mc-feature-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/></svg>
                    </div>
                    <h4>Doctor Connect</h4>
                    <p>Share health data with your doctor securely. Better information, better care.</p>
                </div>

                <!-- Private & Secure -->
                <div class="mc-feature-card">
                    <div class="mc-feature-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    </div>
                    <h4>Private &amp; Secure</h4>
                    <p>Your medical data is encrypted end-to-end. Full HIPAA-aligned privacy controls.</p>
                </div>

                <!-- Health Records -->
                <div class="mc-feature-card">
                    <div class="mc-feature-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/></svg>
                    </div>
                    <h4>Health Records</h4>
                    <p>Store chronic diseases, family history, and vitals in one organized place.</p>
                </div>

                <!-- Any Device -->
                <div class="mc-feature-card">
                    <div class="mc-feature-icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="20" height="14" x="2" y="3" rx="2"/><line x1="8" x2="16" y1="21" y2="21"/><line x1="12" x2="12" y1="17" y2="21"/></svg>
                    </div>
                    <h4>Any Device</h4>
                    <p>Access your health dashboard from desktop, tablet, or mobile — anywhere.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ══════════════════════════════════════════════════
         SECTION 5 — PORTAL SELECTION + FORMS
    ══════════════════════════════════════════════════ -->
    <section class="mc-auth" id="auth-section">
        <div class="mc-container">
            <div class="mc-section-header">
                <span class="mc-section-tag">Get Started Today</span>
                <h2 class="mc-section-title">Choose your portal to<br /><em>begin your journey</em></h2>
                <p class="mc-section-sub">Whether you're a patient managing health or a doctor connecting with patients, we have the right tools for you.</p>
            </div>

            <!-- Portal Selector Tabs -->
            <div class="mc-portal-tabs" role="tablist">

                <button type="button"
                    class="mc-portal-tab mc-portal-tab--active"
                    id="tabPatient"
                    role="tab"
                    aria-selected="true"
                    aria-controls="panelPatient"
                    data-target="patient">

                    <div class="mc-portal-tab__icon">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                            <circle cx="12" cy="7" r="4"/>
                        </svg>
                    </div>

                    <div>
                        <strong>Patient Portal</strong>
                        <small>Manage your medications &amp; health</small>
                    </div>

                </button>

                <button type="button"
                    class="mc-portal-tab"
                    id="tabDoctor"
                    role="tab"
                    aria-selected="false"
                    aria-controls="panelDoctor"
                    data-target="doctor">

                    <div class="mc-portal-tab__icon">
                        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
                        </svg>
                    </div>

                    <div>
                        <strong>Doctor Portal</strong>
                        <small>Connect with patients &amp; manage care</small>
                    </div>

                </button>

            </div>

            <!-- ═══════════════════════════════════════
                 PATIENT SIGN UP FORM
            ═══════════════════════════════════════ -->
            <div class="mc-form-panel" id="panelPatient" role="tabpanel" aria-labelledby="tabPatient">
                <div class="mc-form-card">
                    <div class="mc-form-card__header">
                        <div class="mc-form-avatar mc-form-avatar--green">
                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>
                        <div>
                            <h3>Patient Registration</h3>
                            <p>Create your free health profile today</p>
                        </div>
                    </div>

                    <asp:Panel ID="pnlPatientForm" runat="server" CssClass="mc-form">

                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Full Name <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtPatientName" runat="server" CssClass="mc-input" placeholder="e.g. Sara Al-Khalil" />
                                <asp:RequiredFieldValidator ID="rfvPatientName" runat="server" ControlToValidate="txtPatientName"
                                    ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Full name is required." Display="Dynamic" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Email Address <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtPatientEmail" runat="server" CssClass="mc-input" TextMode="Email" placeholder="you@example.com" />
                                <asp:RequiredFieldValidator ID="rfvPatientEmail" runat="server" ControlToValidate="txtPatientEmail"
                                    ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Email is required." Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revPatientEmail" runat="server" ControlToValidate="txtPatientEmail"
                                    ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Please enter a valid email."
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" />
                            </div>
                        </div>

                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Password <span class="mc-required">*</span></label>
                                <div class="mc-input-wrap">
                                    <asp:TextBox ID="txtPatientPassword" runat="server" CssClass="mc-input" TextMode="Password" placeholder="Min 8 characters" />
                                    <button type="button" class="mc-eye-btn" data-target="<%= txtPatientPassword.ClientID %>">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                    </button>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvPatientPwd" runat="server" ControlToValidate="txtPatientPassword"
                                    ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Password is required." Display="Dynamic" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Confirm Password <span class="mc-required">*</span></label>
                                <div class="mc-input-wrap">
                                    <asp:TextBox ID="txtPatientConfirmPwd" runat="server" CssClass="mc-input" TextMode="Password" placeholder="Re-enter password" />
                                    <button type="button" class="mc-eye-btn" data-target="<%= txtPatientConfirmPwd.ClientID %>">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                    </button>
                                </div>
                                <asp:CompareValidator ID="cvPatientPwd" runat="server"
                                    ControlToValidate="txtPatientConfirmPwd" ControlToCompare="txtPatientPassword"
                                    ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Passwords do not match." Display="Dynamic" />
                            </div>
                        </div>

                        <div class="mc-form__row mc-form__row--thirds">
                            <div class="mc-form__group">
                                <label class="mc-label">Age <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtPatientAge" runat="server" CssClass="mc-input" TextMode="Number" placeholder="25" />
                                <asp:RequiredFieldValidator ID="rfvPatientAge" runat="server" ControlToValidate="txtPatientAge"
                                    ValidationGroup="PatientGroup" CssClass="mc-error" ErrorMessage="Age is required." Display="Dynamic" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Height (cm)</label>
                                <asp:TextBox ID="txtPatientHeight" runat="server" CssClass="mc-input" TextMode="Number" placeholder="170" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Weight (kg)</label>
                                <asp:TextBox ID="txtPatientWeight" runat="server" CssClass="mc-input" TextMode="Number" placeholder="70" />
                            </div>
                        </div>

                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Phone Number</label>
                                <asp:TextBox ID="txtPatientPhone" runat="server" CssClass="mc-input" TextMode="Phone" placeholder="+961 71 123 456" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Disability (if any)</label>
                                <asp:TextBox ID="txtDisability" runat="server" CssClass="mc-input" placeholder="e.g. Visual impairment, None" />
                            </div>
                        </div>

                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Chronic Disease (if any)</label>
                                <asp:TextBox ID="txtChronicDisease" runat="server" CssClass="mc-input" placeholder="e.g. Diabetes Type 2, None" />
                            </div>
                        </div>

                        <div class="mc-form__group mc-form__group--full">
                            <label class="mc-label">Family Disease History</label>
                            <asp:TextBox ID="txtFamilyHistory" runat="server" CssClass="mc-input mc-textarea" TextMode="MultiLine" Rows="3"
                                placeholder="e.g. Father: Heart disease, Mother: Diabetes. Enter None if not applicable." />
                        </div>

                        <div class="mc-form__footer">
                            <p class="mc-form__terms">By signing up, you agree to our <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>.</p>
                            <asp:Button ID="btnPatientSignUp" runat="server" Text="Create Patient Account"
                                CssClass="mc-btn mc-btn--primary mc-btn--lg mc-btn--submit"
                                ValidationGroup="PatientGroup"
                                OnClick="btnPatientSignUp_Click"/>
                        </div>

                        <asp:Label ID="lblPatientMessage" runat="server" CssClass="mc-form__message" Visible="false" />

                        <div class="mc-form__signin-link">
                            Already have an account? <a href="Pages/Account/Login.aspx">Sign in instead</a>
                        </div>

                    </asp:Panel>
                </div>
            </div>

            <!-- ═══════════════════════════════════════
                 DOCTOR SIGN UP FORM
            ═══════════════════════════════════════ -->
            <div class="mc-form-panel mc-form-panel--hidden" id="panelDoctor" role="tabpanel" aria-labelledby="tabDoctor">
                <div class="mc-form-card">
                    <div class="mc-form-card__header">
                        <div class="mc-form-avatar mc-form-avatar--teal">
                            <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
                            </svg>
                        </div>
                        <div>
                            <h3>Doctor Registration</h3>
                            <p>Join our network of verified healthcare professionals</p>
                        </div>
                    </div>

                    <asp:Panel ID="pnlDoctorForm" runat="server" CssClass="mc-form">

                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Full Name <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtDoctorName" runat="server" CssClass="mc-input" placeholder="Dr. Ahmad Karimi" />
                                <asp:RequiredFieldValidator ID="rfvDoctorName" runat="server" ControlToValidate="txtDoctorName"
                                    ValidationGroup="DoctorGroup" CssClass="mc-error" ErrorMessage="Full name is required." Display="Dynamic" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Email Address <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtDoctorEmail" runat="server" CssClass="mc-input" TextMode="Email" placeholder="doctor@hospital.com" />
                                <asp:RequiredFieldValidator ID="rfvDoctorEmail" runat="server" ControlToValidate="txtDoctorEmail"
                                    ValidationGroup="DoctorGroup" CssClass="mc-error" ErrorMessage="Email is required." Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revDoctorEmail" runat="server" ControlToValidate="txtDoctorEmail"
                                    ValidationGroup="DoctorGroup" CssClass="mc-error" ErrorMessage="Please enter a valid email."
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic" />
                            </div>
                        </div>

                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Password <span class="mc-required">*</span></label>
                                <div class="mc-input-wrap">
                                    <asp:TextBox ID="txtDoctorPassword" runat="server" CssClass="mc-input" TextMode="Password" placeholder="Min 8 characters" />
                                    <button type="button" class="mc-eye-btn" data-target="<%= txtDoctorPassword.ClientID %>">
                                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                    </button>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvDoctorPwd" runat="server" ControlToValidate="txtDoctorPassword"
                                    ValidationGroup="DoctorGroup" CssClass="mc-error" ErrorMessage="Password is required." Display="Dynamic" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Age <span class="mc-required">*</span></label>
                                <asp:TextBox ID="txtDoctorAge" runat="server" CssClass="mc-input" TextMode="Number" placeholder="35" />
                                <asp:RequiredFieldValidator ID="rfvDoctorAge" runat="server" ControlToValidate="txtDoctorAge"
                                    ValidationGroup="DoctorGroup" CssClass="mc-error" ErrorMessage="Age is required." Display="Dynamic" />
                            </div>
                        </div>

                        <div class="mc-form__row">
                            <div class="mc-form__group">
                                <label class="mc-label">Phone Number</label>
                                <asp:TextBox ID="txtDoctorPhone" runat="server" CssClass="mc-input" TextMode="Phone" placeholder="+961 71 123 456" />
                            </div>
                            <div class="mc-form__group">
                                <label class="mc-label">Speciality</label>
                                <asp:TextBox ID="txtDoctorSpeciality" runat="server" CssClass="mc-input" placeholder="e.g. Cardiology, General Practice" />
                            </div>
                        </div>

                        <div class="mc-form__group mc-form__group--full">
                            <label class="mc-label">Clinic Address</label>
                            <asp:TextBox ID="txtDoctorClinicAddress" runat="server" CssClass="mc-input" placeholder="e.g. 14 Hamra St, Beirut" />
                        </div>

                        <div class="mc-form__group mc-form__group--full">
                            <label class="mc-label">Certificate <span class="mc-required">*</span></label>
                            <div class="mc-upload-zone" id="uploadZone" role="button" tabindex="0">
                                <div class="mc-upload-icon">
                                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                        <polyline points="17 8 12 3 7 8"/>
                                        <line x1="12" y1="3" x2="12" y2="15"/>
                                    </svg>
                                </div>
                                <p class="mc-upload-text"><strong>Click to upload</strong> or drag and drop</p>
                                <p class="mc-upload-hint">PDF, JPG, PNG up to 10MB — Medical license or board certification</p>
                                <asp:FileUpload ID="fuDoctorCertificate" runat="server" CssClass="mc-file-input" accept=".pdf,.jpg,.jpeg,.png" />
                            </div>
                            <div class="mc-upload-preview" id="uploadPreview" style="display:none;">
                                <span class="mc-upload-preview__icon">📄</span>
                                <span class="mc-upload-preview__name" id="uploadFileName"></span>
                                <button type="button" class="mc-upload-preview__remove" id="btnRemoveFile">×</button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvCertificate" runat="server" ControlToValidate="fuDoctorCertificate"
                                ValidationGroup="DoctorGroup" CssClass="mc-error" ErrorMessage="Please upload your medical certificate." Display="Dynamic" />
                        </div>

                        <div class="mc-form__footer">
                            <p class="mc-form__terms">By registering, you confirm all information is accurate and agree to our <a href="#">Terms of Service</a>.</p>
                            <asp:Button ID="btnDoctorSignUp" runat="server" Text="Apply as Doctor"
                                CssClass="mc-btn mc-btn--primary mc-btn--lg mc-btn--submit"
                                ValidationGroup="DoctorGroup"
                                OnClick="btnDoctorSignUp_Click" />
                        </div>

                        <asp:Label ID="lblDoctorMessage" runat="server" CssClass="mc-form__message" Visible="false" />

                        <div class="mc-form__signin-link">
                            Already have an account? <a href="Pages/Account/Login.aspx">Sign in instead</a>
                        </div>

                    </asp:Panel>
                </div>
            </div>

        </div>
    </section>

    <!-- ══════════════════════════════════════════════════
         SECTION 6 — TESTIMONIALS
    ══════════════════════════════════════════════════ -->
    <section class="mc-testimonials">
        <div class="mc-container">
            <div class="mc-section-header">
                <span class="mc-section-tag">Patient Stories</span>
                <h2 class="mc-section-title">Trusted by real<br /><em>patients &amp; doctors</em></h2>
            </div>
            <div class="mc-testimonials__grid">
                <div class="mc-testimonial-card">
                    <div class="mc-testimonial__stars">★★★★★</div>
                    <p>"MediCare changed how I manage my diabetes medications. I never miss a dose and my doctor can see my progress in real time."</p>
                    <div class="mc-testimonial__author">
                        <div class="mc-author-avatar" style="background:#D1FAE5;">👩</div>
                        <div>
                            <strong>Lara Mansour</strong>
                            <small>Patient · Beirut</small>
                        </div>
                    </div>
                </div>
                <div class="mc-testimonial-card mc-testimonial-card--featured">
                    <div class="mc-testimonial__stars">★★★★★</div>
                    <p>"As a cardiologist, MediCare lets me monitor adherence for all my patients in one dashboard. It's the tool I've always needed."</p>
                    <div class="mc-testimonial__author">
                        <div class="mc-author-avatar" style="background:#A7F3D0;">👨‍⚕️</div>
                        <div>
                            <strong>Dr. Halim Kouchaji</strong>
                            <small>Cardiologist · Riyadh</small>
                        </div>
                    </div>
                </div>
                <div class="mc-testimonial-card">
                    <div class="mc-testimonial__stars">★★★★★</div>
                    <p>"The pill count tracker is a lifesaver. I get refill alerts before I run out. Simple, clean, and exactly what I needed."</p>
                    <div class="mc-testimonial__author">
                        <div class="mc-author-avatar" style="background:#6EE7B7;">🧑</div>
                        <div>
                            <strong>Omar Khalil</strong>
                            <small>Patient · Dubai</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ══════════════════════════════════════════════════
         SECTION 7 — CTA BANNER
    ══════════════════════════════════════════════════ -->
    <section class="mc-cta-banner">
        <div class="mc-container">
            <div class="mc-cta-banner__inner">
                <div class="mc-cta-banner__text">
                    <h2>Ready to take control<br />of your health?</h2>
                    <p>Join over 124,000 patients and 3,400 doctors already using MediCare.</p>
                </div>
                <div class="mc-cta-banner__actions">
                    <a href="#auth-section" class="mc-btn mc-btn--white mc-btn--lg">Start Free Today</a>
                    <a href="#about" class="mc-btn mc-btn--outline-white mc-btn--lg">See How It Works</a>
                </div>
            </div>
        </div>
    </section>

</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>
