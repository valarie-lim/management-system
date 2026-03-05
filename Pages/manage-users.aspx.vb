Imports System.Data.SqlClient
Imports System.Web.Services.Description

Public Class manage_users
    Inherits System.Web.UI.Page

    Protected Sub BtnAddUser_Click(sender As Object, e As EventArgs) Handles BtnAddUser.Click
        ' Read userRole from session
        Dim userRole As String = Session("UserRole")

        ' Check session
        If String.IsNullOrEmpty(userRole) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertRedirect",
    $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("浏览已过期，请重新登录！")}'); window.location='login.aspx'; }}, 200);", True)

            Exit Sub
        End If

        ' Check if NOT principal
        If userRole.ToLower() <> "principal" Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "accessDenied",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("您没有权限访问此页面。")}'); }}, 100);", True)
            Exit Sub
        End If

        ' if principal, then proceed
        Response.Redirect("add-new-user.aspx")
    End Sub

    Protected Sub BtnRmvUser_Click(sender As Object, e As EventArgs) Handles BtnRmvUser.Click
        Dim userRole As String = Session("UserRole")

        If String.IsNullOrEmpty(userRole) Then
            Dim message As String = "会话已过期，请重新登录。"
            message = HttpUtility.JavaScriptStringEncode(message)

            ' Use master page's ScriptManager and show its alert
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertRedirect",
    $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("浏览已过期，请重新登录！")}'); window.location='login.aspx'; }}, 200);", True)
            Exit Sub
        End If

        If userRole.ToLower() <> "principal" Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "accessDenied",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("您没有权限访问此页面。")}'); }}, 100);", True)
            Exit Sub
        End If

        Response.Redirect("remove-user.aspx")
    End Sub
End Class