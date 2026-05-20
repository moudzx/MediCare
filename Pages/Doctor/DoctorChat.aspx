<%@ Page Title="Doctor Chat – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/DoctorSite.Master"
    AutoEventWireup="true"
    CodeBehind="DoctorChat.aspx.cs"
    Inherits="MediCare.Pages.Doctor.DoctorChat" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .dc-shell {
            display: flex;
            gap: 24px;
            height: calc(100vh - 170px);
        }

        .dc-sidebar {
            width: 320px;
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        .dc-sidebar__header {
            padding: 18px 20px;
            border-bottom: 1px solid #f1f5f9;
            font-size: .78rem;
            font-weight: 700;
            color: #64748b;
            letter-spacing: .08em;
            text-transform: uppercase;
        }

        .dc-conversations {
            flex: 1;
            overflow-y: auto;
        }

        .dc-conv {
            position: relative;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 18px;
            border-bottom: 1px solid #f8fafc;
            transition: .15s ease;
        }

        .dc-conv:hover {
            background: #f8fafc;
        }

        .dc-conv--active {
            background: #ecfdf5;
        }

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

        .dc-conv__meta {
            flex: 1;
            min-width: 0;
        }

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
        }

        .dc-chat {
            flex: 1;
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .dc-chat__header {
            padding: 18px 22px;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .dc-chat__info h2 {
            font-size: 1rem;
            color: #0f172a;
        }

        .dc-chat__info p {
            margin-top: 2px;
            font-size: .8rem;
            color: #64748b;
        }

        .dc-messages {
            flex: 1;
            overflow-y: auto;
            padding: 22px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            background: #f8fafc;
        }

        .dc-row {
            display: flex;
            align-items: flex-end;
            gap: 8px;
        }

        .dc-row--me {
            justify-content: flex-end;
        }

        .dc-bubble {
            max-width: 70%;
            padding: 12px 15px;
            border-radius: 16px;
            font-size: .88rem;
            line-height: 1.55;
            word-break: break-word;
        }

        .dc-row--me .dc-bubble {
            background: #16a34a;
            color: white;
            border-bottom-right-radius: 4px;
        }

        .dc-row--them .dc-bubble {
            background: white;
            border: 1px solid #e2e8f0;
            color: #0f172a;
            border-bottom-left-radius: 4px;
        }

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

        .dc-input {
            padding: 18px;
            border-top: 1px solid #f1f5f9;
            display: flex;
            gap: 12px;
            align-items: center;
            background: white;
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
        }

        .dc-input textarea:focus {
            border-color: #16a34a;
        }

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
        }

        .dc-send:hover {
            background: #15803d;
        }

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
        <!-- LEFT -->
        <div class="dc-sidebar">

            <div class="dc-sidebar__header">
                Patient Conversations
            </div>

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

                                <div class="dc-conv__name">
                                    <%# Eval("PatientName") %>
                                </div>

                                <div class="dc-conv__snippet">
                                    <%# Eval("LastSnippet") %>
                                </div>
                            </div>

                            <%# Convert.ToInt32(Eval("UnreadCount")) > 0
                                ? "<div class='dc-conv__badge'>" + Eval("UnreadCount") + "</div>"
                                : "" %>

                            <asp:LinkButton ID="btnSelect"
                                            runat="server"
                                            CommandName="Open"
                                            CommandArgument='<%# Eval("ConversationID") %>'
                                            Style="position:absolute; inset:0; opacity:0;" />

                        </div>

                    </ItemTemplate>

                </asp:Repeater>

            </div>
        </div>

        <!-- RIGHT -->
        <div class="dc-chat">

            <asp:Panel ID="pnlNoChat" runat="server" CssClass="dc-empty">
                Select a patient conversation
            </asp:Panel>

            <asp:Panel ID="pnlChat" runat="server" Visible="false" style="display:flex; flex-direction:column; height:100%;">

                <div class="dc-chat__header">

                    <div class="dc-avatar">
                        <asp:Literal ID="litPatientInitials" runat="server" />
                    </div>

                    <div class="dc-chat__info">
                        <h2>
                            <asp:Literal ID="litPatientName" runat="server" />
                        </h2>

                        <p>
                            Patient Conversation
                        </p>
                    </div>
                </div>

                <asp:UpdatePanel ID="upMessages" runat="server">

                    <ContentTemplate>

                        <asp:Timer ID="timerRefresh"
                                   runat="server"
                                   Interval="4000"
                                   OnTick="timerRefresh_Tick" />

                        <div class="dc-messages" id="msgWrap">

                            <asp:Repeater ID="rptMessages" runat="server">

                                <ItemTemplate>

                                    <%# (bool)Eval("ShowDivider")
                                        ? "<div class='dc-divider'>" + Eval("DayLabel") + "</div>"
                                        : "" %>

                                    <div class='dc-row <%# (bool)Eval("IsMe") ? "dc-row--me" : "dc-row--them" %>'>

                                        <div class="dc-bubble">
                                            <%# Eval("Body").ToString().Replace("\n","<br/>") %>
                                        </div>

                                        <div class="dc-time">
                                            <%# Convert.ToDateTime(Eval("SentAt")).ToString("h:mm tt") %>
                                        </div>

                                    </div>

                                </ItemTemplate>

                            </asp:Repeater>

                        </div>

                    </ContentTemplate>

                </asp:UpdatePanel>

                <div class="dc-input">

                    <textarea id="txtMsg"
                              runat="server"
                              placeholder="Type your message..."></textarea>

                    <asp:Button ID="btnSend"
                                runat="server"
                                Text="➜"
                                CssClass="dc-send"
                                OnClick="btnSend_Click" />

                </div>

            </asp:Panel>

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