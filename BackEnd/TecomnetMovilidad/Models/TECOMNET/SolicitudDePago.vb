Namespace TECOMNET
    Public Class SolicitudDePago
        Public Property SolicitudID As Integer
        Public Property OrderID As String
        Public Property MetodoPagoID As Integer
        Public Property OfertaIDActual As Integer
        Public Property OfertaIDNueva As Integer
        Public Property Monto As Double
        Public Property ICCID As String
        Public Property MSISDN As String
        Public Property Estatus As String
        Public Property FechaCreacion As DateTime
        Public Property EstatusDepositoID As Integer
        Public Property IdTransaction As String
        Public Property AuthNumber As String
        Public Property AuthCode As String
        Public Property Reason As String
        Public Property PagoDepositoID As Integer?
        Public Property UltimaActualizacion As DateTime
        Public Property NumeroReintentos As Integer
        Public Property DistribuidorID As Integer
        Public Sub New()
            Me.SolicitudID = 0
            Me.OrderID = String.Empty
            Me.OfertaIDActual = 0
            Me.OfertaIDNueva = 0
            Me.Monto = 0
            Me.MetodoPagoID = 1
            Me.ICCID = String.Empty
            Me.MSISDN = String.Empty
            Me.Estatus = "Created"
            Me.FechaCreacion = Now
            Me.EstatusDepositoID = 1
            Me.IdTransaction = String.Empty
            Me.AuthNumber = String.Empty
            Me.AuthCode = String.Empty
            Me.Reason = String.Empty
            Me.PagoDepositoID = Nothing
            Me.UltimaActualizacion = Now
            Me.NumeroReintentos = 0
            Me.DistribuidorID = 0
        End Sub
    End Class
End Namespace