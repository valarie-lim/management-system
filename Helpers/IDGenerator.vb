Imports System.Data.SqlClient

Public Class IDGenerator

    Public Shared Function NextID(connection As SqlConnection, tableName As String, columnName As String, prefix As String, Optional digits As Integer = 5, Optional transaction As SqlTransaction = Nothing) As String
        Dim newID As String = prefix & "00001"

        Dim query As String = $"SELECT TOP 1 {columnName} FROM {tableName} ORDER BY {columnName} DESC"

        Using cmd As New SqlCommand(query, connection, transaction)
            Dim result As Object = cmd.ExecuteScalar()

            If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                Dim lastID As String = result.ToString().Trim()
                Dim numPart As Integer
                If Integer.TryParse(lastID.Replace(prefix, "").Trim(), numPart) Then
                    numPart += 1
                    newID = prefix & numPart.ToString("D" & digits)
                End If
            End If
        End Using

        Return newID
    End Function

End Class
