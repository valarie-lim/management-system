Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Drawing.Printing
Imports iTextSharp.text.pdf.draw
Imports System.IO

Public Class report_attendance_summaries
    Inherits System.Web.UI.Page
    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("view-reports.aspx")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ddlActivity.Items.Clear()
            ddlActivity.Items.Add(New System.Web.UI.WebControls.ListItem("- Select Activity -", ""))
            ddlActivity.Items.Add(New System.Web.UI.WebControls.ListItem("All Activities (Except Children Choir)", "ALL_EXCEPT_CHOIR"))

            Dim connectionString As String = DbHelper.GetConnectionString()
            Using connection As New SqlConnection(connectionString)
                Using readCommand As New SqlCommand("
                    SELECT DISTINCT activity_id, activity_name
                    FROM activity
                    ORDER BY activity_name", connection)
                    connection.Open()
                    Using reader = readCommand.ExecuteReader()
                        While reader.Read()
                            ' Use activity_id as value, activity_name as text
                            ddlActivity.Items.Add(New System.Web.UI.WebControls.ListItem(reader("activity_name").ToString(), reader("activity_id").ToString()))
                        End While
                    End Using
                End Using
            End Using
        End If
    End Sub

    Private Function GetAttendanceData(activityId As String) As DataTable
        Dim dt As New DataTable()
        Dim query As String = "
        SELECT 
            c.child_id,
            c.chinese_name,
            (c.first_name + ' ' + c.last_name) AS FullName,
            c.age,
            MONTH(s.activity_date) AS [Month],
            IIF(ca.isPresent = 1, '1', '') AS PresentMark,
            s.schedule_id,
            a.activity_name
        FROM child c
        LEFT JOIN childAttendance ca ON c.child_id = ca.child_id
        LEFT JOIN attendance att ON ca.attendance_id = att.attendance_id
        LEFT JOIN activitySchedule s ON att.schedule_id = s.schedule_id
        LEFT JOIN activity a ON s.activity_id = a.activity_id
        WHERE (
            (@activity_id = 'ALL_EXCEPT_CHOIR' AND a.activity_name IS NOT NULL AND a.activity_name <> 'Children Choir')
            OR (@activity_id <> 'ALL_EXCEPT_CHOIR' AND a.activity_id = @activity_id)
        )
        ORDER BY c.age DESC;"

        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            Using getCommand As New SqlCommand(query, connection)
                ' Always supply the parameter (simpler and safer)
                getCommand.Parameters.AddWithValue("@activity_id", activityId)

                Using da As New SqlDataAdapter(getCommand)
                    da.Fill(dt)
                End Using
            End Using
        End Using
        Return dt
    End Function

    Private Sub ddlActivity_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlActivity.SelectedIndexChanged
        LoadAttendanceTable()
    End Sub

    Private Sub LoadAttendanceTable()
        Try
            Dim selectedActivity As String = ddlActivity.SelectedValue
            If String.IsNullOrEmpty(selectedActivity) Then selectedActivity = "ALL"

            Dim dt As DataTable = GetAttendanceData(selectedActivity)
            If dt.Rows.Count = 0 Then
                gvAttendance.DataSource = Nothing
                gvAttendance.DataBind()
                Return
            End If
            ' pivot the data for display (child names as rows, months as columns)
            Dim pivot As New DataTable()
            pivot.Columns.Add("Child Name")
            pivot.Columns.Add("Chinese Name")
            pivot.Columns.Add("Age")
            ' add month columns Jan–Dec
            For m As Integer = 1 To 12
                pivot.Columns.Add(New DateTime(2000, m, 1).ToString("MMM"))
            Next
            ' add total column
            pivot.Columns.Add("Total")
            ' add a row per child
            Dim childList = dt.AsEnumerable().
            Select(Function(r) r("child_id")).Distinct().ToList()

            For Each childId In childList
                Dim childRows = dt.AsEnumerable().Where(Function(r) r("child_id") = childId)
                Dim newRow = pivot.NewRow()
                newRow("Chinese Name") = childRows.First()("chinese_name").ToString()
                newRow("Child Name") = childRows.First()("FullName").ToString()
                newRow("Age") = childRows.First()("age").ToString()
                ' Fill attendance per month
                Dim totalAttendance As Integer = 0
                For m As Integer = 1 To 12
                    Dim currentMonth As Integer = m
                    ' Sum all attendance for this child in this month
                    Dim monthTotal As Integer = childRows.
                        Where(Function(r) r("Month") = currentMonth).
                        Sum(Function(r) SafeInt(r("PresentMark")))
                    ' Put the sum into the monthly column
                    newRow(New DateTime(2000, currentMonth, 1).ToString("MMM")) = monthTotal
                    ' Accumulate into total
                    totalAttendance += monthTotal
                Next
                ' Set total column
                newRow("Total") = totalAttendance
                pivot.Rows.Add(newRow)
            Next
            gvAttendance.DataSource = pivot
            gvAttendance.DataBind()

        Catch ex As Exception
            '' alert message for technical checking
            'Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
            'ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert",
            '    "alert('Error saving data: " & safeMessage & "');", True)
            ClientScript.RegisterStartupScript(Me.GetType(), "alertError",
            "alert('An unexpected error occurred. Please try again or contact support.');", True)
        End Try
    End Sub

    Protected Sub BtnExportPDF_Click(sender As Object, e As EventArgs) Handles BtnExportPDF.Click
        ' get the data based on user selection on the dropdownlist
        Dim selectedActivity As String = ddlActivity.SelectedValue
        If String.IsNullOrEmpty(selectedActivity) Then selectedActivity = "ALL"
        Dim data As DataTable = GetAttendanceData(selectedActivity)

        ' group attendance data by child to build a unique list of children for the summary
        Dim childList = data.AsEnumerable().
            GroupBy(Function(r) r("child_id")).
            Select(Function(g) New With {
                .ChildID = g.Key,
                .ChineseName = g.First()("chinese_name").ToString(),
                .FullName = g.First()("FullName").ToString(),
                .Age = g.First()("age").ToString()
            }).ToList()

        ' get total scheduled activities per half-year
        Dim totalScheduleJanToJun As Integer = 0
        Dim totalScheduleJulToDec As Integer = 0
        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()

            ' Jan-Jun
            Dim GetFirstHalfSql As New SqlCommand("
            SELECT COUNT(*) 
            FROM activitySchedule s
            INNER JOIN activity a ON s.activity_id = a.activity_id
            WHERE MONTH(s.activity_date) BETWEEN 1 AND 6
            " & If(selectedActivity = "ALL_EXCEPT_CHOIR", "AND a.activity_name <> 'Children Choir'", "AND a.activity_id = @activity_id"), connection)
            If selectedActivity <> "ALL_EXCEPT_CHOIR" Then GetFirstHalfSql.Parameters.AddWithValue("@activity_id", selectedActivity)
            totalScheduleJanToJun = Convert.ToInt32(GetFirstHalfSql.ExecuteScalar())

            ' Jul-Dec
            Dim GetSecondHalfSql As New SqlCommand("
            SELECT COUNT(*) 
            FROM activitySchedule s
            INNER JOIN activity a ON s.activity_id = a.activity_id
            WHERE MONTH(s.activity_date) BETWEEN 7 AND 12
            " & If(selectedActivity = "ALL_EXCEPT_CHOIR", "AND a.activity_name <> 'Children Choir'", "AND a.activity_id = @activity_id"), connection)
            If selectedActivity <> "ALL_EXCEPT_CHOIR" Then GetSecondHalfSql.Parameters.AddWithValue("@activity_id", selectedActivity)
            totalScheduleJulToDec = Convert.ToInt32(GetSecondHalfSql.ExecuteScalar())
        End Using

        ' PDF page setup
        Dim pdfDoc As New Document(PageSize.A4.Rotate(), 20, 20, 20, 20)
        Dim memoryStream As New MemoryStream()
        Dim writer = PdfWriter.GetInstance(pdfDoc, memoryStream)
        pdfDoc.Open()

        ' setup the Fonts
        Dim fontPath = Server.MapPath("~/Fonts/msyh.ttf")
        Dim bFont = BaseFont.CreateFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED)
        Dim fontNormal As New iTextSharp.text.Font(bFont, 9)
        Dim fontBold As New iTextSharp.text.Font(bFont, 9, iTextSharp.text.Font.BOLD)
        Dim titleFont As New iTextSharp.text.Font(bFont, 14, iTextSharp.text.Font.BOLD)
        Dim chineseFont As New iTextSharp.text.Font(bFont, 9)
        Dim chineseFontBold As New iTextSharp.text.Font(bFont, 9, iTextSharp.text.Font.BOLD)

        ' build the PDF table structure
        Dim buildTable = Function(startMonth As Integer, endMonth As Integer, totalActivitiesHalf As Integer) As PdfPTable
                             Dim colCount As Integer = 12 ' # + 中文 + Name + Age + 6 months + Total + %
                             Dim table As New PdfPTable(colCount)
                             table.WidthPercentage = 100

                             ' Column widths
                             Dim widths() As Single = {1.0F, 2.0F, 3.0F, 1.0F, 1, 1, 1, 1, 1, 1, 1, 1}
                             table.SetWidths(widths)

                             ' Table header
                             table.AddCell(New PdfPCell(New Phrase("#", chineseFontBold)) With {.BackgroundColor = BaseColor.LIGHT_GRAY, .HorizontalAlignment = Element.ALIGN_CENTER})
                             table.AddCell(New PdfPCell(New Phrase("中文", chineseFontBold)) With {.BackgroundColor = BaseColor.LIGHT_GRAY, .HorizontalAlignment = Element.ALIGN_CENTER})
                             table.AddCell(New PdfPCell(New Phrase("Name", fontBold)) With {.BackgroundColor = BaseColor.LIGHT_GRAY, .HorizontalAlignment = Element.ALIGN_CENTER})
                             table.AddCell(New PdfPCell(New Phrase("Age", fontBold)) With {.BackgroundColor = BaseColor.LIGHT_GRAY, .HorizontalAlignment = Element.ALIGN_CENTER})
                             ' Month columns
                             For m = startMonth To endMonth
                                 Dim ci As New Globalization.CultureInfo("en")
                                 table.AddCell(New PdfPCell(New Phrase(ci.DateTimeFormat.GetMonthName(m), fontBold)) With {.BackgroundColor = BaseColor.LIGHT_GRAY, .HorizontalAlignment = Element.ALIGN_CENTER})
                             Next
                             ' Total and percentage column
                             table.AddCell(New PdfPCell(New Phrase("Total", fontBold)) With {.BackgroundColor = BaseColor.LIGHT_GRAY, .HorizontalAlignment = Element.ALIGN_CENTER})
                             table.AddCell(New PdfPCell(New Phrase("Attendance %", fontBold)) With {.BackgroundColor = BaseColor.LIGHT_GRAY, .HorizontalAlignment = Element.ALIGN_CENTER})
                             ' Table data
                             Dim counter As Integer = 1
                             For Each c In childList
                                 table.AddCell(New PdfPCell(New Phrase(counter.ToString(), chineseFontBold)) With {.HorizontalAlignment = Element.ALIGN_CENTER})
                                 table.AddCell(New PdfPCell(New Phrase(c.ChineseName, chineseFont)))
                                 table.AddCell(New PdfPCell(New Phrase(c.FullName, fontNormal)))
                                 table.AddCell(New PdfPCell(New Phrase(c.Age, fontNormal)))

                                 Dim totalAttendance As Integer = 0
                                 For m = startMonth To endMonth
                                     Dim currentMonth As Integer = m
                                     ' For child attendance
                                     Dim monthTotal = data.AsEnumerable().
                                         Where(Function(r) r("child_id") = c.ChildID AndAlso r("Month") = currentMonth).
                                         Sum(Function(r) SafeInt(r("PresentMark")))
                                     table.AddCell(New PdfPCell(New Phrase(monthTotal.ToString(), fontNormal)) With {.HorizontalAlignment = Element.ALIGN_CENTER})
                                     totalAttendance += monthTotal
                                 Next

                                 ' data for total attendance added to the table
                                 table.AddCell(New PdfPCell(New Phrase(totalAttendance.ToString(), fontBold)) With {.HorizontalAlignment = Element.ALIGN_CENTER})

                                 ' calculate the attendance percentage using formula: ChildTotalAttendance/TotalScheduleActivities*100%
                                 Dim percentage As String = "0%"
                                 If totalActivitiesHalf > 0 Then
                                     percentage = Math.Round((totalAttendance / totalActivitiesHalf) * 100, 1).ToString() & "%"
                                 End If
                                 ' data attendance percentage added to the table
                                 table.AddCell(New PdfPCell(New Phrase(percentage, fontBold)) With {.HorizontalAlignment = Element.ALIGN_CENTER})
                                 counter += 1
                             Next
                             ' Totals row
                             table.AddCell(New PdfPCell(New Phrase("Totals", fontBold)) With {.Colspan = 4, .HorizontalAlignment = Element.ALIGN_CENTER})
                             Dim grandTotal As Integer = 0
                             For m = startMonth To endMonth
                                 Dim currentMonth As Integer = m  ' local copy
                                 Dim monthTotal = data.AsEnumerable().
                                     Where(Function(r) r("Month") = currentMonth AndAlso SafeInt(r("PresentMark")) > 0).
                                     Count()
                                 table.AddCell(New PdfPCell(New Phrase(monthTotal.ToString(), fontBold)) With {.HorizontalAlignment = Element.ALIGN_CENTER})
                                 grandTotal += monthTotal
                             Next
                             table.AddCell(New PdfPCell(New Phrase(grandTotal.ToString(), fontBold)) With {.HorizontalAlignment = Element.ALIGN_CENTER})
                             table.AddCell(New PdfPCell(New Phrase("-", fontBold)) With {.HorizontalAlignment = Element.ALIGN_CENTER}) ' blank % for totals
                             Return table
                         End Function

        ' generate a customised activity name based on user selection for used in the PDF header.
        Dim selectedActivityName As String = ddlActivity.SelectedItem.Text
        If String.IsNullOrEmpty(selectedActivityName) Or selectedActivityName = "- Select Activity -" Then
            selectedActivityName = "All Activities"
        End If

        ' customised the PDF layout for Page 1: Jan-Jun
        pdfDoc.Add(New Paragraph("Attendance Summary (Jan – Jun) for " & selectedActivityName, titleFont))
        pdfDoc.Add(New Paragraph(" "))
        pdfDoc.Add(buildTable(1, 6, totalScheduleJanToJun))
        pdfDoc.Add(New Chunk(New LineSeparator()))
        pdfDoc.Add(New Paragraph("Generated on: " & DateTime.Now.ToString("dd-MM-yyyy HH:mm")))

        ' customised the PDF layout for Page 2: Jul-Dec
        pdfDoc.NewPage()
        pdfDoc.Add(New Paragraph("Attendance Summary (Jul – Dec) for " & selectedActivityName, titleFont))
        pdfDoc.Add(New Paragraph(" "))
        pdfDoc.Add(buildTable(7, 12, totalScheduleJulToDec))
        pdfDoc.Add(New Chunk(New LineSeparator()))
        pdfDoc.Add(New Paragraph("Generated on: " & DateTime.Now.ToString("dd-MM-yyyy HH:mm")))

        pdfDoc.Close()

        ' set customise name for the PDF, send PDF to browser, and automatically saved to PC downloads folder
        Dim pdfFileName As String = DateTime.Now.ToString("yyyy") & "_" & selectedActivityName & ".pdf"
        Response.ContentType = "application/pdf"
        Response.AddHeader("content-disposition", "attachment;filename=AttendanceSummary_" & pdfFileName)
        Response.BinaryWrite(memoryStream.ToArray())
        Response.End()
    End Sub


    ' Helper function
    Private Function SafeInt(value As Object) As Integer
        If value Is Nothing Then Return 0
        Dim s As String = value.ToString().Trim()
        If s = "" Then Return 0
        Dim num As Integer
        If Integer.TryParse(s, num) Then Return num
        Return 0
    End Function



End Class