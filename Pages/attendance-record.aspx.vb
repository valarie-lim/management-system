Imports System.Data.SqlClient

Public Class attendance_record
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Session("UserRole") Is Nothing Then
                Dim url As String = ResolveUrl("~/index.aspx")
                ClientScript.RegisterStartupScript(Me.GetType(), "alertRedirect",
                "alert('请登录以使用系统功能。'); window.location='" & url & "';", True)
                Return
            End If
            Dim URole As String = Session("UserRole").ToString()
            Select Case URole
                Case "Principal"
                    UserRole.Text = "校长"
                    UserRoleMobile.Text = "校长"
                Case "Teacher"
                    UserRole.Text = "老师"
                    UserRoleMobile.Text = "老师"
                Case "Teaching assistants"
                    UserRole.Text = "协助"
                    UserRoleMobile.Text = "协助"
                Case Else
                    UserRole.Text = "其他"
                    UserRoleMobile.Text = "其他"
            End Select
        End If
    End Sub

    Protected Sub BtnMenu_Click(sender As Object, e As EventArgs) Handles BtnMenu.Click
        ' Read isAdmin from session
        Dim isAdminDashboard As Boolean = If(Session("IsAdmin") IsNot Nothing, Convert.ToBoolean(Session("IsAdmin")), False)
        ' Read userRole from session
        Dim userRoleDashboard As String = Session("UserRole")
        ' Check session
        If String.IsNullOrEmpty(userRoleDashboard) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
            "alert('会话已过期，请重新登录。');", True)
            Exit Sub
        End If
        ' Check behavior based on isAdmin flag
        If isAdminDashboard Then
            ' if isAdmin is true, skip restrictions, allow navigation freely
            Response.Redirect("admin-dashboard.aspx")
            Exit Sub
        Else
            ' for general access user, show confirm/alert
            Dim script As String = "if (confirm('您没有权限访问此页面。请登录后继续。前往登录？')) {" &
                       "window.location='login.aspx';" &
                       "} else {" &
                       "history.back();" &
                       "}"
            ClientScript.RegisterStartupScript(Me.GetType(), "confirmRedirect", script, True)
            Exit Sub
        End If
    End Sub

    Private Sub BtnExit_Click(sender As Object, e As EventArgs) Handles BtnExit.Click
        Dim isAdmin As Boolean = If(Session("IsAdmin") IsNot Nothing, Convert.ToBoolean(Session("IsAdmin")), False)

        If isAdmin Then
            Exit Sub
        Else
            Dim url As String = ResolveUrl("~/index.aspx")

            ClientScript.RegisterStartupScript(Me.GetType(), "alertRedirect",
                "alert('您已退出系统。'); window.location='" & url & "';", True)
        End If

    End Sub

    Protected Sub BtnUpdate_Click(sender As Object, e As EventArgs) Handles BtnUpdate.Click
        Try
            Dim activityDate As Date
            ' Required Field Validation
            If Not Date.TryParse(txtActivityDate.Text, activityDate) Then
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('请选择日期。');", True)
                Exit Sub
            End If
            If String.IsNullOrEmpty(ddlActivity.SelectedValue) Then
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('请选择对应的活动。');", True)
                Exit Sub
            End If

            Dim activityId As String = ddlActivity.SelectedValue
            Dim failedChildren As New List(Of String)
            ' establish a connection to the database helper function that connect to the connectionstring
            Dim connectionString As String = DbHelper.GetConnectionString()
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim transaction As SqlTransaction = connection.BeginTransaction()

                Try
                    ' Check if attendance_date matches any activity_date in the activitySchedule table
                    Dim checkDate As New SqlCommand("
                            SELECT COUNT(*) 
                            FROM activitySchedule 
                            WHERE activity_id = @activityId AND activity_date = @attendanceDate
                        ", connection, transaction)

                    checkDate.Parameters.AddWithValue("@activityId", activityId)
                    checkDate.Parameters.AddWithValue("@attendanceDate", activityDate)

                    Dim validDate As Integer = Convert.ToInt32(checkDate.ExecuteScalar())
                    If validDate = 0 Then
                        transaction.Rollback()
                        ClientScript.RegisterStartupScript(Me.GetType(), "alert",
                                                           "alert('系统中未找到所选日期。');", True)
                        Exit Sub
                    End If

                    ' Get the schedule_id for the selected activity and date
                    Dim getSchedule As New SqlCommand("
                        SELECT schedule_id 
                        FROM activitySchedule 
                        WHERE activity_id = @activityId AND activity_date = @attendanceDate
                    ", connection, transaction)

                    getSchedule.Parameters.AddWithValue("@activityId", activityId)
                    getSchedule.Parameters.AddWithValue("@attendanceDate", activityDate)

                    Dim scheduleIdObj As Object = getSchedule.ExecuteScalar()

                    If scheduleIdObj Is Nothing Then
                        transaction.Rollback()
                        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('系统中未找到所选活动和日期的安排。');", True)
                        Exit Sub
                    End If

                    ' Check if attendance already exists for the same date and activity
                    Dim scheduleId As String = scheduleIdObj.ToString()
                    Dim checkAttendance As New SqlCommand("
                        SELECT COUNT(*) FROM attendance 
                        WHERE attendance_date = @attendanceDate AND schedule_id = @scheduleId
                    ", connection, transaction)
                    checkAttendance.Parameters.AddWithValue("@attendanceDate", activityDate)
                    checkAttendance.Parameters.AddWithValue("@scheduleId", scheduleId)

                    Dim exists As Integer = Convert.ToInt32(checkAttendance.ExecuteScalar())
                    If exists > 0 Then
                        transaction.Rollback()
                        ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('此出勤记录已被提交。如需更改，请到更改/查看出勤汇总。');", True)
                        Exit Sub
                    End If

                    ' Start insert attendance: create a new attendance record
                    Dim attendanceId As String = IDGenerator.NextID(connection, "attendance", "attendance_id", "ATT-", 5, transaction)
                    Dim insertAttendance As New SqlCommand("
                    INSERT INTO attendance (attendance_id, attendance_date, record_by, schedule_id)
                    VALUES (@attendanceId, @attendanceDate, @recordBy, @scheduleId)
                        ", connection, transaction)
                    insertAttendance.Parameters.AddWithValue("@attendanceId", attendanceId)
                    insertAttendance.Parameters.AddWithValue("@attendanceDate", activityDate)
                    insertAttendance.Parameters.AddWithValue("@recordBy", Session("UserFirstName"))
                    insertAttendance.Parameters.AddWithValue("@scheduleId", scheduleId)
                    insertAttendance.ExecuteNonQuery()

                    ' Insert childAttendance records
                    Dim rowsInserted As Integer = 0
                    For Each row As GridViewRow In GridView_recordAttendance.Rows
                        Dim chk As CheckBox = CType(row.FindControl("chkAttendance"), CheckBox)
                        If chk Is Nothing Then Continue For

                        Dim childId As String = GridView_recordAttendance.DataKeys(row.RowIndex).Value.ToString()
                        Dim childName As String = row.Cells(0).Text
                        Dim insertChildAttendance As New SqlCommand("
                        INSERT INTO childAttendance (child_id, attendance_id, isPresent)
                        VALUES (@childId, @attendanceId, @isPresent)
                        ", connection, transaction)
                        insertChildAttendance.Parameters.AddWithValue("@childId", childId)
                        insertChildAttendance.Parameters.AddWithValue("@attendanceId", attendanceId)
                        insertChildAttendance.Parameters.Add("@isPresent", SqlDbType.Bit).Value = chk.Checked

                        Try
                            insertChildAttendance.ExecuteNonQuery()
                            rowsInserted += 1
                        Catch ex As SqlException
                            failedChildren.Add(childName & " (" & ex.Message & ", child_id: " & childId & ")")
                        End Try
                    Next

                    ' Commit if all ok
                    transaction.Commit()
                    connection.Close()

                    If failedChildren.Count > 0 Then
                        Dim msg As String = "Attendance not recorded for: " & String.Join(", ", failedChildren)
                        ClientScript.RegisterStartupScript(Me.GetType(), "alert", $"alert('{msg}');", True)
                    Else
                        ClientScript.RegisterStartupScript(Me.GetType(), "alert", $"alert('出勤已记录，日期为 " & activityDate & ".');", True)

                    End If

                Catch ex As Exception
                    transaction.Rollback()
                    ClientScript.RegisterStartupScript(Me.GetType(), "alert", $"alert('Error: {ex.Message}');", True)
                End Try
            End Using

            GridView_recordAttendance.DataBind()
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", $"alert('Unexpected error: {ex.Message}');", True)
        End Try
    End Sub

    Protected Sub BtnView_Click(sender As Object, e As EventArgs) Handles BtnView.Click
        Dim isAdmin As Boolean = If(Session("IsAdmin") IsNot Nothing, Convert.ToBoolean(Session("IsAdmin")), False)
        Dim userRole As String = Session("UserRole")

        If String.IsNullOrEmpty(userRole) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
            "alert('会话已过期，请重新登录。');", True)
            Exit Sub
        End If
        If isAdmin Then
            Response.Redirect("attendance-view.aspx")
            Exit Sub
        Else
            Dim script As String = "if (confirm('您没有权限访问此页面。请登录后继续。前往登录？')) {" &
                               "window.location='login.aspx';" &
                               "} else {" &
                               "history.back();" &
                               "}"
            ClientScript.RegisterStartupScript(Me.GetType(), "confirmRedirect", script, True)
            Exit Sub
        End If
    End Sub

    Private Sub BtnMenuMobile_Click(sender As Object, e As EventArgs) Handles BtnMenuMobile.Click
        Dim isAdminDashboard As Boolean = If(Session("IsAdmin") IsNot Nothing, Convert.ToBoolean(Session("IsAdmin")), False)
        Dim userRoleDashboard As String = Session("UserRole")
        If String.IsNullOrEmpty(userRoleDashboard) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert",
            "alert('会话已过期，请重新登录。');", True)
            Exit Sub
        End If
        If isAdminDashboard Then
            Response.Redirect("admin-dashboard.aspx")
            Exit Sub
        Else
            Dim script As String = "if (confirm('您没有权限访问此页面。请登录后继续。前往登录？')) {" &
                       "window.location='login.aspx';" &
                       "} else {" &
                       "history.back();" &
                       "}"
            ClientScript.RegisterStartupScript(Me.GetType(), "confirmRedirect", script, True)
            Exit Sub
        End If
    End Sub

    Private Sub BtnExitMobile_Click(sender As Object, e As EventArgs) Handles BtnExitMobile.Click
        Dim isAdmin As Boolean = If(Session("IsAdmin") IsNot Nothing, Convert.ToBoolean(Session("IsAdmin")), False)

        If isAdmin Then
            Exit Sub
        Else
            Dim url As String = ResolveUrl("~/index.aspx")

            ClientScript.RegisterStartupScript(Me.GetType(), "alertRedirect",
                "alert('您已退出系统。'); window.location='" & url & "';", True)
        End If
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_Activity.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_recordAttendance.ConnectionString = DbHelper.GetConnectionString()
    End Sub

End Class