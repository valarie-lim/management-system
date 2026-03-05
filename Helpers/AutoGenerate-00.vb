Imports System.Data.SqlClient

Public Class AutoGenerate
    ''' <summary>
    ''' Generate next ID for a table with a prefix and numeric sequence
    ''' </summary>
    ''' <param name="connection">Open SqlConnection</param>
    ''' <param name="tableName">Table to check for existing IDs</param>
    ''' <param name="columnName">ID column name</param>
    ''' <param name="prefix">Prefix for the ID, e.g. "SL-"</param>
    ''' <param name="padLength">Number of digits for numeric part, e.g. 2 → SL-01</param>
    ''' <param name="transaction">Optional SqlTransaction</param>
    ''' <returns>Next ID string</returns>
    Public Shared Function NextID(connection As SqlConnection, tableName As String, columnName As String, prefix As String, Optional padLength As Integer = 2, Optional transaction As SqlTransaction = Nothing) As String
        Dim query As String = $"SELECT MAX({columnName}) FROM {tableName} WHERE {columnName} LIKE @Prefix + '%'"
        Using cmd As New SqlCommand(query, connection, transaction)
            cmd.Parameters.AddWithValue("@Prefix", prefix)
            Dim result As Object = cmd.ExecuteScalar()
            Dim nextNumber As Integer = 1

            If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                Dim currentID As String = result.ToString()
                ' Remove prefix
                Dim numericPart As String = currentID.Replace(prefix, "")
                ' Parse to integer safely
                Dim currentNumber As Integer
                If Integer.TryParse(numericPart, currentNumber) Then
                    nextNumber = currentNumber + 1
                End If
            End If

            ' Return new ID with prefix and padded numeric part
            Return prefix & nextNumber.ToString().PadLeft(padLength, "0"c)
        End Using
    End Function
End Class
