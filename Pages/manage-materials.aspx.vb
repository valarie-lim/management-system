Imports System.Data.SqlClient

Public Class manage_materials
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ddlSearchMaterial.Items.Clear()
            ddlSearchMaterial.Items.Add(New System.Web.UI.WebControls.ListItem("全部", "All"))
            ddlSearchMaterial.SelectedValue = "All"
        End If
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_material.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_materialList.ConnectionString = DbHelper.GetConnectionString()
    End Sub

    Private Sub ddlSearchMaterial_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSearchMaterial.SelectedIndexChanged
        GridView_material.DataBind()
    End Sub
End Class