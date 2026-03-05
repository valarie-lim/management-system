Public Class manage_teacher_address
    Inherits System.Web.UI.Page


    Private Sub BtnDone_Click(sender As Object, e As EventArgs) Handles BtnDone.Click
        Response.Redirect("manage-teacher-details.aspx")
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_teacherAddress.ConnectionString = DbHelper.GetConnectionString()
    End Sub
End Class