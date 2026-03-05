Imports System.Data.SqlClient

Public Class manage_children
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ddlSearchActive.Items.Clear()
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("全部", "all"))
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("活跃", "0"))
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("已归档", "1"))
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("新朋友", "2"))
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("路过", "3"))
            ddlSearchActive.SelectedValue = "all"
        End If
    End Sub


    Protected Sub ddlSearchActive_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSearchActive.SelectedIndexChanged
        Dim selectedValue As String = ddlSearchActive.SelectedValue
        Response.Write("Selected: " & selectedValue)
    End Sub


    Protected Sub GridView_Child_RowCommand(sender As Object, e As GridViewCommandEventArgs) _
    Handles GridView_Child.RowCommand

        Dim childId As String = e.CommandArgument.ToString()
        Dim connectionString As String = DbHelper.GetConnectionString()

        If e.CommandName = "Archive" Then
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim updateSql As String = "
                UPDATE child
                SET isArchive = CASE WHEN isArchive = 0 THEN 1 ELSE 0 END
                WHERE child_id = @child_id
            "

                Using cmd As New SqlCommand(updateSql, connection)
                    cmd.Parameters.AddWithValue("@child_id", childId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertNotice",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("状态已更新。")}'); }}, 100);", True)
        End If


        If e.CommandName = "PassBy" Then
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim updateSql As String = "
                UPDATE child
                SET isPassing = CASE WHEN isPassing = 0 THEN 1 ELSE 0 END
                WHERE child_id = @child_id
            "

                Using cmd As New SqlCommand(updateSql, connection)
                    cmd.Parameters.AddWithValue("@child_id", childId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            'ClientScript.RegisterStartupScript(Me.GetType(), "alertPassBy",
            '"alert('路过状态已更新。');", True)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertNotice",
                                    $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("路过状态已更新。")}'); }}, 100);", True)
        End If

        GridView_Child.DataBind()
    End Sub


    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_childInfo.ConnectionString = DbHelper.GetConnectionString()
    End Sub
End Class