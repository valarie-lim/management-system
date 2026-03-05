Imports System.Data.SqlClient
Imports System.EnterpriseServices

Public Class manage_teacher_service
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Session("TeacherServiceStaffId") IsNot Nothing Then
                BindGrid(Session("TeacherServiceStaffId").ToString())
            End If
        End If
    End Sub

    Protected Sub BtnDone_Click(sender As Object, e As EventArgs) Handles BtnDone.Click

        Dim confirmMessage As String = "确定要退出编辑吗?"
        confirmMessage = HttpUtility.JavaScriptStringEncode(confirmMessage)

        Dim redirectScript As String =
        $"if (confirm('{confirmMessage}')) " &
        "{ window.location='manage-teacher-details.aspx'; }"

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "confirmExit", redirectScript, True)
    End Sub


    Private Sub BindGrid(staffId As String)
        Dim dtServices As New DataTable()
        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim getCommand As New SqlCommand("
                SELECT s.serviceList_id, s.start_date, sl.service_type, p.chinese_name
                FROM service s
                INNER JOIN serviceList sl ON s.serviceList_id = sl.serviceList_id
                INNER JOIN staff st ON s.staff_id = st.staff_id
                INNER JOIN person p ON st.person_id = p.person_id
                WHERE s.staff_id=@staff", connection)
            getCommand.Parameters.AddWithValue("@staff", staffId)
            Dim da As New SqlDataAdapter(getCommand)
            da.Fill(dtServices)
        End Using

        gvTeacherServices.DataSource = dtServices
        gvTeacherServices.DataBind()
    End Sub

    ' Populate dropdowns during RowDataBound
    Protected Sub gvTeacherServices_RowDataBound(sender As Object, e As GridViewRowEventArgs)
        If e.Row.RowType = DataControlRowType.DataRow AndAlso e.Row.RowIndex = gvTeacherServices.EditIndex Then
            Dim ddlEdit As DropDownList = CType(e.Row.FindControl("ddlEditService"), DropDownList)
            If ddlEdit IsNot Nothing Then
                Dim dtAllServices As New DataTable()

                Dim connectionString As String = DbHelper.GetConnectionString()
                Using connection As New SqlConnection(connectionString)
                    Dim cmdAll As New SqlCommand("
                        SELECT serviceList_id, service_type
                        FROM serviceList
                        ORDER BY service_type", connection)
                    Dim daAll As New SqlDataAdapter(cmdAll)
                    daAll.Fill(dtAllServices)
                End Using

                ddlEdit.DataSource = dtAllServices
                ddlEdit.DataTextField = "service_type"
                ddlEdit.DataValueField = "serviceList_id"
                ddlEdit.DataBind()

                ' Set selected value
                Dim currentId As String = gvTeacherServices.DataKeys(e.Row.RowIndex).Value.ToString()
                ddlEdit.SelectedValue = currentId
            End If
        End If

        ' Footer dropdown
        If e.Row.RowType = DataControlRowType.Footer Then
            Dim ddlNew As DropDownList = CType(e.Row.FindControl("ddlNewService"), DropDownList)
            If ddlNew IsNot Nothing Then
                Dim dtAllServices As New DataTable()
                Using connection As New SqlConnection(ConfigurationManager.ConnectionStrings("SundaySchDBConnection").ConnectionString)
                    Dim cmdAll As New SqlCommand("SELECT serviceList_id, service_type FROM serviceList ORDER BY service_type", connection)
                    Dim daAll As New SqlDataAdapter(cmdAll)
                    daAll.Fill(dtAllServices)
                End Using

                ddlNew.DataSource = dtAllServices
                ddlNew.DataTextField = "service_type"
                ddlNew.DataValueField = "serviceList_id"
                ddlNew.DataBind()

                ' Add default "Others" option remains
                ddlNew.Items.Insert(0, New ListItem("- Select Service -", ""))
                ddlNew.Items.Add(New ListItem("其他（新）", "other"))
            End If
        End If
    End Sub

    ' Show/hide new service textbox
    Protected Sub ddlNewService_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim ddl As DropDownList = CType(sender, DropDownList)
        Dim footerRow As GridViewRow = gvTeacherServices.FooterRow
        Dim txtNew As TextBox = CType(footerRow.FindControl("txtNewService"), TextBox)

        txtNew.Visible = (ddl.SelectedValue = "other")
    End Sub

    ' Editing
    Protected Sub gvTeacherServices_RowEditing(sender As Object, e As GridViewEditEventArgs)
        gvTeacherServices.EditIndex = e.NewEditIndex
        BindGrid(Session("TeacherServiceStaffId").ToString())
    End Sub

    ' Cancel Editing
    Protected Sub gvTeacherServices_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
        gvTeacherServices.EditIndex = -1
        BindGrid(Session("TeacherServiceStaffId").ToString())
    End Sub

    ' Update service into service table
    Protected Sub gvTeacherServices_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
        Dim row As GridViewRow = gvTeacherServices.Rows(e.RowIndex)
        Dim staffId As String = Session("TeacherServiceStaffId").ToString()
        Dim currentServiceId As String = gvTeacherServices.DataKeys(e.RowIndex).Value.ToString()
        Dim ddlRowUpdate As DropDownList = CType(row.FindControl("ddlEditService"), DropDownList)
        Dim newServiceId As String = ddlRowUpdate.SelectedValue
        Dim txtCurrentStartDate As TextBox = CType(row.FindControl("txtCurrentStartDate"), TextBox)
        Dim existingDate As String = txtCurrentStartDate.Text.Trim()

        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim updateCommand As New SqlCommand("
                UPDATE service
                SET serviceList_id=@newServiceID
                WHERE staff_id=@staff AND serviceList_id=@currentService AND start_date=@currentServiceDate", connection)
            updateCommand.Parameters.AddWithValue("@newServiceID", newServiceId)
            updateCommand.Parameters.AddWithValue("@staff", staffId)
            updateCommand.Parameters.AddWithValue("@currentService", currentServiceId)
            updateCommand.Parameters.AddWithValue("@currentServiceDate", existingDate)
            updateCommand.ExecuteNonQuery()
        End Using

        gvTeacherServices.EditIndex = -1
        BindGrid(staffId)
    End Sub

    ' Delete service-pairing from service table
    Protected Sub gvTeacherServices_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Dim staffId As String = Session("TeacherServiceStaffId").ToString()
        Dim serviceListId As String = gvTeacherServices.DataKeys(e.RowIndex).Value.ToString()
        Dim serviceId As String = ""

        ' Retrieve service_id from database
        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim selectCommand As New SqlCommand("
            SELECT service_id 
            FROM service 
            WHERE staff_id=@staff AND serviceList_id=@serviceList", connection)
            selectCommand.Parameters.AddWithValue("@staff", staffId)
            selectCommand.Parameters.AddWithValue("@serviceList", serviceListId)

            Dim reader As SqlDataReader = selectCommand.ExecuteReader()
            If reader.Read() Then
                serviceId = reader("service_id").ToString()
            End If
            reader.Close()

            ' Delete the row using service_id
            If Not String.IsNullOrEmpty(serviceId) Then
                Dim deleteCommand As New SqlCommand("
                DELETE FROM service
                WHERE service_id=@serviceId", connection)
                deleteCommand.Parameters.AddWithValue("@serviceId", serviceId)
                deleteCommand.ExecuteNonQuery()
            End If
        End Using

        ' Rebind GridView
        BindGrid(staffId)
    End Sub

    ' Add new service
    Protected Sub gvTeacherServices_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "AddNew" Then
            Dim staffId As String = Session("TeacherServiceStaffId").ToString()
            Dim footerRow As GridViewRow = gvTeacherServices.FooterRow
            Dim ddlNew As DropDownList = CType(footerRow.FindControl("ddlNewService"), DropDownList)
            Dim txtNew As TextBox = CType(footerRow.FindControl("txtNewService"), TextBox)
            Dim txtStartDate As TextBox = CType(footerRow.FindControl("txtStartDate"), TextBox)

            Dim newServiceId As String = ddlNew.SelectedValue
            Dim startDate As String = txtStartDate.Text.Trim()

            Dim connectionString As String = DbHelper.GetConnectionString()
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                ' If "Others" selected, insert into serviceList table
                If newServiceId = "other" AndAlso txtNew.Text.Trim() <> "" Then
                    Dim newId As String = AutoGenerate.NextID(connection, "serviceList", "serviceList_id", "SL-", 2)
                    Dim insertListCommand As New SqlCommand("
                        INSERT INTO serviceList(serviceList_id, service_type)
                        VALUES(@id,@type)", connection)
                    insertListCommand.Parameters.AddWithValue("@id", newId)
                    insertListCommand.Parameters.AddWithValue("@type", txtNew.Text.Trim())
                    insertListCommand.ExecuteNonQuery()
                    newServiceId = newId
                End If

                ' Insert to service table
                Dim serviceID As String = IDGenerator.NextID(connection, "service", "service_id", "SE-", 5)
                Dim insertCommand As New SqlCommand("
                    INSERT INTO service(service_id, staff_id, serviceList_id, start_date)
                    VALUES(@serviceId, @staff,@service, @startDate)", connection)
                insertCommand.Parameters.AddWithValue("@serviceId", serviceID)
                insertCommand.Parameters.AddWithValue("@staff", staffId)
                insertCommand.Parameters.AddWithValue("@service", newServiceId)
                insertCommand.Parameters.AddWithValue("@startDate", startDate)
                insertCommand.ExecuteNonQuery()
            End Using

            BindGrid(staffId)
        End If
    End Sub


End Class