Imports System.Data.SqlClient
Imports System.Security.Cryptography

Public Class forgot_password_reset
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Session("ResetCode") Is Nothing Then
                ClientScript.RegisterStartupScript(Me.GetType(), "alertRedirect",
                "alert('请登录以使用系统功能。'); window.location='login.aspx';", True)
                Return
            End If
        End If
    End Sub

    Private Sub BtnResetPass_Click(sender As Object, e As EventArgs) Handles BtnResetPass.Click
        If Page.IsValid Then
            Dim rawPassword As String = TxtVerifyNewPass.Text.Trim()

            Dim connectionString As String = DbHelper.GetConnectionString()
            Dim salt As Byte() = GenerateSalt(16)
            Dim hashedPassword() As Byte = ComputeSha256HashBytes(rawPassword, salt)

            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim transaction As SqlTransaction = connection.BeginTransaction()

                ' Database transaction error handling
                Try
                    ' Update new password into Login Table
                    Dim passwordQuery As String = "
                        UPDATE dbo.login
                        SET password_hash = @password_hash,
                            password_salt = @password_salt
                        WHERE username = @username;"

                    Using resetCommand As New SqlCommand(passwordQuery, connection, transaction)
                        resetCommand.Parameters.Add("@password_hash", SqlDbType.VarBinary, 64).Value = hashedPassword
                        resetCommand.Parameters.Add("@password_salt", SqlDbType.VarBinary, 16).Value = salt
                        resetCommand.Parameters.AddWithValue("@username", Session("Username"))

                        Dim rowsAffected As Integer = resetCommand.ExecuteNonQuery()

                        If rowsAffected > 0 Then
                            ' Commit inserts
                            transaction.Commit()

                            ' Redirect to reset confirmation page
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                                    "alert('密码已重置成功！您现在可以使用新密码登录。');
                                    window.location='Login.aspx';", True)
                        End If
                    End Using

                Catch ex As Exception
                    transaction.Rollback()

                    '' alert message for technical checking
                    'Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
                    'ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert",
                    '    "alert('Error saving data: " & safeMessage & "');", True)

                    ClientScript.RegisterStartupScript(Me.GetType(), "alertError",
                    "alert('出现意外错误，请重试或联系客服。');", True)

                End Try
            End Using
        End If
    End Sub

    ' Generate random salt for password salting
    Private Function GenerateSalt(size As Integer) As Byte()
        Dim salt(size - 1) As Byte
        Using rng As New System.Security.Cryptography.RNGCryptoServiceProvider()
            rng.GetBytes(salt)
        End Using
        Return salt
    End Function

    ' Hash password combined with salt
    Private Function ComputeSha256HashBytes(password As String, salt() As Byte) As Byte()
        Dim passwordBytes() As Byte = System.Text.Encoding.UTF8.GetBytes(password)
        Dim combined(passwordBytes.Length + salt.Length - 1) As Byte
        ' Copy password bytes first, then salt the bytes
        System.Buffer.BlockCopy(passwordBytes, 0, combined, 0, passwordBytes.Length)
        System.Buffer.BlockCopy(salt, 0, combined, passwordBytes.Length, salt.Length)
        Using sha256 As System.Security.Cryptography.SHA256 = System.Security.Cryptography.SHA256.Create()
            Return sha256.ComputeHash(combined)
        End Using
    End Function

End Class