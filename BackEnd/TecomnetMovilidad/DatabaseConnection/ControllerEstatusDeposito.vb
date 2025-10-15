Imports Models.TECOMNET

Public Class ControllerEstatusDeposito

    Public Function ObtenerEstatusDeposito() As List(Of EstatusDeposito)
        Dim controller As New Controller
        Dim lstEstatusDeposito As New List(Of EstatusDeposito)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsEstatusDeposito(Of DataSet)(1, New EstatusDeposito)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstEstatusDeposito
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstEstatusDeposito.Add(ConvertObject.EstatusDeposito(dr))
                Next
            End If
        Catch ex As Exception
            Return lstEstatusDeposito
        End Try
        Return lstEstatusDeposito
    End Function

    Public Function AddEstatusDeposito(ByVal objEstatusDeposito As EstatusDeposito) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsEstatusDeposito(Of Integer)(3, objEstatusDeposito)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
