Imports System.Data.SqlClient

Public Class add_new_material
    Inherits System.Web.UI.Page

    Private Sub BtnCancel_Click(sender As Object, e As EventArgs) Handles BtnCancel.Click
        Response.Redirect("manage-materials.aspx")
    End Sub

    Private Sub BtnInsert_Click(sender As Object, e As EventArgs) Handles BtnInsert.Click
        If Page.IsValid Then
            Dim title As String = TxtMaterialTitle.Text.Trim()
            Dim chapter As String = TxtMaterialChapter.Text.Trim()
        Dim year As String = TxtPublishedYear.Text.Trim()
        Dim remark As String = TxtRemark.Text.Trim()
        Dim connectionString As String = DbHelper.GetConnectionString()
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                Dim materialID As String = IDGenerator.NextID(connection, "material", "material_id", "MA-", 5)
                Dim transaction As SqlTransaction = connection.BeginTransaction()
                Try
                    ' Check duplicate material title
                    Dim checkQuery As String = "
                SELECT COUNT(*)
                FROM dbo.material
                WHERE book_title = @Title AND book_chapter = @Chapter
                "
                    Using checkCommand As New SqlCommand(checkQuery, connection, transaction)
                        checkCommand.Parameters.AddWithValue("@Title", title)
                        checkCommand.Parameters.AddWithValue("@Chapter", chapter)

                        Dim count As Integer = Convert.ToInt32(checkCommand.ExecuteScalar())
                        If count > 0 Then
                            transaction.Rollback()
                            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alertMessage",
                                                    $"setTimeout(function() {{ showAlert('{HttpUtility.JavaScriptStringEncode("材料已经在系统里!")}'); }}, 100);", True)
                            Exit Sub
                        End If
                    End Using
                    ' Insert into material Table
                    Dim materialQuery As String = "
                    INSERT INTO dbo.material
                        (material_id, book_title, book_chapter, published_year, remark)
                    VALUES
                        (@materialID, @Title, @Chapter, @PublishedYear, @Remark);"
                    Using InsertCommand As New SqlCommand(materialQuery, connection, transaction)
                        InsertCommand.Parameters.AddWithValue("@materialID", materialID)
                        InsertCommand.Parameters.AddWithValue("@Title", title)
                        ' Handle NULL or empty chapter safely
                        If String.IsNullOrWhiteSpace(chapter) Then
                            InsertCommand.Parameters.AddWithValue("@Chapter", DBNull.Value)
                        Else
                            InsertCommand.Parameters.AddWithValue("@Chapter", chapter)
                        End If
                        ' Handle NULL or empty published year safely
                        If String.IsNullOrWhiteSpace(year) Then
                            InsertCommand.Parameters.AddWithValue("@PublishedYear", DBNull.Value)
                        Else
                            InsertCommand.Parameters.AddWithValue("@PublishedYear", year)
                        End If
                        ' Handle NULL or empty remark safely
                        If String.IsNullOrWhiteSpace(remark) Then
                            InsertCommand.Parameters.AddWithValue("@Remark", DBNull.Value)
                        Else
                            InsertCommand.Parameters.AddWithValue("@Remark", remark)
                        End If
                        InsertCommand.ExecuteNonQuery()
                    End Using
                    transaction.Commit()

                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "successMsg",
                        $"setTimeout(function() {{
                            showAlert('{HttpUtility.JavaScriptStringEncode("材料输入成功！")}', function() {{
                                window.location='manage-materials.aspx';
                            }});
                        }}, 200);", True)

                    ' clear the field and redirect after transaction successful.
                    TxtMaterialTitle.Text = ""
                    TxtMaterialChapter.Text = ""
                    TxtPublishedYear.Text = ""
                    TxtRemark.Text = ""

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
        End If
    End Sub
End Class