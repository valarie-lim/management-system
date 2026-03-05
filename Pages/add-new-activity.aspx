<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="add-new-activity.aspx.vb" Inherits="sunday_school_ms.add_new_activity" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Manage Activities and Events</title>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="menu-container">
        <div class="right-menu-container">
            <div class="filter-menu">
                <h4>添加新活动</h4>
            </div>
            <hr />
            <h6>请填写所有标有 * 的必填栏位。</h6>
            <!-- Activity Name -->
            <div class="form-container">
                <br />
                <div class="form-field">
                    <label>活动<span style="color: red;">*</span>: </label>
                    <div class="input-validation-wrapper">
                        <asp:DropDownList ID="ddlActivityName" runat="server" CssClass="textbox-size"
                        AutoPostBack="True"
                        OnSelectedIndexChanged="ddlActivityName_SelectedIndexChanged">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvActivity" runat="server"
                        ControlToValidate="ddlActivityName"
                        InitialValue=""
                        ErrorMessage="请选择活动名字"
                        ForeColor="Red"
                        Display="Dynamic"
                        CssClass="validator-font"
                        ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>

                    <asp:TextBox ID="txtNewActivity" runat="server" CssClass="textbox-size" Visible="False"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvNewActivity" runat="server"
                        Placeholder="输入新活动的名字"
                        ControlToValidate="txtNewActivity"
                        ErrorMessage="请输入新的活动名字"
                        Display="Dynamic"
                        CssClass="validator-font"
                        ValidationGroup="RequiredFieldValidate"
                        Enabled="False"></asp:RequiredFieldValidator>
                </div>
                    </div>
                <!-- Activity Date -->
                <div class="form-field">
                    <label>活动日期<span style="color: red;">*</span>: </label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="txtActivityDate" runat="server" CssClass="textbox-size"
                        placeholder="dd/MM/yyyy" Type="Date"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDate" runat="server"
                        ControlToValidate="txtActivityDate"
                        ErrorMessage="请输入活动日期"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                </div>
                    </div>
                <!-- Buttons -->
                <div class="btn-form-align">
                    <asp:Button ID="BtnInsert" runat="server" Text="输入" CssClass="btn-insert"
                        ClientIDMode="Static" ValidationGroup="RequiredFieldValidate" />
                    <asp:Button ID="BtnCancel" runat="server" Text="取消" CssClass="btn-cancel"
                        ClientIDMode="Static"
                        OnClientClick="return confirm('取消操作后，所有未保存的数据都将丢失。您确定吗？');" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>