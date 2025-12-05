Imports Microsoft.VisualBasic.ApplicationServices
Imports Models.TECOMNET

Public Class ControllerUsuario
    Public Function ObtenerUsuarios() As List(Of Usuario)
        Dim controller As New Controller
        Dim lstUsuario As New List(Of Usuario)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsUsuario(Of DataSet)(1, New Usuario)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstUsuario
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstUsuario.Add(ConvertObject.Usuario(dr))
                Next
            End If
        Catch ex As Exception
        End Try
        Return lstUsuario
    End Function
    Public Function ObtenerUsuario(ByVal UsuarioID As Integer) As Usuario
        Dim controller As New Controller
        Dim objUsuario As New Usuario
        objUsuario.UsuarioID = UsuarioID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsUsuario(Of DataSet)(5, objUsuario)

            For Each dr As DataRow In dt.Tables(0).Rows
                objUsuario = ConvertObject.Usuario(dr)
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
            exito = controller.TransactionsUsuario(Of Integer)(3, objUsuario)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function ActualizarUsuario(ByVal objUsuario As Usuario) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsUsuario(Of Integer)(4, objUsuario)
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
            exito = controller.TransactionsUsuario(Of Integer)(6, objUsuario)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function LoginUsuario(ByVal email As String, ByVal password As String) As Usuario
        Dim controller As New Controller
        Dim objUsuario As Usuario = Nothing
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsUsuario(Of DataSet)(2, New Usuario With {.Email = email, .PasswordHash = password})

            If dt.Tables.Count > 0 AndAlso dt.Tables(0).Rows.Count > 0 Then
                objUsuario = ConvertObject.Usuario(dt.Tables(0).Rows(0))
            End If

        Catch ex As Exception
            ' Puedes registrar el error si quieres
        End Try
        Return objUsuario
    End Function

    Public Function ObtenerUsuarioPorEmail(ByVal email As String) As Usuario
        Dim controller As New Controller
        Dim objUsuario As New Usuario
        objUsuario.Email = email
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsUsuario(Of DataSet)(8, objUsuario)

            For Each dr As DataRow In dt.Tables(0).Rows
                objUsuario = ConvertObject.Usuario(dr)
            Next
        Catch ex As Exception
            Return objUsuario
        End Try
        Return objUsuario
    End Function
End Class