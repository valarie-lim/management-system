Imports System.Data.SqlClient
Imports System.Net
Imports System.Net.Mail

Public Class activate_account
    Inherits System.Web.UI.Page


    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("manage-users.aspx")
    End Sub
    Private Sub BtnDashboard_Click(sender As Object, e As EventArgs) Handles BtnDashboard.Click
        Response.Redirect("admin-dashboard.aspx")
    End Sub
    Protected Sub BtnSearch_Click(sender As Object, e As EventArgs) Handles BtnSearch.Click
        GridView_EditUserInfo.DataBind()
    End Sub

    Protected Sub GridView_EditUserInfo_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView_EditUserInfo.SelectedIndexChanged
        Dim selectedUserID As String = GridView_EditUserInfo.SelectedDataKey.Value.ToString()
        Dim connectionString As String = DbHelper.GetConnectionString()
        Dim email As String = ""
        Dim staffName As String = ""
        Dim username As String = ""

        ' Update account status and reset attempts, then get email and name
        Using connection As New SqlConnection(connectionString)
            connection.Open()

            ' Update query
            Dim updateSql As String = "
            UPDATE login
            SET acc_status = 'Active', failed_attempts = 0
            WHERE user_id = @user_id"
            Using updateCmd As New SqlCommand(updateSql, connection)
                updateCmd.Parameters.AddWithValue("@user_id", selectedUserID)
                updateCmd.ExecuteNonQuery()
            End Using

            ' Retrieve email and name
            Dim selectSql As String = "
            SELECT p.first_name, s.email, l.username
            FROM person p
            INNER JOIN staff s ON p.person_id = s.person_id
            INNER JOIN login l ON s.staff_id = l.user_id
            WHERE l.user_id = @user_id"
            Using selectCmd As New SqlCommand(selectSql, connection)
                selectCmd.Parameters.AddWithValue("@user_id", selectedUserID)
                Using reader As SqlDataReader = selectCmd.ExecuteReader()
                    If reader.Read() Then
                        email = reader("email").ToString()
                        staffName = reader("first_name").ToString()
                        username = reader("username").ToString()
                    End If
                End Using
            End Using
        End Using

        ' Send reactivation email if email exists
        If Not String.IsNullOrEmpty(email) Then
            Try
                Dim from As String = "bemkchsundayschool@gmail.com"
                Dim smtpUser As String = "9a59db001@smtp-brevo.com"
                Dim smtpPass As String = "xsmtpsib-91b5119e30a26aba292c781ed745af84d552deff7af05b986f002cc79d6cde91-Jmmj8vt5Cr1u4Fq0"

                Dim message As New MailMessage()
                message.To.Add(email)
                message.From = New MailAddress(from)
                message.Subject = "Your Sunday School Account Has Been Reactivated – Action Required"

                Dim resetLink As String = Request.Url.GetLeftPart(UriPartial.Authority) & ResolveUrl("~/Pages/forgot-password.aspx")
                Dim uniqueTimestamp As String = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")

                message.Body = "<html><body><!-- Unique ID: " & Guid.NewGuid().ToString() & " -->" &
                    "<div style='font-family:Arial, sans-serif;'>" &
                    "<p>Hi <b>" & staffName & "</b>,</p>" &
                    "<p>Your account has been successfully reactivated.</p>" &
                    "<p>For security reasons, you are required to reset your password before logging in again.
                    <br/>Please click the button below to reset your password:</p>" &
                    "<p><a href='" & resetLink & "' style='display:inline-block;padding:10px 20px;background-color:#EC3237;color:#fff;text-decoration:none;border-radius:5px;'>Reset Password</a></p>" &
                    "<p>If you did not request this reactivation, please ignore this email or contact our support team immediately.</p>" &
                    "<br/><p>Thank you,<br/>Sunday School BEM KCH Support Team</p>" &
                    "<hr/><p style='font-size:10px;color:#888;'>Email Sent On: " & uniqueTimestamp & "</p>" &
                    "</div></body></html>"
                message.IsBodyHtml = True

                Dim smtp As New SmtpClient("smtp-relay.brevo.com", 587)
                smtp.EnableSsl = True
                smtp.UseDefaultCredentials = False
                smtp.Credentials = New NetworkCredential(smtpUser, smtpPass)
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network

                smtp.Send(message)

                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("用户账号已激活，邮件已成功发送。")}'); }}, 100);", True)

            Catch ex As Exception
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                    $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("发送邮件出错: " & ex.Message.Replace("'", "\'") & "")}'); }}, 100);", True)

            End Try
        Else
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("未找到用户邮箱，账号已更新，但未发送邮件。")}'); }}, 100);", True)

        End If

        ' Refresh GridView
        GridView_EditUserInfo.DataBind()

    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_editUserInfo.ConnectionString = DbHelper.GetConnectionString()
    End Sub


End Class