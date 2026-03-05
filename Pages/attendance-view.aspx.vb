Imports System.ComponentModel.Design
Imports System.Data.SqlClient

Public Class attendance_view
    Inherits System.Web.UI.Page

    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("attendance-record.aspx")
    End Sub

    Private Sub BtnViewReport_Click(sender As Object, e As EventArgs) Handles BtnViewReport.Click
        Response.Redirect("report-attendance-summaries.aspx")
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadYears()
            LoadMonths()
        End If
    End Sub

    Private Sub LoadYears()
        ddlYear.Items.Clear()
        ddlYear.Items.Add(New ListItem("- 选年份 -", ""))

        Dim currentYear As Integer = DateTime.Now.Year
        For y As Integer = currentYear - 2 To currentYear + 3
            ddlYear.Items.Add(New ListItem(y.ToString(), y.ToString()))
        Next
    End Sub


    Protected Sub ddlYear_SelectedIndexChanged(sender As Object, e As EventArgs)
        ddlMonth.Items.Clear()
        ddlActivity.Items.Clear()
        If ddlYear.SelectedValue = "" Then Exit Sub

        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            Dim readCommand As New SqlCommand("
            SELECT DISTINCT MONTH(activity_date) AS Mth
            FROM activitySchedule
            WHERE YEAR(activity_date) = @yr
            ORDER BY Mth", connection)
            readCommand.Parameters.AddWithValue("@yr", ddlYear.SelectedValue)

            connection.Open()
            Dim reader = readCommand.ExecuteReader()
            ddlMonth.Items.Add(New ListItem("- 选月份 -", ""))

            While reader.Read()
                Dim m As Integer = reader("Mth")
                ddlMonth.Items.Add(New ListItem(MonthName(m), m.ToString()))
            End While
        End Using
    End Sub

    Private Sub LoadMonths()
        ddlMonth.Items.Clear()
        ddlMonth.Items.Add(New ListItem("- 选月份 -", ""))

        For m As Integer = 1 To 12
            Dim monthName As String = New DateTime(2000, m, 1).ToString("MMMM")
            ddlMonth.Items.Add(New ListItem(monthName, m.ToString()))
        Next
    End Sub

    Protected Sub ddlMonth_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlMonth.SelectedIndexChanged
        If ddlYear.SelectedValue <> "" Then
            LoadActivities()
        Else
            ddlActivity.Items.Clear()
            ddlActivity.Items.Add(New ListItem("- 选活动 -", ""))
        End If
    End Sub

    Private Sub LoadActivities()
        ddlActivity.Items.Clear()
        ddlActivity.Items.Add(New ListItem("- 选活动 -", ""))

        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()

            Dim command As New SqlCommand("
                SELECT
                    s.schedule_id,
                    FORMAT(s.activity_date, 'MM/dd') + ' — ' + a.activity_name AS DisplayName
                FROM activitySchedule s
                INNER JOIN activity a ON s.activity_id = a.activity_id
                WHERE YEAR(s.activity_date) = @yr
                  AND MONTH(s.activity_date) = @m
                ORDER BY s.activity_date", connection)

            command.Parameters.AddWithValue("@yr", ddlYear.SelectedValue)
            command.Parameters.AddWithValue("@m", ddlMonth.SelectedValue)

            Dim reader As SqlDataReader = command.ExecuteReader()

            While reader.Read()
                ddlActivity.Items.Add(
            New ListItem(reader("DisplayName").ToString(),
                         reader("schedule_id").ToString())
            )
            End While

            reader.Close()
            connection.Close()
        End Using

    End Sub

    Protected Sub ddlActivity_SelectedIndexChanged(sender As Object, e As EventArgs)
        GridView_childAttendance.DataBind()
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_childAttendance.ConnectionString = DbHelper.GetConnectionString()
    End Sub
End Class