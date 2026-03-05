<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="manage-users.aspx.vb" Inherits="sunday_school_ms.manage_users" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Manage System Users</title>
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

                <!-- Main content inside form -->
                <div class="right-menu-container">
                    <h3>系统用户管理</h3>
                    <hr />
                    <div class="btn-content">
                        <button type="button" onclick="navigateTo('activate-account.aspx')">激活帐户</button>
                        <asp:Button ID="BtnAddUser" runat="server" Text="添加新用户" CssClass="btn-filter" />
                        <asp:Button ID="BtnRmvUser" runat="server" Text="移除用户" CssClass="btn-filter" />
                    </div>
                </div>
            </div>
</asp:Content>
