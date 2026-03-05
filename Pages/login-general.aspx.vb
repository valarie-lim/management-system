Imports System.Data.SqlClient

Public Class login_general
    Inherits System.Web.UI.Page

    Private Sub BtnAccess_Click(sender As Object, e As EventArgs) Handles BtnAccess.Click
        Dim userName As String = txtName.Text.Trim()
        Dim userRole As String = txtRole.Text.Trim()
        ' --- Required Field Validation ---
        If String.IsNullOrEmpty(userName) OrElse String.IsNullOrEmpty(userRole) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('请输入姓名与角色。');", True)
            Exit Sub
        End If
        Dim connectionString As String = DbHelper.GetConnectionString()

        ' --- Verify registered name and staff role (both must match to proceed) ---
        Dim sql As String = "
            SELECT p.first_name, s.role
            FROM dbo.person p
            INNER JOIN dbo.staff s ON p.person_id = s.person_id
            WHERE p.first_name = @first_name AND s.role = @role"
        Try
            Using connection As New SqlConnection(connectionString)
                Using command As New SqlCommand(sql, connection)
                    command.Parameters.AddWithValue("@first_name", userName)
                    command.Parameters.AddWithValue("@role", userRole)
                    connection.Open()
                    Using reader As SqlDataReader = command.ExecuteReader()
                        If reader.Read() Then
                            ' if identity is valid, store session info
                            Session("UserFirstName") = reader("first_name").ToString()
                            Session("UserRole") = reader("role").ToString()
                            ' Display welcome message and redirect to record attendance page
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                                "alert('欢迎使用古晋真道堂儿童主日学资料管理系统。'); window.location='attendance-record.aspx';", True)
                        Else
                            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('姓名或角色无效。');", True)
                        End If
                    End Using
                End Using
            End Using
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "alertError",
                "alert('出现未知错误，请重试或联系客服。');", True)
        End Try
    End Sub

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        Response.Redirect(ResolveUrl("~/index.aspx"), False)
    End Sub
End Class
