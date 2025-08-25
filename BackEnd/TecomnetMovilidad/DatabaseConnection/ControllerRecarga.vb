Imports System.Runtime.ConstrainedExecution
Imports Models.TECOMNET

Public Class ControllerRecarga
    Public Function ObtenRecargas() As List(Of Recarga)
        Dim controller As New Controller
        Dim lstRecarga As New List(Of Recarga)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsRecarga(Of DataSet)(1, New Recarga)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstRecarga
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstRecarga.Add(ConvertObject.Recarga(dr))
                Next
            End If
        Catch ex As Exception
            Return lstRecarga
        End Try
        Return lstRecarga
    End Function
    Public Function ObtenRecarga(RecargaID As Integer) As Recarga
        Dim controller As New Controller
        Dim objRecarga As New Recarga
        objRecarga.RecargaId = RecargaID

        Try
            Dim dt As New DataSet
            dt = controller.TransactionsRecarga(Of DataSet)(2, objRecarga)

            If dt.Tables(0).Rows.Count = 0 Then
                Return New Recarga
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    objRecarga = ConvertObject.Recarga(dr)
                Next
            End If
        Catch ex As Exception
            Return objRecarga
        End Try
        Return objRecarga
    End Function
    Public Function AgregarRecarga(ByVal objRecarga As Recarga) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsRecarga(Of Integer)(3, objRecarga)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    Public Function ObtenRecargasPorCliente(ClienteID As Integer) As List(Of VisRecarga)
        Dim controller As New Controller
        Dim lstRecarga As New List(Of VisRecarga)
        Dim objRecarga As New VisRecarga
        objRecarga.ClienteID = ClienteID

        Try
            Dim dt As New DataSet
            dt = controller.TransactionsRecarga(Of DataSet)(4, objRecarga)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstRecarga
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstRecarga.Add(ConvertObject.VisRecarga(dr))
                Next
            End If
        Catch ex As Exception
            Return lstRecarga
        End Try
        Return lstRecarga
    End Function
End Class
