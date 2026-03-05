<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="add-new-child-confirmation.aspx.vb" Inherits="sunday_school_ms.add_new_child_confirmation" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Confirmation Page</title>
    </asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="menu-container">
        <div class="right-menu-container">
            <div class="filter-menu">
                <h4>资料确认</h4>
            </div>
            <hr />
            <h6>请先确认资料后点击注册。</h6>
            <div class="form-container">
                <p>个人信息</p>
                <div class="display-field">
                    <!-- Child First Name -->
                    <label>姓名（英）:</label>
                    <asp:Label ID="InputFirstName" runat="server" CssClass="field-value"></asp:Label>
                    <!-- Last Name -->
                    <label>姓氏（英）:</label>
                    <asp:Label ID="InputLastName" runat="server" CssClass="field-value"></asp:Label>
                    <!-- Chinese Name -->
                    <label>姓名（中）:</label>
                    <asp:Label ID="InputChineseName" runat="server" CssClass="field-value"></asp:Label>
                    <!-- Gender -->
                    <label>性别 :</label>
                    <asp:Label ID="InputGender" runat="server" CssClass="field-value"></asp:Label>
                    <!-- Date of Birth -->
                    <label>出生日期 :</label>
                    <asp:Label ID="InputDateOfBirth" runat="server" CssClass="field-value"></asp:Label>
                </div>

                <p>其他信息</p>
                <div class="display-field">
                    <!-- Religion -->
                    <label>信仰 :</label>
                    <asp:Label ID="InputReligion" runat="server" CssClass="field-value"></asp:Label>
                    <!-- Joined Date -->
                    <label>第一次参加 :</label>
                    <asp:Label ID="InputJoinedDate" runat="server" CssClass="field-value"></asp:Label>
                    <!-- Church -->
                    <label>所属教会 :</label>
                    <asp:Label ID="InputChurch" runat="server" CssClass="field-value"></asp:Label>
                    <!-- Inviter -->
                    <label>带领者 :</label>
                    <asp:Label ID="InputInviter" runat="server" CssClass="field-value"></asp:Label>
                    <!-- School -->
                    <label>学校 :</label>
                    <asp:Label ID="InputSchool" runat="server" CssClass="field-value"></asp:Label>
                    <!-- Remark -->
                    <label>备注 :</label>
                    <asp:Label ID="InputRemark" runat="server" CssClass="field-value"></asp:Label>
                </div>
                <!-- Buttons -->
                <div class="btn-form-align">
                    <asp:Button ID="BtnSubmit" runat="server" Text="注册" CssClass="btn-insert" ClientIDMode="Static" />
                    <asp:Button ID="BtnReturn" runat="server" Text="返回" CssClass="btn-cancel" ClientIDMode="Static" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
