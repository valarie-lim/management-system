Imports System.Data.SqlClient
Imports System.IO
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports System.Drawing
Imports System.Drawing.Printing
Imports iTextSharp.text.pdf.draw

Public Class report_teacher_activity_schedule
    Inherits System.Web.UI.Page

    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("admin-dashboard.aspx")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ddlScheduleType.Items.Clear()
            ddlScheduleType.Items.Add(New System.Web.UI.WebControls.ListItem("- Select Period -", ""))
            ddlScheduleType.Items.Add(New System.Web.UI.WebControls.ListItem("Annually", "YEAR"))
            ddlScheduleType.Items.Add(New System.Web.UI.WebControls.ListItem("6 months", "HALF"))
            ' Year dropdown
            ddlYear.Items.Add(New System.Web.UI.WebControls.ListItem("- Select Year -", ""))
            For year As Integer = 2025 To 2030
                ddlYear.Items.Add(New System.Web.UI.WebControls.ListItem(year.ToString(), year.ToString()))
            Next
            ' Half dropdown
            ddlHalf.Items.Clear()
            ddlHalf.Items.Add(New System.Web.UI.WebControls.ListItem("- Select Month -", ""))
            ddlHalf.Items.Add(New System.Web.UI.WebControls.ListItem("Jan-Jun", "1"))
            ddlHalf.Items.Add(New System.Web.UI.WebControls.ListItem("Jul-Dec", "2"))
        End If
    End Sub

    Protected Sub ddlScheduleType_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlScheduleType.SelectedIndexChanged
        Dim selectedMode As String = ddlScheduleType.SelectedValue
        If selectedMode = "HALF" Then
            lblHalf.Visible = True
            ddlHalf.Visible = True
        Else
            lblHalf.Visible = False
            ddlHalf.Visible = False
        End If
    End Sub

    ' retrieve data, filter data, and print pdf
    Private Function GetScheduleData(mode As String, year As Integer, half As Integer?) As DataTable
        Dim dt As New DataTable()
        Dim query As String = "
            SELECT
                MAX(str.record_id) AS record_id,
                act.schedule_id AS schedule_id,
                FORMAT(act.activity_date, 'dd/MM') AS [Date],
                a.activity_name AS Activity,

                MAX(CASE WHEN cl.class_id = 'CL00' AND str.serviceList_id = 'SL-05' THEN p.first_name END) AS [Song Leader],
                MAX(CASE WHEN cl.class_id = 'CL00' AND str.serviceList_id = 'SL-06' THEN p.first_name END) AS [Song TA],
                MAX(CASE WHEN cl.class_id = 'CL00' AND str.serviceList_id = 'SL-03' THEN p.first_name END) AS [Pianist],
                MAX(CASE WHEN cl.class_id = 'CL00' AND str.serviceList_id = 'SL-02' THEN p.first_name END) AS [Prayer],
                
                (m.book_title + '-' + m.book_chapter) AS Material,

                -- CL01 (0-4Y)
                MAX(CASE WHEN cl.class_id = 'CL01' AND str.serviceList_id = 'SL-04' THEN p.first_name END) AS [S-01],
                MAX(CASE WHEN cl.class_id = 'CL01' AND str.serviceList_id = 'SL-01' THEN p.first_name END) AS [TA-01],

                -- CL02 (5–6Y)
                MAX(CASE WHEN cl.class_id = 'CL02' AND str.serviceList_id = 'SL-04' THEN p.first_name END) AS [S-02],
                MAX(CASE WHEN cl.class_id = 'CL02' AND str.serviceList_id = 'SL-01' THEN p.first_name END) AS [TA-02],

                -- CL03 (7–8Y)
                MAX(CASE WHEN cl.class_id = 'CL03' AND str.serviceList_id = 'SL-04' THEN p.first_name END) AS [S-03],
                MAX(CASE WHEN cl.class_id = 'CL03' AND str.serviceList_id = 'SL-01' THEN p.first_name END) AS [TA-03],
    
                -- CL04 (9-10Y)
                MAX(CASE WHEN cl.class_id = 'CL04' AND str.serviceList_id = 'SL-04' THEN p.first_name END) AS [S-04],
                MAX(CASE WHEN cl.class_id = 'CL04' AND str.serviceList_id = 'SL-01' THEN p.first_name END) AS [TA-04],
    
                -- CL05 (11-12Y)
                MAX(CASE WHEN cl.class_id = 'CL05' AND str.serviceList_id = 'SL-04' THEN p.first_name END) AS [S-05],
                MAX(CASE WHEN cl.class_id = 'CL05' AND str.serviceList_id = 'SL-01' THEN p.first_name END) AS [TA-05]

                FROM activitySchedule act
                INNER JOIN activity a ON act.activity_id = a.activity_id
                LEFT JOIN staffTeachingRecord str ON str.schedule_id = act.schedule_id
                LEFT JOIN class cl ON cl.class_id = str.class_id
                LEFT JOIN staff s ON s.staff_id = str.staff_id
                LEFT JOIN person p ON p.person_id = s.person_id
                LEFT JOIN scheduleMaterial sm ON act.schedule_id = sm.schedule_id
                LEFT JOIN material m on sm.material_id = m.material_id
                WHERE a.activity_name <> 'Children Choir'
                AND (
                        (@Mode = 'YEAR' AND YEAR(str.teaching_date) = @Year)

                     OR (@Mode = 'HALF' AND YEAR(str.teaching_date) = @Year
                            AND (
                                (@Half = 1 AND MONTH(str.teaching_date) BETWEEN 1 AND 6)
                             OR (@Half = 2 AND MONTH(str.teaching_date) BETWEEN 7 AND 12)
                            )
                        )
                    )
                GROUP BY act.schedule_id, act.activity_date, a.activity_name,(m.book_title + '-' + m.book_chapter)
                ORDER BY act.activity_date ASC;
                "

        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            Using getCommand As New SqlCommand(query, connection)

                getCommand.Parameters.AddWithValue("@Mode", mode)
                getCommand.Parameters.AddWithValue("@Year", year)

                If mode = "HALF" Then
                    getCommand.Parameters.AddWithValue("@Half", half)
                Else
                    getCommand.Parameters.AddWithValue("@Half", DBNull.Value)
                End If

                Using da As New SqlDataAdapter(getCommand)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    Private Sub BtnFilter_Click(sender As Object, e As EventArgs) Handles BtnFilter.Click
        ' Read user selections
        Dim schedulePeriod As String = ddlScheduleType.SelectedValue
        Dim yearValue As String = ddlYear.SelectedValue
        Dim halfValue As String = ddlHalf.SelectedValue

        ' Required field validator
        If String.IsNullOrEmpty(schedulePeriod) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Please select a schedule type.');", True)
            Exit Sub
        End If
        If String.IsNullOrEmpty(yearValue) Then
            ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Please select a year.');", True)
            Exit Sub
        End If

        Dim selectedYear As Integer = Integer.Parse(yearValue)
        Dim selectedHalf As Integer? = Nothing

        ' If HALF is selected from schedulePeriod ddl, apply required field validation on half-year ddl
        If schedulePeriod = "HALF" Then
            If String.IsNullOrEmpty(halfValue) Then
                ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Please select a half-year period.');", True)
                Exit Sub
            End If
            selectedHalf = Integer.Parse(halfValue)  ' value '1' is Jan–Jun, value '2' is Jul–Dec
        End If

        ' Get the DataTable from GetScheduleData function
        Dim dt As DataTable = GetScheduleData(schedulePeriod, selectedYear, selectedHalf)

        ' Bind to GridView
        GridView_Arrangement.DataSource = dt
        GridView_Arrangement.DataBind()
    End Sub


    Protected Sub BtnExportPDF_Click(sender As Object, e As EventArgs) Handles BtnExportPDF.Click
        Dim selectedSchedule As String = ddlScheduleType.SelectedValue
        Dim selectedYear As String = ddlYear.SelectedValue
        Dim customFileName As String

        If selectedSchedule = "YEAR" Then
            customFileName = selectedYear & " Schedule"
        ElseIf selectedSchedule = "HALF" AndAlso ddlHalf.SelectedValue = "1" Then
            customFileName = selectedYear & " Schedule (January - June)"
        ElseIf selectedSchedule = "HALF" AndAlso ddlHalf.SelectedValue = "2" Then
            customFileName = selectedYear & " Schedule (July - December)"
        Else
            customFileName = selectedYear & " Schedule"
        End If

        ' Create PDF in MemoryStream first
        Dim ms As New MemoryStream()
        Dim pdfDoc As New Document(PageSize.A4.Rotate(), 20, 20, 20, 20)
        Dim writer = PdfWriter.GetInstance(pdfDoc, ms)

        pdfDoc.Open()

        ' Determine mode based on schedule selection
        Dim mode As String
        Dim halfValue As Integer? = Nothing
        If ddlScheduleType.SelectedValue = "Annually" Then
            mode = "YEAR"
        Else
            mode = "HALF"
            halfValue = If(ddlHalf.SelectedValue = "1", 1, 2) 'convert half ddl value to integer
        End If
        Dim yearValue As Integer = CInt(ddlYear.SelectedValue) 'convert year ddl value to integer

        ' build title to print on PDF
        Dim titleFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 16)
        pdfDoc.Add(New Paragraph("Teacher and Activity " & customFileName, titleFont))
        pdfDoc.Add(New Paragraph(" "))


        ' call data from the datatable GetScheduleDate and select only the needed column
        Dim dt As DataTable = GetScheduleData(mode, yearValue, halfValue)
        Dim columnsToPrint As List(Of DataColumn) = dt.Columns.Cast(Of DataColumn) _
                                            .Skip(dt.Columns.Count - 17).ToList()


        ' build data table to print on pdf
        Dim table As New PdfPTable(columnsToPrint.Count)
        table.WidthPercentage = 100
        Dim columnWidths() As Single = {45, 65, 55, 50, 55, 50, 60, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50}
        table.SetWidths(columnWidths)


        ' loop through the gridview column to display the header
        For Each col As DataColumn In columnsToPrint
            Dim header As New PdfPCell(New Phrase(col.ColumnName))
            header.BackgroundColor = BaseColor.LIGHT_GRAY
            header.HorizontalAlignment = Element.ALIGN_CENTER
            header.Padding = 5
            table.AddCell(header)
        Next

        ' loop through the gridview colum to read each row for pdf table
        For Each datarow As DataRow In dt.Rows
            For Each col As DataColumn In columnsToPrint
                Dim cellText As String = datarow(col.ColumnName).ToString()
                table.AddCell(New PdfPCell(New Phrase(cellText)))
            Next
        Next

        pdfDoc.Add(table)
        pdfDoc.Close()

        ' Write PDF to Response
        Dim pdfBytes As Byte() = ms.ToArray()

        Response.Clear()
        Response.ContentType = "application/pdf"
        Response.AddHeader("content-disposition",
                           "attachment; filename=TeacherActivitySchedule_" & customFileName & ".pdf")
        Response.Cache.SetCacheability(HttpCacheability.NoCache)
        Response.BinaryWrite(pdfBytes)
        Response.Flush()
        Response.SuppressContent = True

        HttpContext.Current.ApplicationInstance.CompleteRequest()

    End Sub

End Class