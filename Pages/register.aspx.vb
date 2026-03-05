Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text

Public Class register
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim userId As String = Request.QueryString("userid")    ' Get user_id from the URL
            If String.IsNullOrEmpty(userId) Then
                Dim url As String = ResolveUrl("~/index.aspx")
                Response.Write("<script>alert('Access denied.'); window.location='" & url & "';</script>")
                Response.End()
                BtnCreate.Enabled = False
                Exit Sub
            End If
            Session("UserID") = userId    ' Store userId in Session for later use
        End If
    End Sub

    Private Sub BtnCreate_Click(sender As Object, e As EventArgs) Handles BtnCreate.Click
        ' Ensure UserID retrieved from the link exists in session fri
        If Session("UserID") Is Nothing OrElse String.IsNullOrEmpty(Session("UserID").ToString()) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('Cannot update account. Invalid ID.');", True)
            Return
        End If
        Dim userid As String = Session("UserID").ToString()
        Dim username As String = TxtUsername.Text.Trim()
        Dim rawPassword As String = TxtPass.Text.Trim()
        ' Required field validation for both username and password field
        If String.IsNullOrEmpty(username) OrElse String.IsNullOrEmpty(rawPassword) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('Please enter both username and password.');", True)
            Return
        End If

        Dim salt() As Byte = GenerateSalt(16)    ' Generate a 16-byte random salt
        Dim hashedPassword() As Byte = ComputeSha256HashBytes(rawPassword, salt)    ' Hash password + salt
        ' establish connection to the database
        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            ' Check acc_status if null
            Dim currentStatus As Object
            Using checkCommand As New SqlCommand("SELECT acc_status FROM dbo.login WHERE user_id = @UserID", connection)
                checkCommand.Parameters.AddWithValue("@UserID", userid)
                currentStatus = checkCommand.ExecuteScalar()
            End Using
            If currentStatus Is Nothing Then
                ClientScript.RegisterStartupScript(Me.GetType(), "error", "alert('Invalid account. User ID does not exist.');", True)
                Return
            End If
            ' if Status is new, register user credentials into the database with the password salt
            If currentStatus = "new" Then
                Dim transaction As SqlTransaction = connection.BeginTransaction()
                Try
                    Dim sql As String = "
                        UPDATE dbo.login
                        SET username = @Username,
                            password_hash = @Password,
                            password_salt = @Salt,
                            acc_status = 'active'
                        WHERE user_id = @UserID AND acc_status = 'new'"
                    Using updateCommand As New SqlCommand(sql, connection, transaction)
                        updateCommand.Parameters.AddWithValue("@Username", username)
                        updateCommand.Parameters.Add("@Password", SqlDbType.VarBinary, 64).Value = hashedPassword
                        updateCommand.Parameters.Add("@Salt", SqlDbType.VarBinary, 16).Value = salt
                        updateCommand.Parameters.AddWithValue("@UserID", userid)
                        updateCommand.ExecuteNonQuery()
                    End Using
                    transaction.Commit()
                    ClientScript.RegisterStartupScript(Me.GetType(), "alertRedirect",
                        "alert('Your account has been successfully created. You can log in now.'); window.location='login.aspx';", True)
                Catch ex As Exception
                    Try
                        transaction.Rollback()
                    Catch
                        ' Ignore errors from rollback
                    End Try
                    '' alert message for technical checking
                    'Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
                    'ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert",
                    '    "alert('Error saving data: " & safeMessage & "');", True)

                    ClientScript.RegisterStartupScript(Me.GetType(), "alertError",
                    "alert('An unexpected error occurred. Please try again or contact support.');", True)

                End Try
            End If
        End Using

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
