<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="add-new-material.aspx.vb" Inherits="sunday_school_ms.add_new_material" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Manage Teaching Materials</title>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="menu-container">
        <div class="right-menu-container">
            <div class="filter-menu">
                <h4>添加新材料/书</h4>
            </div>
            <hr />
            <h6>请填写所有标有 * 的必填栏位。</h6>
            <!-- Material Title -->
            <div class="form-container">
                <br />
                <div class="form-field">
                    <label>名字<span style="color: red;">*</span>: </label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtMaterialTitle" runat="server" CssClass="textbox-size"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvTxtMaterialTitle" runat="server"
                            ControlToValidate="TxtMaterialTitle"
                            ErrorMessage="请输入材料/书的名字"
                            Display="Dynamic"
                            CssClass="validator-font"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <!-- Book Chapter -->
                <div class="form-field">
                    <label>章节: </label>
                    <asp:TextBox ID="TxtMaterialChapter" runat="server" CssClass="textbox-size"></asp:TextBox>
                </div>
                <!-- Published Year -->
                <div class="form-field">
                    <label>出版年份: </label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtPublishedYear" runat="server" CssClass="textbox-size"
                        Placeholder="2025" TextMode="Number"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RvTxtPublishedYear" runat="server"
                        ErrorMessage="请输入正确的年份 (例子: 2023)"
                        Display="Dynamic"
                        CssClass="validator-font"
                        ValidationGroup="RequiredFieldValidate"
                        ControlToValidate="TxtPublishedYear"
                        ValidationExpression="\d{4}"></asp:RegularExpressionValidator>
                </div>
                    </div>
                <!-- Remarks -->
                <div class="form-field">
                    <label>备注: </label>
                    <asp:TextBox ID="TxtRemark" runat="server" CssClass="textbox-size"
                        ToolTip="Remark" TextMode="MultiLine"></asp:TextBox>
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