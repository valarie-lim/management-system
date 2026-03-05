Imports System.Data.SqlClient

Public Class add_new_activity
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadActivities()
        End If
    End Sub

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        Response.Redirect("manage-activity.aspx")
    End Sub


    ' Load activity data from database
    Private Sub LoadActivities()
        ddlActivityName.Items.Clear()
        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            Dim readCommand As New SqlCommand("
                SELECT activity_name
                FROM activity
                ORDER BY activity_name", connection)
            connection.Open()
            ddlActivityName.DataSource = readCommand.ExecuteReader()
            ddlActivityName.DataTextField = "activity_name"
            ddlActivityName.DataValueField = "activity_name"
            ddlActivityName.DataBind()
        End Using
        ddlActivityName.Items.Insert(0, New ListItem("- Select -", ""))
        ddlActivityName.Items.Add(New ListItem("其他", "Others"))
    End Sub

    ' Show textbox if 'Others' is selected.
    Protected Sub ddlActivityName_SelectedIndexChanged(sender As Object, e As EventArgs)
        txtNewActivity.Visible = (ddlActivityName.SelectedValue = "Others")
        If ddlActivityName.SelectedValue = "Others" Then
            txtNewActivity.Visible = True
            rfvNewActivity.Enabled = True
        Else
            txtNewActivity.Visible = False
            rfvNewActivity.Enabled = False
        End If
    End Sub

    ' Save activity
    Private Sub BtnInsert_Click(sender As Object, e As EventArgs) Handles BtnInsert.Click
        If Page.IsValid Then
            ' First check: If "Others", textbox cannot be empty
            If ddlActivityName.SelectedValue = "Others" AndAlso String.IsNullOrWhiteSpace(txtNewActivity.Text) Then
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("请输入新的活动名称！")}'); }}, 100);", True)
                Exit Sub
            End If
            Dim selectedActivity As String
            If ddlActivityName.SelectedValue = "Others" Then
                selectedActivity = txtNewActivity.Text.Trim()
            Else
                selectedActivity = ddlActivityName.SelectedValue
            End If

            selectedActivity = selectedActivity.Trim().Replace("　", "")

            Dim safeActivity As String = HttpUtility.JavaScriptStringEncode(selectedActivity)
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "debug", $"console.log('SelectedActivity = [{safeActivity}]');", True)

            Dim activityDate As DateTime = Convert.ToDateTime(txtActivityDate.Text)
            Dim activityID As String

            Dim connectionString As String = DbHelper.GetConnectionString()
            Using connection As New SqlConnection(connectionString)

                connection.Open()
                Dim transaction As SqlTransaction = connection.BeginTransaction()
                Try
                    ' 1. insert into activity table
                    ' Check if activity exists first
                    Dim checkActivity As New SqlCommand("
                        SELECT activity_id
                        FROM activity
                        WHERE activity_name=@name", connection, transaction)
                    checkActivity.Parameters.AddWithValue("@name", selectedActivity)
                    Dim existingID = checkActivity.ExecuteScalar()

                    If existingID Is Nothing Then

                        'if no activity is founded, then insert new activity
                        activityID = IDGenerator.NextID(connection, "activity", "activity_id", "AC-", 5, transaction)

                        Dim insertNewActivity As New SqlCommand("
                            INSERT INTO activity (activity_id, activity_name)
                            VALUES (@id,@name)", connection, transaction)
                        insertNewActivity.Parameters.AddWithValue("@id", activityID)
                        insertNewActivity.Parameters.AddWithValue("@name", selectedActivity)
                        insertNewActivity.ExecuteNonQuery()
                    Else
                        activityID = existingID.ToString()
                    End If


                    ' 2. insert into activitySchedule table
                    ' Check if schedule exists for this activity and date first
                    Dim checkSchedule As New SqlCommand("
                        SELECT schedule_id
                        FROM activitySchedule
                        WHERE activity_id = @activityID AND activity_date = @activityDate", connection, transaction)
                    checkSchedule.Parameters.AddWithValue("@activityID", activityID)
                    checkSchedule.Parameters.AddWithValue("@activityDate", activityDate)
                    Dim existingSchedule = checkSchedule.ExecuteScalar()

                    Dim scheduleID As Integer
                    If existingSchedule Is Nothing Then

                        ' if no schedule is founded for this activity matching date, insert into schedule table
                        Dim insertSchedule As New SqlCommand("
                        INSERT INTO activitySchedule (activity_id, activity_date)
                        OUTPUT INSERTED.schedule_id
                        VALUES (@id, @date)", connection, transaction)
                        insertSchedule.Parameters.AddWithValue("@id", activityID)
                        insertSchedule.Parameters.AddWithValue("@date", activityDate)
                        scheduleID = CInt(insertSchedule.ExecuteScalar())

                        ' then, insert schedule_id into the scheduleMaterial
                        Dim insertScheduleMaterial As New SqlCommand("
                        INSERT INTO scheduleMaterial (schedule_id)
                        VALUES (@scheduleID)", connection, transaction)
                        insertScheduleMaterial.Parameters.AddWithValue("@scheduleID", scheduleID)
                        insertScheduleMaterial.ExecuteNonQuery()
                    Else
                        scheduleID = CInt(existingSchedule)
                        ' Activity already exists – show alert and exit

                        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("活动已经在系统里!")}'); }}, 100);", True)
                        Exit Sub
                    End If


                    ' 3. insert into StaffTeaching Record table
                    ' Check if schedule exists for this activity and date first
                    If selectedActivity <> "儿童诗班" Then

                        ' Check whether record already exists (prevent duplicates)
                        Dim checkRecord As New SqlCommand("
                            SELECT record_id
                            FROM staffTeachingRecord
                            WHERE schedule_id = @scheduleID AND teaching_date = @teachingDate",
                            connection, transaction)

                        checkRecord.Parameters.AddWithValue("@scheduleID", scheduleID)
                        checkRecord.Parameters.AddWithValue("@teachingDate", activityDate)

                        Dim existingRecord = checkRecord.ExecuteScalar()

                        If existingRecord Is Nothing Then
                            Dim insertQuery As String = "
                                INSERT INTO staffTeachingRecord (class_id, schedule_id, teaching_date)
                                VALUES (@classID, @scheduleID, @teachingDate);"

                            Using insertCommand As New SqlCommand(insertQuery, connection, transaction)
                                insertCommand.Parameters.AddWithValue("@classID", "CL00")
                                insertCommand.Parameters.AddWithValue("@scheduleID", scheduleID)
                                insertCommand.Parameters.AddWithValue("@teachingDate", activityDate)
                                insertCommand.ExecuteNonQuery()
                            End Using
                        End If
                    End If


                    ' Commit the transaction if all inserts succeed
                    transaction.Commit()

                    ' Redirect to manage page
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "successMsg",
                        $"setTimeout(function() {{
                            showAlert('{HttpUtility.JavaScriptStringEncode("活动输入成功！")}', function() {{window.location='manage-activity.aspx';}});}}, 200);", True)

                Catch ex As Exception

                    ' Rollback transaction if any command fails
                    transaction.Rollback()

                    '' alert message for technical checking
                    'Dim msg As String = ex.Message
                    'If ex.InnerException IsNot Nothing Then
                    '    msg &= "\nInner: " & ex.InnerException.Message
                    'End If
                    'ScriptManager.RegisterStartupScript(Me, Me.GetType(), "insertFail",
                    '                            $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("活动输入失败:\n{msg}")}'); }}, 100);", True)

                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("发生意外错误，请重试或联系管理员。")}'); }}, 100);", True)
                End Try
            End Using
        End If
    End Sub

End Class
