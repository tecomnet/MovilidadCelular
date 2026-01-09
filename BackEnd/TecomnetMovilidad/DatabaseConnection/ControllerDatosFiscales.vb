Imports Models
Imports Models.TECOMNET

Public Class ControllerDatosFiscales

    Public Function AddDatosFiscales(ByVal objDatosFiscales As DatosFiscales) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsDatosFiscales(Of Integer)(1, objDatosFiscales)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function

    Public Function ObtenerDatosFiscalesPorClienteID(ByVal ClienteId As Integer) As DatosFiscales
        Dim controller As New Controller
        Dim objClienteId As DatosFiscales = Nothing

        Try
            Dim filtro As New DatosFiscales
            filtro.ClienteId = ClienteId

            Dim ds As DataSet = controller.TransactionsDatosFiscales(Of DataSet)(2, filtro)

            If ds IsNot Nothing AndAlso
           ds.Tables.Count > 0 AndAlso
           ds.Tables(0).Rows.Count > 0 Then

                objClienteId = ConvertObject.DatosFiscales(ds.Tables(0).Rows(0))
            End If

        Catch ex As Exception
            Throw
        End Try

        Return objClienteId
    End Function


    Public Function UpdateDatosFiscales(ByVal objDatosFiscales As DatosFiscales) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsDatosFiscales(Of Integer)(3, objDatosFiscales)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
