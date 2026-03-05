Imports System.Data.SqlClient
Imports System.Runtime.InteropServices.ComTypes
Imports System.Web.Services.Description

Public Class manage_guardian_details
    Inherits System.Web.UI.Page

    Protected Function FormatContact(ByVal number As String) As String
        If number.Length = 10 Then
            Return number.Substring(0, 3) & "-" & number.Substring(3, 7)  ' Format XXX-XXXXXXX
        ElseIf number.Length = 11 Then
            Return number.Substring(0, 4) & "-" & number.Substring(3, 7)  ' Format XXX-XXXXXXXX
        Else
            Return number
        End If
    End Function

    Private Sub ShowAddTeacherModal()
        ScriptManager.RegisterStartupScript(Me, Me.GetType(),
                                        "showModal",
                                        "$('#addTeacherModal').modal('show');",
                                        True)
    End Sub

    Protected Sub GridView_Guardian_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridView_Guardian.RowCommand
        If e.CommandName = "ToggleTeacher" Then

            Dim personId As String = e.CommandArgument.ToString()
            ViewState("SelectedPersonID") = personId

            Dim row As GridViewRow = Nothing

            ' Find matching row
            For Each r As GridViewRow In GridView_Guardian.Rows
                If GridView_Guardian.DataKeys(r.RowIndex)("person_id").ToString() = personId Then
                    row = r
                    Exit For
                End If
            Next

            Dim chineseName As String = ""
            Dim staffId As String = ""

            If row IsNot Nothing Then
                staffId = GridView_Guardian.DataKeys(row.RowIndex)("staff_id").ToString()

                ' ★ Check if already a teacher
                If Not String.IsNullOrWhiteSpace(staffId) Then
                    Dim message As String = "此家长已经是老师，无需重复注册。"
                    message = HttpUtility.JavaScriptStringEncode(message)
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "accessDenied",
                                                $"setTimeout(function() {{ showAlert('{message}'); }}, 100);", True)
                    Return
                End If

                chineseName = row.Cells(5).Text
            End If

            ' Save for modal later
            ViewState("SelectedStaffID") = staffId
            TxtName.Text = chineseName

            ' Open modal
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowTeacherModal",
            "var myModal = new bootstrap.Modal(document.getElementById('TeacherModal')); myModal.show();", True)

        End If
    End Sub


    Protected Sub BtnSubmit_Click(sender As Object, e As EventArgs) Handles BtnSubmit.Click

        If ViewState("SelectedPersonID") Is Nothing Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "errorMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("系统错误：无法找到对应的编号。")}'); }}, 100);", True)

            ShowAddTeacherModal()
            Return
        End If

        Dim personId As String = ViewState("SelectedPersonID").ToString()
        Dim email As String = TxtEmail.Text.Trim()
        Dim serviceRole As String
        If String.IsNullOrWhiteSpace(RblRole.SelectedValue.Trim()) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "errorMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("请选择一个角色。")}'); }}, 100);", True)

            ShowAddTeacherModal()
            Return
        Else
            serviceRole = RblRole.SelectedValue.Trim()
        End If

        ' Services
        Dim serviceType As New List(Of String)
        For Each item As ListItem In CblServiceType.Items
            If item.Selected Then
                ' 如果要存 serviceList_id 用 item.Value，要存文字用 item.Text
                serviceType.Add(item.Text)
            End If
        Next
        Session("ServiceType") = String.Join(", ", serviceType)

        Dim connectionString As String = DbHelper.GetConnectionString()

        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim transaction As SqlTransaction = connection.BeginTransaction()
            Try

                Dim staffID As String = IDGenerator.NextID(connection, "staff", "staff_id", "S", 5, transaction)

                Dim insertSql As String = "
                    INSERT INTO staff (staff_id, person_id, email, role)
                    VALUES (@staffID, @personID, @email, @role)"

                Using insertCommand As New SqlCommand(insertSql, connection, transaction)

                    insertCommand.Parameters.AddWithValue("@staffID", staffID)
                    insertCommand.Parameters.AddWithValue("@personID", personId)

                    ' Email → Convert to NULL if empty
                    insertCommand.Parameters.AddWithValue("@email",
                        If(String.IsNullOrEmpty(email), DBNull.Value, CType(email, Object)))

                    insertCommand.Parameters.AddWithValue("@role", serviceRole)

                    insertCommand.ExecuteNonQuery()
                End Using


                '-----------------------------------------------------------------
                ' Insert into service Table using serviceList_id
                If ViewState("SelectedPersonID") IsNot Nothing Then
                    Dim startDate As DateTime
                    If String.IsNullOrWhiteSpace(TxtStartDate.Text) Then
                        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "errorMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("请输入开始事奉的日期。")}'); }}, 100);", True)
                        ShowAddTeacherModal()
                        Return
                    Else
                        startDate = Convert.ToDateTime(TxtStartDate.Text)
                    End If

                    Dim services As String() = Session("ServiceType").ToString().Split(","c) _
                             .Select(Function(s) s.Trim()) _
                             .Where(Function(s) Not String.IsNullOrEmpty(s)) _
                             .ToArray()

                    ' ← Add the check here
                    If services.Length = 0 Then
                        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "errorMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("请至少选择一个事奉项目。")}'); }}, 100);", True)
                        ShowAddTeacherModal()
                        Return
                    End If

                    Dim serviceQuery As String = "
                            INSERT INTO dbo.service
                                (service_id, staff_id, serviceList_id, start_date)
                            VALUES
                                (@ServiceID, @StaffID, @ServiceListID, @StartDate);"

                    For Each service As String In services
                        Dim serviceID As String = IDGenerator.NextID(connection, "service", "service_id", "SE-", 5, transaction)

                        ' Get or create serviceList_id (uses new AutoGenerate class with 2-digit ID)
                        Dim serviceListID As String = GetOrCreateServiceListID(connection, transaction, service.Trim())

                        Using serviceCommand As New SqlCommand(serviceQuery, connection, transaction)
                            serviceCommand.Parameters.AddWithValue("@ServiceID", serviceID)
                            serviceCommand.Parameters.AddWithValue("@StaffID", staffID)
                            serviceCommand.Parameters.AddWithValue("@ServiceListID", serviceListID)
                            serviceCommand.Parameters.AddWithValue("@StartDate", startDate)
                            serviceCommand.ExecuteNonQuery()
                        End Using
                    Next
                End If
                transaction.Commit()

                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "accessDenied",
                                                    $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("家长已成功注册为老师。")}'); }}, 100);", True)

                ' Refresh GridView
                GridView_Guardian.DataBind()

            Catch ex As Exception
                transaction.Rollback()

                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "errorMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("注册失败，请重试或联系管理员。")}'); }}, 100);", True)

                '' technician error message
                'ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertError", $"alert('错误: {ex.Message}');", True)
            End Try
        End Using
    End Sub

    Private Function GetOrCreateServiceListID(connection As SqlConnection, transaction As SqlTransaction, serviceType As String) As String
        ' Check if service_type already exists
        Dim selectQuery As String = "SELECT serviceList_id FROM dbo.serviceList WHERE service_type = @ServiceType"
        Using selectCmd As New SqlCommand(selectQuery, connection, transaction)
            selectCmd.Parameters.AddWithValue("@ServiceType", serviceType)
            Dim result As Object = selectCmd.ExecuteScalar()
            If result IsNot Nothing Then
                Return result.ToString() ' Return existing ID
            End If
        End Using

        ' If not exists, insert new serviceList record with 2-digit ID
        Dim newServiceListID As String = AutoGenerate.NextID(connection, "serviceList", "serviceList_id", "SL-", 2, transaction)
        Dim insertQuery As String = "INSERT INTO dbo.serviceList (serviceList_id, service_type) VALUES (@ServiceListID, @ServiceType)"
        Using insertCmd As New SqlCommand(insertQuery, connection, transaction)
            insertCmd.Parameters.AddWithValue("@ServiceListID", newServiceListID)
            insertCmd.Parameters.AddWithValue("@ServiceType", serviceType)
            insertCmd.ExecuteNonQuery()
        End Using

        Return newServiceListID
    End Function


    Protected Sub GridView_Guardian_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles GridView_Guardian.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then

            ' 1) Always run for all data rows: disable BtnTeacher if staff_id exists
            Dim staffId As String = DataBinder.Eval(e.Row.DataItem, "staff_id").ToString()
            Dim btn As Button = CType(e.Row.FindControl("BtnTeacher"), Button)
            If btn IsNot Nothing AndAlso Not String.IsNullOrWhiteSpace(staffId) Then
                btn.Enabled = False
                btn.CssClass = "btn-selection btn-disabled"
            End If

            ' 2) Only when row is in edit mode: handle ddlRelation / ddlChild
            If (e.Row.RowState And DataControlRowState.Edit) > 0 Then
                Dim ddlRelation As DropDownList = CType(e.Row.FindControl("ddlRelation"), DropDownList)
                If ddlRelation IsNot Nothing Then
                    Dim currentRelation As String = DataBinder.Eval(e.Row.DataItem, "relation_type").ToString()
                    If ddlRelation.Items.FindByValue(currentRelation) IsNot Nothing Then
                        ddlRelation.SelectedValue = currentRelation
                    End If
                End If

                Dim ddlChild As DropDownList = CType(e.Row.FindControl("ddlChild"), DropDownList)
                If ddlChild IsNot Nothing Then
                    Dim currentChildId As String = DataBinder.Eval(e.Row.DataItem, "child_id").ToString()
                    If ddlChild.Items.FindByValue(currentChildId) IsNot Nothing Then
                        ddlChild.SelectedValue = currentChildId
                    End If
                End If
            End If

        End If
    End Sub


    ' Insert or update relationship when child/relation is selected
    Protected Sub GridView_Guardian_RowUpdating(sender As Object, e As GridViewUpdateEventArgs) Handles GridView_Guardian.RowUpdating
        Dim gvRow As GridViewRow = GridView_Guardian.Rows(GridView_Guardian.EditIndex)
        Dim ddlChild As DropDownList = CType(gvRow.FindControl("ddlChild"), DropDownList)
        Dim ddlRelation As DropDownList = CType(gvRow.FindControl("ddlRelation"), DropDownList)

        If ddlChild IsNot Nothing AndAlso ddlRelation IsNot Nothing AndAlso Not String.IsNullOrEmpty(ddlChild.SelectedValue) Then
            Dim childId As String = ddlChild.SelectedValue
            Dim relationType As String = ddlRelation.SelectedValue
            Dim personId As String = e.Keys("person_id").ToString()
            Dim guardianId As String = GetGuardianIdByPersonId(personId)

            Dim connectionString As String = DbHelper.GetConnectionString()
            Using connection As New SqlClient.SqlConnection(connectionString)
                connection.Open()

                ' Check if relationship already exists
                Dim checkCommand As New SqlClient.SqlCommand("
                    SELECT COUNT(*)
                    FROM relationship
                    WHERE guardian_id=@guardian_id
                    AND child_id=@child_id", connection)
                checkCommand.Parameters.AddWithValue("@guardian_id", guardianId)
                checkCommand.Parameters.AddWithValue("@child_id", childId)
                Dim exists As Integer = CInt(checkCommand.ExecuteScalar())

                If exists > 0 Then
                    ' Update existing relationship
                    Dim updateCommand As New SqlClient.SqlCommand("
                        UPDATE relationship
                        SET relation_type=@relation_type
                        WHERE guardian_id=@guardian_id
                        AND child_id=@child_id", connection)
                    updateCommand.Parameters.AddWithValue("@relation_type", relationType)
                    updateCommand.Parameters.AddWithValue("@guardian_id", guardianId)
                    updateCommand.Parameters.AddWithValue("@child_id", childId)
                    updateCommand.ExecuteNonQuery()
                Else
                    ' Insert new relationship
                    Dim relationshipID As String = IDGenerator.NextID(connection, "relationship", "relationship_id", "RE-")
                    Dim insertCommand As New SqlClient.SqlCommand("
                        INSERT INTO relationship (relationship_id, guardian_id, child_id, relation_type)
                        VALUES (@relationship_id, @guardian_id, @child_id, @relation_type)", connection)
                    insertCommand.Parameters.AddWithValue("@relationship_id", relationshipID)
                    insertCommand.Parameters.AddWithValue("@guardian_id", guardianId)
                    insertCommand.Parameters.AddWithValue("@child_id", childId)
                    insertCommand.Parameters.AddWithValue("@relation_type", relationType)
                    insertCommand.ExecuteNonQuery()
                End If
            End Using
        End If

        ' Exit edit mode and refresh GridView to show updated data
        GridView_Guardian.EditIndex = -1
        GridView_Guardian.DataBind()
    End Sub


    Private Function GetGuardianIdByPersonId(personId As String) As String
        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim selectCommand As New SqlCommand("
                SELECT guardian_id
                FROM guardian
                WHERE person_id=@person_id", connection)
            selectCommand.Parameters.AddWithValue("@person_id", personId)
            Return selectCommand.ExecuteScalar().ToString()
        End Using
    End Function


    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_guardianInfo.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_ChildList.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_Roles.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_ServiceType.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_serviceList.ConnectionString = DbHelper.GetConnectionString()
    End Sub

    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("manage-child-details.aspx")
    End Sub

End Class