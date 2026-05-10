<%@ Page Title="Login - Medicare" Language="C#" MasterPageFile="../../MasterPage/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MediCare.Pages.Account.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <section class="mc-auth">
        <div class="mc-container">
            <div class="mc-form-panel">
                <div class="mc-form-card">
                    <!-- Header matching your Register design -->
                    <div class="mc-form-card__header">
                        <div class="mc-form-avatar mc-form-avatar--green">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                        </div>
                        <div>
                            <h3>Welcome Back</h3>
                            <p>Please enter your credentials to access your portal</p>
                        </div>
                    </div>

                    <div class="mc-form">
                        <!-- Email Group -->
                        <div class="mc-form__group">
                            <label class="mc-label">Email Address <span class="mc-required">*</span></label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="mc-input" placeholder="name@example.com" TextMode="Email"></asp:TextBox>
                        </div>

                        <!-- Password Group -->
                        <div class="mc-form__group">
                            <label class="mc-label">Password <span class="mc-required">*</span></label>
                            <div class="mc-input-wrap">
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="mc-input" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Forgot Password Link (Styled to match your theme) -->
                        <div style="text-align: right; margin-top: -10px;">
                            <a href="ForgotPassword.aspx" class="mc-form__terms" style="color: var(--mc-green-600); font-weight: 500;">Forgot password?</a>
                        </div>

                        <!-- Action Button -->
                        <div class="mc-form__footer">
                            <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="mc-btn mc-btn--primary mc-btn--full" OnClick="btnLogin_Click" />
                            
                            <div class="mc-form__signin-link">
                                New to Medicare? <a href="../../default.aspx">Create an account instead</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</asp:Content>