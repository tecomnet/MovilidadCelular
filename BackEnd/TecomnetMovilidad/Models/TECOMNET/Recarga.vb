Imports Models.TECOMNET.Enumeraciones

Namespace TECOMNET
    Public Class Recarga
        Public Property RecargaId As Integer
        Public Property FechaRecarga As DateTime
        Public Property ICCID As String
        Public Property ClienteID As Integer
        Public Property OferID As Integer
        Public Property Total As Double
        Public Property MetodoPagoID As Integer
        Public Property OrderID As String
        Public Property DistribuidorID As Integer
        Public Property EstatusPagoDistribuidorID As Integer
        Public Property FechaPagoDistribuidor As DateTime?
        Public Property Comision As Double
        Public Property Impuesto As Double
        Public Property DepositoID As Integer?
        Public Property RequiereFacturaCliente As Boolean
        Public Property InvoiceID As Integer?
    End Class
End Namespace