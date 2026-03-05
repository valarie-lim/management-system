<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="login-general.aspx.vb" Inherits="sunday_school_ms.login_general" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>System General Access</title>
    <link runat="server" rel="stylesheet" href="../CSS/style-login.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="background-container">
            <div class="login-logo-style">
                <p>古晋真道堂儿童主日学<br />资料管理系统</p>
            </div>
            <div class="login-font-align">
                <div class="login-font-style">
                    <!-- Name -->
                    <div class="login-row">
                        <label for="txtName" style="font-size: 16px; text-align: center;">英文姓名</label>
                        <asp:TextBox ID="txtName" runat="server"
                            CssClass="input-font">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="ChecktxtName" runat="server"
                            ErrorMessage="请输入英文姓名。"
                            ControlToValidate="txtName"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                    </div>
                    <!-- Role Check -->
                    <div class="login-row">
                        <label for="txtRole" style="font-size: 16px; text-align: center;">角色</label>
                        <asp:TextBox ID="txtRole" runat="server"
                            CssClass="input-font" TextMode="Password">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="ChecktxtRole" runat="server"
                            ErrorMessage="请输入在主日学的角色"
                            ControlToValidate="txtRole"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                        <!-- Show Role Checkbox -->
                        <div class="login-font-style">
                            <asp:CheckBox ID="showRole" runat="server" CssClass="check-show-pass"
                                ClientIDMode="Static" Style="text-align: center;" Text="显示角色" />
                        </div>
                    </div>
                </div>
            </div>
            <br />
            <div class="btn-align">
                <asp:Button ID="BtnAccess" runat="server"
                    CssClass="btn-style"
                    ValidationGroup="RequiredFieldValidate"
                    Text="立即登入" />
                <asp:Button ID="BtnCancel" runat="server"
                    CssClass="btn-style"
                    ClientIDMode="Static"
                    Text="取消" />
            </div>
        </div>
    </form>
        <script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function () {
        var showRole = document.getElementById("showRole");
        var txtRole = document.getElementById("txtRole");

        showRole.addEventListener("change", function () {
            if (this.checked) {
                txtRole.type = "text";
            } else {
                txtRole.type = "password";
            }
        });
    });
        </script>
</body>
</html>