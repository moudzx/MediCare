<%@ Page Title="Medications – MediCare" Language="C#" MasterPageFile="~/MasterPage/PatientSite.Master" AutoEventWireup="true" CodeBehind="Medications.aspx.cs" Inherits="MediCare.Pages.Patient.Medications" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/medications.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

<div class="med-root">

    <!-- ══════════════════════════════════════
         PAGE HEADER
    ══════════════════════════════════════ -->
    <div class="med-page-header">
        <div class="med-page-header__left">
            <div class="med-page-header__icon">
                <i class="fa-solid fa-pills"></i>
            </div>
            <div>
                <h1 class="med-page-header__title">Medications</h1>
                <p class="med-page-header__sub">Manage your prescriptions and personal medications</p>
            </div>
        </div>
        <div class="med-page-header__right">
            <div class="med-header-stat">
                <span class="med-header-stat__num">3</span>
                <span class="med-header-stat__label">Active</span>
            </div>
            <div class="med-header-stat">
                <span class="med-header-stat__num">1</span>
                <span class="med-header-stat__label">Pending</span>
            </div>
            <div class="med-header-stat">
                <span class="med-header-stat__num">2</span>
                <span class="med-header-stat__label">Own Meds</span>
            </div>
        </div>
    </div>

    <!-- ══════════════════════════════════════
         MAIN TWO-COLUMN GRID
    ══════════════════════════════════════ -->
    <div class="med-main-grid">

        <!-- ════════════════════════════
             LEFT CARD — APPROVED MEDICATIONS
        ════════════════════════════ -->
        <div class="med-card" id="cardApproved">
            <div class="med-card__header">
                <div class="med-card__title-group">
                    <div class="med-card__icon med-card__icon--green">
                        <i class="fa-solid fa-clipboard-check"></i>
                    </div>
                    <div>
                        <h2 class="med-card__title">Approved Medications</h2>
                        <p class="med-card__subtitle">Prescribed by your doctor</p>
                    </div>
                </div>
                <div class="med-badge med-badge--green">
                    <i class="fa-solid fa-circle-check"></i> 3 Active
                </div>
            </div>

            <!-- Search Box -->
            <div class="med-search-wrap">
                <i class="fa-solid fa-magnifying-glass med-search-icon"></i>
                <input type="text" id="txtSearchApproved" class="med-search-input" placeholder="Search medications..." oninput="filterApprovedGrid(this.value)" />
            </div>

         
            <!-- GridView -->
        <div class="med-table-wrap">

            <asp:GridView ID="tblApproved" runat="server"
                CssClass="med-grid"
                AutoGenerateColumns="False"
                ShowHeader="True"
                GridLines="None">

                <Columns>

                    <asp:TemplateField HeaderText="">
                        <HeaderTemplate>
                            <span><i class="fa-solid fa-pills"></i> Medication</span>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <div class="med-grid-pill">
                                <div class="med-pill-dot med-pill-dot--green"></div>
                                <span class="med-grid-name"><%# Eval("Medication") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="Dosage" HeaderText="Dosage"
                        ItemStyle-CssClass="med-grid-cell" />

                    <asp:BoundField DataField="Frequency" HeaderText="Frequency"
                        ItemStyle-CssClass="med-grid-cell" />

                    <asp:TemplateField HeaderText="Start">
                        <ItemTemplate>
                            <span class="med-grid-cell med-grid-cell--muted">
                                <%# Eval("StartDate", "{0:yyyy-MM-dd}") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="End">
                        <ItemTemplate>
                            <span class="med-grid-cell med-grid-cell--muted">
                                <%# Eval("EndDate", "{0:yyyy-MM-dd}") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>

                <HeaderStyle CssClass="med-grid-header" />
                <RowStyle CssClass="med-grid-row" />
                <AlternatingRowStyle CssClass="med-grid-row med-grid-row--alt" />

            </asp:GridView>

            <!-- Empty state (unchanged) -->
            <div class="med-empty-state" id="emptyApproved" style="display:none;">
                <div class="med-empty-state__icon">
                    <i class="fa-solid fa-pills"></i>
                </div>
                <p class="med-empty-state__text">No medications found.</p>
                <p class="med-empty-state__sub">Try a different search term.</p>
            </div>

        </div>

        <!-- Footer Button -->
        <div class="med-card__footer">
            <a href="/Pages/Patient/SearchMedication.aspx" class="med-btn med-btn--primary">
                <i class="fa-solid fa-plus"></i>
                Add New Medication
            </a>
        </div>

        <!-- ════════════════════════════
             RIGHT CARD — MY OWN MEDICATIONS
        ════════════════════════════ -->
        <div class="med-card" id="cardOwn">
            <div class="med-card__header">
                <div class="med-card__title-group">
                    <div class="med-card__icon med-card__icon--blue">
                        <i class="fa-solid fa-user-nurse"></i>
                    </div>
                    <div>
                        <h2 class="med-card__title">My Own Medications</h2>
                        <p class="med-card__subtitle">Self-reported medications</p>
                    </div>
                </div>
                <div class="med-badge med-badge--blue">
                    <i class="fa-solid fa-list"></i> 2 Entries
                </div>
            </div>

            <!-- Own Meds Table -->
            <div class="med-table-wrap">
                <table class="med-grid" id="tblOwn">
                    <thead>
                        <tr class="med-grid-header">
                            <th><span><i class="fa-solid fa-capsules"></i> Medication</span></th>
                            <th>Dosage</th>
                            <th>Frequency</th>
                            <th>Status</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="med-grid-row">
                            <td>
                                <div class="med-grid-pill">
                                    <div class="med-pill-dot med-pill-dot--blue"></div>
                                    <span class="med-grid-name">Vitamin D3</span>
                                </div>
                            </td>
                            <td class="med-grid-cell">1000 IU</td>
                            <td class="med-grid-cell">Once daily</td>
                            <td>
                                <span class="med-status-badge med-status-badge--orange">
                                    <i class="fa-solid fa-clock"></i> Pending
                                </span>
                            </td>
                            <td>
                                <button class="med-delete-btn" onclick="deleteOwnRow(this)" title="Delete">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </td>
                        </tr>
                        <tr class="med-grid-row med-grid-row--alt">
                            <td>
                                <div class="med-grid-pill">
                                    <div class="med-pill-dot med-pill-dot--blue"></div>
                                    <span class="med-grid-name">Omega-3</span>
                                </div>
                            </td>
                            <td class="med-grid-cell">500mg</td>
                            <td class="med-grid-cell">Twice daily</td>
                            <td>
                                <span class="med-status-badge med-status-badge--green">
                                    <i class="fa-solid fa-circle-check"></i> Approved
                                </span>
                            </td>
                            <td>
                                <button class="med-delete-btn" onclick="deleteOwnRow(this)" title="Delete">
                                    <i class="fa-solid fa-trash-can"></i>
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <!-- Empty state -->
                <div class="med-empty-state" id="emptyOwn" style="display:none;">
                    <div class="med-empty-state__icon"><i class="fa-solid fa-capsules"></i></div>
                    <p class="med-empty-state__text">No personal medications added.</p>
                    <p class="med-empty-state__sub">Use the form below to add your own.</p>
                </div>
            </div>

            <!-- Approval Request Bar -->
            <div class="med-approval-bar">
                <div class="med-approval-bar__label">
                    <i class="fa-solid fa-paper-plane"></i>
                    <span>Request doctor approval</span>
                </div>
                <div class="med-approval-bar__controls">
                    <select id="ddlDoctor" class="med-select">
                        <option value="">Select Doctor...</option>
                        <option value="1">Dr. Ahmad Karimi</option>
                        <option value="2">Dr. Sara Hassan</option>
                        <option value="3">Dr. Karim Mansour</option>
                    </select>
                    <button class="med-btn med-btn--teal" onclick="sendApprovalRequest()" type="button">
                        <i class="fa-solid fa-paper-plane"></i>
                        Send Request
                    </button>
                </div>
            </div>

            <div id="requestMsg" class="med-inline-msg" style="display:none; margin: 0 26px 16px;"></div>

        </div>

    </div>

    <!-- ══════════════════════════════════════
         CUSTOM MEDICATION COLLAPSIBLE CARD
    ══════════════════════════════════════ -->
    <div class="med-card med-card--collapsible">
        <div class="med-card__header med-card__header--clickable"
             id="btnToggleCustom"
             onclick="toggleCustomForm()"
             role="button"
             tabindex="0"
             aria-expanded="false"
             aria-controls="customFormBody">
            <div class="med-card__title-group">
                <div class="med-card__icon med-card__icon--purple">
                    <i class="fa-solid fa-wand-magic-sparkles"></i>
                </div>
                <div>
                    <h2 class="med-card__title">Add Custom Medication</h2>
                    <p class="med-card__subtitle">Log a medication not in our database</p>
                </div>
            </div>
            <div class="med-collapse-arrow" id="collapseArrow">
                <i class="fa-solid fa-chevron-down"></i>
            </div>
        </div>

        <!-- Collapsible Body -->
        <div class="med-collapse-body" id="customFormBody" aria-hidden="true">
            <div class="med-custom-form">

                <div class="med-form-row">
                    <div class="med-form-group">
                        <label class="med-label">
                            <i class="fa-solid fa-pills"></i>
                            Medication Name <span class="med-required">*</span>
                        </label>
                        <input type="text" id="txtMedName" class="med-input" placeholder="e.g. Vitamin D3" />
                        <span class="med-error" id="errMedName" style="display:none;">Medication name is required.</span>
                    </div>
                    <div class="med-form-group">
                        <label class="med-label">
                            <i class="fa-solid fa-weight-scale"></i>
                            Dosage <span class="med-required">*</span>
                        </label>
                        <input type="text" id="txtDosage" class="med-input" placeholder="e.g. 500mg" />
                        <span class="med-error" id="errDosage" style="display:none;">Dosage is required.</span>
                    </div>
                </div>

                <div class="med-form-row">
                    <div class="med-form-group">
                        <label class="med-label">
                            <i class="fa-solid fa-clock"></i>
                            Frequency <span class="med-required">*</span>
                        </label>
                        <select id="ddlFrequency" class="med-input med-select-inline">
                            <option value="">Select frequency...</option>
                            <option>Once daily</option>
                            <option>Twice daily</option>
                            <option>Three times daily</option>
                            <option>Every 8 hours</option>
                            <option>As needed</option>
                            <option>Weekly</option>
                        </select>
                        <span class="med-error" id="errFrequency" style="display:none;">Frequency is required.</span>
                    </div>
                    <div class="med-form-group">
                        <label class="med-label">
                            <i class="fa-solid fa-calendar-day"></i>
                            Start Date
                        </label>
                        <input type="date" id="txtStartDate" class="med-input" />
                    </div>
                    <div class="med-form-group">
                        <label class="med-label">
                            <i class="fa-solid fa-calendar-xmark"></i>
                            End Date
                        </label>
                        <input type="date" id="txtEndDate" class="med-input" />
                    </div>
                </div>

                <div class="med-form-row med-form-row--full">
                    <div class="med-form-group med-form-group--full">
                        <label class="med-label">
                            <i class="fa-solid fa-note-sticky"></i>
                            Notes <small>(optional)</small>
                        </label>
                        <textarea id="txtNotes" class="med-input med-textarea" rows="3" placeholder="Any additional notes..."></textarea>
                    </div>
                </div>

                <div class="med-form-footer">
                    <div id="customMsg" class="med-inline-msg" style="display:none;"></div>
                    <button type="button" class="med-btn med-btn--save" onclick="saveCustomMed()">
                        <i class="fa-solid fa-floppy-disk"></i>
                        Save Medication
                    </button>
                </div>

            </div>
        </div>
    </div>

