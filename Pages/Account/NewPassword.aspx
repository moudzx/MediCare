<%@ Page Title="New Password – MediCare" Language="C#" MasterPageFile="~/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="NewPassword.aspx.cs" Inherits="MediCare.Pages.Account.NewPassword" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Page-specific stylesheet -->
    <link rel="stylesheet" href="/css/ForgetPassword.css" />
    <link rel="stylesheet" href="/css/NewPassword.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<!-- ═══════════════════════════════════════════════════
     NEW PASSWORD PAGE WRAPPER
═══════════════════════════════════════════════════ -->
<div class="fp-root np-root">

    <!-- Background decorative blobs (reused from fp-root) -->
    <div class="fp-blob fp-blob--1" aria-hidden="true"></div>
    <div class="fp-blob fp-blob--2" aria-hidden="true"></div>

    <!-- ═══════════════════════════════════════════════════
         MAIN CARD
    ═══════════════════════════════════════════════════ -->
    <div class="fp-card np-card">

        <!-- Card top icon -->
        <div class="fp-card__icon-wrap" aria-hidden="true">
            <div class="fp-card__icon np-icon">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                </svg>
            </div>
            <div class="fp-card__icon-ring" aria-hidden="true"></div>
        </div>

        <!-- Title -->
        <div class="fp-card__head">
            <h1 class="fp-card__title">Set New Password</h1>
            <p class="fp-card__sub">Create a strong password for your MediCare account. It must be at least 8 characters and contain an uppercase letter and a number.</p>
        </div>

        <!-- ═══════════════════════════════════════════════
             PASSWORD STRENGTH INDICATOR
        ═══════════════════════════════════════════════ -->
        <div class="np-strength-wrap" id="strengthWrap" style="display:none;">
            <div class="np-strength-label">
                Password strength:
                <span class="np-strength-text" id="strengthText">Weak</span>
            </div>
            <div class="np-strength-bar">
                <div class="np-strength-fill" id="strengthFill"></div>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════════
             PASSWORD REQUIREMENTS CHECKLIST
        ═══════════════════════════════════════════════ -->
        <div class="np-rules" id="rulesWrap" style="display:none;">
            <div class="np-rule" id="rule-length">
                <span class="np-rule__icon" aria-hidden="true">○</span>
                At least 8 characters
            </div>
            <div class="np-rule" id="rule-upper">
                <span class="np-rule__icon" aria-hidden="true">○</span>
                Contains uppercase letter (A–Z)
            </div>
            <div class="np-rule" id="rule-number">
                <span class="np-rule__icon" aria-hidden="true">○</span>
                Contains a number (0–9)
            </div>
            <div class="np-rule" id="rule-match">
                <span class="np-rule__icon" aria-hidden="true">○</span>
                Passwords match
            </div>
        </div>

        <!-- ═══════════════════════════════════════════════
             FORM FIELDS
        ═══════════════════════════════════════════════ -->
        <div class="np-form" id="npForm">

            <!-- New Password -->
            <div class="fp-field">
                <label class="fp-label" for="txtNewPassword">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                    New Password
                </label>
                <div class="fp-input-wrap">
                    <span class="fp-input-icon" aria-hidden="true">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                    </span>
                    <asp:TextBox
                        ID="txtNewPassword"
                        runat="server"
                        CssClass="fp-input np-password-input"
                        TextMode="Password"
                        placeholder="Enter new password"
                        MaxLength="64" />
                    <button type="button"
                        class="np-eye-btn"
                        id="eyeNew"
                        onclick="toggleEye('txtNewPassword', 'eyeNew')"
                        aria-label="Toggle password visibility">
                        <svg class="np-eye-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
                <asp:Label ID="lblNewPwdError" runat="server" CssClass="fp-field-error" Visible="false" />
            </div>

            <!-- Confirm Password -->
            <div class="fp-field">
                <label class="fp-label" for="txtConfirmPassword">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M9 12l2 2 4-4"/>
                        <path d="M21 12c0 4.97-4.03 9-9 9S3 16.97 3 12 7.03 3 12 3s9 4.03 9 9z"/>
                    </svg>
                    Confirm Password
                </label>
                <div class="fp-input-wrap">
                    <span class="fp-input-icon" aria-hidden="true">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M9 12l2 2 4-4"/>
                            <path d="M21 12c0 4.97-4.03 9-9 9S3 16.97 3 12 7.03 3 12 3s9 4.03 9 9z"/>
                        </svg>
                    </span>
                    <asp:TextBox
                        ID="txtConfirmPassword"
                        runat="server"
                        CssClass="fp-input np-password-input"
                        TextMode="Password"
                        placeholder="Re-enter new password"
                        MaxLength="64" />
                    <button type="button"
                        class="np-eye-btn"
                        id="eyeConfirm"
                        onclick="toggleEye('txtConfirmPassword', 'eyeConfirm')"
                        aria-label="Toggle password visibility">
                        <svg class="np-eye-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                            <circle cx="12" cy="12" r="3"/>
                        </svg>
                    </button>
                </div>
                <asp:Label ID="lblConfirmPwdError" runat="server" CssClass="fp-field-error" Visible="false" />
            </div>

            <!-- Error alert -->
            <div class="fp-alert fp-alert--error" id="saveErrorMsg" style="display:none;" role="alert">
                <span class="fp-alert__icon" aria-hidden="true">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                </span>
                <div>
                    <strong id="saveErrorTitle">Please fix the errors below.</strong>
                    <p id="saveErrorDetail">Check your password and try again.</p>
                </div>
            </div>

            <!-- Save button -->
            <asp:Button
                ID="btnSavePassword"
                runat="server"
                Text="Save New Password"
                CssClass="fp-btn fp-btn--primary np-save-btn"
                OnClick="btnSavePassword_Click" />

        </div>

        <!-- ═══════════════════════════════════════════════
             SUCCESS STATE (hidden initially)
        ═══════════════════════════════════════════════ -->
        <div class="np-success" id="npSuccess" style="display:none;">
            <div class="np-success__circle" aria-hidden="true">
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                    <polyline points="22 4 12 14.01 9 11.01"/>
                </svg>
            </div>
            <h2 class="np-success__title">Password Updated!</h2>
            <p class="np-success__sub">Your password has been changed successfully. You can now sign in with your new password.</p>
            <a href="/Default.aspx" class="fp-btn fp-btn--primary np-signin-btn">
                Go to Sign In
            </a>
            <div class="np-success__redirect">
                Redirecting automatically in <span id="redirectCount">5</span>s
            </div>
        </div>

        <!-- Back link -->
        <div class="fp-footer-link" id="backLinkWrap">
            <a href="/Pages/ForgetPassword.aspx" class="fp-back-link">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <line x1="19" y1="12" x2="5" y2="12"/>
                    <polyline points="12 19 5 12 12 5"/>
                </svg>
                Back to Verification
            </a>
        </div>

    </div>
</div>

</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="ScriptContent" runat="server">
    <script>
    /* ── Minimal inline script – only password visibility toggle ── */
    function toggleEye(inputIdSuffix, eyeBtnId) {
        var input = document.querySelector('input[id$="' + inputIdSuffix + '"]');
        var btn   = document.getElementById(eyeBtnId);
        if (!input || !btn) return;

        var isPassword = input.type === 'password';
        input.type = isPassword ? 'text' : 'password';

        // Swap eye icon
        var icon = btn.querySelector('.np-eye-icon');
        if (icon) {
            if (isPassword) {
                // Show “eye‑off” (crossed‑out)
                icon.innerHTML =
                    '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/>' +
                    '<path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/>' +
                    '<line x1="1" y1="1" x2="23" y2="23"/>';
            } else {
                // Show “eye”
                icon.innerHTML =
                    '<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>' +
                    '<circle cx="12" cy="12" r="3"/>';
            }
        }

        btn.setAttribute('aria-label', isPassword ? 'Hide password' : 'Show password');
        input.focus();
    }
    </script>
</asp:Content>