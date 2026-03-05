Imports System.Data.SqlClient

Public Class manage_activity
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Load all activities initially
            SqlDataSource_viewActivity.SelectParameters("Year").DefaultValue = "0"
            GridView_Activity.DataBind()
        End If
    End Sub

    Private Sub BtnSearch_Click(sender As Object, e As EventArgs) Handles BtnSearch.Click
        GridView_Activity.DataBind()
    End Sub

    Protected Sub txtActivityYear_TextChanged(sender As Object, e As EventArgs) Handles txtActivityYear.TextChanged
        Dim yearValue As Integer
        If String.IsNullOrWhiteSpace(txtActivityYear.Text) Then
            ' No year entered → show all
            SqlDataSource_viewActivity.SelectParameters("Year").DefaultValue = Nothing
        ElseIf Integer.TryParse(txtActivityYear.Text, yearValue) Then
            ' Valid year → filter by this year
            SqlDataSource_viewActivity.SelectParameters("Year").DefaultValue = yearValue
        Else
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("请输入年份。")}'); }}, 100);", True)
            Exit Sub
        End If

        GridView_Activity.DataBind()
    End Sub

    Protected Sub GridView_Activity_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles GridView_Activity.RowUpdating
        e.Cancel = True  ' Prevent automatic SqlDataSource update

        Dim row As GridViewRow = GridView_Activity.Rows(e.RowIndex)
        Dim scheduleId As Integer = CInt(GridView_Activity.DataKeys(e.RowIndex).Value)

        ' get new activity_id
        Dim ddlActivityName As DropDownList = CType(row.FindControl("ddlActivityName"), DropDownList)
        Dim newActivityId As String = ddlActivityName.SelectedValue
        If String.IsNullOrEmpty(newActivityId) Then
            Exit Sub
        End If

        ' get new activity_date
        Dim txtActivityDate As TextBox = CType(row.FindControl("txtActivityDate"), TextBox)
        Dim newActivityDate As DateTime
        If Not DateTime.TryParse(txtActivityDate.Text, newActivityDate) Then
            Exit Sub
        End If

        ' get new material_id
        Dim ddlMaterialName As DropDownList = CType(row.FindControl("ddlMaterialName"), DropDownList)
        Dim newMaterialId As String = ddlMaterialName.SelectedValue
        If String.IsNullOrEmpty(newMaterialId) Then
            Exit Sub
        End If

        ' update database

        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()

            ' Update activitySchedule: activity_id and activity_date
            Using updateCommand As New SqlCommand("
            UPDATE activitySchedule
            SET activity_id=@activity_id, activity_date=@activity_date
            WHERE schedule_id=@schedule_id", connection)
                updateCommand.Parameters.AddWithValue("@activity_id", newActivityId)
                updateCommand.Parameters.AddWithValue("@activity_date", newActivityDate)
                updateCommand.Parameters.AddWithValue("@schedule_id", scheduleId)
                Dim rows As Integer = updateCommand.ExecuteNonQuery()
                If rows = 0 Then
                    Exit Sub
                End If
            End Using

            ' Update scheduleMaterial: material_id
            Using updateCommand As New SqlCommand("
                UPDATE scheduleMaterial
                SET material_id = @material_id
                WHERE schedule_id = @schedule_id", connection)

                If newMaterialId = "None" Then
                    updateCommand.Parameters.AddWithValue("@material_id", "None")
                Else
                    updateCommand.Parameters.AddWithValue("@material_id", newMaterialId)
                End If

                updateCommand.Parameters.AddWithValue("@schedule_id", scheduleId)

                Dim rows As Integer = updateCommand.ExecuteNonQuery()
                If rows > 0 Then
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("资料更新成功！")}'); }}, 100);", True)
                    Exit Sub
                End If
            End Using
        End Using

        ' Exit edit mode and refresh GridView
        GridView_Activity.EditIndex = -1
        GridView_Activity.DataBind()
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_viewActivity.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_ActivitiesList.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_MaterialsList.ConnectionString = DbHelper.GetConnectionString()
    End Sub
End Class