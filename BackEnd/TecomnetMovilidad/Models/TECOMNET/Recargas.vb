Imports Models.TECOMNET.Enumeraciones
Namespace TECOMNET
    Public Class Recargas
        Public Property RecargaID As Integer
        Public Property OfertaID As Integer
        Public Property SIMID As Integer
        Public Property ClienteId As Integer
        Public Property FechaCompra As DateTime
        Public Property Monto As Decimal
        Public Property MetodoPago As MetodoPago
        Public Property InvoiceRequired As Boolean
        Public Property OrdenID As Integer?
        Public Property FacturaID As Integer?
        Public Property DepositoID As Integer?
        Public Property Referencia As String
    End Class
End Namespace