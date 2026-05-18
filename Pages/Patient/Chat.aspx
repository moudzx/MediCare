<%@ Page Title="Chat – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="Chat.aspx.cs"
    Inherits="MediCare.Pages.Patient.Chat" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
        /* =========================
           PAGE
        ========================= */

        .chat-page {
            padding: 28px;
            background: #f4f7f5;
            min-height: 100vh;
        }

        .chat-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 22px;
        }

        /* =========================
           SIDEBAR
        ========================= */

        .chat-sidebar {
            background: #ffffff;
            border-radius: 18px;
            border: 1px solid #e5e7eb;
            overflow: hidden;
            box-shadow: 0 6px 18px rgba(0,0,0,.05);
            height: calc(100vh - 140px);
            display: flex;
            flex-direction: column;
        }

        .chat-sidebar__header {
            padding: 18px;
            border-bottom: 1px solid #f3f4f6;
        }

        .chat-sidebar__title {
            font-size: 20px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 14px;
        }

        .chat-search {
            width: 100%;
            border: 1.5px solid #e5e7eb;
            border-radius: 12px;
            padding: 10px 12px;
            font-size: 14px;
            outline: none;
        }

        .chat-search:focus {
            border-color: #16a34a;
            box-shadow: 0 0 0 3px rgba(22,163,74,.12);
        }

        /* =========================
           CONTACT LIST
        ========================= */

        .chat-users {
            overflow-y: auto;
            flex: 1;
        }

        .chat-user {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            border-bottom: 1px solid #f3f4f6;
            cursor: pointer;
            transition: .2s ease;
            text-decoration: none;
            color: inherit;
        }

        .chat-user:hover {
            background: #f9fafb;
        }

        .chat-user--active {
            background: #f0fdf4;
        }

        .chat-user__avatar {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            background: linear-gradient(135deg, #16a34a, #22c55e);
            color: white;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 15px;
        }

        .chat-user__content {
            flex: 1;
            min-width: 0;
        }

        .chat-user__name {
            font-size: 14px;
            font-weight: 700;
            color: #111827;
            margin-bottom: 3px;
        }

        .chat-user__message {
            font-size: 12px;
            color: #6b7280;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .chat-user__badge {
            min-width: 22px;
            height: 22px;
            border-radius: 999px;
            background: #16a34a;
            color: white;
            font-size: 11px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* =========================
           CHAT PANEL
        ========================= */

        .chat-main {
            background: #ffffff;
            border-radius: 18px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 6px 18px rgba(0,0,0,.05);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            height: calc(100vh - 140px);
        }

        .chat-main__header {
            padding: 18px 22px;
            border-bottom: 1px solid #f3f4f6;
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .chat-main__avatar {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            background: linear-gradient(135deg, #16a34a, #22c55e);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
        }

        .chat-main__info h2 {
            margin: 0;
            font-size: 16px;
            color: #111827;
        }

        .chat-main__info span {
            font-size: 12px;
            color: #16a34a;
            font-weight: 600;
        }

        /* =========================
           MESSAGES
        ========================= */

        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 22px;
            background: #f9fafb;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .chat-message {
            max-width: 72%;
            padding: 12px 14px;
            border-radius: 16px;
            font-size: 14px;
            line-height: 1.5;
            position: relative;
        }

        .chat-message small {
            display: block;
            margin-top: 6px;
            font-size: 11px;
            opacity: .8;
        }

        .chat-message--incoming {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            align-self: flex-start;
            color: #111827;
        }

        .chat-message--outgoing {
            background: linear-gradient(135deg, #16a34a, #22c55e);
            color: white;
            align-self: flex-end;
        }

        /* =========================
           INPUT
        ========================= */

        .chat-input {
            border-top: 1px solid #f3f4f6;
            padding: 18px;
            background: #ffffff;
        }

        .chat-input__row {
            display: flex;
            gap: 12px;
            align-items: flex-end;
        }

        .chat-textbox {
            flex: 1;
            border: 1.5px solid #e5e7eb;
            border-radius: 14px;
            padding: 12px 14px;
            font-size: 14px;
            resize: none;
            outline: none;
            min-height: 52px;
            max-height: 140px;
        }

        .chat-textbox:focus {
            border-color: #16a34a;
            box-shadow: 0 0 0 3px rgba(22,163,74,.12);
        }

        .chat-send-btn {
            border: none;
            background: linear-gradient(135deg, #16a34a, #22c55e);
            color: white;
            width: 54px;
            height: 54px;
            border-radius: 14px;
            cursor: pointer;
            font-size: 18px;
            transition: .2s ease;
        }

        .chat-send-btn:hover {
            transform: translateY(-1px);
        }

        /* =========================
           EMPTY CHAT
        ========================= */

        .chat-empty {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            gap: 12px;
            color: #6b7280;
        }

        .chat-empty i {
            font-size: 48px;
            color: #d1d5db;
        }

        /* =========================
           MOBILE
        ========================= */

        @media (max-width: 900px) {

            .chat-layout {
                grid-template-columns: 1fr;
            }

            .chat-sidebar,
            .chat-main {
                height: auto;
            }
        }

    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="chat-page">

        <div class="chat-layout">

            <!-- =========================
                 LEFT SIDEBAR
            ========================= -->

            <div class="chat-sidebar">

                <div class="chat-sidebar__header">

                    <div class="chat-sidebar__title">
                        Messages
                    </div>

                    <asp:TextBox ID="txtSearch"
                        runat="server"
                        CssClass="chat-search"
                        placeholder="Search doctor..." />

                </div>

                <div class="chat-users">

                    <!-- USER 1 -->
                    <asp:LinkButton ID="btnChat1"
                        runat="server"
                        CssClass="chat-user chat-user--active">

                        <div class="chat-user__avatar">
                            DR
                        </div>

                        <div class="chat-user__content">
                            <div class="chat-user__name">
                                Dr. Sarah Johnson
                            </div>

                            <div class="chat-user__message">
                                Your prescription is ready.
                            </div>
                        </div>

                        <div class="chat-user__badge">
                            2
                        </div>

                    </asp:LinkButton>

                    <!-- USER 2 -->
                    <asp:LinkButton ID="btnChat2"
                        runat="server"
                        CssClass="chat-user">

                        <div class="chat-user__avatar">
                            AM
                        </div>

                        <div class="chat-user__content">
                            <div class="chat-user__name">
                                Dr. Ahmed Mansour
                            </div>

                            <div class="chat-user__message">
                                Please schedule your visit.
                            </div>
                        </div>

                    </asp:LinkButton>

                </div>

            </div>

            <!-- =========================
                 CHAT MAIN
            ========================= -->

            <div class="chat-main">

                <!-- CHAT HEADER -->

                <div class="chat-main__header">

                    <div class="chat-main__avatar">
                        SJ
                    </div>

                    <div class="chat-main__info">
                        <h2>Dr. Sarah Johnson</h2>
                        <span>Online</span>
                    </div>

                </div>

                <!-- MESSAGES -->

                <div class="chat-messages">

                    <div class="chat-message chat-message--incoming">
                        Hello Nadune, your blood test results are ready.
                        <small>09:12 AM</small>
                    </div>

                    <div class="chat-message chat-message--outgoing">
                        Thank you doctor, I will check them today.
                        <small>09:15 AM</small>
                    </div>

                    <div class="chat-message chat-message--incoming">
                        Also remember to take your medication after dinner.
                        <small>09:17 AM</small>
                    </div>

                </div>

                <!-- INPUT -->

                <div class="chat-input">

                    <div class="chat-input__row">

                        <asp:TextBox ID="txtMessage"
                            runat="server"
                            CssClass="chat-textbox"
                            TextMode="MultiLine"
                            Rows="2"
                            placeholder="Type your message..." />

                        <asp:Button ID="btnSend"
                            runat="server"
                            Text="➜"
                            CssClass="chat-send-btn" />

                    </div>

                </div>

            </div>

        </div>

    </div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ScriptContent" runat="server">
</asp:Content>