<%@ Page Title="Forget Password – MediCare" Language="C#" MasterPageFile="~/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="MediCare.Pages.Account.ForgotPassword" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Page-specific stylesheet -->
    <link rel="stylesheet" href="/css/ForgetPassword.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<!-- ═══════════════════════════════════════════════════
     FORGET PASSWORD PAGE WRAPPER
═══════════════════════════════════════════════════ -->
<div class="fp-root">

    <!-- Background decorative blobs -->
    <div class="fp-blob fp-blob--1" aria-hidden="true"></div>
    <div class="fp-blob fp-blob--2" aria-hidden="true"></div>
    <div class="fp-blob fp-blob--3" aria-hidden="true"></div>

    <!-- ═══════════════════════════════════════════════════
         MAIN CARD
    ═══════════════════════════════════════════════════ -->
    <div class="fp-card">

        <!-- Card top icon -->
        <div class="fp-card__icon-wrap" aria-hidden="true">
            <div class="fp-card__icon">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
            </div>
            <div class="fp-card__icon-ring" aria-hidden="true"></div>
        </div>

        <!-- Title & subtitle -->
        <div class="fp-card__head">
            <h1 class="fp-card__title">Forgot Password?</h1>
            <p class="fp-card__sub">Enter your registered email address and we'll send you a verification code to reset your password.</p>
        </div>

        <!-- ═══════════════════════════════════════════════
             STEP 1 — EMAIL INPUT
        ═══════════════════════════════════════════════ -->
        <div class="fp-step" id="stepEmail">

            <div class="fp-step__label">
                <div class="fp-step__num">1</div>
                <span>Enter your email address</span>
            </div>

            <!-- Email field -->
            <div class="fp-field" id="emailFieldWrap">
                <label class="fp-label" for="txtEmail">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                        <polyline points="22,6 12,13 2,6"/>
                    </svg>
                    Email Address
                </label>
                <div class="fp-input-wrap">
                    <span class="fp-input-icon" aria-hidden="true">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                            <polyline points="22,6 12,13 2,6"/>
                        </svg>
                    </span>
                    <asp:TextBox
                        ID="txtEmail"
                        runat="server"
                        CssClass="fp-input"
                        TextMode="Email"
                        placeholder="e.g. sara@example.com"
                        MaxLength="150" />
                </div>
                <asp:Label ID="lblMessage" runat="server" CssClass="fp-field-error" Visible="false" />
            </div>

            <!-- Send Code button -->
            <asp:Button
                ID="btnSendCode"
                runat="server"
                Text="Send Verification Code"
                CssClass="fp-btn fp-btn--primary"
                OnClientClick="handleSendCode(event);"
                OnClick="btnSendCode_Click" />

            <!-- Success message (hidden initially) -->
            <div class="fp-alert fp-alert--success" id="sendSuccessMsg" style="display:none;" role="alert">
                <span class="fp-alert__icon" aria-hidden="true">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                        <polyline points="22 4 12 14.01 9 11.01"/>
                    </svg>
                </span>
                <div>
                    <strong>Code Sent!</strong>
                    <p>A verification code has been sent to your email. Please check your inbox and spam folder.</p>
                </div>
            </div>

        </div>

        <!-- Divider -->
        <div class="fp-divider" id="stepDivider" style="display:none;">
            <span>Enter verification code below</span>
        </div>

        <!-- ═══════════════════════════════════════════════
             STEP 2 — VERIFICATION CODE
        ═══════════════════════════════════════════════ -->
        <div class="fp-step fp-step--hidden" id="stepVerify">

            <div class="fp-step__label">
                <div class="fp-step__num">2</div>
                <span>Enter verification code</span>
            </div>

            <!-- Countdown timer -->
            <div class="fp-timer" id="timerWrap">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                </svg>
                Code expires in <span class="fp-timer__count" id="timerCount">05:00</span>
            </div>

            <!-- Attempts bar -->
            <div class="fp-attempts" id="attemptsWrap">
                <span class="fp-attempts__label">Attempts remaining:</span>
                <div class="fp-attempts__dots">
                    <div class="fp-attempt-dot fp-attempt-dot--active" id="dot1" aria-label="Attempt 1"></div>
                    <div class="fp-attempt-dot fp-attempt-dot--active" id="dot2" aria-label="Attempt 2"></div>
                    <div class="fp-attempt-dot fp-attempt-dot--active" id="dot3" aria-label="Attempt 3"></div>
                </div>
            </div>

            <!-- Code input -->
            <div class="fp-field">
                <label class="fp-label" for="txtCode">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <rect x="2" y="3" width="20" height="14" rx="2" ry="2"/>
                        <line x1="8" y1="21" x2="16" y2="21"/>
                        <line x1="12" y1="17" x2="12" y2="21"/>
                    </svg>
                    Verification Code
                </label>
                <div class="fp-input-wrap">
                    <span class="fp-input-icon" aria-hidden="true">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                        </svg>
                    </span>
                    <asp:TextBox
                        ID="txtCode"
                        runat="server"
                        CssClass="fp-input fp-input--code"
                        placeholder="Enter 6-digit code"
                        MaxLength="6" />
                </div>
            </div>

            <!-- Verify button -->
            <asp:Button
                ID="btnVerifyCode"
                runat="server"
                Text="Verify Code"
                CssClass="fp-btn fp-btn--primary"
              OnClientClick="handleVerify(event);"
                OnClick="btnVerifyCode_Click"/>

            <!-- Locked message (hidden initially) -->
            <div class="fp-alert fp-alert--error" id="lockedMsg" style="display:none;" role="alert">
                <span class="fp-alert__icon" aria-hidden="true">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                </span>
                <div>
                    <strong>Too many failed attempts.</strong>
                    <p>Your verification has been locked. Please request a new code.</p>
                </div>
            </div>

            <!-- Wrong code message -->
            <div class="fp-alert fp-alert--warning" id="wrongCodeMsg" style="display:none;" role="alert">
                <span class="fp-alert__icon" aria-hidden="true">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                        <line x1="12" y1="9" x2="12" y2="13"/>
                        <line x1="12" y1="17" x2="12.01" y2="17"/>
                    </svg>
                </span>
                <div>
                    <strong>Incorrect code.</strong>
                    <p id="wrongCodeDetail">Please check the code and try again.</p>
                </div>
            </div>

            <!-- Resend link -->
            <div class="fp-resend" id="resendWrap" style="display:none;">
    <asp:LinkButton 
    ID="btnResendCode" 
    runat="server" 
    CssClass="fp-resend__btn"
OnClientClick="handleResend(event);"
    OnClick="btnResendCode_Click">

    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <polyline points="1 4 1 10 7 10"/>
        <path d="M3.51 15a9 9 0 1 0 .49-3.32"/>
    </svg>

    Resend verification code
</asp:LinkButton>
            </div>

        </div>

        <!-- Back to login -->
        <div class="fp-footer-link">
            <a href="/Default.aspx" class="fp-back-link">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <line x1="19" y1="12" x2="5" y2="12"/>
                    <polyline points="12 19 5 12 12 5"/>
                </svg>
                Back to Sign In
            </a>
        </div>

    </div>
</div>

</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="ScriptContent" runat="server">
    <script src="/js/ForgetPassword.js"></script>
</asp:Content>
