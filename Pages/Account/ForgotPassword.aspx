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

        <div class="fp-card__icon-wrap" aria-hidden="true">
            <div class="fp-card__icon">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#1A9E5C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                </svg>
            </div>
            <div class="fp-card__icon-ring" aria-hidden="true"></div>
        </div>

        <div class="fp-card__head">
            <h1 class="fp-card__title">Forgot Password?</h1>
            <p class="fp-card__sub">Enter your email and verification code.</p>
        </div>

        <div class="fp-field">
            <label class="fp-label">Email Address</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="fp-input" TextMode="Email" />
        </div>

        <asp:Button ID="btnSendCode" runat="server" Text="Send Code" CssClass="fp-btn fp-btn--primary" OnClick="btnSendCode_Click" />

        <asp:Label ID="lblMessage" runat="server" CssClass="fp-field-error" Visible="false" />

        <div class="fp-field">
            <label class="fp-label">Verification Code</label>
            <asp:TextBox ID="txtCode" runat="server" CssClass="fp-input" MaxLength="6" />
        </div>

        <asp:Button ID="btnVerifyCode" runat="server" Text="Verify" CssClass="fp-btn fp-btn--primary" OnClick="btnVerifyCode_Click" />

        <div class="fp-resend">
            <asp:LinkButton ID="btnResendCode" runat="server" OnClick="btnResendCode_Click">Resend Code</asp:LinkButton>
        </div>

    </div>
</div>

</asp:Content>