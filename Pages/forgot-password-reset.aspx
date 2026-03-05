<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="forgot-password-reset.aspx.vb" Inherits="sunday_school_ms.forgot_password_reset" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Password Reset Now</title>
    <link runat="server" rel="stylesheet" href="../CSS/style-login.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="background-container">
            <div class="login-logo-style">
                <p>古晋真道堂儿童主日学<br />资料管理系统</p>
            </div>
            <div class="login-font-align">
                <div class="login-font-style">
                    <p>请输入一个安全密码</p>
                    <!-- New Password -->
                    <label for="TxtNewPass" style="font-size: 16px; text-align: center;">New Password</label>
                    <asp:TextBox ID="TxtNewPass" runat="server"
                        TextMode="Password"
                        CssClass="input-font">
                    </asp:TextBox>
                    <div></div>
                    <!-- empty placeholder cell -->
                    <asp:RequiredFieldValidator ID="CheckTxtNewPass" runat="server"
                        ErrorMessage="请输入你的新密码。"
                        ControlToValidate="TxtNewPass"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ClientIDMode="Static">
                    </asp:RequiredFieldValidator>
                    <!-- Validator to check New Pass Format -->
                    <asp:RegularExpressionValidator
                        ID="PasswordValidator"
                        runat="server"
                        ControlToValidate="TxtNewPass"
                        ErrorMessage="密码长度须为 8-20 个字符，且至少包含 1 个小写字母（a-z）、1 个大写字母（A-Z）以及 1 个数字或符号（0-9 或 !@#$）。"
                        ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9!@#$]).{8,20}$"
                        CssClass="validator-font"
                        Display="Dynamic">
                    </asp:RegularExpressionValidator>

                    <!-- Confirm New Password -->
                    <label for="TxtVerifyNewPass" style="font-size: 16px; text-align: center;">Confirm Password</label>
                    <asp:TextBox ID="TxtVerifyNewPass" runat="server"
                        TextMode="Password"
                        CssClass="input-font">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator ID="CheckVerifyNewPass" runat="server"
                        ErrorMessage="请确认你的新密码。"
                        ControlToValidate="TxtVerifyNewPass"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ClientIDMode="Static">
                    </asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvVerifyNewPass" runat="server"
                        ControlToCompare="TxtNewPass"
                        ControlToValidate="TxtVerifyNewPass"
                        ErrorMessage="密码不匹配！请检查。"
                        CssClass="validator-font">
                    </asp:CompareValidator>

                    <!-- Show Password Checkbox -->
                    <div class="content-font-style">
                        <asp:CheckBox ID="showPass" runat="server" CssClass="check-show-pass"
                            ClientIDMode="Static" Style="text-align: center;" Text="显示密码" />
                    </div>
                </div>
            </div>
            <!-- Reset Button -->
            <div class="btn-align">
                <asp:Button ID="BtnResetPass" runat="server" CssClass="btn-style" Text="立即重置" />
            </div>
        </div>
    </form>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var checkbox = document.getElementById("showPass");
            var txtNewPass = document.getElementById("TxtNewPass");
            var txtVerifyNewPass = document.getElementById("TxtVerifyNewPass");

            checkbox.addEventListener("change", function () {
                if (this.checked) {
                    txtNewPass.type = "text";
                    txtVerifyNewPass.type = "text";
                } else {
                    txtNewPass.type = "password";
                    txtVerifyNewPass.type = "password";
                }
            });
        });
    </script>
</body>
</html>