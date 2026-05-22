<%@ Page Title="Doctor Chat – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="DoctorChat.aspx.cs"
    Inherits="MediCare.Pages.Doctor.DoctorChat" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ── Shell ───────────────────────────────────────────── */
        .dc-shell {
            display: flex;
            gap: 24px;
            height: calc(100vh - 170px);
            min-height: 0;          /* let flex children shrink below content size */
        }

        /* ── Sidebar ─────────────────────────────────────────── */
        .dc-sidebar {
            width: 320px;
            flex-shrink: 0;
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            min-height: 0;
        }

        .dc-sidebar__header {
            padding: 18px 20px;
            border-bottom: 1px solid #f1f5f9;
            font-size: .78rem;
            font-weight: 700;
            color: #64748b;
            letter-spacing: .08em;
            text-transform: uppercase;
            flex-shrink: 0;
        }

        .dc-conversations {
            flex: 1;
            overflow-y: auto;
            min-height: 0;
        }

        .dc-conv {
            position: relative;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 18px;
            border-bottom: 1px solid #f8fafc;
            transition: background .15s ease;
        }

        .dc-conv:hover    { background: #f8fafc; }
        .dc-conv--active  { background: #ecfdf5; }

        .dc-avatar {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: #dcfce7;
            color: #166534;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            flex-shrink: 0;
        }

        .dc-conv__meta   { flex: 1; min-width: 0; }

        .dc-conv__name {
            font-size: .92rem;
            font-weight: 600;
            color: #0f172a;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .dc-conv__snippet {
            margin-top: 3px;
            font-size: .8rem;
            color: #64748b;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .dc-conv__badge {
            min-width: 20px;
            height: 20px;
            border-radius: 999px;
            background: #16a34a;
            color: white;
            font-size: .72rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0 6px;
            flex-shrink: 0;
        }

        /* ── Chat panel ──────────────────────────────────────── */
        .dc-chat {
            flex: 1;
            min-width: 0;
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            min-height: 0;
        }

        .dc-chat__header {
            padding: 18px 22px;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            gap: 14px;
            flex-shrink: 0;
        }

        .dc-chat__info h2 { font-size: 1rem; color: #0f172a; margin: 0; }
        .dc-chat__info p  { margin: 2px 0 0; font-size: .8rem; color: #64748b; }

        /* ── Inner chat wrapper (pnlChat renders as a div) ───── */
        .dc-chat-inner {
            display: flex;
            flex-direction: column;
            flex: 1;
            overflow: hidden;
        }

        /* ── Message list ────────────────────────────────────── */
        .dc-messages {
            flex: 1;
            overflow-y: auto;
            padding: 22px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            background: #f8fafc;
            min-height: 0;
        }

        .dc-row         { display: flex; align-items: flex-end; gap: 8px; }
        .dc-row--me     { justify-content: flex-end; }

        .dc-bubble {
            max-width: 70%;
            padding: 12px 15px;
            border-radius: 16px;
            font-size: .88rem;
            line-height: 1.55;
            word-break: break-word;
        }

        .dc-row--me   .dc-bubble { background: #16a34a; color: white;   border-bottom-right-radius: 4px; }
        .dc-row--them .dc-bubble { background: white;   border: 1px solid #e2e8f0; color: #0f172a; border-bottom-left-radius: 4px; }

        .dc-time {
            font-size: .7rem;
            color: #94a3b8;
            white-space: nowrap;
        }

        .dc-divider {
            text-align: center;
            font-size: .72rem;
            color: #94a3b8;
            margin: 8px 0;
        }

        /* ── Input bar ───────────────────────────────────────── */
        .dc-input {
            padding: 18px;
            border-top: 1px solid #f1f5f9;
            display: flex;
            gap: 12px;
            align-items: center;
            background: white;
            flex-shrink: 0;         /* never get squashed */
        }

        .dc-input textarea {
            flex: 1;
            resize: none;
            border: 1px solid #dbe2ea;
            border-radius: 14px;
            padding: 12px 14px;
            min-height: 50px;
            max-height: 120px;
            font-size: .88rem;
            outline: none;
            font-family: inherit;
        }

        .dc-input textarea:focus { border-color: #16a34a; }

        .dc-send {
            width: 50px;
            height: 50px;
            border-radius: 14px;
            border: none;
            background: #16a34a;
            color: white;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 700;
            flex-shrink: 0;
        }

        .dc-send:hover { background: #15803d; }

        /* ── Empty state ─────────────────────────────────────── */
        .dc-empty {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #94a3b8;
            font-size: .95rem;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="sm" runat="server" />

    <div class="dc-shell">

        <!-- SIDEBAR -->
        <div class="dc-sidebar">

            <div class="dc-sidebar__header">Patient Conversations</div>

            <div class="dc-conversations">
                <asp:Repeater ID="rptConversations"
                              runat="server"
                              OnItemCommand="rptConversations_ItemCommand">
                    <ItemTemplate>
                        <div class='dc-conv <%# (int)Eval("ConversationID") == SelectedConvID ? "dc-conv--active" : "" %>'>

                            <div class="dc-avatar">
                                <%# GetInitials(Eval("PatientName").ToString()) %>
                            </div>

                            <div class="dc-conv__meta">
                                <div class="dc-conv__name"><%# Eval("PatientName") %></div>
                                <div class="dc-conv__snippet"><%# Eval("LastSnippet") %></div>
                            </div>

                            <%# Convert.ToInt32(Eval("UnreadCount")) > 0
                                ? "<div class='dc-conv__badge'>" + Eval("UnreadCount") + "</div>"
                                : "" %>

                            <asp:LinkButton ID="btnSelect"
                                            runat="server"
                                            CommandName="Open"
                                            CommandArgument='<%# Eval("ConversationID") %>'
                                            Style="position:absolute;inset:0;opacity:0;" />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

        </div>

        <!-- CHAT PANEL -->
        <div class="dc-chat">

            <asp:Panel ID="pnlNoChat" runat="server" CssClass="dc-empty">
                Select a patient conversation
            </asp:Panel>

            <%-- CssClass drives display; no inline style needed --%>
            <asp:Panel ID="pnlChat" runat="server" Visible="false" CssClass="dc-chat-inner">

                <div class="dc-chat__header">
                    <div class="dc-avatar">
                        <asp:Literal ID="litPatientInitials" runat="server" />
                    </div>
                    <div class="dc-chat__info">
                        <h2><asp:Literal ID="litPatientName" runat="server" /></h2>
                        <p>Patient Conversation</p>
                    </div>
                </div>

                <%-- Single UpdatePanel: messages + timer only; input stays outside --%>
                <asp:UpdatePanel ID="upMessages" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>

                        <asp:Timer ID="timerRefresh"
                                   runat="server"
                                   Interval="4000"
                                   OnTick="timerRefresh_Tick" />

                        <div class="dc-messages dc-up-messages" id="msgWrap">
                            <asp:Repeater ID="rptMessages" runat="server">
                                <ItemTemplate>

                                    <%# (bool)Eval("ShowDivider")
                                        ? "<div class='dc-divider'>" + Eval("DayLabel") + "</div>"
                                        : "" %>

                                    <div class='dc-row <%# (bool)Eval("IsMe") ? "dc-row--me" : "dc-row--them" %>'>
                                        <div class="dc-bubble">
                                            <%# System.Web.HttpUtility.HtmlEncode(Eval("Body").ToString()).Replace("&#10;","<br/>") %>
                                        </div>
                                        <div class="dc-time">
                                            <%# Convert.ToDateTime(Eval("SentAt")).ToString("h:mm tt") %>
                                        </div>
                                    </div>

                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="timerRefresh" EventName="Tick" />
                        <asp:AsyncPostBackTrigger ControlID="btnSend" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>

                <%-- Input bar lives outside UpdatePanel so it never disappears --%>
                <div class="dc-input">
                    <textarea id="txtMsg"
                              runat="server"
                              placeholder="Type your message..."></textarea>

                    <asp:Button ID="btnSend"
                                runat="server"
                                Text="➜"
                                CssClass="dc-send"
                                OnClick="btnSend_Click"
                                UseSubmitBehavior="false" />
                </div>

            </asp:Panel>

        </div>
    </div>

<script type="text/javascript">
// @ts-nocheck
(function () {
    function sizeAndScroll() {
        var shell = document.querySelector('.dc-shell');
        var header = document.querySelector('.dc-chat__header');
        var inputBar = document.querySelector('.dc-input');
        var msgWrap = document.getElementById('msgWrap');

        if (!shell || !msgWrap) return;

        var shellH = shell.offsetHeight;
        var headerH = header ? header.offsetHeight : 0;
        var inputH = inputBar ? inputBar.offsetHeight : 0;

        msgWrap.style.height = (shellH - headerH - inputH) + 'px';
        msgWrap.style.overflowY = 'auto';

        msgWrap.scrollTop = msgWrap.scrollHeight;
    }

    window.addEventListener('load', sizeAndScroll);
    window.addEventListener('resize', sizeAndScroll);

    var aspSys = window['Sys'];
    if (aspSys && aspSys.WebForms && aspSys.WebForms.PageRequestManager) {
        aspSys.WebForms.PageRequestManager.getInstance().add_endRequest(sizeAndScroll);
    }
})();
</script>
</asp:Content>
