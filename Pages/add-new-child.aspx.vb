Imports System.Data.SqlClient
Imports System.Net.NetworkInformation

Public Class add_new_child
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            Dim today As Date = DateTime.Today
            ' Set joined date to only can choose until today
            RvTxtJoinedDate.MaximumValue = DateTime.Today.ToShortDateString()

            ' Restore user input to the fields, if user return from the confirmation page
            If Session("FirstName") IsNot Nothing Then
                TxtFirstName.Text = Session("FirstName").ToString()
            End If
            If Session("LastName") IsNot Nothing Then
                TxtLastName.Text = Session("LastName").ToString()
            End If
            If Session("ChineseName") IsNot Nothing Then
                TxtChineseName.Text = Session("ChineseName").ToString()
            End If
            If Session("Gender") IsNot Nothing Then
                RblGender.SelectedValue = Session("Gender").ToString()
            End If
            If Session("DateOfBirth") IsNot Nothing Then
                TxtDateOfBirth.Text = Session("DateOfBirth").ToString()
            End If
            If Session("Religion") IsNot Nothing Then
                RblReligion.SelectedValue = Session("Religion").ToString()
            End If
            If Session("JoinedDate") IsNot Nothing Then
                TxtJoinedDate.Text = Session("JoinedDate").ToString()
            End If
            If Session("Church") IsNot Nothing Then
                TxtChurch.Text = Session("Church").ToString()
            End If
            If Session("Inviter") IsNot Nothing Then
                TxtInviter.Text = Session("Inviter").ToString()
            End If
            If Session("School") IsNot Nothing Then
                TxtSchool.Text = Session("School").ToString()
            End If
            If Session("Remark") IsNot Nothing Then
                TxtRemark.Text = Session("Remark").ToString()
            End If
        End If
    End Sub


    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        ' Clear session variables
        Session.Remove("FirstName")
        Session.Remove("LastName")
        Session.Remove("ChineseName")
        Session.Remove("Gender")
        Session.Remove("DateOfBirth")
        Session.Remove("Religion")
        Session.Remove("JoinedDate")
        Session.Remove("Church")
        Session.Remove("Inviter")
        Session.Remove("School")
        Session.Remove("Remark")
        Response.Redirect("manage-children.aspx")
    End Sub


    Private Sub BtnConfirm_Click(sender As Object, e As EventArgs) Handles BtnConfirm.Click
        If Page.IsValid Then
            ' Check if child already exists using the child first name + dob
            Dim NewChild = TxtFirstName.Text.Trim()
            Dim dateOfBirth = TxtDateOfBirth.Text.Trim()

            Dim connectionString As String = DbHelper.GetConnectionString()
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Try
                    Dim checkChild As New SqlCommand("
                        SELECT child_id
                        FROM child
                        WHERE first_name=@FirstName AND dob=@DOB", connection)
                    checkChild.Parameters.AddWithValue("@FirstName", NewChild)
                    checkChild.Parameters.AddWithValue("@DOB", dateOfBirth)
                    Dim childID = checkChild.ExecuteScalar()

                    If childID Is Nothing Then
                        ' if no child is founded, then stored into session
                        Session("FirstName") = NewChild
                        Session("DateOfBirth") = dateOfBirth
                    Else
                        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("已有此儿童的记录，请查看列表。")}'); }}, 100);", True)

                        Exit Sub
                    End If

                Catch ex As Exception
                    '' alert message for technical checking
                    'Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
                    'ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert",
                    '    "alert('System Error: " & safeMessage & "');", True)

                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("发生意外错误，请重试或联系管理员。")}'); }}, 100);", True)
                End Try
            End Using

            Session("LastName") = TxtLastName.Text.Trim()
            Session("ChineseName") = If(String.IsNullOrWhiteSpace(TxtChineseName.Text), Nothing, TxtChineseName.Text.Trim())
            Session("Gender") = RblGender.SelectedValue
            Session("Religion") = RblReligion.SelectedValue
            Session("JoinedDate") = TxtJoinedDate.Text
            Session("Church") = If(String.IsNullOrWhiteSpace(TxtChurch.Text), Nothing, TxtChurch.Text.Trim())
            Session("Inviter") = If(String.IsNullOrWhiteSpace(TxtInviter.Text), Nothing, TxtInviter.Text.Trim())
            Session("School") = If(String.IsNullOrWhiteSpace(TxtSchool.Text), Nothing, TxtSchool.Text.Trim())
            Session("Remark") = If(String.IsNullOrWhiteSpace(TxtRemark.Text), Nothing, TxtRemark.Text.Trim())
            ' Redirect to the confirmation page
            Response.Redirect("add-new-child-confirmation.aspx")
        End If
    End Sub


End Class