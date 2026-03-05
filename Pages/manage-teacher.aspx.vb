Imports System.Data.SqlClient

Public Class manage_teacher
    Inherits System.Web.UI.Page


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ddlSearchActive.Items.Clear()
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("全部", "All"))
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("活跃", "Active"))
            ddlSearchActive.Items.Add(New System.Web.UI.WebControls.ListItem("已归档", "Archived"))
            ddlSearchActive.SelectedValue = "All"
        End If
    End Sub

    Protected Sub ddlSearchActive_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlSearchActive.SelectedIndexChanged
        GridView_Teacher.DataBind()
    End Sub

    Protected Sub GridView_Teacher_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles GridView_Teacher.RowCommand
        Dim staffId As String = e.CommandArgument.ToString()
        Dim connectionString As String = DbHelper.GetConnectionString()

        ' ===========================================================
        ' 1. ARCHIVE / UNARCHIVE TEACHER
        ' ===========================================================
        If e.CommandName = "ArchiveTeacher" Then
            Using connection As New SqlConnection(connectionString)
                connection.Open()

                Dim updateSql As String = "
                UPDATE staff
                SET status = CASE WHEN status = 'Active' THEN 'Archived' ELSE 'Active' END
                WHERE staff_id = @staff_id
            "

                Using cmd As New SqlCommand(updateSql, connection)
                    cmd.Parameters.AddWithValue("@staff_id", staffId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("老师状态已更新。")}'); }}, 100);", True)

        End If

        ' ===========================================================
        ' 2. SET / UNSET GUARDIAN FLAG
        ' ===========================================================

        If e.CommandName = "ToggleGuardian" Then
            HiddenStaffID.Value = staffId

            ' Open Bootstrap modal
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "OpenGuardianPopup",
                "var myModal = new bootstrap.Modal(document.getElementById('GuardianModal')); myModal.show();", True)
        End If

        GridView_Teacher.DataBind()
    End Sub

    Protected Sub BtnSaveGuardian_Click(sender As Object, e As EventArgs) Handles BtnSaveGuardian.Click
        Dim staffId As String = HiddenStaffID.Value
        Dim childId As String = DdlChild.SelectedValue
        Dim relationship As String = DdlRelationship.SelectedValue
        Dim religion As String = DdlReligion.SelectedValue

        If staffId = "" Or childId = "" Or relationship = "" Or religion = "" Then

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("请选择孩子和关系。")}'); }}, 100);", True)

            ' Keep modal open if validation fails
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "KeepModalOpen",
                "var myModal = new bootstrap.Modal(document.getElementById('GuardianModal')); myModal.show();", True)
            Return
        End If

        Dim connectionString As String = DbHelper.GetConnectionString()
        Using connection As New SqlConnection(connectionString)
            connection.Open()

            Dim guardianID As String = IDGenerator.NextID(connection, "guardian", "guardian_id", "GU-")
            Dim relationshipID As String = IDGenerator.NextID(connection, "relationship", "relationship_id", "RE-")

            Dim transaction As SqlTransaction = connection.BeginTransaction()

            Try
                ' ★★ STEP 1 — Use staff_id → Get person_id ★★
                Dim personID As String = ""
                Dim getPersonSql As String = "SELECT person_id FROM staff WHERE staff_id = @staff_id"
                Using getPersonCmd As New SqlCommand(getPersonSql, connection, transaction)
                    getPersonCmd.Parameters.AddWithValue("@staff_id", staffId)
                    Dim result = getPersonCmd.ExecuteScalar()

                    If result IsNot Nothing Then
                        personID = result.ToString()
                    Else
                        Throw New Exception("Staff has no matching person_id.")
                    End If
                End Using

                ' ★★ STEP 2 — Insert guardian table ★★
                Dim guardianQuery As String = "
                INSERT INTO guardian (guardian_id, person_id, religion)
                VALUES (@GuardianID, @PID, @Religion);"

                Using GuardianCommand As New SqlCommand(guardianQuery, connection, transaction)
                    GuardianCommand.Parameters.AddWithValue("@GuardianID", guardianID)
                    GuardianCommand.Parameters.AddWithValue("@PID", personID)
                    GuardianCommand.Parameters.AddWithValue("@Religion", religion)
                    GuardianCommand.ExecuteNonQuery()
                End Using

                ' ★★ STEP 3 — Insert relationship table ★★
                Dim relationshipQuery As String = "
                INSERT INTO relationship (relationship_id, guardian_id, child_id, relation_type)
                VALUES (@RelationshipID, @GuardianID, @ChildID, @RelationType);"

                Using RelationshipCommand As New SqlCommand(relationshipQuery, connection, transaction)
                    RelationshipCommand.Parameters.AddWithValue("@RelationshipID", relationshipID)
                    RelationshipCommand.Parameters.AddWithValue("@GuardianID", guardianID)
                    RelationshipCommand.Parameters.AddWithValue("@ChildID", childId)
                    RelationshipCommand.Parameters.AddWithValue("@RelationType", relationship)
                    RelationshipCommand.ExecuteNonQuery()
                End Using
                transaction.Commit()

                ' Success alert and hide modal
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "SaveComplete",
                    "alert('监护人已成功设置。');" &
                    "var myModalEl = document.getElementById('GuardianModal');" &
                    "var modal = bootstrap.Modal.getInstance(myModalEl);" &
                    "if(modal){modal.hide();}", True)

            Catch ex As Exception
                Try
                    If transaction IsNot Nothing AndAlso transaction.Connection IsNot Nothing Then
                        transaction.Rollback()
                    End If
                Catch
                End Try

                '' alert message for technical checking
                'Dim safeMessage As String = HttpUtility.JavaScriptStringEncode(ex.Message)
                'ClientScript.RegisterStartupScript(Me.GetType(), "errorAlert", "alert('Error saving data: " & safeMessage & "');", True)


                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertError",
                    "alert('系统出现异常，请重试或联系技术人员协助处理。');" &
                    "var myModal = new bootstrap.Modal(document.getElementById('GuardianModal')); myModal.show();", True)
            End Try

            GridView_Teacher.DataBind()
        End Using

    End Sub

    Protected Sub Page_Init(sender As Object, e As EventArgs) Handles Me.Init
        SqlDataSource_Children.ConnectionString = DbHelper.GetConnectionString()
        SqlDataSource_editUserInfo.ConnectionString = DbHelper.GetConnectionString()
    End Sub

End Class