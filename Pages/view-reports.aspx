<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="view-reports.aspx.vb" Inherits="sunday_school_ms.view_reports" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Report</title>
    <link runat="server" rel="stylesheet" href="../CSS/style.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <header id="main-header">
            <div class="header-left">
                <a href="#" class="logo-style">
                    <img src="../Images/logo.png" /></a>
                <h3>古晋真道堂儿童主日学资料管理系统</h3>
            </div>
            <div class="header-right">
                <ul class="navlist">
                    <li><span id="LiveClock" class="timestamp-font-size"></span></li>
                </ul>
                <asp:Button ID="BtnLogout" runat="server"
                    CssClass="btn-logout"
                    Style="border-radius: 5px;" Text="登出"
                    OnClientClick="return confirm('确定要登出吗?');" />
            </div>
        </header>

        <!-- Keep the container structure inside the form -->
        <section>
            <div class="menu-container">
                <!-- Sidebar stays visually inside layout but logically outside form -->
                <div class="side-menu-container" onclick="event.stopPropagation()">
                    <button class="btn-menu" style="margin-top: 50px;" type="button" onclick="navigateTo('admin-dashboard.aspx')">主界面</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-children.aspx')">儿童与家长管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-teacher.aspx')">老师管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-activity.aspx')">活动管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-materials.aspx')">材料管理</button>
                    <button class="btn-menu" type="button" onclick="navigateTo('manage-users.aspx')">系统用户管理</button>
                </div>

                <!-- Main content inside form -->
                <div class="right-menu-container">
                    <h2>查看报表</h2>
                    <hr />
                    <div class="btn-content">
                        <button type="button" onclick="navigateTo('report-attendance-summaries.aspx')">出勤汇总<br />（Attendance Summaries）</button>
                        <button type="button" onclick="navigateTo('report-teacher-activity-schedule.aspx')">教师与活动排程<br />（Teacher and Activity Schedule）</button>
                        <button type="button" onclick="navigateTo('report-children-information.aspx')">孩子资料<br />（Children Information）</button>
                    </div>
                </div>
            </div>
        </section>
    </form>
    <footer>
        <small>Sunday School Database Management System © 2025 BEM The Way Kuching. All rights reserved.<br />
            Version 1.0 | 系统维修联络: 0109640097 （whatsapp）</small>
    </footer>
</body>
</html>