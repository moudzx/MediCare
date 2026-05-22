<%@ Page Title="Doctor Dashboard – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="MediCare.Pages.Doctor.Dashboard" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        :root {
            --bg: #f0f4f8;
            --surface: #ffffff;
            --border: #dde3ec;
            --text-primary: #1a2332;
            --text-secondary: #5a6a7e;
            --text-muted: #94a3b8;
            --accent: #1d6fdb;
            --accent-hover: #1558b0;
            --success: #0e7a4f;
            --success-bg: #d1fae5;
            --success-border: #6ee7b7;
            --danger: #b91c1c;
            --danger-bg: #fee2e2;
            --danger-border: #fca5a5;
            --warning: #92400e;
            --warning-bg: #fef3c7;
            --info-bg: #e0f2fe;
            --info: #0369a1;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.07), 0 1px 2px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 12px rgba(0,0,0,0.08);
            --radius: 10px;
            --radius-sm: 6px;
        }

        * { box-sizing: border-box; }

        body { background: var(--bg); }

        .dash-wrap {
            max-width: 1260px;
            margin: 28px auto;
            padding: 0 20px;
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            color: var(--text-primary);
        }

        .dash-page-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0 0 24px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .dash-grid {
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 24px;
            align-items: start;
        }

        @media (max-width: 1024px) { .dash-grid { grid-template-columns: 1fr; } }

        /* ── Card ── */
        .card {
            background: var(--surface);
            border-radius: var(--radius);
            border: 1px solid var(--border);
            box-shadow: var(--shadow-sm);
            margin-bottom: 22px;
            overflow: hidden;
        }

        .card-head {
            padding: 16px 20px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #fafbfc;
        }

        .card-title {
            font-size: 1rem;
            font-weight: 650;
            color: var(--text-primary);
            margin: 0;
            display: flex;
            align-items: center;
            gap: 9px;
        }

        .card-body { padding: 18px 20px; }

        /* ── Table ── */
        .dt {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.875rem;
        }

        .dt th {
            background: #f8fafc;
            color: var(--text-secondary);
            font-weight: 600;
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            padding: 10px 14px;
            border-bottom: 1px solid var(--border);
            white-space: nowrap;
        }

        .dt td {
            padding: 13px 14px;
            border-bottom: 1px solid #f1f5f9;
            color: var(--text-primary);
            vertical-align: middle;
        }

        .dt tr:last-child td { border-bottom: none; }

        /* ── Buttons ── */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 13px;
            border-radius: var(--radius-sm);
            font-size: 0.83rem;
            font-weight: 550;
            border: none;
            cursor: pointer;
            transition: background 0.15s, color 0.15s, transform 0.1s;
            text-decoration: none;
            white-space: nowrap;
        }

        .btn:active { transform: scale(0.97); }

        .btn-primary { background: var(--accent); color: #fff; }
        .btn-primary:hover { background: var(--accent-hover); color: #fff; }

        .btn-success { background: var(--success-bg); color: var(--success); }
        .btn-success:hover { background: #10b981; color: #fff; }

        .btn-danger { background: var(--danger-bg); color: var(--danger); }
        .btn-danger:hover { background: #ef4444; color: #fff; }

        .btn-ghost-danger {
            background: transparent;
            color: #ef4444;
            border: 1px solid #fca5a5;
            padding: 5px 9px;
        }
        .btn-ghost-danger:hover { background: var(--danger-bg); }

        .btn-full { width: 100%; justify-content: center; padding: 10px; }

        /* ── Badges ── */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 3px 9px;
            border-radius: 20px;
            font-size: 0.73rem;
            font-weight: 650;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .badge-pending  { background: var(--warning-bg); color: var(--warning); }
        .badge-accepted { background: var(--info-bg); color: var(--info); }
        .badge-open     { background: #f0fdf4; color: #16a34a; }

        /* ── Form ── */
        .form-stack { display: flex; flex-direction: column; gap: 14px; }

        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }

        .form-group { display: flex; flex-direction: column; gap: 5px; }

        .form-label {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-secondary);
        }

        .form-ctrl {
            padding: 9px 11px;
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 0.875rem;
            color: var(--text-primary);
            background: #fff;
            transition: border-color 0.15s, box-shadow 0.15s;
        }

        .form-ctrl:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(29,111,219,0.12);
        }

        .form-hint {
            font-size: 0.77rem;
            color: var(--text-muted);
            margin: 0;
            line-height: 1.5;
        }

        .divider {
            border: none;
            border-top: 1px solid var(--border);
            margin: 16px 0;
        }

        /* ── Alert ── */
        .alert {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 12px 16px;
            border-radius: var(--radius-sm);
            font-size: 0.875rem;
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .alert-success { background: var(--success-bg); color: var(--success); border: 1px solid var(--success-border); }
        .alert-error   { background: var(--danger-bg);  color: var(--danger);  border: 1px solid var(--danger-border); }

        /* ── Empty state ── */
        .empty {
            text-align: center;
            padding: 28px 12px;
            color: var(--text-muted);
            font-size: 0.875rem;
        }

        .empty i { display: block; font-size: 2rem; margin-bottom: 8px; opacity: 0.4; }

        /* ── Slot item ── */
        .slot-row td:first-child { font-size: 0.82rem; }
        .slot-day { font-weight: 600; color: var(--text-primary); margin-bottom: 2px; }
        .slot-time { color: var(--text-secondary); }

        /* ── Section label ── */
        .section-label {
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-muted);
            margin: 0 0 10px 0;
        }
    </style>
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="dash-wrap">

    <h1 class="dash-page-title">
        <i class="fa-solid fa-stethoscope" style="color: var(--accent);"></i>
        Doctor Dashboard
    </h1>

    <asp:Panel ID="pnlAlert" runat="server" Visible="false">
        <i id="alertIcon" runat="server"></i>
        <asp:Label ID="lblAlert" runat="server" />
    </asp:Panel>

    <div class="dash-grid">

        <%-- ══════════════ LEFT COLUMN ══════════════ --%>
        <div>

            <%-- Pending Requests --%>
            <div class="card">
                <div class="card-head">
                    <h2 class="card-title">
                        <i class="fa-solid fa-bell" style="color:#f59e0b;"></i>
                        Incoming Appointment Requests
                    </h2>
                </div>
                <div class="card-body" style="padding:0;">
                    <asp:Repeater ID="rptPending" runat="server" OnItemCommand="rptPending_ItemCommand">
                        <HeaderTemplate>
                            <table class="dt">
                                <thead>
                                    <tr>
                                        <th>Patient</th>
                                        <th>Requested Slot</th>
                                        <th>Reason</th>
                                        <th style="text-align:right;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><strong><%# Eval("PatientName") %></strong></td>
                                <td>
                                    <i class="fa-regular fa-calendar" style="color:var(--accent);margin-right:4px;"></i>
                                    <%# Convert.ToDateTime(Eval("AppointmentDate")).ToString("ddd, MMM dd yyyy") %><br />
                                    <small style="color:var(--text-secondary);"><%# Convert.ToDateTime(Eval("AppointmentDate")).ToString("HH:mm") %> – <%# Convert.ToDateTime(Eval("AppointmentDate")).AddHours(1).ToString("HH:mm") %></small>
                                </td>
                                <td style="color:var(--text-secondary);"><%# string.IsNullOrEmpty(Eval("Reason") == null ? null : Eval("Reason").ToString()) ? "—" : Eval("Reason") %></td>
                                <td style="text-align:right;">
                                    <div style="display:flex;gap:6px;justify-content:flex-end;">
                                        <asp:LinkButton runat="server" CommandName="Accept" CommandArgument='<%# Eval("AppointmentId") %>' CssClass="btn btn-success"><i class="fa-solid fa-check"></i> Accept</asp:LinkButton>
                                        <asp:LinkButton runat="server" CommandName="Reject" CommandArgument='<%# Eval("AppointmentId") %>' CssClass="btn btn-danger" OnClientClick="return confirm('Reject this appointment request?');"><i class="fa-solid fa-xmark"></i> Reject</asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate></tbody></table></FooterTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoPending" runat="server" Visible="false">
                        <div class="empty"><i class="fa-regular fa-bell-slash"></i>No pending requests.</div>
                    </asp:Panel>
                </div>
            </div>

            <%-- Accepted Appointments --%>
            <div class="card">
                <div class="card-head">
                    <h2 class="card-title">
                        <i class="fa-solid fa-calendar-check" style="color:#0284c7;"></i>
                        Confirmed Appointments
                    </h2>
                </div>
                <div class="card-body" style="padding:0;">
                    <asp:Repeater ID="rptAccepted" runat="server" OnItemCommand="rptAccepted_ItemCommand">
                        <HeaderTemplate>
                            <table class="dt">
                                <thead>
                                    <tr>
                                        <th>Patient</th>
                                        <th>Time Slot</th>
                                        <th>Status</th>
                                        <th style="text-align:right;">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><strong><%# Eval("PatientName") %></strong></td>
                                <td>
                                    <i class="fa-regular fa-clock" style="color:var(--accent);margin-right:4px;"></i>
                                    <%# Convert.ToDateTime(Eval("AppointmentDate")).ToString("ddd, MMM dd yyyy") %><br />
                                    <small style="color:var(--text-secondary);"><%# Convert.ToDateTime(Eval("AppointmentDate")).ToString("HH:mm") %> – <%# Convert.ToDateTime(Eval("AppointmentDate")).AddHours(1).ToString("HH:mm") %></small>
                                </td>
                                <td><span class="badge badge-accepted"><%# Eval("Status") %></span></td>
                                <td style="text-align:right;">
                                    <asp:LinkButton runat="server" CommandName="Cancel" CommandArgument='<%# Eval("AppointmentId") %>' CssClass="btn btn-danger" OnClientClick="return confirm('Cancel this appointment? The patient will be notified.');"><i class="fa-solid fa-ban"></i> Cancel</asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate></tbody></table></FooterTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoAccepted" runat="server" Visible="false">
                        <div class="empty"><i class="fa-regular fa-calendar-xmark"></i>No confirmed appointments.</div>
                    </asp:Panel>
                </div>
            </div>

        </div>

        <%-- ══════════════ RIGHT COLUMN ══════════════ --%>
        <div>

            <%-- ── Range Generator ── --%>
            <div class="card">
                <div class="card-head">
                    <h2 class="card-title">
                        <i class="fa-solid fa-calendar-plus" style="color:#16a34a;"></i>
                        Generate Slots by Range
                    </h2>
                </div>
                <div class="card-body">
                    <div class="form-stack">
                        <p class="form-hint">Creates hourly 1-hour slots for every weekday in the selected date range, between the chosen start and end hours.</p>
                        <p class="section-label">Date Range</p>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">From Date</label>
                                <asp:TextBox ID="txtRangeFromDate" runat="server" TextMode="Date" CssClass="form-ctrl" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">To Date</label>
                                <asp:TextBox ID="txtRangeToDate" runat="server" TextMode="Date" CssClass="form-ctrl" />
                            </div>
                        </div>
                        <p class="section-label" style="margin-top:4px;">Hour Range (Daily)</p>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Start Time</label>
                                <asp:TextBox ID="txtRangeStartTime" runat="server" TextMode="Time" CssClass="form-ctrl" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">End Time</label>
                                <asp:TextBox ID="txtRangeEndTime" runat="server" TextMode="Time" CssClass="form-ctrl" />
                            </div>
                        </div>
                        <asp:CheckBox ID="chkIncludeWeekends" runat="server" Text=" Include weekends" CssClass="form-hint" />
                        <asp:Button ID="btnGenerateRange" runat="server" OnClick="btnGenerateRange_Click" CssClass="btn btn-primary btn-full" Text="Generate Slots" />
                    </div>
                </div>
            </div>

            <%-- ── Add Specific Slot ── --%>
            <div class="card">
                <div class="card-head">
                    <h2 class="card-title">
                        <i class="fa-solid fa-plus" style="color:#7c3aed;"></i>
                        Add Specific Slot
                    </h2>
                </div>
                <div class="card-body">
                    <div class="form-stack">
                        <p class="form-hint">Add a single 1-hour availability slot on a specific day and hour.</p>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Date</label>
                                <asp:TextBox ID="txtSpecificDate" runat="server" TextMode="Date" CssClass="form-ctrl" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">Hour Start</label>
                                <asp:TextBox ID="txtSpecificHour" runat="server" TextMode="Time" CssClass="form-ctrl" />
                            </div>
                        </div>
                        <asp:Button ID="btnAddSpecific" runat="server" OnClick="btnAddSpecific_Click" CssClass="btn btn-primary btn-full" Text="Add Slot" />
                    </div>
                </div>
            </div>

            <%-- ── Delete Specific Slot ── --%>
            <div class="card">
                <div class="card-head">
                    <h2 class="card-title">
                        <i class="fa-solid fa-scissors" style="color:#e11d48;"></i>
                        Remove Specific Slot
                    </h2>
                </div>
                <div class="card-body">
                    <div class="form-stack">
                        <p class="form-hint">Deletes the open slot at this date &amp; hour. If a patient is booked, they will be automatically notified.</p>
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Date</label>
                                <asp:TextBox ID="txtDropDate" runat="server" TextMode="Date" CssClass="form-ctrl" />
                            </div>
                            <div class="form-group">
                                <label class="form-label">Hour Start</label>
                                <asp:TextBox ID="txtDropHour" runat="server" TextMode="Time" CssClass="form-ctrl" />
                            </div>
                        </div>
                        <asp:Button ID="btnDropSlot" runat="server" OnClick="btnDropSlot_Click" CssClass="btn btn-danger btn-full" Text="Remove Slot" OnClientClick="return confirm('Remove this slot? Any existing booking will be cancelled and the patient notified.');" />
                    </div>
                </div>
            </div>

            <%-- ── Open Slots List ── --%>
            <div class="card">
                <div class="card-head">
                    <h2 class="card-title">
                        <i class="fa-solid fa-list-ul"></i>
                        Open Availability Slots
                    </h2>
                </div>
                <div class="card-body" style="padding:0;">
                    <asp:Repeater ID="rptSlots" runat="server" OnItemCommand="rptSlots_ItemCommand">
                        <HeaderTemplate>
                            <table class="dt">
                                <thead>
                                    <tr>
                                        <th>Slot</th>
                                        <th style="text-align:right;">Remove</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr class="slot-row">
                                <td>
                                    <div class="slot-day"><%# Convert.ToDateTime(Eval("StartTime")).ToString("ddd, MMM dd yyyy") %></div>
                                    <div class="slot-time"><%# Convert.ToDateTime(Eval("StartTime")).ToString("HH:mm") %> – <%# Convert.ToDateTime(Eval("EndTime")).ToString("HH:mm") %></div>
                                </td>
                                <td style="text-align:right;">
                                    <asp:LinkButton runat="server" CommandName="Delete" CommandArgument='<%# Eval("AvailabilityId") %>' CssClass="btn btn-ghost-danger" OnClientClick="return confirm('Withdraw this open slot?');"><i class="fa-solid fa-trash-can"></i></asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate></tbody></table></FooterTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoSlots" runat="server" Visible="false">
                        <div class="empty"><i class="fa-regular fa-calendar"></i>No open slots published.</div>
                    </asp:Panel>
                </div>
            </div>

        </div>
    </div>
</div>
</asp:Content>
