<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="login.aspx.vb" Inherits="sunday_school_ms.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>System Login</title>
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
                    <!-- Username -->
                    <div class="login-row">
                        <label for="txtUser" style="font-size: 16px; text-align: center;">Username</label>
                        <asp:TextBox ID="txtUser" runat="server"
                            CssClass="input-font">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="ChecktxtUser" runat="server"
                            ErrorMessage="请输入你的用户名字。"
                            ControlToValidate="txtUser"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                    </div>
                    <!-- Password Input -->
                    <div class="login-row" id="lblPass">
                        <label for="txtPass" style="font-size: 16px; text-align: center;">Password</label>
                        <asp:TextBox ID="txtPass" runat="server"
                            ClientIDMode="Static"
                            CssClass="input-font"
                            TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckTxtPass" runat="server"
                            ErrorMessage="请输入你的密码。"
                            ControlToValidate="txtPass"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"
                            ClientIDMode="Static">
                        </asp:RequiredFieldValidator>
                    </div>
                    <!-- Show Password Checkbox -->
                    <div class="login-font-style">
                        <asp:CheckBox ID="showPass" runat="server" CssClass="check-show-pass"
                            ClientIDMode="Static" Style="text-align: center;" Text="显示密码" />
                    </div>
                    <!-- Forgot Password Link-->
                    <div class="login-font-style">
                        <asp:LinkButton ID="ForgotPass" runat="server"
                            Style="font-size: 12px; text-align: center; margin-top: 10px;"
                            CausesValidation="false">忘记密码 ?</asp:LinkButton>
                    </div>
                </div>
            </div>
            <br />
            <div class="btn-align">
                <asp:Button ID="BtnLogin" runat="server"
                    CssClass="btn-style"
                    ValidationGroup="RequiredFieldValidate"
                    Text="登录" />
                <asp:Button ID="BtnCancel" runat="server"
                    CssClass="btn-style"
                    ClientIDMode="Static"
                    Text="取消" />
            </div>
        </div>
    </form>
    <script type="text/javascript">
    document.addEventListener("DOMContentLoaded", function () {
        var showPass = document.getElementById("showPass");
        var txtPass = document.getElementById("txtPass");

        showPass.addEventListener("change", function () {
            if (this.checked) {
                txtPass.type = "text";
            } else {
                txtPass.type = "password";
            }
        });
    });
    </script>
</body>
</html>
