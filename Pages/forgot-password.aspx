<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="forgot-password.aspx.vb" Inherits="sunday_school_ms.forgot_password" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forgot Password</title>
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
                    <p>请验证您的登录信息：</p>
                    <!-- Username -->
                    <div class="login-row">
                        <label for="txtUser" style="font-size: 16px; text-align: center;">Username</label>
                        <asp:TextBox ID="txtUser" runat="server"
                            CssClass="input-font">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="ChecktxtUser" runat="server"
                            ErrorMessage="请输入用户名。"
                            ControlToValidate="txtUser"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:RequiredFieldValidator>
                    </div>

                    <%-- Send Code to Email --%>
                    <label for="txtUser" style="font-size: 16px; text-align: center;">Registered Email</label>
                    <asp:TextBox ID="TxtEmail" runat="server" CssClass="input-font">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator ID="CheckEmail" runat="server"
                        ErrorMessage="请输入注册的邮箱。"
                        ControlToValidate="TxtEmail"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ClientIDMode="Static"
                        ValidationGroup="RequiredFieldValidate">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                        ControlToValidate="TxtEmail"
                        ErrorMessage="邮箱格式不正确，请输入有效邮箱（如：myname@email.com)"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        CssClass="validator-font"
                        Display="Dynamic">
                    </asp:RegularExpressionValidator>
                </div>
            </div>
            <br />
            <div class="btn-align">
                <asp:Button ID="BtnSendCode" runat="server"
                    CssClass="btn-style"
                    ValidationGroup="RequiredFieldValidate"
                    Text="发送验证码" />
                <asp:Button ID="BtnCancel" runat="server"
                    CssClass="btn-style" Text="取消" />
            </div>
        </div>
    </form>
</body>
</html>
