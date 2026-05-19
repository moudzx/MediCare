<%@ Page Title="Forget Password – MediCare" Language="C#" MasterPageFile="~/MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="MediCare.Pages.Account.ForgotPassword" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/ForgetPassword.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="fp-root">

    <div class="fp-blob fp-blob--1" aria-hidden="true"></div>
    <div class="fp-blob fp-blob--2" aria-hidden="true"></div>
    <div class="fp-blob fp-blob--3" aria-hidden="true"></div>

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

        <!-- Title -->
        <div class="fp-card__head">
            <h1 class="fp-card__title">Forgot Password?</h1>
            <p class="fp-card__sub">Enter your registered email address and we'll send you a verification code to reset your password.</p>
        </div>

        <!-- Email -->
        <div class="fp-field">
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
                <asp:TextBox ID="txtEmail" runat="server" CssClass="fp-input" TextMode="Email" placeholder="e.g. sara@example.com" MaxLength="150" />
            </div>
        </div>

        <asp:Button ID="btnSendCode" runat="server" Text="Send Verification Code" CssClass="fp-btn fp-btn--primary" OnClick="btnSendCode_Click" />

        <!-- All feedback goes here -->
        <asp:Label ID="lblMessage" runat="server" CssClass="fp-field-error" Visible="false" />

        <!-- Verification code (visible right away) -->
        <div class="fp-field" style="margin-top:24px;">
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
                <asp:TextBox ID="txtCode" runat="server" CssClass="fp-input fp-input--code" placeholder="Enter 6-digit code" MaxLength="6" />
            </div>
        </div>

        <asp:Button ID="btnVerifyCode" runat="server" Text="Verify Code" CssClass="fp-btn fp-btn--primary" OnClick="btnVerifyCode_Click" />

        <!-- Resend link -->
        <div class="fp-resend" style="margin-top:16px;">
            <asp:LinkButton ID="btnResendCode" runat="server" CssClass="fp-resend__btn" OnClick="btnResendCode_Click">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <polyline points="1 4 1 10 7 10"/>
                    <path d="M3.51 15a9 9 0 1 0 .49-3.32"/>
                </svg>
                Resend verification code
            </asp:LinkButton>
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