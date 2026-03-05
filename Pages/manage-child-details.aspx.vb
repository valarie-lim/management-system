Imports System.Data.SqlClient

Public Class manage_child_details
    Inherits System.Web.UI.Page

    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("manage-children.aspx")
    End Sub

    Protected Sub ddlSearchClass_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSearchClass.SelectedIndexChanged
        GridView_Child.DataBind()
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_ClassList.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_childInfo.ConnectionString = DbHelper.GetConnectionString()
    End Sub
End Class