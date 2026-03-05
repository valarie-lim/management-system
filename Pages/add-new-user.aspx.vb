Imports System.Data.SqlClient
Imports System.Net
Imports System.Net.Mail
Imports System.Runtime.Remoting.Messaging

Public Class add_new_user
    Inherits System.Web.UI.Page

    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("manage-children.aspx")
    End Sub

    Protected Sub GridView_AddUser_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView_AddUser.SelectedIndexChanged
        Dim selectedRow As GridViewRow = GridView_AddUser.SelectedRow
        Dim staffID As String = GridView_AddUser.DataKeys(selectedRow.RowIndex).Value.ToString()
        Dim firstName As String = selectedRow.Cells(1).Text.Trim()
        Dim role As String = selectedRow.Cells(2).Text.Trim()
        Dim email As String = selectedRow.Cells(3).Text.Trim()
        ' Update to login and staff table
        Dim connectionString As String = DbHelper.GetConnectionString()
        Dim sql As String = "
            -- 1) Ensure a login row for this staff_id (insert only)
            IF NOT EXISTS (SELECT 1 FROM login WHERE user_id = @staff_id)
            BEGIN
                INSERT INTO login (user_id)
                VALUES (@staff_id);
            END

            -- 2) Set admin flag on the staff row
            UPDATE staff
            SET isAdmin = @isAdmin
            WHERE staff_id = @staff_id;
            "
        Using connection As New SqlConnection(connectionString)
            Using updateCommand As New SqlCommand(sql, connection)
                updateCommand.Parameters.Add("@staff_id", SqlDbType.VarChar, 50).Value = staffID
                updateCommand.Parameters.Add("@isAdmin", SqlDbType.Bit).Value = True
                connection.Open()
                updateCommand.ExecuteNonQuery()
            End Using
        End Using

        ' Send account register email to the selected staff email
        Dim emailSent As Boolean = False
        If Not String.IsNullOrEmpty(email) Then
            Try
                ' double check and validate if the retrieve string is a proper email
                email = email.Trim()
                If Not email.Contains("@") Then Throw New Exception("Recipient email is invalid.")

                Dim from As String = "bemkchsundayschool@gmail.com"
                Dim smtpUser As String = "9a59db001@smtp-brevo.com"
                Dim smtpPass As String = "xsmtpsib-91b5119e30a26aba292c781ed745af84d552deff7af05b986f002cc79d6cde91-Jmmj8vt5Cr1u4Fq0"

                Dim message As New MailMessage()
                message.To.Add(email)
                message.From = New MailAddress(from)
                message.Subject = "您的系统账号已成功创建"
                ' Send account registration link
                Dim register As String = Request.Url.GetLeftPart(UriPartial.Authority) & "/Pages/register.aspx?userid=" & staffID
                Dim uniqueTimestamp As String = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")

                message.Body = "<html><body><!-- Unique ID: " & Guid.NewGuid().ToString() & " -->" &
                    "<div style='font-family:Arial, sans-serif;'>" &
                    "<p>Hi <b>" & firstName & " " & role & "</b>,</p>" &
                    "<p>Your account has been created.</p>" &
                    "<p>You may register your login credential at the link below:</p>" &
                    "<p><a href='" & register & "' style='display:inline-block;padding:10px 20px;background-color:#EC3237;color:#fff;text-decoration:none;border-radius:5px;'>Register Now</a></p>" &
                    "<p>If you did not request this registration, please ignore this email or contact our support team immediately.</p>" &
                    "<p>Thank you,<br/>Sunday School BEM KCH Support Team</p>" &
                    "<hr/><p style='font-size:10px;color:#888;'>Email Sent On: " & uniqueTimestamp & "</p>" &
                    "</div></body></html>"
                message.IsBodyHtml = True

                Dim smtp As New SmtpClient("smtp-relay.brevo.com", 587)
                smtp.EnableSsl = True
                smtp.UseDefaultCredentials = False
                smtp.Credentials = New NetworkCredential(smtpuser, smtppass)
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network

                smtp.Send(message)
                emailSent = True


            Catch ex As SmtpException
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert",
                                                    "alert('SMTP ERROR: " & ex.StatusCode.ToString() & " - " & ex.Message.Replace("'", "\'") & "');", True)
            Catch ex As Exception
                ' Email failed but account updated
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("账号已更新，但邮件发送失败：" & ex.Message.Replace("'", "\'") & "")}'); }}, 100);", True)

            End Try
        End If
        ' Show success email sent out message
        If emailSent Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("新的系统用户已添加，注册链接已成功发送。")}'); }}, 100);", True)

        ElseIf String.IsNullOrEmpty(email) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("账号创建成功，但未提供电子邮箱。")}'); }}, 100);", True)

        End If

        ' Refresh the gridview and remove the email send user from the list
        GridView_AddUser.DataBind()
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_editUserInfo.ConnectionString = DbHelper.GetConnectionString()
    End Sub
End Class