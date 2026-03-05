Imports System.Data.SqlClient
Imports System.Net
Imports System.Net.Mail

Public Class forgot_password
    Inherits System.Web.UI.Page

    Private Sub BtnSendCode_Click(sender As Object, e As EventArgs) Handles BtnSendCode.Click
        Session("Username") = txtUser.Text.Trim()

        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()

            ' Get user email using INNER JOIN
            Dim staffSql As String = "
                SELECT s.email
                FROM dbo.staff s
                INNER JOIN dbo.login l ON s.staff_id = l.user_id
                WHERE l.username = @username"

            Using staffCommand As New SqlCommand(staffSql, connection)
                staffCommand.Parameters.AddWithValue("@username", txtUser.Text)

                Using staffReader As SqlDataReader = staffCommand.ExecuteReader()
                    If staffReader.Read() Then
                        ' Store email in session
                        Session("UserEmail") = staffReader("email").ToString()
                    Else
                        ' Username not found
                        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('未找到用户名或邮箱，请再次确认。');", True)
                        Exit Sub
                    End If
                End Using
            End Using
        End Using

        ' Validate email entered by user
        Dim userEmail As String = TxtEmail.Text.Trim()
        If userEmail.Trim().ToLower() <> Session("UserEmail").ToString().Trim().ToLower() Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('未找到用户名或邮箱，请再次确认。');", True)
            Exit Sub
        End If

        ' Generate random 6-digit verification code
        Dim rand As New Random()
        Dim randomCode As String = rand.Next(0, 999999).ToString("D6")
        Session("ResetCode") = randomCode

        ' Email configuration
        Dim from As String = "bemkchsundayschool@gmail.com"
        Dim smtpUser As String = "9a59db001@smtp-brevo.com"
        Dim smtpPass As String = "xsmtpsib-91b5119e30a26aba292c781ed745af84d552deff7af05b986f002cc79d6cde91-Jmmj8vt5Cr1u4Fq0"
        Dim uniqueTimestamp As String = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")

        Dim message As New MailMessage()
        message.To.Add(TxtEmail.Text)
        message.From = New MailAddress(from)
        message.Subject = "古晋真道堂儿童主日学 - 密码重置请求"

        message.IsBodyHtml = True
        message.Body =
            "<html><body><!-- Unique ID: " & Guid.NewGuid().ToString() & " -->" &
            "<div style='font-family:Microsoft YaHei, SimSun, SimHei, sans-serif;'>" &
            "<p>哈咯 <b>" & Session("Username") & "</b>,</p>" &
            "<p>你的 <b>验证码</b> 是: <b>" & randomCode & "</b></p>" &
            "<p>如果您没有申请此操作，请忽略此邮件，或马上联系客服。</p>" &
            "<br/>" &
            "<p>谢谢,<br/>古晋真道堂儿童主日学</p>" &
            "<hr/>" &
            "<p style='font-size:10px;color:#888;'>Email Sent On: " & uniqueTimestamp & "</p>" &
            "</div></body></html>"

        Dim smtp As New SmtpClient("smtp-relay.brevo.com", 587)
        smtp.EnableSsl = True
        smtp.UseDefaultCredentials = False
        smtp.Credentials = New NetworkCredential(smtpUser, smtpPass)
        smtp.DeliveryMethod = SmtpDeliveryMethod.Network

        Try
            smtp.Send(message)
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                "alert('已向注册邮箱发送验证码，请查看。'); window.location='forgot-password-verify.aspx';", True)
        Catch ex As Exception
            '' alert message for technical checking
            'Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
            'ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert",
            '    "alert('Error saving data: " & safeMessage & "');", True)

            ClientScript.RegisterStartupScript(Me.GetType(), "alertError",
                "alert('出现意外错误，请重试或联系客服。');", True)

        End Try
    End Sub


    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        Response.Redirect("login.aspx")
    End Sub

End Class