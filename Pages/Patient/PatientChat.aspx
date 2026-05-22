<%@ Page Title="Messages – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="PatientChat.aspx.cs"
    Inherits="MediCare.Pages.Patient.PatientChat" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* ── Shell ───────────────────────────────────────────── */
        .chat-shell {
            display: flex;
            gap: 20px;
            height: calc(100vh - 180px);
            margin-top: 24px;
            min-height: 0;          /* let flex children shrink below content size */
        }

        /* ── Sidebar ─────────────────────────────────────────── */
        .sidebar {
            width: 300px;
            flex-shrink: 0;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 18px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            min-height: 0;
        }

        .sidebar-header {
            padding: 18px 20px;
            border-bottom: 1px solid #f3f4f6;
            font-size: 13px;
            font-weight: 700;
            color: #6b7280;
            letter-spacing: .08em;
            text-transform: uppercase;
            flex-shrink: 0;
        }

        .conv-list {
            overflow-y: auto;
            flex: 1;
            min-height: 0;
        }

        .conv-item {
            display: flex;
            gap: 12px;
            align-items: center;
            padding: 14px 18px;
            position: relative;
            border-left: 3px solid transparent;
            transition: background .15s ease;
        }

        .conv-item:hover  { background: #f9fafb; }
        .conv-item.active { background: #ecfdf5; border-left-color: #16a34a; }

        .avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: #dcfce7;
            color: #16a34a;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .conv-meta  { flex: 1; min-width: 0; }

        .conv-name {
            font-size: 14px;
            font-weight: 600;
            color: #111827;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .conv-snip {
            font-size: 12px;
            color: #6b7280;
            margin-top: 3px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .conv-badge {
            min-width: 18px;
            height: 18px;
            padding: 0 5px;
            border-radius: 999px;
            background: #16a34a;
            color: #fff;
            font-size: 10px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        /* ── Chat panel ──────────────────────────────────────── */
        .chat-panel {
            flex: 1;
            min-width: 0;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 18px;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            min-height: 0;
        }

        /* pnlChat inner wrapper */
        .chat-inner {
            display: flex;
            flex-direction: column;
            flex: 1;
            overflow: hidden;
        }

        .chat-header {
            padding: 18px 22px;
            border-bottom: 1px solid #f3f4f6;
            display: flex;
            align-items: center;
            gap: 14px;
            flex-shrink: 0;
        }

        .chat-header h2 { font-size: 16px; margin: 0; color: #111827; }
        .chat-header p  { margin: 2px 0 0; font-size: 13px; color: #6b7280; }

        /* ── Message list ────────────────────────────────────── */
        .messages-wrap {
            flex: 1;
            overflow-y: auto;
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 14px;
            background: #f9fafb;
            min-height: 0;
        }

        .msg-divider {
            text-align: center;
            font-size: 11px;
            color: #9ca3af;
            margin: 4px 0;
        }

        .msg-row      { display: flex; gap: 8px; align-items: flex-end; }
        .msg-row.me   { justify-content: flex-end; }

        .bubble {
            max-width: 70%;
            padding: 11px 14px;
            border-radius: 16px;
            font-size: 14px;
            line-height: 1.5;
            word-break: break-word;
        }

        .msg-row.me   .bubble { background: #16a34a; color: #fff;     border-bottom-right-radius: 4px; }
        .msg-row.them .bubble { background: #fff;    border: 1px solid #e5e7eb; color: #111827; border-bottom-left-radius: 4px; }

        .msg-time {
            font-size: 11px;
            color: #6b7280;
            white-space: nowrap;
        }

        /* ── Input bar ───────────────────────────────────────── */
        .input-bar {
            padding: 18px;
            border-top: 1px solid #f3f4f6;
            display: flex;
            gap: 12px;
            background: #fff;
            flex-shrink: 0;         /* never get squashed */
            align-items: center;
        }

        .msg-input {
            flex: 1;
            border: 1px solid #d1d5db;
            border-radius: 14px;
            padding: 12px 14px;
            resize: none;
            outline: none;
            font-family: inherit;
            font-size: 14px;
            min-height: 46px;
            max-height: 120px;
        }

        .msg-input:focus { border-color: #16a34a; }

        .send-btn {
            width: 46px;
            height: 46px;
            border: none;
            border-radius: 14px;
            background: #16a34a;
            color: #fff;
            cursor: pointer;
            font-size: 18px;
            flex-shrink: 0;
        }

        .send-btn:hover { background: #15803d; }

        .no-chat-selected {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6b7280;
            font-size: 15px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:ScriptManager ID="sm" runat="server" EnablePartialRendering="true" />

    <div class="mc-container">
        <div class="chat-shell">

            <!-- SIDEBAR -->
            <div class="sidebar">

                <div class="sidebar-header">My Doctors</div>

                <div class="conv-list">
                    <asp:Repeater ID="rptConversations"
                        runat="server"
                        OnItemCommand="rptConversations_ItemCommand">
                        <ItemTemplate>
                            <div class='conv-item <%# (int)Eval("ConversationID") == SelectedConvID ? "active" : "" %>'>

                                <div class="avatar">
                                    <%# GetInitials(Eval("DoctorName").ToString()) %>
                                </div>

                                <div class="conv-meta">
                                    <div class="conv-name">Dr. <%# Eval("DoctorName") %></div>
                                    <div class="conv-snip"><%# Eval("LastSnippet") %></div>
                                </div>

                                <%# (int)Eval("UnreadCount") > 0
                                    ? "<span class='conv-badge'>" + Eval("UnreadCount") + "</span>"
                                    : "" %>

                                <asp:LinkButton ID="lbSelect"
                                    runat="server"
                                    CommandName="Select"
                                    CommandArgument='<%# Eval("ConversationID") %>'
                                    Style="position:absolute;inset:0;opacity:0;" />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

            </div>

            <!-- CHAT -->
            <div class="chat-panel">

                <asp:Panel ID="pnlNoneSelected"
                    runat="server"
                    CssClass="no-chat-selected">
                    Select a doctor to start chatting
                </asp:Panel>

                <%-- CssClass drives display; no inline style needed --%>
                <asp:Panel ID="pnlChat"
                    runat="server"
                    Visible="false"
                    CssClass="chat-inner">

                    <div class="chat-header">
                        <div class="avatar">
                            <asp:Literal ID="litDrInitials" runat="server" />
                        </div>
                        <div>
                            <h2>Dr. <asp:Literal ID="litDrName" runat="server" /></h2>
                            <p><asp:Literal ID="litDrSpec" runat="server" /></p>
                        </div>
                    </div>

                    <%-- Wrapper gives the UpdatePanel a proper flex-stretching parent --%>
                    <div class="up-messages-wrap">
                    <asp:UpdatePanel ID="upMessages"
                        runat="server"
                        UpdateMode="Conditional">

                        <ContentTemplate>

                            <asp:Timer ID="timerRefresh"
                                runat="server"
                                Interval="4000"
                                OnTick="timerRefresh_Tick" />

                            <div class="messages-wrap" id="msgWrap">
                                <asp:Repeater ID="rptMessages" runat="server">
                                    <ItemTemplate>

                                        <%# (bool)Eval("ShowDivider")
                                            ? "<div class='msg-divider'>" + Eval("DayLabel") + "</div>"
                                            : "" %>

                                        <div class='msg-row <%# (bool)Eval("IsMe") ? "me" : "them" %>'>
                                            <div class="bubble">
                                                <%# System.Web.HttpUtility.HtmlEncode(Eval("Body").ToString()).Replace("&#10;","<br/>") %>
                                            </div>
                                            <span class="msg-time">
                                                <%# ((DateTime)Eval("SentAt")).ToString("h:mm tt") %>
                                            </span>
                                        </div>

                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>

                        </ContentTemplate>

                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="timerRefresh" EventName="Tick" />
                            <asp:AsyncPostBackTrigger ControlID="btnSend"      EventName="Click" />
                        </Triggers>

                    </asp:UpdatePanel>
                    </div><%-- end .up-messages-wrap --%>

                    <%-- Input bar lives outside UpdatePanel so it never disappears on refresh --%>
                    <div class="input-bar">
                        <asp:TextBox ID="txtMessage"
                            runat="server"
                            TextMode="MultiLine"
                            CssClass="msg-input"
                            Rows="1"
                            placeholder="Type your message..." />

                        <asp:Button ID="btnSend"
                            runat="server"
                            CssClass="send-btn"
                            Text="➜"
                            OnClick="btnSend_Click"
                            UseSubmitBehavior="false" />
                    </div>

                </asp:Panel>

            </div>

        </div>
    </div>

<script type="text/javascript">
// @ts-nocheck
(function () {
    function sizeAndScroll() {
        var shell = document.querySelector('.chat-shell');
        var panel = document.querySelector('.chat-panel');
        var header = document.querySelector('.chat-header');
        var inputBar = document.querySelector('.input-bar');
        var msgWrap = document.getElementById('msgWrap');

        if (!shell || !panel || !msgWrap) return;

        var shellH = shell.offsetHeight;
        var headerH = header ? header.offsetHeight : 0;
        var inputH = inputBar ? inputBar.offsetHeight : 0;

        // msgWrap height = total panel height minus header and input bar
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
