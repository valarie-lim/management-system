Public Class forgot_password_verify
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Session("Username") Is Nothing Then
                ClientScript.RegisterStartupScript(Me.GetType(), "alertRedirect",
                    "alert('未找到用户名。请登录或使用忘记密码。'); window.location='login.aspx';", True)
            End If
        End If
    End Sub

    Private Sub BtnVerifyCode_Click(sender As Object, e As EventArgs) Handles BtnVerifyCode.Click
        If Page.IsValid Then
            If TxtVerifyCode.Text.Equals(Session("ResetCode")) Then
                Response.Redirect("forgot-password-reset.aspx")
            Else
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('验证码无效！请输入您邮箱收到的验证码。');", True)
            End If
        End If
    End Sub

End Class