<%@ Page Title="Patient Profile"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="PatientProfile.aspx.cs"
    Inherits="MediCare.Pages.Patient.PatientProfile" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/ProfilePatient.css" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="prp-root">

        <!-- BANNER -->
        <div class="prp-banner">
            <div class="prp-banner__overlay"></div>
            <div class="prp-banner__body">

                <div class="prp-avatar-ring">
                    <div class="prp-avatar" id="prpAvatar">
                        <span class="prp-avatar__initials" id="prpInitials">--</span>
                    </div>
                    <span class="prp-online-dot" title="Online"></span>
                </div>

                <div class="prp-banner__info">
                    <h1 class="prp-banner__name"><asp:Label ID="lblDisplayName" runat="server" /></h1>
                    <span class="prp-banner__role">
                        <i class="fas fa-user-circle"></i> Patient
                    </span>
                </div>

                <div class="prp-banner__actions">
                    <button type="button" id="btnEdit" class="prp-btn prp-btn--outline">
                        <i class="fas fa-user-edit"></i> Edit Profile
                    </button>
                    <asp:Button ID="btnSave" runat="server"
                        CssClass="prp-btn prp-btn--primary"
                        style="display:none;"
                        Text="Save Changes"
                        OnClick="btnSave_Click" />
                    <button type="button" id="btnCancel" class="prp-btn prp-btn--ghost" style="display:none;">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                </div>
            </div>
        </div>

        <!-- BODY -->
        <div class="prp-body">

            <!-- LEFT COLUMN -->
            <div class="prp-col prp-col--left">
                <div class="prp-card prp-card--profile">
                    <div class="prp-card__avatar-area">
                        <div class="prp-avatar prp-avatar--lg" id="prpAvatarCard">
                            <span class="prp-avatar__initials" id="prpInitialsCard">--</span>
                        </div>
                        <h2 class="prp-card__name"><asp:Label ID="lblCardName" runat="server" /></h2>
                        <span class="prp-card__tag">
                            <i class="fas fa-shield-alt"></i> Verified Patient
                        </span>
                    </div>
                    <div class="prp-card__divider"></div>
                    
                    </div>
            </div>

            <!-- RIGHT COLUMN -->
            <div class="prp-col prp-col--right">

                <!-- ACCOUNT INFO -->
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
                        <div class="prp-field">
                            <label class="prp-field__label"><i class="fas fa-at"></i> Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="prp-input locked" ReadOnly="true" />
                        </div>
                        <div class="prp-field">
                            <label class="prp-field__label"><i class="fas fa-envelope"></i> Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="prp-input locked" ReadOnly="true" />
                            <span class="prp-verified-badge"><i class="fas fa-check-circle"></i> Verified</span>
                        </div>
                    </div>
                </div>

                <!-- CONTACT INFO -->
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
                        <div class="prp-field prp-field--highlight">
                            <label class="prp-field__label">
                                <i class="fas fa-mobile-alt"></i> Phone Number
                                <span class="prp-required-dot" title="Required">*</span>
                            </label>
                            <div class="prp-phone-wrap">
                                <asp:DropDownList ID="ddlPhoneCode" runat="server" CssClass="prp-select locked" Enabled="false">
                                    <asp:ListItem Text="🇺🇸 +1" Value="+1" />
                                    <asp:ListItem Text="🇬🇧 +44" Value="+44" />
                                    <asp:ListItem Text="🇦🇺 +61" Value="+61" />
                                    <asp:ListItem Text="🇫🇷 +33" Value="+33" />
                                    <asp:ListItem Text="🇩🇪 +49" Value="+49" />
                                    <asp:ListItem Text="🇱🇧 +961" Value="+961" />
                                    <asp:ListItem Text="🇦🇪 +971" Value="+971" />
                                </asp:DropDownList>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="prp-input prp-input--phone locked" ReadOnly="true" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- HEALTH INFO (NEW - all server controls) -->
                <div class="prp-card">
                    <div class="prp-card__header">
                        <div class="prp-card__header-icon prp-card__header-icon--green">
                            <i class="fas fa-heart-pulse"></i>
                        </div>
                        <div>
                            <h3 class="prp-card__title">Health Information</h3>
                            <p class="prp-card__sub">Your medical profile & vitals</p>
                        </div>
                    </div>
                    <div class="prp-card__body">
                        <div class="prp-field">
                            <label class="prp-field__label"><i class="fas fa-calendar"></i> Age</label>
                            <asp:TextBox ID="txtAge" runat="server" CssClass="prp-input locked" TextMode="Number" ReadOnly="true" />
                        </div>
                        <div class="prp-field">
                            <label class="prp-field__label"><i class="fas fa-ruler-vertical"></i> Height (cm)</label>
                            <asp:TextBox ID="txtHeight" runat="server" CssClass="prp-input locked" TextMode="Number" ReadOnly="true" />
                        </div>
                        <div class="prp-field">
                            <label class="prp-field__label"><i class="fas fa-weight-scale"></i> Weight (kg)</label>
                            <asp:TextBox ID="txtWeight" runat="server" CssClass="prp-input locked" TextMode="Number" ReadOnly="true" />
                        </div>
                        <div class="prp-field">
                            <label class="prp-field__label"><i class="fas fa-tint"></i> Blood Type</label>
                            <asp:DropDownList ID="ddlBloodType" runat="server" CssClass="prp-select locked" Enabled="false">
                                <asp:ListItem Text="Select..." Value="" />
                                <asp:ListItem Text="A+" Value="A+" />
                                <asp:ListItem Text="O+" Value="O+" />
                                <asp:ListItem Text="B+" Value="B+" />
                                <asp:ListItem Text="AB+" Value="AB+" />
                                <asp:ListItem Text="A-" Value="A-" />
                                <asp:ListItem Text="O-" Value="O-" />
                                <asp:ListItem Text="B-" Value="B-" />
                                <asp:ListItem Text="AB-" Value="AB-" />
                            </asp:DropDownList>
                        </div>
                        <div class="prp-field">
                            <label class="prp-field__label"><i class="fas fa-disease"></i> Chronic Disease</label>
                            <asp:TextBox ID="txtDisease" runat="server" CssClass="prp-input locked" ReadOnly="true" />
                        </div>
                        <div class="prp-field">
                            <label class="prp-field__label"><i class="fas fa-wheelchair"></i> Disability</label>
                            <asp:TextBox ID="txtDisability" runat="server" CssClass="prp-input locked" ReadOnly="true" />
                        </div>
                        <div class="prp-field">
                            <label class="prp-field__label"><i class="fas fa-people-arrows"></i> Family History</label>
                            <asp:TextBox ID="txtFamilyHistory" runat="server" CssClass="prp-input locked" TextMode="MultiLine" Rows="3" ReadOnly="true" />
                        </div>
                    </div>
                </div>

                <!-- SECURITY (unchanged) -->
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
                            
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- TOAST (optional) -->
    <div class="prp-toast" id="prpToast">
        <i class="fas fa-check-circle prp-toast__icon"></i>
        <span class="prp-toast__msg" id="prpToastMsg">Changes saved.</span>
    </div>

    <!-- SIMPLIFIED JAVASCRIPT: only locks/unlocks inputs -->
    <script>
        (function () {
            var isEditing = false;
            var originalValues = {};   // stores original values per control ID

            // Store initial values for cancel
            function snapshot() {
                document.querySelectorAll('.prp-input, .prp-select').forEach(function (el) {
                    originalValues[el.id] = el.value;
                });
            }

            // Enter edit mode
            function enterEdit() {
                if (isEditing) return;
                snapshot();                 // save current values for cancel
                toggleLock(false);          // unlock all controls
                showButtons(true);
                isEditing = true;
            }

            // Cancel editing
            function cancelEdit() {
                // Restore original values
                for (var id in originalValues) {
                    if (originalValues.hasOwnProperty(id)) {
                        var el = document.getElementById(id);
                        if (el) el.value = originalValues[id];
                    }
                }
                toggleLock(true);           // lock again
                showButtons(false);
                isEditing = false;
            }

            // Lock or unlock all input/select controls
            function toggleLock(lock) {
                document.querySelectorAll('.prp-input.locked, .prp-select.locked').forEach(function (el) {
                    if (lock) {
                        el.setAttribute('readonly', 'readonly');
                        el.setAttribute('disabled', 'disabled');
                        el.classList.add('locked');
                    } else {
                        el.removeAttribute('readonly');
                        el.removeAttribute('disabled');
                        el.classList.remove('locked');
                    }
                });
            }

            function showButtons(editing) {
                document.getElementById('btnEdit').style.display = editing ? 'none' : 'inline-flex';
                var saveBtn = document.getElementById('<%= btnSave.ClientID %>');
                if (saveBtn) saveBtn.style.display = editing ? 'inline-flex' : 'none';
                document.getElementById('btnCancel').style.display = editing ? 'inline-flex' : 'none';
            }

            // Hook up buttons
            document.getElementById('btnEdit').addEventListener('click', enterEdit);
            document.getElementById('btnCancel').addEventListener('click', cancelEdit);

            // Optional: Show toast after postback if needed
            window.showToast = function(msg) {
                var t = document.getElementById('prpToast');
                var m = document.getElementById('prpToastMsg');
                if (t && m) {
                    m.textContent = msg;
                    t.classList.add('prp-toast--show');
                    clearTimeout(t._timeout);
                    t._timeout = setTimeout(function(){ t.classList.remove('prp-toast--show'); }, 3000);
                }
            };

            // Set initials from server-side name
            var nameLabel = document.getElementById('<%= lblDisplayName.ClientID %>');
            if (nameLabel) {
                var initials = nameLabel.textContent.trim().split(' ').map(function(n){ return n.charAt(0); }).slice(0,2).join('').toUpperCase();
                document.getElementById('prpInitials').textContent = initials;
                document.getElementById('prpInitialsCard').textContent = initials;
            }
        })();
    </script>

</asp:Content>