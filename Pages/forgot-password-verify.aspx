<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="forgot-password-verify.aspx.vb" Inherits="sunday_school_ms.forgot_password_verify" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Password Reset Verification</title>
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
                    <p>请输入验证码</p>
                    <%-- Verification Code --%>
                    <asp:TextBox ID="TxtVerifyCode" runat="server" CssClass="input-font">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator ID="CheckVerifyCode" runat="server"
                        ErrorMessage="请在此输入发送到您邮箱的验证码。"
                        ControlToValidate="TxtVerifyCode"
                        CssClass="validator-font"
                        Display="Dynamic"
                        ClientIDMode="Static">
                    </asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="btn-align">
                <asp:Button ID="BtnVerifyCode" runat="server" CssClass="btn-style" Text="立即验证" />
            </div>
        </div>
    </form>
</body>
</html>