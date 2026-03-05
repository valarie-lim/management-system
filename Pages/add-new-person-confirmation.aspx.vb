Imports System.Data.SqlClient
Imports System.Drawing

Public Class add_new_person_confirmation
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
        End If

        ' Retrieve user inputs that were stored in Session variables
        '1. Personal Details
        InputFirstName.Text = Session("FirstName")
        InputLastName.Text = Session("LastName")
        InputChineseName.Text = Session("ChineseName")
        InputContactNo.Text = Session("ContactNo")
        InputEmail.Text = Session("Email")
        InputGender.Text = Session("Gender")
        InputDateOfBirth.Text = Session("DateOfBirth")
        '2. Address
        InputStreetAddress.Text = Session("StreetAddress")
        InputCity.Text = Session("City")
        InputPostcode.Text = Session("Postcode")
        InputState.Text = Session("State")
        InputCountry.Text = Session("Country")
        '3. Service Information
        InputRole.Text = Session("Role")
        InputService.Text = Session("ServiceType")
        InputStartDate.Text = Session("StartDate")
        '4. Guardian Information
        InputChildName.Text = Session("ChildName")
        InputRelationship.Text = Session("RelationType")
        InputReligion.Text = Session("Religion")
    End Sub

    Private Sub BtnReturn_Click(sender As Object, e As EventArgs) Handles BtnReturn.Click
        Response.Redirect("add-new-person.aspx")
    End Sub

    Private Sub BtnSubmit_Click(sender As Object, e As EventArgs) Handles BtnSubmit.Click
        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()
            Dim addressID As String = IDGenerator.NextID(connection, "address", "address_id", "AD-")
            Dim personID As String = IDGenerator.NextID(connection, "person", "person_id", "P")
            Dim staffID As String = IDGenerator.NextID(connection, "staff", "staff_id", "S")
            Dim guardianID As String = IDGenerator.NextID(connection, "guardian", "guardian_id", "GU-")
            Dim relationshipID As String = IDGenerator.NextID(connection, "relationship", "relationship_id", "RE-")

            Dim transaction As SqlTransaction = connection.BeginTransaction()
            ' Database transaction error handling
            Try
                ' 1. Insert into address Table
                Dim addressQuery As String = "
                    INSERT INTO dbo.address
                        (address_id, street_address, city, postcode, state_province, country)
                    VALUES
                        (@AddressID, @StreetAddress, @City, @Postcode, @State, @Country);"
                Using AddressCommand As New SqlCommand(addressQuery, connection, transaction)
                    AddressCommand.Parameters.AddWithValue("@AddressID", addressID)

                    ' Handle NULL or empty Street Address safely
                    Dim streetAddress As String = TryCast(Session("StreetAddress"), String)
                    If String.IsNullOrWhiteSpace(streetAddress) Then
                        AddressCommand.Parameters.AddWithValue("@StreetAddress", DBNull.Value)
                    Else
                        AddressCommand.Parameters.AddWithValue("@StreetAddress", streetAddress)
                    End If

                    ' Handle NULL or empty City safely
                    Dim city As String = TryCast(Session("City"), String)
                    If String.IsNullOrWhiteSpace(city) Then
                        AddressCommand.Parameters.AddWithValue("@City", DBNull.Value)
                    Else
                        AddressCommand.Parameters.AddWithValue("@City", city)
                    End If

                    ' Handle NULL or empty Postcode safely
                    Dim postcode As String = TryCast(Session("Postcode"), String)
                    If String.IsNullOrWhiteSpace(postcode) Then
                        AddressCommand.Parameters.AddWithValue("@Postcode", DBNull.Value)
                    Else
                        AddressCommand.Parameters.AddWithValue("@Postcode", postcode)
                    End If

                    ' Handle NULL or empty State safely
                    Dim state As String = TryCast(Session("State"), String)
                    If String.IsNullOrWhiteSpace(state) Then
                        AddressCommand.Parameters.AddWithValue("@State", DBNull.Value)
                    Else
                        AddressCommand.Parameters.AddWithValue("@State", state)
                    End If

                    ' Handle NULL or empty Country safely
                    Dim country As String = TryCast(Session("Country"), String)
                    If String.IsNullOrWhiteSpace(country) Then
                        AddressCommand.Parameters.AddWithValue("@Country", DBNull.Value)
                    Else
                        AddressCommand.Parameters.AddWithValue("@Country", country)
                    End If

                    AddressCommand.ExecuteNonQuery()
                End Using

                ' 2. Insert into person Table

                Dim personQuery As String = "
                    INSERT INTO dbo.person
                        (person_id, first_name, last_name, chinese_name, contact_no, gender, dob, address_id)
                    VALUES
                        (@PID, @FirstName, @LastName, @ChineseName, @ContactNo, @Gender, @DateOfBirth, @AddressID);"
                Using PersonCommand As New SqlCommand(personQuery, connection, transaction)
                    PersonCommand.Parameters.AddWithValue("@PID", personID)
                    PersonCommand.Parameters.AddWithValue("@FirstName", Session("FirstName"))
                    PersonCommand.Parameters.AddWithValue("@LastName", Session("LastName"))
                    ' Handle NULL or empty Chinese Name safely
                    Dim chineseName As String = TryCast(Session("ChineseName"), String)
                    If String.IsNullOrWhiteSpace(chineseName) Then
                        PersonCommand.Parameters.AddWithValue("@ChineseName", DBNull.Value)
                    Else
                        PersonCommand.Parameters.AddWithValue("@ChineseName", chineseName)
                    End If
                    PersonCommand.Parameters.AddWithValue("@ContactNo", Session("ContactNo"))

                    Dim gender As String = ""
                    If Session("Gender") IsNot Nothing Then
                        Select Case Session("Gender").ToString()
                            Case "男"
                                gender = "1"
                            Case "女"
                                gender = "2"
                        End Select
                    End If
                    PersonCommand.Parameters.AddWithValue("@Gender", gender)

                    Dim dob As Object = Session("DateOfBirth")
                    If dob Is Nothing OrElse String.IsNullOrWhiteSpace(dob.ToString()) Then
                        PersonCommand.Parameters.AddWithValue("@DateOfBirth", DBNull.Value)
                    Else
                        PersonCommand.Parameters.AddWithValue("@DateOfBirth", Convert.ToDateTime(dob))
                    End If

                    PersonCommand.Parameters.AddWithValue("@AddressID", addressID)
                    PersonCommand.ExecuteNonQuery()
                End Using


                ' === 3 & 4. Insert into staff + service + serviceList Tables ===
                If Session("Role") IsNot Nothing AndAlso
                   Not String.IsNullOrWhiteSpace(Session("Role").ToString()) Then

                    ' 3. Insert into staff Table
                    Dim staffQuery As String = "
                    INSERT INTO dbo.staff
                        (staff_id, person_id, email, role)
                    VALUES
                        (@StaffID, @PID, @Email, @Role);"
                    Using StaffCommand As New SqlCommand(staffQuery, connection, transaction)
                        StaffCommand.Parameters.AddWithValue("@StaffID", staffID)
                        StaffCommand.Parameters.AddWithValue("@PID", personID)
                        ' Handle NULL or empty Street Address safely
                        Dim email As String = TryCast(Session("Email"), String)
                        If String.IsNullOrWhiteSpace(email) Then
                            StaffCommand.Parameters.AddWithValue("@Email", DBNull.Value)
                        Else
                            StaffCommand.Parameters.AddWithValue("@Email", email)
                        End If
                        StaffCommand.Parameters.AddWithValue("@Role", Session("Role"))
                        StaffCommand.ExecuteNonQuery()
                    End Using

                    ' 4. Insert into service Table using serviceList_id
                    If Session("ServiceType") IsNot Nothing Then
                        Dim serviceTypes As String() = Session("ServiceType").ToString().Split(","c)

                        Dim serviceQuery As String = "
                            INSERT INTO dbo.service
                                (service_id, staff_id, serviceList_id, start_date)
                            VALUES
                                (@ServiceID, @StaffID, @ServiceListID, @StartDate);"

                        For Each serviceType As String In serviceTypes
                            Dim serviceID As String = IDGenerator.NextID(connection, "service", "service_id", "SE-", 5, transaction)

                            ' Get or create serviceList_id (uses new AutoGenerate class with 2-digit ID)
                            Dim serviceListID As String = GetOrCreateServiceListID(connection, transaction, serviceType.Trim())

                            Using serviceCmd As New SqlCommand(serviceQuery, connection, transaction)
                                serviceCmd.Parameters.AddWithValue("@ServiceID", serviceID)
                                serviceCmd.Parameters.AddWithValue("@StaffID", staffID)
                                serviceCmd.Parameters.AddWithValue("@ServiceListID", serviceListID)

                                ' Use Session("StartDate") if set, otherwise default to current date
                                Dim startDate As Object = Session("StartDate")
                                If startDate Is Nothing OrElse String.IsNullOrWhiteSpace(startDate.ToString()) Then
                                    serviceCmd.Parameters.AddWithValue("@StartDate", DateTime.Now)
                                Else
                                    serviceCmd.Parameters.AddWithValue("@StartDate", Convert.ToDateTime(startDate))
                                End If

                                serviceCmd.ExecuteNonQuery()
                            End Using
                        Next
                    End If
                End If


                ' === 5 & 6. Insert into guardian + relationship Tables ===
                If Session("Religion") IsNot Nothing AndAlso
                   Not String.IsNullOrWhiteSpace(Session("Religion").ToString()) Then
                    ' 5. Insert into guardian Table
                    Dim religion As String
                    Select Case Session("Religion").ToString()
                        Case "基督徒"
                            religion = "1"
                        Case "非基督徒"
                            religion = "0"
                        Case Else
                            religion = ""
                    End Select

                    Dim guardianQuery As String = "
                    INSERT INTO dbo.guardian
                        (guardian_id, person_id, religion)
                    VALUES
                        (@GuardianID, @PID, @Religion);"
                Using GuardianCommand As New SqlCommand(guardianQuery, connection, transaction)
                    GuardianCommand.Parameters.AddWithValue("@GuardianID", guardianID)
                    GuardianCommand.Parameters.AddWithValue("@PID", personID)
                    GuardianCommand.Parameters.AddWithValue("@Religion", religion)
                    GuardianCommand.ExecuteNonQuery()
                    End Using

                    ' --- Insert into relationship Table (only if child info exists) ---
                    If Session("ChildID") IsNot Nothing AndAlso
                        Not String.IsNullOrWhiteSpace(Session("ChildID").ToString()) Then

                        ' 6. Insert into relationship Table
                        Dim relationshipQuery As String = "
                    INSERT INTO dbo.relationship
                        (relationship_id, guardian_id, child_id, relation_type)
                    VALUES
                        (@RelationshipID, @GuardianID, @ChildID, @RelationType);"
                        Using GuardianCommand As New SqlCommand(relationshipQuery, connection, transaction)
                            GuardianCommand.Parameters.AddWithValue("@RelationshipID", relationshipID)
                            GuardianCommand.Parameters.AddWithValue("@GuardianID", guardianID)
                            GuardianCommand.Parameters.AddWithValue("@ChildID", Session("ChildID"))
                            GuardianCommand.Parameters.AddWithValue("@RelationType", Session("RelationType"))
                            GuardianCommand.ExecuteNonQuery()
                        End Using
                    End If
                End If

                ' Commit all inserts
                transaction.Commit()

                ' Alert then redirect
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertRedirect",
    $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("新老师/家长已添加。")}'); window.location='admin-dashboard.aspx'; }}, 300);", True)

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

                Session.Remove("Role")
                Session.Remove("StartDate")
                Session.Remove("ServiceType")

                Session.Remove("ChildID")
                Session.Remove("ChildName")
                Session.Remove("RelationType")
                Session.Remove("Religion")
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
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("发生意外错误。请重试或联系技术支持。")}'); }}, 100);", True)
            End Try
        End Using
    End Sub

    Private Function GetOrCreateServiceListID(connection As SqlConnection, transaction As SqlTransaction, serviceType As String) As String
        ' Check if service_type already exists
        Dim selectQuery As String = "SELECT serviceList_id FROM dbo.serviceList WHERE service_type = @ServiceType"
        Using selectCmd As New SqlCommand(selectQuery, connection, transaction)
            selectCmd.Parameters.AddWithValue("@ServiceType", serviceType)
            Dim result As Object = selectCmd.ExecuteScalar()
            If result IsNot Nothing Then
                Return result.ToString() ' Return existing ID
            End If
        End Using

        ' If not exists, insert new serviceList record with 2-digit ID
        Dim newServiceListID As String = AutoGenerate.NextID(connection, "serviceList", "serviceList_id", "SL-", 2, transaction)
        Dim insertQuery As String = "INSERT INTO dbo.serviceList (serviceList_id, service_type) VALUES (@ServiceListID, @ServiceType)"
        Using insertCmd As New SqlCommand(insertQuery, connection, transaction)
            insertCmd.Parameters.AddWithValue("@ServiceListID", newServiceListID)
            insertCmd.Parameters.AddWithValue("@ServiceType", serviceType)
            insertCmd.ExecuteNonQuery()
        End Using

        Return newServiceListID
    End Function

End Class