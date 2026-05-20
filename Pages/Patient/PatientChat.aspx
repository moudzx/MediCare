<%@ Page Title="Messages – MediCare" 
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="PatientChat.aspx.cs"
    Inherits="MediCare.Pages.Patient.PatientChat" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        .chat-shell {
            display: flex;
            gap: 20px;
            height: calc(100vh - 180px);
            margin-top: 24px;
        }

        .sidebar {
            width: 300px;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 18px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .sidebar-header {
            padding: 18px 20px;
            border-bottom: 1px solid #f3f4f6;
            font-size: 13px;
            font-weight: 700;
            color: #6b7280;
            letter-spacing: .08em;
            text-transform: uppercase;
        }

        .conv-list {
            overflow-y: auto;
            flex: 1;
        }

        .conv-item {
            display: flex;
            gap: 12px;
            align-items: center;
            padding: 14px 18px;
            position: relative;
            border-left: 3px solid transparent;
            transition: .15s ease;
        }

        .conv-item:hover {
            background: #f9fafb;
        }

        .conv-item.active {
            background: #ecfdf5;
            border-left-color: #16a34a;
        }

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

        .conv-meta {
            flex: 1;
            min-width: 0;
        }

        .conv-name {
            font-size: 14px;
            font-weight: 600;
            color: #111827;
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
        }

        .chat-panel {
            flex: 1;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 18px;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .chat-header {
            padding: 18px 22px;
            border-bottom: 1px solid #f3f4f6;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .chat-header h2 {
            font-size: 16px;
            margin: 0;
            color: #111827;
        }

        .chat-header p {
            margin: 2px 0 0;
            font-size: 13px;
            color: #6b7280;
        }

        .messages-wrap {
            flex: 1;
            overflow-y: auto;
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 14px;
            background: #f9fafb;
        }

        .msg-row {
            display: flex;
            gap: 8px;
        }

        .msg-row.me {
            justify-content: flex-end;
        }

        .bubble {
            max-width: 70%;
            padding: 11px 14px;
            border-radius: 16px;
            font-size: 14px;
            line-height: 1.5;
        }

        .msg-row.me .bubble {
            background: #16a34a;
            color: #fff;
            border-bottom-right-radius: 4px;
        }

        .msg-row.them .bubble {
            background: #fff;
            border: 1px solid #e5e7eb;
            color: #111827;
            border-bottom-left-radius: 4px;
        }

        .msg-time {
            font-size: 11px;
            color: #6b7280;
            align-self: flex-end;
        }

        .input-bar {
            padding: 18px;
            border-top: 1px solid #f3f4f6;
            display: flex;
            gap: 12px;
            background: #fff;
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
        }

        .msg-input:focus {
            border-color: #16a34a;
        }

        .send-btn {
            width: 46px;
            height: 46px;
            border: none;
            border-radius: 14px;
            background: #16a34a;
            color: #fff;
            cursor: pointer;
            font-size: 18px;
        }

        .send-btn:hover {
            background: #15803d;
        }

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

                <div class="sidebar-header">
                    My Doctors
                </div>

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
                                    <div class="conv-name">
                                        Dr. <%# Eval("DoctorName") %>
                                    </div>

                                    <div class="conv-snip">
                                        <%# Eval("LastSnippet") %>
                                    </div>
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

                <asp:Panel ID="pnlChat"
                    runat="server"
                    Visible="false"
                    Style="display:flex;flex-direction:column;flex:1;">

                    <div class="chat-header">

                        <div class="avatar">
                            <asp:Literal ID="litDrInitials" runat="server" />
                        </div>

                        <div>
                            <h2>
                                Dr.
                                <asp:Literal ID="litDrName" runat="server" />
                            </h2>

                            <p>
                                <asp:Literal ID="litDrSpec" runat="server" />
                            </p>
                        </div>

                    </div>

                    <asp:UpdatePanel ID="upMessages"
                        runat="server"
                        UpdateMode="Conditional">

                        <ContentTemplate>

                            <asp:Timer ID="timerRefresh"
                                runat="server"
                                Interval="5000"
                                OnTick="timerRefresh_Tick" />

                            <div class="messages-wrap">

                                <asp:Repeater ID="rptMessages" runat="server">

                                    <ItemTemplate>

                                        <div class='msg-row <%# (bool)Eval("IsMe") ? "me" : "them" %>'>

                                            <div class="bubble">
                                                <%# System.Web.HttpUtility.HtmlEncode(Eval("Body").ToString()).Replace("\n","<br/>") %>
                                            </div>

                                            <span class="msg-time">
                                                <%# ((DateTime)Eval("SentAt")).ToString("h:mm tt") %>
                                            </span>

                                        </div>

                                    </ItemTemplate>

                                </asp:Repeater>

                            </div>

                        </ContentTemplate>

                    </asp:UpdatePanel>

                    <asp:UpdatePanel ID="upInput"
                        runat="server"
                        UpdateMode="Conditional">

                        <ContentTemplate>

                            <div class="input-bar">
                                <asp:TextBox ID="txtMessage" 
                                    runat="server" 
                                    TextMode="MultiLine" 
                                    CssClass="msg-input" 
                                    Rows="1" 
                                    placeholder="Type your message..."></asp:TextBox>

                                <asp:Button ID="btnSend"
                                    runat="server"
                                    CssClass="send-btn"
                                    Text="➜"
                                    OnClick="btnSend_Click" />

                            </div>

                        </ContentTemplate>

                    </asp:UpdatePanel>

                </asp:Panel>

            </div>

        </div>

    </div>
<script type="text/javascript">
(function () {
    var containerObj: { aspSys: any } = { aspSys: null };

    try {
        containerObj.aspSys = eval('typeof Sys !== "undefined" ? Sys : null');
    } catch (e) {
        containerObj.aspSys = null;
    }

    function runScroll() {
        var container = document.querySelector('.messages-wrap') || document.getElementById('msgWrap');
        if (container) {
            container.scrollTop = container.scrollHeight;
        }
    }

    window.addEventListener('load', function () {
        var scriptEngine = containerObj.aspSys;

        if (scriptEngine && scriptEngine.WebForms && scriptEngine.WebForms.PageRequestManager) {
            var prm = scriptEngine.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(runScroll);
        }
        runScroll();
    });
})();
</script>
</asp:Content>