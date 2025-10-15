Imports Models.TECOMNET

Public Class ControllerEstatusDeposito


    Public Function GetEstatusDeposito() As List(Of EstatusDeposito)
        Dim controller As New Controller
        Dim lista As New List(Of EstatusDeposito)

        Try
            Dim ds As DataSet = controller.TransactionsEstatusDeposito(Of DataSet)(1, New EstatusDeposito)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                For Each row As DataRow In ds.Tables(0).Rows
                    lista.Add(ConvertObject.EstatusDeposito(row))
                Next
            End If
        Catch ex As Exception

        End Try

        Return lista
    End Function
End Class