</div>

<!-- ══════════════════════════════════════
     ALL PAGE JAVASCRIPT
══════════════════════════════════════ -->
<script>
(function () {

    /* ── Card entrance animation ──────────────────────────────── */
    document.querySelectorAll('.med-card').forEach(function (card, i) {
        card.style.opacity    = '0';
        card.style.transform  = 'translateY(22px)';
        card.style.transition = 'opacity .5s ease, transform .5s ease';
        card.style.transitionDelay = (i * 100) + 'ms';
        setTimeout(function () {
            card.style.opacity   = '1';
            card.style.transform = 'translateY(0)';
        }, 60);
    });

    /* ── Collapse header keyboard support ─────────────────────── */
    var collapseHeader = document.getElementById('btnToggleCustom');
    if (collapseHeader) {
        collapseHeader.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                window.toggleCustomForm();
            }
        });
    }

    /* ── Live search filter for approved table ────────────────── */
    window.filterApprovedGrid = function (query) {
        query = query.toLowerCase();
        var rows  = document.querySelectorAll('#tblApproved tbody tr');
        var empty = document.getElementById('emptyApproved');
        var shown = 0;

        rows.forEach(function (row) {
            var match = row.textContent.toLowerCase().indexOf(query) !== -1;
            row.style.display = match ? '' : 'none';
            if (match) shown++;
        });

        if (empty) empty.style.display = shown === 0 ? 'block' : 'none';
    };

    /* ── Delete own medication row ────────────────────────────── */
    window.deleteOwnRow = function (btn) {
        if (!confirm('Remove this medication?')) return;
        var row   = btn.closest('tr');
        var tbody = document.querySelector('#tblOwn tbody');
        row.style.transition = 'opacity .3s ease, transform .3s ease';
        row.style.opacity    = '0';
        row.style.transform  = 'translateX(20px)';
        setTimeout(function () {
            row.remove();
            var remaining = tbody.querySelectorAll('tr').length;
            var empty     = document.getElementById('emptyOwn');
            if (empty) empty.style.display = remaining === 0 ? 'block' : 'none';
        }, 300);
    };

    /* ── Send approval request ────────────────────────────────── */
    window.sendApprovalRequest = function () {
        var select  = document.getElementById('ddlDoctor');
        var msgBox  = document.getElementById('requestMsg');
        var doctors = ['Dr. Ahmad Karimi', 'Dr. Sara Hassan', 'Dr. Karim Mansour'];

        if (!select.value) {
            showMsg(msgBox, 'error', '⚠ Please select a doctor first.');
            return;
        }
        var docName = select.options[select.selectedIndex].text;
        showMsg(msgBox, 'success', '✓ Approval request sent to ' + docName + ' successfully.');
        select.selectedIndex = 0;
    };

    /* ── Toggle collapsible custom form ───────────────────────── */
    window.toggleCustomForm = function () {
        var body   = document.getElementById('customFormBody');
        var arrow  = document.getElementById('collapseArrow');
        var header = document.getElementById('btnToggleCustom');
        var isOpen = body.classList.contains('med-collapse-body--open');

        if (isOpen) {
            body.style.maxHeight = body.scrollHeight + 'px';
            requestAnimationFrame(function () { body.style.maxHeight = '0px'; });
            setTimeout(function () {
                body.classList.remove('med-collapse-body--open');
                body.setAttribute('aria-hidden', 'true');
            }, 350);
            arrow.classList.remove('med-collapse-arrow--open');
            header.setAttribute('aria-expanded', 'false');
        } else {
            body.classList.add('med-collapse-body--open');
            body.setAttribute('aria-hidden', 'false');
            body.style.maxHeight = '0px';
            requestAnimationFrame(function () {
                body.style.maxHeight = body.scrollHeight + 'px';
            });
            setTimeout(function () { body.style.maxHeight = 'none'; }, 360);
            arrow.classList.add('med-collapse-arrow--open');
            header.setAttribute('aria-expanded', 'true');
        }
    };

    /* ── Save custom medication ───────────────────────────────── */
    window.saveCustomMed = function () {
        var name  = document.getElementById('txtMedName');
        var dose  = document.getElementById('txtDosage');
        var freq  = document.getElementById('ddlFrequency');
        var msgBox = document.getElementById('customMsg');
        var valid  = true;

        function setErr(input, errId, show) {
            var errEl = document.getElementById(errId);
            if (errEl) errEl.style.display = show ? 'block' : 'none';
            input.style.borderColor = show ? '#EF4444' : '';
        }

        setErr(name, 'errMedName',   !name.value.trim());
        setErr(dose, 'errDosage',    !dose.value.trim());
        setErr(freq, 'errFrequency', !freq.value);

        if (!name.value.trim() || !dose.value.trim() || !freq.value) return;

        /* Add row to own table */
        var tbody = document.querySelector('#tblOwn tbody');
        var empty = document.getElementById('emptyOwn');
        var rows  = tbody.querySelectorAll('tr');
        var isAlt = rows.length % 2 !== 0;

        var tr = document.createElement('tr');
        tr.className = 'med-grid-row' + (isAlt ? ' med-grid-row--alt' : '');
        tr.style.opacity   = '0';
        tr.style.transform = 'translateY(-10px)';
        tr.style.transition = 'opacity .35s ease, transform .35s ease';
        tr.innerHTML =
            '<td><div class="med-grid-pill"><div class="med-pill-dot med-pill-dot--blue"></div>' +
            '<span class="med-grid-name">' + escHtml(name.value.trim()) + '</span></div></td>' +
            '<td class="med-grid-cell">' + escHtml(dose.value.trim()) + '</td>' +
            '<td class="med-grid-cell">' + escHtml(freq.options[freq.selectedIndex].text) + '</td>' +
            '<td><span class="med-status-badge med-status-badge--orange"><i class="fa-solid fa-clock"></i> Pending</span></td>' +
            '<td><button class="med-delete-btn" onclick="deleteOwnRow(this)" title="Delete"><i class="fa-solid fa-trash-can"></i></button></td>';

        tbody.appendChild(tr);
        requestAnimationFrame(function () {
            tr.style.opacity   = '1';
            tr.style.transform = 'translateY(0)';
        });
        if (empty) empty.style.display = 'none';

        showMsg(msgBox, 'success', '✓ ' + escHtml(name.value.trim()) + ' added successfully!');

        /* Reset form */
        name.value  = '';
        dose.value  = '';
        freq.selectedIndex = 0;
        document.getElementById('txtStartDate').value = '';
        document.getElementById('txtEndDate').value   = '';
        document.getElementById('txtNotes').value     = '';
    };

    /* ── Helpers ──────────────────────────────────────────────── */
    function showMsg(el, type, text) {
        el.className = 'med-inline-msg med-inline-msg--' + type;
        el.textContent = text;
        el.style.display = 'inline-flex';
        setTimeout(function () {
            el.style.opacity = '0';
            el.style.transition = 'opacity .4s ease';
            setTimeout(function () {
                el.style.display  = 'none';
                el.style.opacity  = '1';
                el.style.transition = '';
            }, 400);
        }, 4000);
    }

    function escHtml(str) {
        return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
    }

})();
</script>

</asp:Content>