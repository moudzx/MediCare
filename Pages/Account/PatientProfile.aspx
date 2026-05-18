<%@ Page Title="Patient Profile"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="PatientProfile.aspx.cs"
    Inherits="MediCare.Pages.Account.PatientProfile" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <%-- Link the ProfilePatient stylesheet --%>
    <link rel="stylesheet" href="/css/ProfilePatient.css" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- ═══════════════════════════════════════════════════════════
         PATIENT PROFILE PAGE ROOT
         All inputs are plain HTML — no runat=server on controls —
         because this page is 100% client-side (JS-driven).
         DB / code-behind integration points are marked in
         ProfilePatient.js with  *** DB HOOK ***  comments.
         ═══════════════════════════════════════════════════════════ --%>
    <div class="prp-root">

        <%-- ── BANNER / HEADER ──────────────────────────────────── --%>
        <div class="prp-banner">
            <div class="prp-banner__overlay"></div>

            <div class="prp-banner__body">

                <%-- Avatar ring --%>
                <div class="prp-avatar-ring">
                    <div class="prp-avatar" id="prpAvatar">
                        <span class="prp-avatar__initials" id="prpInitials">--</span>
                    </div>
                    <span class="prp-online-dot" title="Online"></span>
                </div>

                <%-- Name + role --%>
                <div class="prp-banner__info">
                    <h1 class="prp-banner__name" id="prpDisplayName">Loading…</h1>
                    <span class="prp-banner__role">
                        <i class="fas fa-user-circle"></i> Patient
                    </span>
                </div>

                <%-- Header action buttons --%>
                <div class="prp-banner__actions">
                    <button type="button" class="prp-btn prp-btn--outline"
                        id="btnEdit" onclick="enterEditMode()">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                    <button type="button" class="prp-btn prp-btn--primary"
                        id="btnSave" style="display:none;" onclick="saveProfile()">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
                    <button type="button" class="prp-btn prp-btn--ghost"
                        id="btnCancel" style="display:none;" onclick="cancelEdit()">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </div>
        </div>
        <%-- end banner --%>

        <%-- ── PROFILE BODY ───────────────────────────────────────── --%>
        <div class="prp-body">

            <%-- ── LEFT COLUMN — Avatar card + quick stats ───────── --%>
            <div class="prp-col prp-col--left">

                <%-- Profile card --%>
                <div class="prp-card prp-card--profile">
                    <div class="prp-card__avatar-area">
                        <div class="prp-avatar prp-avatar--lg" id="prpAvatarCard">
                            <span class="prp-avatar__initials" id="prpInitialsCard">--</span>
                        </div>
                        <h2 class="prp-card__name" id="prpCardName">--</h2>
                        <span class="prp-card__tag">
                            <i class="fas fa-shield-alt"></i> Verified Patient
                        </span>
                    </div>

                    <div class="prp-card__divider"></div>

                    <%-- Quick info pills --%>
                    <div class="prp-quick-info">
                        <div class="prp-quick-pill">
                            <i class="fas fa-id-card"></i>
                            <div>
                                <span class="prp-quick-pill__label">Patient ID</span>
                                <span class="prp-quick-pill__val" id="prpPatientId">--</span>
                            </div>
                        </div>
                        <div class="prp-quick-pill">
                            <i class="fas fa-calendar-alt"></i>
                            <div>
                                <span class="prp-quick-pill__label">Member Since</span>
                                <span class="prp-quick-pill__val" id="prpMemberSince">--</span>
                            </div>
                        </div>
                        <div class="prp-quick-pill">
                            <i class="fas fa-map-marker-alt"></i>
                            <div>
                                <span class="prp-quick-pill__label">Location</span>
                                <span class="prp-quick-pill__val" id="prpLocation">--</span>
                            </div>
                        </div>
                    </div>
                </div>
                <%-- end profile card --%>

            </div>
            <%-- end left column --%>

            <%-- ── RIGHT COLUMN — Info cards ─────────────────────── --%>
            <div class="prp-col prp-col--right">

                <%-- ── Account Information card ──────────────────── --%>
                <div class="prp-card">
                    <div class="prp-card__header">
                        <div class="prp-card__header-icon prp-card__header-icon--blue">
                            <i class="fas fa-user"></i>
                        </div>
                        <div>
                            <h3 class="prp-card__title">Account Information</h3>
                            <p class="prp-card__sub">Your login and identity details</p>
                        </div>
                    </div>

                    <div class="prp-card__body">

                        <%-- Username field --%>
                        <div class="prp-field" id="fieldUsername">
                            <label class="prp-field__label">
                                <i class="fas fa-at"></i> Username
                            </label>
                            <%-- VIEW mode --%>
                            <div class="prp-field__view" id="viewUsername">
                                <span class="prp-field__value" id="prpUsername">--</span>
                            </div>
                            <%-- EDIT mode — hidden until edit button clicked --%>
                            <div class="prp-field__edit" id="editUsername" style="display:none;">
                                <input type="text" id="inputUsername" class="prp-input"
                                    placeholder="Enter username" autocomplete="off" />
                                <span class="prp-field__hint">3–20 characters, no spaces</span>
                            </div>
                        </div>

                        <%-- Email field --%>
                        <div class="prp-field" id="fieldEmail">
                            <label class="prp-field__label">
                                <i class="fas fa-envelope"></i> Email Address
                            </label>
                            <div class="prp-field__view" id="viewEmail">
                                <span class="prp-field__value" id="prpEmail">--</span>
                                <span class="prp-verified-badge">
                                    <i class="fas fa-check-circle"></i> Verified
                                </span>
                            </div>
                            <div class="prp-field__edit" id="editEmail" style="display:none;">
                                <input type="email" id="inputEmail" class="prp-input"
                                    placeholder="Enter email address" autocomplete="off" />
                            </div>
                        </div>

                    </div>
                </div>
                <%-- end account card --%>

                <%-- ── Contact Information card ───────────────────── --%>
                <div class="prp-card prp-card--contact">
                    <div class="prp-card__header">
                        <div class="prp-card__header-icon prp-card__header-icon--green">
                            <i class="fas fa-phone-alt"></i>
                        </div>
                        <div>
                            <h3 class="prp-card__title">Contact Information</h3>
                            <p class="prp-card__sub">How we reach you in case of emergency</p>
                        </div>
                    </div>

                    <div class="prp-card__body">

                        <%-- Phone Number — required, displayed prominently --%>
                        <div class="prp-field prp-field--highlight" id="fieldPhone">
                            <label class="prp-field__label">
                                <i class="fas fa-mobile-alt"></i> Phone Number
                                <span class="prp-required-dot" title="Required">*</span>
                            </label>
                            <div class="prp-field__view" id="viewPhone">
                                <span class="prp-field__value prp-field__value--phone" id="prpPhone">--</span>
                            </div>
                            <div class="prp-field__edit" id="editPhone" style="display:none;">
                                <div class="prp-phone-wrap">
                                    <select id="inputPhoneCode" class="prp-select">
                                        <option value="+1">🇺🇸 +1</option>
                                        <option value="+44">🇬🇧 +44</option>
                                        <option value="+61">🇦🇺 +61</option>
                                        <option value="+33">🇫🇷 +33</option>
                                        <option value="+49">🇩🇪 +49</option>
                                        <option value="+961">🇱🇧 +961</option>
                                        <option value="+971">🇦🇪 +971</option>
                                    </select>
                                    <input type="tel" id="inputPhone" class="prp-input prp-input--phone"
                                        placeholder="(555) 000-0000" autocomplete="off" />
                                </div>
                                <span class="prp-field__hint">Phone number is required</span>
                            </div>
                        </div>

                    </div>
                </div>
                <%-- end contact card --%>

                <%-- ── Security card ──────────────────────────────── --%>
                <div class="prp-card prp-card--security">
                    <div class="prp-card__header">
                        <div class="prp-card__header-icon prp-card__header-icon--orange">
                            <i class="fas fa-lock"></i>
                        </div>
                        <div>
                            <h3 class="prp-card__title">Account Security</h3>
                            <p class="prp-card__sub">Password and access settings</p>
                        </div>
                    </div>
                    <div class="prp-card__body">
                        <div class="prp-security-row">
                            <div class="prp-security-item">
                                <i class="fas fa-key"></i>
                                <div>
                                    <span class="prp-security-item__label">Password</span>
                                    <span class="prp-security-item__val">••••••••••••</span>
                                </div>
                                <button type="button" class="prp-link-btn">Change</button>
                            </div>
                            <div class="prp-security-item">
                                <i class="fas fa-shield-virus"></i>
                                <div>
                                    <span class="prp-security-item__label">Two-Factor Auth</span>
                                    <span class="prp-security-item__val prp-security-item__val--enabled">Enabled</span>
                                </div>
                                <button type="button" class="prp-link-btn">Manage</button>
                            </div>
                            <div class="prp-security-item">
                                <i class="fas fa-clock"></i>
                                <div>
                                    <span class="prp-security-item__label">Last Login</span>
                                    <span class="prp-security-item__val" id="prpLastLogin">--</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%-- end security card --%>

            </div>
            <%-- end right column --%>

        </div>
        <%-- end prp-body --%>

    </div>
    <%-- end prp-root --%>

    <%-- ── TOAST NOTIFICATION ──────────────────────────────────── --%>
    <div class="prp-toast" id="prpToast">
        <i class="fas fa-check-circle prp-toast__icon"></i>
        <span class="prp-toast__msg" id="prpToastMsg">Changes saved.</span>
    </div>

    <%-- ProfilePatient JS at bottom so DOM is ready --%>
    <script src="/js/ProfilePatient.js"></script>

</asp:Content>