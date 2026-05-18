<%@ Page Title="Doctor Profile – MediCare"
    Language="C#"
    MasterPageFile="~/MasterPage/PatientSite.Master"
    AutoEventWireup="true"
    CodeBehind="DoctorProfile.aspx.cs"
    Inherits="MediCare.Pages.Patient.DoctorProfile" %>

<asp:Content ID="HeadExtra" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="/css/PDoctorProfile.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="PageContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="dpro-root">

        <!-- Page header -->
        <div class="dpro-page-header">
            <div class="dpro-page-header__icon">
                <i class="fa-solid fa-user-doctor"></i>
            </div>
            <div>
                <h1 class="dpro-page-header__title">Doctor Profile</h1>
                <p class="dpro-page-header__sub">Detailed information &amp; appointment booking</p>
            </div>
        </div>

        <!-- Doctor Info Card -->
        <div class="dpro-card dpro-card--info">
            <div class="dpro-card__body">

                <!-- Avatar & name row -->
                <div class="dpro-profile-header">
                    <div class="dpro-avatar">
                        <asp:Label ID="lblAvatarInitials" runat="server" CssClass="dpro-avatar__text" />
                    </div>
                    <div class="dpro-profile-header__text">
                        <h2 class="dpro-doctor-name">
                            <asp:Label ID="lblDoctorName" runat="server" />
                        </h2>
                        <p class="dpro-specialization">
                            <asp:Label ID="lblSpecialization" runat="server" />
                        </p>
                        <span class="dpro-badge dpro-badge--verified">
                            <i class="fa-solid fa-circle-check"></i> Verified Doctor
                        </span>
                    </div>
                </div>

                <!-- Detailed info grid -->
                <div class="dpro-info-grid">

                    <div class="dpro-info-item">
                        <i class="fa-solid fa-location-dot"></i>
                        <div>
                            <span class="dpro-info-label">Location</span>
                            <span class="dpro-info-value"><asp:Label ID="lblLocation" runat="server" /></span>
                        </div>
                    </div>

                    <div class="dpro-info-item">
                        <i class="fa-solid fa-calendar-alt"></i>
                        <div>
                            <span class="dpro-info-label">Years of Experience</span>
                            <span class="dpro-info-value"><asp:Label ID="lblExperience" runat="server" /></span>
                        </div>
                    </div>

                    <div class="dpro-info-item">
                        <i class="fa-solid fa-language"></i>
                        <div>
                            <span class="dpro-info-label">Languages</span>
                            <span class="dpro-info-value"><asp:Label ID="lblLanguages" runat="server" /></span>
                        </div>
                    </div>

                    <div class="dpro-info-item">
                        <i class="fa-solid fa-graduation-cap"></i>
                        <div>
                            <span class="dpro-info-label">Qualifications</span>
                            <span class="dpro-info-value"><asp:Label ID="lblQualifications" runat="server" /></span>
                        </div>
                    </div>

                    <div class="dpro-info-item dpro-info-item--full">
                        <i class="fa-solid fa-stethoscope"></i>
                        <div>
                            <span class="dpro-info-label">About</span>
                            <span class="dpro-info-value"><asp:Label ID="lblAbout" runat="server" /></span>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- Appointment Scheduling Card -->
        <div class="dpro-card dpro-card--appointments">
            <div class="dpro-card__header">
                <h2 class="dpro-card__title">Schedule Appointment</h2>
                <p class="dpro-card__sub">Choose a date and time</p>
            </div>

            <div class="dpro-card__body">
                <!-- Calendar -->
                <asp:Calendar ID="calAppointments" runat="server" 
                              OnSelectionChanged="calAppointments_SelectionChanged" />

                <!-- GridView for time slots -->
               <asp:GridView ID="gvSlots" runat="server" AutoGenerateColumns="False"
                              CssClass="slot-grid"
                              OnRowCommand="gvSlots_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="SlotText" HeaderText="Available Slot" />

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnBook" runat="server"
                                            Text="Book"
                                            CommandName="BookSlot"
                                            CommandArgument='<%# Eval("SlotValue") %>'
                                            CssClass="slot-btn" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>


                <!-- Message when no slots -->
                <asp:PlaceHolder ID="phNoSlots" runat="server" Visible="false">
                    <div class="dpro-no-slots">
                        <i class="fa-regular fa-calendar-xmark"></i>
                        <p>No available slots for this date.</p>
                    </div>
                </asp:PlaceHolder>

                <!-- Confirmation -->
                <asp:Label ID="lblMessage" runat="server" CssClass="confirmation-msg" />
            </div>
        </div>


    </div>

</asp:Content>