Imports Models
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones

Public Class ControllerSolicitudDePago
    Public Function ObtenerSolicitudes() As List(Of SolicitudDePago)
        Dim controller As New Controller
        Dim lstSolicitudDePago As New List(Of SolicitudDePago)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSolicitudDePago(Of DataSet)(1, New SolicitudDePago)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstSolicitudDePago
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstSolicitudDePago.Add(ConvertObject.SolicitudDePago(dr))
                Next
            End If
        Catch ex As Exception
            Return lstSolicitudDePago
        End Try
        Return lstSolicitudDePago
    End Function
    Public Function ObtenerSolicitud(OrderID As String) As SolicitudDePago
        Dim controller As New Controller
        Dim objSolicitudDePago As New SolicitudDePago
        objSolicitudDePago.OrderID = OrderID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSolicitudDePago(Of DataSet)(2, objSolicitudDePago)
            objSolicitudDePago.SolicitudID = 0
            For Each dr As DataRow In dt.Tables(0).Rows
                objSolicitudDePago = ConvertObject.SolicitudDePago(dr)
            Next
        Catch ex As Exception
            Return objSolicitudDePago
        End Try
        Return objSolicitudDePago
    End Function
    Public Function AgregaSolicitudDePago(ByVal objSolicitudDePago As SolicitudDePago) As SolicitudDePago
        Dim controller As New Controller
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSolicitudDePago(Of DataSet)(3, objSolicitudDePago)

            If dt.Tables(0).Rows.Count = 0 Then
                objSolicitudDePago.SolicitudID = 0
                Return objSolicitudDePago
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    objSolicitudDePago = ConvertObject.SolicitudDePago(dr)
                Next
            End If
        Catch ex As Exception
            Return objSolicitudDePago
        End Try
        Return objSolicitudDePago
    End Function
    Public Function ActualizaSolicitudDePago(ByVal objSolicitudDePago As SolicitudDePago) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsSolicitudDePago(Of Integer)(4, objSolicitudDePago)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function

End Class