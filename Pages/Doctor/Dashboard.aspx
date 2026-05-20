<%@ Page Title="Doctor Dashboard – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="Dashboard.aspx.cs"
    Inherits="MediCare.Pages.Doctor.Dashboard" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        .db-container { max-width: 1200px; margin: 30px auto; padding: 0 20px; font-family: 'Segoe UI', system-ui, sans-serif; }
        .db-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 30px; }
        @media(max-width: 992px) { .db-grid { grid-template-columns: 1fr; } }
        
        .db-card { background: #fff; border-radius: 10px; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); margin-bottom: 25px; overflow: hidden; }
        .db-card__header { background: #fff; padding: 20px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .db-card__title { font-size: 1.15rem; font-weight: 600; color: #1e293b; margin: 0; display: flex; align-items: center; gap: 10px; }
        .db-card__body { padding: 20px; }
        
        .db-table { width: 100%; border-collapse: collapse; text-align: left; font-size: 0.9rem; }
        .db-table th { background: #f8fafc; color: #64748b; font-weight: 600; padding: 12px 16px; border-bottom: 1px solid #e2e8f0; }
        .db-table td { padding: 14px 16px; border-bottom: 1px solid #f1f5f9; color: #334155; vertical-align: middle; }
        
        .btn-db { padding: 6px 12px; border-radius: 6px; font-size: 0.85rem; font-weight: 500; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; text-decoration: none; }
        .btn-db--success { background: #d1fae5; color: #065f46; }
        .btn-db--success:hover { background: #10b981; color: #fff; }
        .btn-db--danger { background: #fee2e2; color: #991b1b; }
        .btn-db--danger:hover { background: #ef4444; color: #fff; }
        .btn-db--primary { background: #0284c7; color: #fff; padding: 8px 16px; }
        .btn-db--primary:hover { background: #0369a1; }
        .btn-db--warning { background: #fffbeb; color: #b45309; border: 1px solid #fde68a; }
        .btn-db--warning:hover { background: #f59e0b; color: #fff; }
        
        .badge-status { padding: 4px 8px; border-radius: 12px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; }
        .badge-status--reserved { background: #e0f2fe; color: #0369a1; }
        .badge-status--open { background: #f0fdf4; color: #16a34a; }
        
        .form-vertical { display: flex; flex-direction: column; gap: 15px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-label { font-size: 0.85rem; font-weight: 500; color: #475569; }
        .form-input { padding: 10px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 0.9rem; color: #334155; }
        
        .empty-state { text-align: center; padding: 30px 10px; color: #94a3b8; font-size: 0.9rem; }
        .db-alert { padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; font-size: 0.9rem; display: flex; align-items: center; gap: 10px; }
        .db-alert--success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
        .db-alert--error { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
    </style>
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">
<div class="db-container">

    <asp:Panel ID="pnlGlobalAlert" runat="server" Visible="false">
        <i id="alertIcon" runat="server" class="fa-solid"></i>
        <asp:Label ID="lblAlertMessage" runat="server" />
    </asp:Panel>

    <div class="db-grid">
        
        <div>
            <div class="db-card">
                <div class="db-card__header">
                    <h2 class="db-card__title"><i class="fa-solid fa-bell-concierge" style="color: #f59e0b;"></i> Incoming Appointment Requests</h2>
                </div>
                <div class="db-card__body">
                    <asp:Repeater ID="rptIncomingRequests" runat="server" OnItemCommand="rptIncomingRequests_ItemCommand">
                        <HeaderTemplate>
                            <table class="db-table">
                                <thead>
                                    <tr>
                                        <th>Patient Name</th>
                                        <th>Target DateTime Slot</th>
                                        <th>Reason/Notes</th>
                                        <th style="text-align: right;">Action Matrix</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><strong><%# Eval("PatientName") %></strong></td>
                                <td><i class="fa-regular fa-calendar-days"></i> <%# Convert.ToDateTime(Eval("AppointmentDate")).ToString("yyyy-MM-dd HH:mm") %></td>
                                <td><%# string.IsNullOrEmpty(Eval("Reason").ToString()) ? "None" : Eval("Reason") %></td>
                                <td style="text-align: right; display: flex; justify-content: flex-end; gap: 8px;">
                                    <asp:LinkButton ID="lnkAccept" runat="server" CommandName="AcceptRequest" CommandArgument='<%# Eval("AppointmentId") %>' CssClass="btn-db btn-db--success"><i class="fa-solid fa-check"></i> Accept</asp:LinkButton>
                                    <asp:LinkButton ID="lnkReject" runat="server" CommandName="RejectRequest" CommandArgument='<%# Eval("AppointmentId") %>' CssClass="btn-db btn-db--danger" OnClientClick="return confirm('Reject this request?');"><i class="fa-solid fa-xmark"></i> Reject</asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate></tbody></table></FooterTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoRequests" runat="server" CssClass="empty-state" Visible="false">No pending requests.</asp:Panel>
                </div>
            </div>

            <div class="db-card">
                <div class="db-card__header">
                    <h2 class="db-card__title"><i class="fa-solid fa-calendar-check" style="color: #0284c7;"></i> Active Reserved Appointments</h2>
                </div>
                <div class="db-card__body">
                    <asp:Repeater ID="rptReservedAppointments" runat="server" OnItemCommand="rptReservedAppointments_ItemCommand">
                        <HeaderTemplate>
                            <table class="db-table">
                                <thead>
                                    <tr>
                                        <th>Patient Name</th>
                                        <th>Allocated Time Slot</th>
                                        <th>Status</th>
                                        <th style="text-align: right;">Operations</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><strong><%# Eval("PatientName") %></strong></td>
                                <td><i class="fa-regular fa-clock"></i> <%# Convert.ToDateTime(Eval("AppointmentDate")).ToString("yyyy-MM-dd HH:mm") %> – <%# Convert.ToDateTime(Eval("AppointmentDate")).AddHours(1).ToString("HH:mm") %></td>
                                <td><span class="badge-status badge-status--reserved"><%# Eval("Status") %></span></td>
                                <td style="text-align: right;">
                                    <asp:LinkButton ID="lnkCancelAppointment" runat="server" CommandName="CancelBooking" CommandArgument='<%# Eval("AppointmentId") %>' CssClass="btn-db btn-db--danger" OnClientClick="return confirm('Cancel this reserved timeline slot? This automatically alerts the patient.');"><i class="fa-solid fa-ban"></i> Cancel Booking</asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate></tbody></table></FooterTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoReserved" runat="server" CssClass="empty-state" Visible="false">No confirmed reservations.</asp:Panel>
                </div>
            </div>
        </div>

        <div>
            <div class="db-card">
                <div class="db-card__header">
                    <h2 class="db-card__title"><i class="fa-solid fa-calendar-plus" style="color: #16a34a;"></i> Weekday Slot Generator</h2>
                </div>
                <div class="db-card__body">
                    <div class="form-vertical">
                        <div class="form-group">
                            <label class="form-label">Daily Shift Start Time</label>
                            <asp:TextBox ID="txtStartTime" runat="server" TextMode="Time" CssClass="form-input" />
                        </div>
                        <div class="form-group">
                            <label class="form-label">Daily Shift End Time</label>
                            <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time" CssClass="form-input" />
                        </div>
                        <asp:Button ID="btnGenerateRecurring" runat="server" OnClick="btnGenerateRecurring_Click" CssClass="btn-db btn-db--primary" Style="width:100%; text-align:center; justify-content:center;" Text="Generate Weekday Windows" />
                    </div>
                </div>
            </div>

            <div class="db-card">
                <div class="db-card__header">
                    <h2 class="db-card__title"><i class="fa-solid fa-calendar-minus" style="color: #e11d48;"></i> Cancel Specific Hour Slot</h2>
                </div>
                <div class="db-card__body">
                    <div class="form-vertical">
                        <p style="font-size: 0.8rem; color: #64748b; margin:0;">
                            Removes availability or cancels a booking at a specific hour. If a patient is booked, they will be automatically notified.
                        </p>
                        <div class="form-group">
                            <label class="form-label">Target Date</label>
                            <asp:TextBox ID="txtSpecificDay" runat="server" TextMode="Date" CssClass="form-input" />
                        </div>
                        <div class="form-group">
                            <label class="form-label">Target Hour Start (1-Hour Block)</label>
                            <asp:TextBox ID="txtSpecificHour" runat="server" TextMode="Time" CssClass="form-input" />
                        </div>
                        <asp:Button ID="btnCancelSpecificHour" runat="server" OnClick="btnCancelSpecificHour_Click" CssClass="btn-db btn-db--danger" Style="width:100%; text-align:center; justify-content:center;" Text="Surgically Drop Hour Block" OnClientClick="return confirm('Execute block cancellation pipeline? Any existing patient booked here will be dropped and notified.');" />
                    </div>
                </div>
            </div>

            <div class="db-card">
                <div class="db-card__header">
                    <h2 class="db-card__title"><i class="fa-solid fa-list-ul"></i> Published Open Slots</h2>
                </div>
                <div class="db-card__body">
                    <asp:Repeater ID="rptAvailabilityBlocks" runat="server" OnItemCommand="rptAvailabilityBlocks_ItemCommand">
                        <HeaderTemplate><table class="db-table"><thead><tr><th>Window Slot</th><th style="text-align: right;">Action</th></tr></thead><tbody></HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td style="font-size: 0.85rem;">
                                    <span class="badge-status badge-status--open"><%# Convert.ToDateTime(Eval("StartTime")).ToString("dddd") %></span><br />
                                    <%# Convert.ToDateTime(Eval("StartTime")).ToString("yyyy-MM-dd HH:mm") %> - <%# Convert.ToDateTime(Eval("EndTime")).ToString("HH:mm") %>
                                </td>
                                <td style="text-align: right;">
                                    <asp:LinkButton ID="lnkDeleteBlock" runat="server" CommandName="DeleteBlock" CommandArgument='<%# Eval("AvailabilityId") %>' ForeColor="#ef4444" OnClientClick="return confirm('Withdraw open slot?');"><i class="fa-solid fa-trash-can"></i></asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate></tbody></table></FooterTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlNoAvailability" runat="server" CssClass="empty-state" Visible="false">No open slots published.</asp:Panel>
                </div>
            </div>
        </div>

    </div>
</div>
</asp:Content>