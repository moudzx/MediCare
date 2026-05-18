<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminProfile.aspx.cs" Inherits="MediCare.Pages.Account.AdminProfile" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Profile | MediCare Admin</title>

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <!-- Google Fonts: Sora (display) + DM Sans (body) -->
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet" />

    <!-- Profile Page Stylesheet -->
    <link rel="stylesheet" href="/css/AdminProfile.css" />
</head>
<body>

  
    <!-- ===== MAIN PAGE WRAPPER ===== -->
    <main class="prof-page">

        <!-- ── PROFILE BANNER / HEADER ── -->
        <section class="prof-banner">
            <div class="prof-banner__bg"></div>

            <div class="prof-banner__content">

                <!-- Avatar circle with initials -->
                <div class="prof-avatar-wrap">
                    <div class="prof-avatar" id="profileAvatar">AK</div>
                    <span class="prof-avatar__badge" title="System Administrator">
                        <i class="fa-solid fa-shield-halved"></i>
                    </span>
                </div>

                <!-- Name + role headline -->
                <div class="prof-banner__info">
                    <h1 class="prof-name" id="profileName">—</h1>
                    <p class="prof-role" id="profileRole">—</p>
                    <span class="prof-status">
                        <span class="prof-status__dot"></span>
                        Active Account
                    </span>
                </div>

                <!-- Edit button (front-end only, opens inline edit mode) -->
                <button class="prof-edit-btn" id="editBtn" onclick="ProfilePage.toggleEdit()">
                    <i class="fa-solid fa-pen-to-square"></i>
                    Edit Profile
                </button>
            </div>
        </section>

        <!-- ── CARDS GRID ── -->
        <section class="prof-cards">

            <!-- Card 1: Contact Information -->
            <div class="prof-card">
                <div class="prof-card__header">
                    <span class="prof-card__icon prof-card__icon--blue">
                        <i class="fa-solid fa-address-card"></i>
                    </span>
                    <h2 class="prof-card__title">Contact Information</h2>
                </div>

                <ul class="prof-info-list">

                    <!-- Email row -->
                    <li class="prof-info-item">
                        <div class="prof-info-item__icon">
                            <i class="fa-solid fa-envelope"></i>
                        </div>
                        <div class="prof-info-item__body">
                            <span class="prof-info-item__label">Email Address</span>
                            <!-- VALUE injected by Profile.js -->
                            <span class="prof-info-item__value" id="profileEmail">—</span>
                            <!-- EDIT INPUT hidden by default -->
                            <input class="prof-edit-input" id="editEmail" type="email" placeholder="Enter email" style="display:none" />
                        </div>
                    </li>

                    <!-- Phone row -->
                    <li class="prof-info-item">
                        <div class="prof-info-item__icon">
                            <i class="fa-solid fa-phone"></i>
                        </div>
                        <div class="prof-info-item__body">
                            <span class="prof-info-item__label">Phone Number</span>
                            <span class="prof-info-item__value" id="profilePhone">—</span>
                            <input class="prof-edit-input" id="editPhone" type="tel" placeholder="Enter phone" style="display:none" />
                        </div>
                    </li>

                </ul>
            </div>

            <!-- Card 2: Account Details -->
            <div class="prof-card">
                <div class="prof-card__header">
                    <span class="prof-card__icon prof-card__icon--teal">
                        <i class="fa-solid fa-user-gear"></i>
                    </span>
                    <h2 class="prof-card__title">Account Details</h2>
                </div>

                <ul class="prof-info-list">

                    <!-- Role row -->
                    <li class="prof-info-item">
                        <div class="prof-info-item__icon">
                            <i class="fa-solid fa-id-badge"></i>
                        </div>
                        <div class="prof-info-item__body">
                            <span class="prof-info-item__label">System Role</span>
                            <span class="prof-info-item__value" id="profileRoleCard">—</span>
                        </div>
                    </li>

                    <!-- Last Login row -->
                    <li class="prof-info-item">
                        <div class="prof-info-item__icon">
                            <i class="fa-solid fa-clock-rotate-left"></i>
                        </div>
                        <div class="prof-info-item__body">
                            <span class="prof-info-item__label">Last Login</span>
                            <span class="prof-info-item__value" id="profileLastLogin">—</span>
                        </div>
                    </li>

                </ul>
            </div>

            <!-- Card 3: Security (static, ready for backend) -->
            <div class="prof-card prof-card--wide">
                <div class="prof-card__header">
                    <span class="prof-card__icon prof-card__icon--indigo">
                        <i class="fa-solid fa-lock"></i>
                    </span>
                    <h2 class="prof-card__title">Security</h2>
                </div>

                <div class="prof-security">
                    <div class="prof-security__item">
                        <div class="prof-security__left">
                            <i class="fa-solid fa-key"></i>
                            <div>
                                <strong>Password</strong>
                                <p>Last changed 30 days ago</p>
                            </div>
                        </div>
                        <!-- Front-end only: shows alert. Backend integration point marked in JS -->
                        <button class="prof-sec-btn" onclick="ProfilePage.changePassword()">
                            Change Password
                        </button>
                    </div>

                    <div class="prof-security__divider"></div>

                    <div class="prof-security__item">
                        <div class="prof-security__left">
                            <i class="fa-solid fa-mobile-screen-button"></i>
                            <div>
                                <strong>Two-Factor Authentication</strong>
                                <p>Enhance your account security</p>
                            </div>
                        </div>
                        <button class="prof-sec-btn prof-sec-btn--outline" onclick="ProfilePage.toggle2FA()">
                            Enable 2FA
                        </button>
                    </div>
                </div>
            </div>

        </section>

        <!-- ── EDIT MODE SAVE / CANCEL BAR (hidden until edit mode) ── -->
        <div class="prof-edit-bar" id="editBar" style="display:none">
            <span class="prof-edit-bar__msg">
                <i class="fa-solid fa-circle-info"></i>
                You are in edit mode — changes are local until saved to the server.
            </span>
            <div class="prof-edit-bar__actions">
                <button class="prof-edit-bar__cancel" onclick="ProfilePage.cancelEdit()">Cancel</button>
                <button class="prof-edit-bar__save"   onclick="ProfilePage.saveEdit()">
                    <i class="fa-solid fa-floppy-disk"></i> Save Changes
                </button>
            </div>
        </div>

    </main>

    <!-- ===== Profile JS ===== -->
    <script src="/js/AdminProfile.js"></script>

</body>
</html>