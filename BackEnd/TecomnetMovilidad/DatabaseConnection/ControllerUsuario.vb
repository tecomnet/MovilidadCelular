Imports Microsoft.VisualBasic.ApplicationServices
Imports Models.TECOMNET

Public Class ControllerUsuario
    Public Function ObtenerUsuarios() As List(Of Usuario)
        Dim controller As New Controller
        Dim lstUsuario As New List(Of Usuario)
        Try
            Dim dt As New DataSet
            'dt = controller.TransactionsUser(Of DataSet)(1, New Usuario)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstUsuario
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    'lstUser.Add(ConvertObject.Users(dr))
                Next
            End If
        Catch ex As Exception
            Return lstUsuario
        End Try
        Return lstUsuario
    End Function
    Public Function ObtenerUsuario(ByVal UsuarioID As Integer) As Usuario
        Dim controller As New Controller
        Dim objUsuario As New Usuario
        objUsuario.UsuarioID = UsuarioID
        Try
            Dim dt As New DataSet
            'dt = controller.TransactionsUser(Of DataSet)(2, objUsuario)

            For Each dr As DataRow In dt.Tables(0).Rows
                'objUsuario = ConvertObject.Users(dr)
            Next
        Catch ex As Exception
            Return objUsuario
        End Try
        Return objUsuario
    End Function
    Public Function AgregarUsuario(ByVal objUsuario As Usuario) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            'exito = controller.TransactionsUser(Of Integer)(3, objUsuario)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function AtualizarUsuario(ByVal objUsuario As Usuario) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            'exito = controller.TransactionsUser(Of Integer)(4, objUsuario)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function DesactivaUsuario(ByVal UsuarioID As Integer) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Dim objUsuario As New Usuario
        objUsuario.UsuarioID = UsuarioID
        objUsuario.fechaBaja = Now
        Try
            'exito = controller.TransactionsUser(Of Integer)(5, objUsuario)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function LoginUsuario(ByVal email As String, ByVal password As String) As Usuario
        Dim controller As New Controller
        Dim objUsuario As New Usuario
        objUsuario.Email = email
        objUsuario.PasswordHash = password
        Try
            Dim dt As New DataSet
            'dt = controller.TransactionsUser(Of DataSet)(6, objUsuario)

            For Each dr As DataRow In dt.Tables(0).Rows
                '   objUser = ConvertObject.Users(dr)
            Next
        Catch ex As Exception
            Return objUsuario
        End Try
        Return objUsuario
    End Function
End Class