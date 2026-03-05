Imports System.Data.SqlClient
Imports System.EnterpriseServices

Public Class add_new_person
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsPostBack Then
            Dim othersSelected As Boolean = CblServiceType.Items.FindByText("其他")?.Selected = True
            CheckTxtServiceType.Enabled = othersSelected
        Else
            CblServiceType.DataBind()
            DdlChild.DataBind()
            DdlRelationship.DataBind()
            RblRole.DataBind()

            ' Restore the user input to the field if user return from confirmation page
            ' 1. Personal Details
            If Session("FirstName") IsNot Nothing Then
                TxtFirstName.Text = Session("FirstName").ToString().Trim()
            End If
            If Session("LastName") IsNot Nothing Then
                TxtLastName.Text = Session("LastName").ToString().Trim()
            End If
            If Session("ChineseName") IsNot Nothing Then
                TxtChineseName.Text = Session("ChineseName").ToString().Trim()
            End If
            If Session("ContactNo") IsNot Nothing Then
                TxtContactNo.Text = Session("ContactNo").ToString().Trim()
            End If
            If Session("Email") IsNot Nothing Then
                TxtEmail.Text = Session("Email").ToString().Trim()
            End If
            If Session("Gender") IsNot Nothing Then
                RblGender.SelectedValue = Session("Gender").ToString().Trim()
            End If
            If Session("DateOfBirth") IsNot Nothing Then
                TxtDateOfBirth.Text = Session("DateOfBirth").ToString().Trim()
            End If
            ' 2. Address Input
            If Session("StreetAddress") IsNot Nothing Then
                TxtStreetAddress.Text = Session("StreetAddress").ToString().Trim()
            End If
            If Session("City") IsNot Nothing Then
                TxtCity.Text = Session("City").ToString().Trim()
            End If
            If Session("Postcode") IsNot Nothing Then
                TxtPostcode.Text = Session("Postcode").ToString().Trim()
            End If
            If Session("State") IsNot Nothing Then
                TxtState.Text = Session("State").ToString().Trim()
            End If
            If Session("Country") IsNot Nothing Then
                TxtCountry.Text = Session("Country").ToString().Trim()
            End If
            ' 3. Restore Service Information
            If Session("Role") IsNot Nothing Then
                RblRole.SelectedValue = Session("Role").ToString().Trim()
            End If
            If Session("StartDate") IsNot Nothing Then
                TxtServiceStartDate.Text = Session("StartDate").ToString().Trim()
            End If
            ' 4. Restore Guardian Information
            If Session("ChildName") IsNot Nothing Then
                DdlChild.SelectedValue = Session("ChildID").ToString().Trim()
            End If
            If Session("RelationType") IsNot Nothing Then
                DdlRelationship.SelectedValue = Session("RelationType").ToString().Trim()
            End If
            If Session("Religion") IsNot Nothing Then
                RblReligion.SelectedValue = Session("Religion").ToString().Trim()
            End If
        End If
    End Sub

    ' Restore Service Information-checkbox value
    Protected Sub CblServiceType_DataBound(sender As Object, e As EventArgs) Handles CblServiceType.DataBound
        ' Add "Others" checkbox at the end
        If CblServiceType.Items.FindByText("其他") Is Nothing Then
            CblServiceType.Items.Add(New ListItem("其他", "Others"))
        End If

        ' Restore session values if any
        RestoreCheckBoxListSession(CblServiceType, TxtServiceType, "ServiceType")
    End Sub
    Private Sub RestoreCheckBoxListSession(input As CheckBoxList, txtbox As TextBox, sessionKey As String)
        If Session(sessionKey) IsNot Nothing Then
            Dim selectedValues As String() = Session(sessionKey).ToString().Split(","c)
            Dim otherValues As New List(Of String)

            ' First, ensure "Others" checkbox exists
            Dim otherItem As ListItem = input.Items.FindByText("其他")
            If otherItem Is Nothing Then
                otherItem = New ListItem("其他", "Others")
                input.Items.Add(otherItem)
            End If

            ' Loop through session values
            For Each val As String In selectedValues
                val = val.Trim()
                ' Try to find a ListItem by Value or Text
                Dim item As ListItem = input.Items.Cast(Of ListItem)().FirstOrDefault(Function(i) i.Value = val OrElse i.Text = val)
                If item IsNot Nothing Then
                    item.Selected = True ' Keep original selected item
                Else
                    otherValues.Add(val) ' Not in ListItems -> go to textbox
                End If
            Next

            ' Handle "Others" textbox
            If otherValues.Count > 0 Then
                otherItem.Selected = True
                If txtbox IsNot Nothing Then
                    txtbox.Style("display") = "inline-block"
                    txtbox.Text = String.Join(", ", otherValues)
                End If
            Else
                otherItem.Selected = False
                If txtbox IsNot Nothing Then
                    txtbox.Style("display") = "none"
                    txtbox.Text = ""
                End If
            End If
        Else
            ' No session value then hide textbox
            If txtbox IsNot Nothing Then
                txtbox.Style("display") = "none"
                txtbox.Text = ""
            End If
        End If
    End Sub
    Private Sub ListItem_Others(input As ListControl)
        Dim others As ListItem = input.Items.FindByText("其他")
        If others IsNot Nothing Then
            input.Items.Remove(others)
            input.Items.Add(others)
        End If
    End Sub

    Private Sub BtnConfirm_Click(sender As Object, e As EventArgs) Handles BtnConfirm.Click
        Dim isTeacherSelected As Boolean = CblUserType.Items(0).Selected
        Dim isGuardianSelected As Boolean = CblUserType.Items(1).Selected

        ' guardian validators
        CheckChild.Enabled = isGuardianSelected
        CheckRelationship.Enabled = isGuardianSelected
        CheckReligion.Enabled = isGuardianSelected

        ' teacher validators
        CheckRole.Enabled = isTeacherSelected
        rvserviceStartDate.Enabled = isTeacherSelected
        CheckTxtServiceType.Enabled = isTeacherSelected
        RvTxtServiceStartDate.Enabled = isTeacherSelected

        Page.Validate("RequiredFieldValidate")

        If Page.IsValid Then
            ' Check if adult already exists using the contact number
            Dim NewAdultContact = TxtContactNo.Text.Trim()
            Dim connectionString As String = DbHelper.GetConnectionString()
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Try
                    Dim checkAdult As New SqlCommand("
                        SELECT contact_no
                        FROM person
                        WHERE contact_no=@ContactNo", connection)
                    checkAdult.Parameters.AddWithValue("@ContactNo", NewAdultContact)
                    Dim contactNo = checkAdult.ExecuteScalar()

                    If contactNo Is Nothing Then
                        ' if no contact number is founded, then stored contact into session
                        Session("ContactNo") = NewAdultContact
                    Else
                        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("已有此老师/家长的记录，请查看列表。")}'); }}, 100);", True)
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

            '1. Personal details
            Session("FirstName") = TxtFirstName.Text.Trim()
            Session("LastName") = TxtLastName.Text.Trim()
            Session("ChineseName") = If(String.IsNullOrWhiteSpace(TxtChineseName.Text), Nothing, TxtChineseName.Text.Trim())
            Session("Email") = If(String.IsNullOrWhiteSpace(TxtEmail.Text), Nothing, TxtEmail.Text.Trim())
            Session("Gender") = RblGender.SelectedValue
            Session("DateOfBirth") = If(String.IsNullOrWhiteSpace(TxtDateOfBirth.Text), Nothing, TxtDateOfBirth.Text.Trim())
            '2. Address
            Session("StreetAddress") = TxtStreetAddress.Text.Trim()
            Session("City") = TxtCity.Text.Trim()
            Session("Postcode") = TxtPostcode.Text.Trim()
            Session("State") = TxtState.Text.Trim()
            Session("Country") = TxtCountry.Text.Trim()

            '3. Service details' --- Determine Selected Roles ---
            Dim roles As New List(Of String)
            If CblUserType.Items.FindByText("老师")?.Selected Then
                roles.Add("老师")
                ' Teacher Section
                Session("Role") = RblRole.SelectedValue
                Session("StartDate") = TxtServiceStartDate.Text
                ' Services
                Dim services As New List(Of String)
                For Each item As ListItem In CblServiceType.Items
                    If item.Selected Then
                        If item.Value = "Others" AndAlso Not String.IsNullOrWhiteSpace(TxtServiceType.Text) Then
                            Dim splitted = TxtServiceType.Text.Split({","c, "，"c}, StringSplitOptions.RemoveEmptyEntries)
                            services.AddRange(splitted.Select(Function(s) s.Trim().Trim(ChrW(&H3000))))
                        ElseIf item.Value <> "Others" Then
                            services.Add(item.Text)
                        End If
                    End If
                Next
                Session("ServiceType") = String.Join(", ", services)
            End If

            If CblUserType.Items.FindByText("家长")?.Selected Then
                roles.Add("家长")
                ' Guardian Section
                Session("ChildID") = DdlChild.SelectedValue
                Session("ChildName") = DdlChild.SelectedItem.Text
                Session("RelationType") = DdlRelationship.SelectedValue
                Session("Religion") = RblReligion.SelectedValue
            End If

            ' Redirect to the confirmation page
            Response.Redirect("add-new-person-confirmation.aspx")

        End If
    End Sub

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        ' Clear session variables
        Session.Remove("FirstName")
        Session.Remove("LastName")
        Session.Remove("ChineseName")
        Session.Remove("ContactNo")
        Session.Remove("Email")
        Session.Remove("Gender")
        Session.Remove("DateOfBirth")

        Session.Remove("StreetAddress")
        Session.Remove("City")
        Session.Remove("Postcode")
        Session.Remove("State")
        Session.Remove("Country")

        Session.Remove("Status")
        Session.Remove("Role")
        Session.Remove("StartDate")
        Session.Remove("ServiceType")

        Session.Remove("ChildID")
        Session.Remove("ChildName")
        Session.Remove("RelationType")
        Session.Remove("Religion")
        Response.Redirect("manage-teacher.aspx")
    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_serviceList.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_Children.ConnectionString = DbHelper.GetConnectionString()
    End Sub

    Protected Sub CvUserType_ServerValidate(source As Object, args As ServerValidateEventArgs)
        Dim selectedCount As Integer = CblUserType.Items.Cast(Of ListItem)().Count(Function(i) i.Selected)
        args.IsValid = (selectedCount >= 1 AndAlso selectedCount <= 2)
    End Sub

End Class