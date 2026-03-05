Imports System.Data.SqlClient

Public Class add_new_child_confirmation
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
        End If
        ' Retrieve Details from Session variables
        ' Personal Details
        InputFirstName.Text = Session("FirstName")
        InputLastName.Text = Session("LastName")
        InputChineseName.Text = Session("ChineseName")
        InputGender.Text = Session("Gender")
        InputDateOfBirth.Text = Session("DateOfBirth")
        ' Others Information
        InputReligion.Text = Session("Religion")
        InputJoinedDate.Text = Session("JoinedDate")
        InputInviter.Text = Session("Inviter")
        InputSchool.Text = Session("School")
        InputChurch.Text = Session("Church")
        InputRemark.Text = Session("Remark")
    End Sub

    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("add-new-child.aspx")
    End Sub

    Private Sub BtnSubmit_Click(sender As Object, e As EventArgs) Handles BtnSubmit.Click
        ' establish connection to the database
        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim childID As String = IDGenerator.NextID(connection, "child", "child_id", "C")
            Dim gender As String
            Select Case InputGender.Text
                Case "男"
                    gender = "1"
                Case "女"
                    gender = "2"
                Case Else
                    gender = ""
            End Select
            Dim religion As String
            Select Case InputReligion.Text
                Case "基督徒"
                    religion = "1"
                Case "非基督徒"
                    religion = "0"
                Case Else
                    religion = ""
            End Select

            Dim transaction As SqlTransaction = connection.BeginTransaction()
            Try
                ' insert into child table
                Dim childQuery As String = "
                    INSERT INTO dbo.child
                        (child_id, first_name, last_name, chinese_name, dob, gender, joined_date, religion, church, inviter, school, remark)
                    VALUES
                        (@ChildID, @FirstName, @LastName, @ChineseName, @DOB, @Gender, @JoinedDate, @Religion, @Church, @Inviter, @School, @Remark);"
                Using ChildCommand As New SqlCommand(childQuery, connection, transaction)
                    ChildCommand.Parameters.AddWithValue("@ChildID", childID)
                    ChildCommand.Parameters.AddWithValue("@FirstName", Session("FirstName"))
                    ChildCommand.Parameters.AddWithValue("@LastName", Session("LastName"))
                    ChildCommand.Parameters.AddWithValue("@DOB", Session("DateOfBirth"))
                    ChildCommand.Parameters.AddWithValue("@Gender", gender)
                    ChildCommand.Parameters.AddWithValue("@JoinedDate", Session("JoinedDate"))
                    ChildCommand.Parameters.AddWithValue("@Religion", religion)

                    ' Handle NULL or empty Chinese Name safely
                    Dim chineseName As String = TryCast(Session("ChineseName"), String)
                    If String.IsNullOrWhiteSpace(chineseName) Then
                        ChildCommand.Parameters.AddWithValue("@ChineseName", DBNull.Value)
                    Else
                        ChildCommand.Parameters.AddWithValue("@ChineseName", chineseName)
                    End If

                    ' Handle NULL or empty Church safely
                    Dim church As String = TryCast(Session("Church"), String)
                    If String.IsNullOrWhiteSpace(church) Then
                        ChildCommand.Parameters.AddWithValue("@Church", DBNull.Value)
                    Else
                        ChildCommand.Parameters.AddWithValue("@Church", church)
                    End If

                    ' Handle NULL or empty Inviter safely
                    Dim inviter As String = TryCast(Session("Inviter"), String)
                    If String.IsNullOrWhiteSpace(inviter) Then
                        ChildCommand.Parameters.AddWithValue("@Inviter", DBNull.Value)
                    Else
                        ChildCommand.Parameters.AddWithValue("@Inviter", inviter)
                    End If

                    ' Handle NULL or empty School safely
                    Dim school As String = TryCast(Session("School"), String)
                    If String.IsNullOrWhiteSpace(school) Then
                        ChildCommand.Parameters.AddWithValue("@School", DBNull.Value)
                    Else
                        ChildCommand.Parameters.AddWithValue("@School", school)
                    End If

                    ' Handle NULL or empty Country safely
                    Dim remark As String = TryCast(Session("Remark"), String)
                    If String.IsNullOrWhiteSpace(remark) Then
                        ChildCommand.Parameters.AddWithValue("@Remark", DBNull.Value)
                    Else
                        ChildCommand.Parameters.AddWithValue("@Remark", remark)
                    End If

                    ChildCommand.ExecuteNonQuery()
                End Using

                ' commit all inserts then show alert and redirect
                transaction.Commit()
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertRedirect",
    $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("新朋友资料已被添加！")}'); window.location='manage-children.aspx'; }}, 200);", True)

                ' Clear session variables
                Session.Remove("FirstName")
                Session.Remove("LastName")
                Session.Remove("ChineseName")
                Session.Remove("Gender")
                Session.Remove("DateOfBirth")
                Session.Remove("Religion")
                Session.Remove("JoinedDate")
                Session.Remove("Inviter")
                Session.Remove("School")
                Session.Remove("Church")
                Session.Remove("Remark")
            Catch ex As Exception
                ' Safe rollback check
                Try
                    If transaction IsNot Nothing AndAlso transaction.Connection IsNot Nothing Then
                        transaction.Rollback()
                    End If
                Catch
                    ' Ignore rollback failure
                End Try
                '' alert message for technical checking
                'Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
                'ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert",
                '    "alert('Error saving data: " & safeMessage & "');", True)

                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("发生意外错误，请重试或联系管理员。")}'); }}, 100);", True)
            End Try
        End Using
    End Sub
End Class