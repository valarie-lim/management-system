Imports System.Data.SqlClient

Public Class manage_teacher_details
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            pnlActionButtons.Visible = False
        End If

    End Sub
    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("manage-teacher.aspx")
    End Sub

    Public Function FormatContact(ByVal numberObj As Object) As String
        If numberObj Is Nothing OrElse Convert.IsDBNull(numberObj) Then
            Return String.Empty
        End If

        Dim number As String = numberObj.ToString().Trim()

        ' normalize digits
        Dim digits As New System.Text.StringBuilder()
        For Each ch As Char In number
            If Char.IsDigit(ch) Then digits.Append(ch)
        Next
        Dim s As String = digits.ToString()

        If s.Length = 10 Then
            Return s.Substring(0, 3) & "-" & s.Substring(3, 7)
        ElseIf s.Length = 11 Then
            Return s.Substring(0, 4) & "-" & s.Substring(4, 7)
        Else
            Return number
        End If
    End Function


    Protected Sub GridView_Teacher_SelectedIndexChanged(sender As Object, e As EventArgs) Handles GridView_Teacher.SelectedIndexChanged
        pnlActionButtons.Visible = True     ' Show action buttons
    End Sub

    Protected Sub BtnUpdateAddress_Click(sender As Object, e As EventArgs) Handles BtnUpdateAddress.Click
        Dim selectedRow As GridViewRow = GridView_Teacher.SelectedRow
        If selectedRow IsNot Nothing Then
            Dim staffId As String = GridView_Teacher.DataKeys(selectedRow.RowIndex).Value.ToString()

            ' Get address_id from database
            Dim addressId As String = ""
            Dim connectionString As String = DbHelper.GetConnectionString()
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim getCommand As New SqlCommand("
                    SELECT address_id
                    FROM staff
                    INNER JOIN person ON staff.person_id = person.person_id
                    WHERE staff_id=@staff_id", connection)
                getCommand.Parameters.AddWithValue("@staff_id", staffId)
                addressId = getCommand.ExecuteScalar().ToString()
            End Using

            ' Store in session and redirect
            Session("TeacherAddress") = addressId
            Response.Redirect("manage-teacher-address.aspx")
        End If
    End Sub

    Protected Sub BtnUpdateService_Click(sender As Object, e As EventArgs) Handles BtnUpdateService.Click
        Dim selectedRow As GridViewRow = GridView_Teacher.SelectedRow
        If selectedRow IsNot Nothing Then
            Dim staffId As String = GridView_Teacher.DataKeys(selectedRow.RowIndex).Value.ToString()

            ' Store in session and redirect
            Session("TeacherServiceStaffId") = staffId
            Response.Redirect("manage-teacher-service.aspx")
        End If
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_teacherArrangement.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_Roles.ConnectionString = DbHelper.GetConnectionString()
    End Sub

End Class