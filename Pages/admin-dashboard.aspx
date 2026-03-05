<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="admin-dashboard.aspx.vb" Inherits="sunday_school_ms.admin_dashboard" %>


<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Admin Dashboard</title>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
        <div class="menu-container">
            <div class="side-menu-container" onclick="event.stopPropagation()">
                <button class="btn-menu" style="margin-top:50px;" type="button" onclick="navigateTo('admin-dashboard.aspx')">主界面</button>
                <button class="btn-menu" type="button" onclick="navigateTo('manage-children.aspx')">儿童与家长管理</button>
                <button class="btn-menu" type="button" onclick="navigateTo('manage-teacher.aspx')">老师管理</button>
                <button class="btn-menu" type="button" onclick="navigateTo('manage-activity.aspx')">活动管理</button>
                <button class="btn-menu" type="button" onclick="navigateTo('manage-materials.aspx')">材料管理</button>
                <button class="btn-menu" type="button" onclick="navigateTo('manage-users.aspx')">系统用户管理</button>
            </div>

            <div class="right-menu-container">
                <h3>主界面</h3>
                <hr />
                <div class="btn-content">
                    <button type="button" onclick="navigateTo('attendance-record.aspx')">出席点名表</button>
                    <button type="button" onclick="navigateTo('schedule-arrangement.aspx')">事奉表安排</button>
                    <button type="button" onclick="navigateTo('add-new-activity.aspx')">创建新活动</button>
                    <button type="button" onclick="navigateTo('view-reports.aspx')">查看和打印报告</button>
                </div>
            </div>
        </div>
</asp:Content>
