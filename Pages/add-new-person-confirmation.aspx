<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="add-new-person-confirmation.aspx.vb" Inherits="sunday_school_ms.add_new_person_confirmation" %>

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
                    <label>姓名(英):</label>
                    <asp:Label ID="InputFirstName" runat="server" CssClass="field-value"></asp:Label>

                    <label>姓氏(英):</label>
                    <asp:Label ID="InputLastName" runat="server" CssClass="field-value"></asp:Label>

                    <label>姓名(中):</label>
                    <asp:Label ID="InputChineseName" runat="server" CssClass="field-value"></asp:Label>

                    <label>联络号码 :</label>
                    <asp:Label ID="InputContactNo" runat="server" CssClass="field-value"></asp:Label>

                    <label>电邮 :</label>
                    <asp:Label ID="InputEmail" runat="server" CssClass="field-value"></asp:Label>

                    <label>性别 :</label>
                    <asp:Label ID="InputGender" runat="server" CssClass="field-value"></asp:Label>

                    <label>出生日期 :</label>
                    <asp:Label ID="InputDateOfBirth" runat="server" CssClass="field-value"></asp:Label>
                </div>
                <!-- 2. Address -->
                <p>地址</p>
                <div class="display-field">
                    <label>街道地址 :</label>
                    <asp:Label ID="InputStreetAddress" runat="server" CssClass="field-value"></asp:Label>

                    <label>城市 :</label>
                    <asp:Label ID="InputCity" runat="server" CssClass="field-value"></asp:Label>

                    <label>邮政编码 :</label>
                    <asp:Label ID="InputPostcode" runat="server" CssClass="field-value"></asp:Label>

                    <label>州/省 :</label>
                    <asp:Label ID="InputState" runat="server" CssClass="field-value"></asp:Label>

                    <label>国家 :</label>
                    <asp:Label ID="InputCountry" runat="server" CssClass="field-value"></asp:Label>
                </div>

                <!-- 3. Service Information -->
                <p>老师信息</p>
                <div class="display-field">
                    <label>角色 :</label>
                    <asp:Label ID="InputRole" runat="server" CssClass="field-value"></asp:Label>
                    <label>事奉项目 :</label>
                    <asp:Label ID="InputService" runat="server" CssClass="field-value"></asp:Label>
                    <label>开始日期 :</label>
                    <asp:Label ID="InputStartDate" runat="server" CssClass="field-value"></asp:Label>
                </div>

                <!-- 4. Guardian Information -->
                <p>家长信息</p>
                <div class="display-field">
                    <label>孩子 :</label>
                    <asp:Label ID="InputChildName" runat="server" CssClass="field-value"></asp:Label>

                    <label>关系 :</label>
                    <asp:Label ID="InputRelationship" runat="server" CssClass="field-value"></asp:Label>

                    <label>信仰 :</label>
                    <asp:Label ID="InputReligion" runat="server" CssClass="field-value"></asp:Label>
                </div>
            </div>
            <!-- Buttons -->
            <div class="btn-form-align">
                <asp:Button ID="BtnSubmit" runat="server" Text="注册" CssClass="btn-insert" ClientIDMode="Static" />
                <asp:Button ID="BtnReturn" runat="server" Text="返回" CssClass="btn-cancel" ClientIDMode="Static" />
            </div>
        </div>
    </div>
</asp:Content>
