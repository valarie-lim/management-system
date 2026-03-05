Imports System.Data.SqlClient
Imports System.Security.Cryptography

Public Class login
    Inherits System.Web.UI.Page

    Private Sub BtnLogin_Click(sender As Object, e As EventArgs) Handles BtnLogin.Click
        Dim username As String = txtUser.Text.Trim()
        Dim pass As String = txtPass.Text.Trim()
        Session("Username") = username
        Dim connectionString As String = DbHelper.GetConnectionString()
        Dim sql As String = "
        SELECT password_hash, password_salt, failed_attempts, acc_status, login_time, user_id
        FROM dbo.login
        WHERE username = @username"
        Try
            Using connection As New SqlConnection(connectionString)
                Using loginCommand As New SqlCommand(sql, connection)
                    loginCommand.Parameters.AddWithValue("@username", username)
                    connection.Open()
                    Using reader As SqlDataReader = loginCommand.ExecuteReader()
                        If Not reader.Read() Then
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('用户名或密码无效。');", True)
                            Exit Sub
                        End If
                        ' Retrieve database fields
                        Dim dbPassHash As Byte() = CType(reader("password_hash"), Byte())
                        Dim dbSalt As Byte() = CType(reader("password_salt"), Byte()) ' <-- Get salt from DB
                        Dim failedAttempts As Integer = If(IsDBNull(reader("failed_attempts")), 0, Convert.ToInt32(reader("failed_attempts")))
                        Dim accStatus As String = If(IsDBNull(reader("acc_status")), "active", reader("acc_status").ToString())
                        Session("UserID") = If(IsDBNull(reader("user_id")), Nothing, reader("user_id").ToString())
                        reader.Close()
                        ' Account locked check 
                        If accStatus = "locked" Then
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                                                               "alert('您的账号已被锁定，请联系技术支持团队。');", True)
                            Exit Sub
                        End If
                        ' Compare hashed password using salt
                        Dim enteredHash As Byte() = ComputeSha256HashBytes(pass, dbSalt)
                        If dbPassHash.SequenceEqual(enteredHash) Then
                            ' Login successful and reset failed_attempts
                            Dim resetSql As String = "
                            UPDATE dbo.login
                            SET failed_attempts = 0, login_time = @loginTime
                            WHERE username = @username"
                            Using resetCommand As New SqlCommand(resetSql, connection)
                                Dim utcNow As DateTime = DateTime.UtcNow
                                Dim singaporeTime As DateTime = TimeZoneInfo.ConvertTimeFromUtc(utcNow, TimeZoneInfo.FindSystemTimeZoneById("Singapore Standard Time"))
                                resetCommand.Parameters.AddWithValue("@loginTime", singaporeTime)
                                resetCommand.Parameters.AddWithValue("@username", username)
                                resetCommand.ExecuteNonQuery()
                                Session("LoginTime") = singaporeTime
                            End Using
                            ' Get the user information from the database using the helper function
                            GetUserInfoQuery(connectionString)
                            ' Login validation successful and redirect to main menu page
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                                                           "alert('欢迎使用古晋真道堂儿童主日学资料管理系统。'); window.location='admin-dashboard.aspx';", True)
                        Else
                            ' if password not found increase failed_attempts number. Reach 3 will update acc_status to locked and user account is blocked
                            failedAttempts += 1
                            If failedAttempts >= 3 Then
                                Dim lockSql As String = "
                                UPDATE dbo.login
                                SET failed_attempts = @fa, acc_status = 'locked'
                                WHERE username = @username"
                                Using lockCommand As New SqlCommand(lockSql, connection)
                                    lockCommand.Parameters.AddWithValue("@fa", failedAttempts)
                                    lockCommand.Parameters.AddWithValue("@username", username)
                                    lockCommand.ExecuteNonQuery()
                                End Using
                                ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                                               "alert('您的账号已被锁定，请联系技术支持团队。');", True)
                            Else
                                Dim failSql As String = "
                                UPDATE dbo.login
                                SET failed_attempts = @fa
                                WHERE username = @username"
                                Using failCommand As New SqlCommand(failSql, connection)
                                    failCommand.Parameters.AddWithValue("@fa", failedAttempts)
                                    failCommand.Parameters.AddWithValue("@username", username)
                                    failCommand.ExecuteNonQuery()
                                End Using
                                Dim left As Integer = 3 - failedAttempts
                                ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                                    "alert('用户名或密码无效。您还有" & left & " 次机会，尝试 3 次后账号将被锁定。');", True)
                            End If
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('System Error: " & ex.Message.Replace("'", "\'") & "');", True)
        End Try
    End Sub
    Private Function ComputeSha256HashBytes(password As String, salt() As Byte) As Byte()
        Dim passwordBytes() As Byte = System.Text.Encoding.UTF8.GetBytes(password)
        Dim combined(passwordBytes.Length + salt.Length - 1) As Byte

        ' Combine password bytes and salt
        System.Buffer.BlockCopy(passwordBytes, 0, combined, 0, passwordBytes.Length)
        System.Buffer.BlockCopy(salt, 0, combined, passwordBytes.Length, salt.Length)

        Using sha256 As System.Security.Cryptography.SHA256 = System.Security.Cryptography.SHA256.Create()
            Return sha256.ComputeHash(combined)
        End Using
    End Function

    Private Sub GetUserInfoQuery(connectionString As String)
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            ' Before redirect to the next page, get user name, contact, role from staff table
            Dim userSql As String = "
                                SELECT p.first_name, p.chinese_name, p.contact_no, s.role, s.isAdmin
                                FROM dbo.person p
                                INNER JOIN dbo.staff s ON p.person_id = s.person_id
                                INNER JOIN dbo.login l ON s.staff_id = l.user_id
                                WHERE l.username = @username"
            Using userCommand As New SqlCommand(userSql, connection)
                userCommand.Parameters.AddWithValue("@username", txtUser.Text)
                Using userReader As SqlDataReader = userCommand.ExecuteReader()
                    If userReader.Read() Then
                        ' Store in session
                        Session("UserFirstName") = If(IsDBNull(userReader("first_name")), "", userReader("first_name").ToString())
                        Session("UserChineseName") = If(IsDBNull(userReader("chinese_name")), "", userReader("chinese_name").ToString())
                        Session("UserPhone") = If(IsDBNull(userReader("contact_no")), "", userReader("contact_no").ToString())
                        Session("UserRole") = If(IsDBNull(userReader("role")), "", userReader("role").ToString())
                        Dim isAdminValue As Boolean = If(IsDBNull(userReader("isAdmin")), False, Convert.ToBoolean(userReader("isAdmin")))
                        Session("IsAdmin") = isAdminValue
                    End If
                End Using
            End Using
        End Using
    End Sub


    Private Sub ForgotPass_Click(sender As Object, e As EventArgs) Handles ForgotPass.Click
        Response.Redirect("forgot-password.aspx")
    End Sub

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        Response.Redirect(ResolveUrl("~/index.aspx"), False)
    End Sub
End Class