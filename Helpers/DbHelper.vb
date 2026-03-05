Imports System.Configuration
Imports System.Data.SqlClient
Imports Microsoft.SqlServer

Public Module DbHelper

    '''' <summary>
    '''' Get the SQL Server connection string.
    '''' </summary>
    '''' <param name="useLocal">If True, use the local development database. Otherwise, use the hosted database.</param>
    '''' <returns>Connection string to use.</returns>
    'Public Function GetConnectionString(Optional useLocal As Boolean = False) As String
    '    If useLocal Then
    '        ' Local development connection string
    '        Return "Server=VLYH\SQLEXPRESS;" &
    '               "Database=SundaySchDB;" &
    '               "Trusted_Connection=True;" &
    '               "TrustServerCertificate=True;"
    '    Else
    '        ' Hosted database connection string
    '        Dim dbPassword As String = Environment.GetEnvironmentVariable("DB_PASSWORD")

    '        If String.IsNullOrEmpty(dbPassword) Then
    '            Throw New InvalidOperationException("Environment variable 'DB_PASSWORD' is not set. Please configure it on your server.")
    '        End If

    '        ' Build the connection string securely without storing the password in web.config
    '        Dim hostConn As String = "Data Source=db34200.public.databaseasp.net;" &
    '                                 "Initial Catalog=db34200;" &
    '                                 "User Id=db34200;" &
    '                                 $"Password={dbPassword};"
    '        Return hostConn
    '    End If
    'End Function

    '''' <summary>
    '''' Test the database connection.
    '''' </summary>
    '''' <param name="useLocal"></param>
    'Public Sub TestConnection(Optional useLocal As Boolean = False)
    '    Using conn As New SqlConnection(GetConnectionString(useLocal))
    '        Try
    '            conn.Open()
    '            Console.WriteLine("Connection successful!")
    '        Catch ex As Exception
    '            Console.WriteLine($"Connection failed: {ex.Message}")
    '            Throw
    '        End Try
    '    End Using
    'End Sub





    ''' <summary>
    ''' Always return the local SQL Server connection string.
    ''' </summary>
    Public Function GetConnectionString() As String
        Return "Server=VLYH\SQLEXPRESS;" &
               "Database=SundaySchDB;" &
               "Trusted_Connection=True;" &
               "TrustServerCertificate=True;"
    End Function

    ''' <summary>
    ''' Test the database connection.
    ''' </summary>
    Public Sub TestConnection()
        Using conn As New SqlConnection(GetConnectionString())
            Try
                conn.Open()
                Console.WriteLine("Connection successful!")
            Catch ex As Exception
                Console.WriteLine($"Connection failed: {ex.Message}")
                Throw
            End Try
        End Using
    End Sub

End Module
