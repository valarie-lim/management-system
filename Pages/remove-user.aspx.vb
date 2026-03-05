Imports System.Data.SqlClient
Imports System.Net
Imports System.Net.Mail

Public Class remove_user
    Inherits System.Web.UI.Page

    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("manage-users.aspx")
    End Sub

    Protected Sub GridView_RemoveUser_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView_RemoveUser.SelectedIndexChanged
        ' Retrieve selected row data
        Dim selectedRow As GridViewRow = GridView_RemoveUser.SelectedRow
        Dim staffID As String = GridView_RemoveUser.DataKeys(selectedRow.RowIndex).Value.ToString()
        Dim firstName As String = selectedRow.Cells(1).Text.Trim()
        Dim role As String = selectedRow.Cells(2).Text.Trim()
        Dim email As String = selectedRow.Cells(3).Text.Trim()
        ' Update to staff table
        Dim connectionString As String = DbHelper.GetConnectionString()
        Dim sql As String = "
            DELETE FROM login
            WHERE user_id = @staff_id;
            
            UPDATE staff
            SET isAdmin = @isAdmin
            WHERE staff_id = @staff_id;
            "
        Using connection As New SqlConnection(connectionString)
            Using updateCommand As New SqlCommand(sql, connection)
                updateCommand.Parameters.Add("@staff_id", SqlDbType.VarChar, 50).Value = staffID
                updateCommand.Parameters.Add("@isAdmin", SqlDbType.Bit).Value = False
                connection.Open()
                updateCommand.ExecuteNonQuery()
            End Using
        End Using

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("用户已成功删除。")}'); }}, 100);", True)

        GridView_RemoveUser.DataBind()
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_editUserInfo.ConnectionString = DbHelper.GetConnectionString()
    End Sub
End Class