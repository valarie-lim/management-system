<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="register.aspx.vb" Inherits="sunday_school_ms.register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>System User's Account Registration</title>
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
                    <p>请创建您的登录信息</p>
                    <div class="login-row">
                        <!-- Username -->
                        <label for="TxtUsername" style="font-size: 16px; text-align: center;">Username</label>
                        <asp:TextBox ID="TxtUsername" runat="server" CssClass="input-font">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckTxtUsername" runat="server"
                            ErrorMessage="请输入用户名。"
                            ControlToValidate="TxtUsername"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static">
                        </asp:RequiredFieldValidator>
                        <!-- Password -->
                        <label for="TxtPass" style="font-size: 16px; text-align: center;">Password</label>
                        <asp:TextBox ID="TxtPass" runat="server" TextMode="Password" CssClass="input-font">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckTxtPass" runat="server"
                            ErrorMessage="请输入你的密码。"
                            ControlToValidate="TxtPass"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static">
                        </asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator
                            ID="PasswordValidator"
                            runat="server"
                            ControlToValidate="TxtPass"
                            ErrorMessage="密码长度须为 8-20 个字符，且至少包含 1 个小写字母（a-z）、1 个大写字母（A-Z）以及 1 个数字或符号（0-9 或 !@#$）。"
                            ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9!@#$]).{8,20}$"
                            CssClass="validator-font"
                            Display="Dynamic">
                        </asp:RegularExpressionValidator>
                        <!-- Show Password Checkbox -->
                        <div class="content-font-style">
                            <asp:CheckBox ID="showPass" runat="server"
                                ClientIDMode="Static" Style="text-align: center;" Text="显示密码" />
                        </div>
                        <br />
                    </div>
                </div>
                <br />
                <div class="btn-align">
                    <asp:Button ID="BtnCreate" runat="server" CssClass="btn-style" Text="立即创建" />
                </div>
            </div>
        </div>
    </form>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var showPass = document.getElementById("showPass");
            var txtPass = document.getElementById("TxtPass");

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
