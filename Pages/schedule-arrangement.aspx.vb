Imports System.Data.SqlClient

Public Class schedule_arrangement
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Load all activities initially
            SqlDataSource_Arrangement.SelectParameters("Year").DefaultValue = "0"
            GridView_Arrangement.DataBind()
        End If
    End Sub

    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("admin-dashboard.aspx")
    End Sub

    Private Sub BtnReport_Click(sender As Object, e As EventArgs) Handles BtnReport.Click
        Response.Redirect("report-teacher-activity-schedule.aspx")
    End Sub


    Protected Sub TxtActivityYear_TextChanged(sender As Object, e As EventArgs) Handles TxtActivityYear.TextChanged

        Dim yearValue As Integer
        If String.IsNullOrWhiteSpace(TxtActivityYear.Text) Then
            ' No year entered → show all
            SqlDataSource_Arrangement.SelectParameters("Year").DefaultValue = Nothing
        ElseIf Integer.TryParse(TxtActivityYear.Text, yearValue) Then
            ' Valid year → filter by this year
            SqlDataSource_Arrangement.SelectParameters("Year").DefaultValue = yearValue
        Else
            ' Invalid input → alert user
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('请输入年份。');", True)
            Exit Sub
        End If

        FilterGrid(sender, e)
    End Sub

    Protected Sub FilterGrid(sender As Object, e As EventArgs)
        Dim year As Integer
        If Not Integer.TryParse(TxtActivityYear.Text, year) Then
            year = 0 ' show all if input is invalid
        End If

        Dim halfYear As Integer = Convert.ToInt32(rblHalfYear.SelectedValue)

        SqlDataSource_Arrangement.SelectParameters("Year").DefaultValue = year
        SqlDataSource_Arrangement.SelectParameters("HalfYear").DefaultValue = halfYear

        GridView_Arrangement.DataBind()
    End Sub

    ' To display the right value on the dropdownlist during edit
    Protected Sub GridView_Arrangement_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView_Arrangement.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow AndAlso GridView_Arrangement.EditIndex = e.Row.RowIndex Then

            ' Helper function to set DropDownList
            Dim SetDropDownList As Action(Of String, String) =
            Sub(dropdownID As String, dataField As String)
                Dim ddl As DropDownList = CType(e.Row.FindControl(dropdownID), DropDownList)
                If ddl IsNot Nothing Then
                    ' Ensure empty item exists
                    If ddl.Items.FindByValue("") Is Nothing Then
                        ddl.Items.Insert(0, New ListItem("", ""))
                    End If

                    ' Set selected value if it exists
                    Dim currentValue As String = DataBinder.Eval(e.Row.DataItem, dataField).ToString()
                    If ddl.Items.FindByText(currentValue) IsNot Nothing Then
                        ddl.SelectedValue = ddl.Items.FindByText(currentValue).Value
                    End If
                End If
            End Sub

            ' ALL class-CL00
            SetDropDownList("ddlEditPianist_ALL", "CL00-Pianist")
            SetDropDownList("ddlEditSongLeader1_ALL", "CL00-SongLeader1")
            SetDropDownList("ddlEditSongLeader2_ALL", "CL00-SongLeader2")
            SetDropDownList("ddlEditTheory_ALL", "CL00-Theory")
            SetDropDownList("ddlEditPrayer_ALL", "CL00-Prayer")

            ' CL01 class
            SetDropDownList("ddlEditSpeaker_CL01", "CL01-Speaker")
            SetDropDownList("ddlEditTA_CL01", "CL01-Assistant")

            ' CL02 class
            SetDropDownList("ddlEditSpeaker_CL02", "CL02-Speaker")
            SetDropDownList("ddlEditTA_CL02", "CL02-Assistant")

            ' CL03 class
            SetDropDownList("ddlEditSpeaker_CL03", "CL03-Speaker")
            SetDropDownList("ddlEditTA_CL03", "CL03-Assistant")

            ' CL04 class
            SetDropDownList("ddlEditSpeaker_CL04", "CL04-Speaker")
            SetDropDownList("ddlEditTA_CL04", "CL04-Assistant")

            ' CL05 class
            SetDropDownList("ddlEditSpeaker_CL05", "CL05-Speaker")
            SetDropDownList("ddlEditTA_CL05", "CL05-Assistant")

        End If
    End Sub


    ' To update the right value on each row value in the pivot table
    Protected Sub GridView_Arrangement_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles GridView_Arrangement.RowUpdating
        e.Cancel = True

        Dim row As GridViewRow = GridView_Arrangement.Rows(e.RowIndex)

        ' Get the record date from the row (optional, used for identifying rows)
        Dim scheduleID As Integer = CInt(GridView_Arrangement.DataKeys(e.RowIndex).Values("schedule_id"))

        ' All class together
        Dim ddlSongLeader1 As DropDownList = CType(row.FindControl("ddlEditSongLeader1_ALL"), DropDownList)
        Dim ddlSongLeader2 As DropDownList = CType(row.FindControl("ddlEditSongLeader2_ALL"), DropDownList)
        Dim ddlPianist As DropDownList = CType(row.FindControl("ddlEditPianist_ALL"), DropDownList)
        Dim ddlTheory As DropDownList = CType(row.FindControl("ddlEditTheory_ALL"), DropDownList)
        Dim ddlPrayer As DropDownList = CType(row.FindControl("ddlEditPrayer_ALL"), DropDownList)

        ' CL01 class
        Dim ddlClassCL01 As DropDownList = CType(row.FindControl("ddlEditClass_CL01"), DropDownList)
        Dim ddlSpeakerCL01 As DropDownList = CType(row.FindControl("ddlEditSpeaker_CL01"), DropDownList)
        Dim ddlTACL01 As DropDownList = CType(row.FindControl("ddlEditTA_CL01"), DropDownList)

        ' CL02 class
        Dim ddlClassCL02 As DropDownList = CType(row.FindControl("ddlEditClass_CL02"), DropDownList)
        Dim ddlSpeakerCL02 As DropDownList = CType(row.FindControl("ddlEditSpeaker_CL02"), DropDownList)
        Dim ddlTACL02 As DropDownList = CType(row.FindControl("ddlEditTA_CL02"), DropDownList)

        ' CL03 class
        Dim ddlClassCL03 As DropDownList = CType(row.FindControl("ddlEditClass_CL03"), DropDownList)
        Dim ddlSpeakerCL03 As DropDownList = CType(row.FindControl("ddlEditSpeaker_CL03"), DropDownList)
        Dim ddlTACL03 As DropDownList = CType(row.FindControl("ddlEditTA_CL03"), DropDownList)

        ' CL02 class
        Dim ddlClassCL04 As DropDownList = CType(row.FindControl("ddlEditClass_CL04"), DropDownList)
        Dim ddlSpeakerCL04 As DropDownList = CType(row.FindControl("ddlEditSpeaker_CL04"), DropDownList)
        Dim ddlTACL04 As DropDownList = CType(row.FindControl("ddlEditTA_CL04"), DropDownList)

        ' CL02 class
        Dim ddlClassCL05 As DropDownList = CType(row.FindControl("ddlEditClass_CL05"), DropDownList)
        Dim ddlSpeakerCL05 As DropDownList = CType(row.FindControl("ddlEditSpeaker_CL05"), DropDownList)
        Dim ddlTACL05 As DropDownList = CType(row.FindControl("ddlEditTA_CL05"), DropDownList)

        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()

            ' Update All class together
            UpdateRole(connection, scheduleID, "CL00", "SL-03", ddlPianist.SelectedValue)
            UpdateRole(connection, scheduleID, "CL00", "SL-05", ddlSongLeader1.SelectedValue)
            UpdateRole(connection, scheduleID, "CL00", "SL-06", ddlSongLeader2.SelectedValue)
            UpdateRole(connection, scheduleID, "CL00", "SL-07", ddlTheory.SelectedValue)
            UpdateRole(connection, scheduleID, "CL00", "SL-02", ddlPrayer.SelectedValue)

            ' Update CL01 class
            UpdateRole(connection, scheduleID, "CL01", "SL-04", ddlSpeakerCL01.SelectedValue)
            UpdateRole(connection, scheduleID, "CL01", "SL-01", ddlTACL01.SelectedValue)

            ' Update CL02 class
            UpdateRole(connection, scheduleID, "CL02", "SL-04", ddlSpeakerCL02.SelectedValue)
            UpdateRole(connection, scheduleID, "CL02", "SL-01", ddlTACL02.SelectedValue)

            ' Update CL03 class
            UpdateRole(connection, scheduleID, "CL03", "SL-04", ddlSpeakerCL03.SelectedValue)
            UpdateRole(connection, scheduleID, "CL03", "SL-01", ddlTACL03.SelectedValue)

            ' Update CL04 class
            UpdateRole(connection, scheduleID, "CL04", "SL-04", ddlSpeakerCL04.SelectedValue)
            UpdateRole(connection, scheduleID, "CL04", "SL-01", ddlTACL04.SelectedValue)

            ' Update CL05 class
            UpdateRole(connection, scheduleID, "CL05", "SL-04", ddlSpeakerCL05.SelectedValue)
            UpdateRole(connection, scheduleID, "CL05", "SL-01", ddlTACL05.SelectedValue)

            '--- delete any rows where staff_id is NULL ---
            Dim deleteNullCommand As New SqlCommand("
            DELETE FROM staffTeachingRecord
            WHERE staff_id IS NULL
              AND schedule_id = @schedule_id;
            ", connection)

            deleteNullCommand.Parameters.AddWithValue("@schedule_id", scheduleID)
            deleteNullCommand.ExecuteNonQuery()
        End Using

        ' Exit edit mode and rebind grid
        GridView_Arrangement.EditIndex = -1
        GridView_Arrangement.DataBind()
    End Sub

    ' Helper function to update a single role
    Private Sub UpdateRole(connection As SqlConnection, scheduleID As Integer, classID As String, serviceType As String, staffID As String)
        Dim getDateCommand As New SqlCommand("
            SELECT DISTINCT act.activity_date
            FROM staffTeachingRecord str
            INNER JOIN activitySchedule act ON str.schedule_id = act.schedule_id
            WHERE act.schedule_id = @id", connection)
        getDateCommand.Parameters.Add("@id", SqlDbType.Int).Value = scheduleID

        Dim activityScheduleDate As Object = getDateCommand.ExecuteScalar()
        If activityScheduleDate Is Nothing OrElse activityScheduleDate Is DBNull.Value Then
            Throw New InvalidOperationException("未找到" & scheduleID.ToString() & “对应的活动日期。”)
        End If

        Dim teachingDate As DateTime = CType(activityScheduleDate, DateTime)
        Session("TeachingDate") = teachingDate

        '--- insert and update any rows where staff_id is NOT NULL ---
        Dim updateCommand As New SqlCommand("
            IF EXISTS (
                SELECT 1 FROM staffTeachingRecord
                WHERE schedule_id = @schedule_id 
                  AND class_id = @class_id 
                  AND serviceList_id = @serviceList_id
            )
            BEGIN
                -- Row exists: update staff_id (can be empty string)
                UPDATE staffTeachingRecord
                SET staff_id = @staff_id
                WHERE schedule_id = @schedule_id 
                  AND class_id = @class_id 
                  AND serviceList_id = @serviceList_id;
            END
            ELSE
            BEGIN
                -- Row does not exist: insert only if staff_id is not NULL (empty string is okay)
                IF (@staff_id IS NOT NULL)
                BEGIN
                    INSERT INTO staffTeachingRecord 
                        (staff_id, class_id, schedule_id, teaching_date, serviceList_id)
                    VALUES 
                        (@staff_id, @class_id, @schedule_id, @teaching_date, @serviceList_id);
                END
            END", connection)
        updateCommand.Parameters.AddWithValue("@staff_id", If(String.IsNullOrEmpty(staffID), "", staffID))
        updateCommand.Parameters.AddWithValue("@schedule_id", scheduleID)
        updateCommand.Parameters.AddWithValue("@class_id", classID)
        updateCommand.Parameters.AddWithValue("@teaching_date", Session("TeachingDate"))
        updateCommand.Parameters.AddWithValue("@serviceList_id", serviceType)
        updateCommand.ExecuteNonQuery()
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_Class.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_TA.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_Speaker.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_SongLeader1.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_SongLeader2.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_Pianist.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_Prayer.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_Theory.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_Arrangement.ConnectionString = DbHelper.GetConnectionString()
    End Sub

End Class