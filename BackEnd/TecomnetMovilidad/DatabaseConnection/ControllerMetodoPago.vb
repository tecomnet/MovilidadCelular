Imports Models.TECOMNET

Public Class ControllerMetodoPago

    Public Function ObtenerMetodoPago() As List(Of MetodoPago)
        Dim controller As New Controller
        Dim lstMetodoPago As New List(Of MetodoPago)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsMetodoPago(Of DataSet)(1, New MetodoPago)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstMetodoPago
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstMetodoPago.Add(ConvertObject.MetodoPago(dr))
                Next
            End If
        Catch ex As Exception
            Return lstMetodoPago
        End Try
        Return lstMetodoPago
    End Function

    Public Function AddMetodoPago(ByVal objMetodoPago As MetodoPago) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsMetodoPago(Of Integer)(2, objMetodoPago)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function

    Public Function UpdateMetodoPago(ByVal objMetodoPago As MetodoPago) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsMetodoPago(Of Integer)(3, objMetodoPago)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function

    Public Function ObtenerMetodoPagoPorID(ByVal MetodoPagoID As Integer) As MetodoPago
        Dim controller As New Controller
        Dim objMetodoPago As New MetodoPago
        objMetodoPago.MetodoPagoID = MetodoPagoID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsMetodoPago(Of DataSet)(4, objMetodoPago)

            For Each dr As DataRow In dt.Tables(0).Rows
                objMetodoPago = ConvertObject.MetodoPago(dr)
            Next
        Catch ex As Exception
            Return objMetodoPago
        End Try
        Return objMetodoPago
    End Function

End Class
