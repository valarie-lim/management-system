Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports System.Drawing.Printing
Imports iTextSharp.text.pdf.draw
Imports System.IO

Public Class report_children_information
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ddlSearchActive.Items.Clear()
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("- Select Status -", ""))
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("Active", "0"))
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("Archived", "1"))
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("New", "2"))
        End If
    End Sub
    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("view-reports.aspx")
    End Sub

    Protected Sub ddlSearchActive_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSearchActive.SelectedIndexChanged
        Dim selectedValue As String = ddlSearchActive.SelectedValue
        Response.Write("Selected: " & selectedValue)
    End Sub


    Protected Sub BtnExportPDF_Click(sender As Object, e As EventArgs) Handles BtnExportPDF.Click
        ' Bind gridview (ensure latest filter applied)
        GridView_Child.AllowPaging = False
        GridView_Child.DataBind()

        ' Create PDF document
        Dim pdfDoc As New Document(PageSize.A4.Rotate(), 20, 20, 20, 20)
        Dim memoryStream As New MemoryStream()
        Dim writer As PdfWriter = PdfWriter.GetInstance(pdfDoc, memoryStream)

        pdfDoc.Open()
        ' Determine status text for report title and pdf filename
        Dim statusText As String = "All"

        Select Case ddlSearchActive.SelectedValue
            Case "0"
                statusText = "Active"
            Case "1"
                statusText = "Archived"
            Case "2"
                statusText = "New-" & DateTime.Now.Year.ToString()
        End Select

        ' Title
        Dim titleFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 16)
        pdfDoc.Add(New Paragraph("BEM Kuching Sunday School", titleFont))
        pdfDoc.Add(New Paragraph(DateTime.Now.ToString("yyyy") & " Children Information (" & statusText & ")"))

        pdfDoc.Add(New Paragraph(" "))

        ' Styling pdf table:
        ' Create PDF table with number of columns in GridView
        Dim table As New PdfPTable(GridView_Child.Columns.Count + 1)
        table.WidthPercentage = 100

        ' Custom column widths (must match GridView column count)
        Dim customWidths As Single() = {4, 5, 8, 10, 22, 10, 12, 28, 10, 32}
        table.SetWidths(customWidths)


        Dim fontPath As String = Server.MapPath("~/Fonts/msyh.ttf")
        Dim baseFont As BaseFont = BaseFont.CreateFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED)

        Dim chineseFont As New Font(baseFont, 10)
        Dim chineseFontBold As New Font(baseFont, 10, Font.BOLD)

        ' Add table headers with # column
        ' Add "#" header
        table.AddCell(New PdfPCell(New Phrase("#", chineseFontBold)) With {
            .BackgroundColor = BaseColor.LIGHT_GRAY,
            .HorizontalAlignment = Element.ALIGN_CENTER})

        ' Add table headers
        For Each col As DataControlField In GridView_Child.Columns
            Dim cell As New PdfPCell(New Phrase(col.HeaderText, chineseFontBold))
            cell.BackgroundColor = BaseColor.LIGHT_GRAY
            cell.HorizontalAlignment = Element.ALIGN_CENTER
            table.AddCell(cell)
        Next

        ' Add data rows with serial number
        Dim rowNumber As Integer = 1
        For Each row As GridViewRow In GridView_Child.Rows
            ' Add serial number
            table.AddCell(New PdfPCell(New Phrase(rowNumber.ToString(), chineseFont)) With {
                .HorizontalAlignment = Element.ALIGN_CENTER
            })

            ' Add the rest of the row data
            For Each cell As TableCell In row.Cells
                table.AddCell(New Phrase(Server.HtmlDecode(cell.Text), chineseFont))
            Next

            rowNumber += 1
        Next

        pdfDoc.Add(table)
        pdfDoc.Add(New Chunk(New LineSeparator()))
        pdfDoc.Add(New Paragraph("Generated on: " & DateTime.Now.ToString("dd-MM-yyyy HH:mm")))
        pdfDoc.Close()

        ' Build custom filename
        Dim pdfFileName As String = $"_{statusText}.pdf"

        ' Return PDF file to browser
        Response.ContentType = "application/pdf"
        Response.AddHeader("content-disposition", "attachment;filename= ChildrenInformation" & pdfFileName)
        Response.BinaryWrite(memoryStream.ToArray())
        Response.Flush()
        Response.End()

        GridView_Child.AllowPaging = True
        GridView_Child.DataBind()
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_childInfo.ConnectionString = DbHelper.GetConnectionString()
    End Sub
End Class





