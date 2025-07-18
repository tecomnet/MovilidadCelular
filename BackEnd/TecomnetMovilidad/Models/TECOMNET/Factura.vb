Imports Models.TECOMNET.Enumeraciones
Namespace TECOMNET
    Public Class Factura
        Public Property Id As Integer
        Public Property ClienteId As Integer
        Public Property Serie As String
        Public Property NombreRazonSocial As String
        Public Property FechaEmision As Date
        Public Property Monto As Decimal
        Public Property FechaCancelacion As Date?
        Public Property Estatus As EstatusFactura
        Public Property MetodoPago As MetodoPago
    End Class
End Namespace
