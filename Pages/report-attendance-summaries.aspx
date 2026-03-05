<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="report-attendance-summaries.aspx.vb" Inherits="sunday_school_ms.report_attendance_summaries" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Attendance Summaries</title>
    <link runat="server" rel="stylesheet" href="../CSS/style.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet" />
    <style>
    table{border-collapse: collapse;width: 100%;}
    th, td{border: 1px solid #ccc;padding: 8px;}
    @media print{body * {visibility: hidden;}#gvAttendance, #gvAttendance * {visibility: visible;}#gvAttendance {position: fixed;top: 20px; left: 20px;width: 90%;}}
</style>
</head>
<body>
    <form id="form1" runat="server">
        <header id="main-header">
            <div class="header-left">
                <a href="#" class="logo-style">
                    <img src="../Images/logo.png" /></a>
                <h3>Attendance Summaries</h3>
            </div>
            <div class="header-right">
                <ul class="navlist">
                    <li><span id="LiveClock" class="timestamp-font-size"></span></li>
                </ul>
                <asp:Button ID="BtnReturn" runat="server"
                    CssClass="btn-normal"
                    Style="border-radius: 5px;"
                    Text="Return" />
            </div>
        </header>
        <br />
        <!-- main content -->
        <div class="menu-container">
            <div class="right-menu-container">
                <div class="filter-menu">
                    <div class="filter-wrapper">
                        <asp:DropDownList ID="ddlActivity" runat="server" AutoPostBack="true" CssClass="filter-txtbox">
                            <asp:ListItem Text="- Select Activity -" Value="" />
                            <asp:ListItem Text="All Activities" Value="ALL" />
                        </asp:DropDownList>
                        <asp:Button ID="BtnExportPDF" runat="server" Text="Save as PDF" CssClass="btn-filter" />
                    </div>
                </div>
                <br />
                <asp:GridView ID="gvAttendance" runat="server" BackColor="White" BorderColor="#999999" 
                    BorderStyle="Solid" BorderWidth="1px" CellPadding="3" ForeColor="Black" GridLines="Vertical">
                    <AlternatingRowStyle BackColor="#CCCCCC" />
                    <FooterStyle BackColor="#CCCCCC" />
                    <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#999999" ForeColor="Black" HorizontalAlign="Center" />
                    <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#F1F1F1" />
                    <SortedAscendingHeaderStyle BackColor="#808080" />
                    <SortedDescendingCellStyle BackColor="#CAC9C9" />
                    <SortedDescendingHeaderStyle BackColor="#383838" />
                </asp:GridView>
                <br />
            </div>
        </div>
    </form>
</body>
</html>