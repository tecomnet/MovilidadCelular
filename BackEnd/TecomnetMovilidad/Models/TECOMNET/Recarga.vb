Imports Models.TECOMNET.Enumeraciones

Namespace TECOMNET
    Public Class Recarga
        Public Property RecargaId As Integer
        Public Property FechaRecarga As DateTime
        Public Property ICCID As String
        Public Property ClienteID As Integer
        Public Property OfertaID As Integer
        Public Property Total As Double
        Public Property MetodoPagoID As Integer
        Public Property OrderID As String
        Public Property DistribuidorID As Integer
        Public Property EstatusPagoDistribuidorID As Integer
        Public Property FechaPagoDistribuidor As DateTime?
        Public Property Comision As Double
        Public Property Impuesto As Double
        Public Property DepositoID As Integer?
        Public Property CanalDeVenta As CanalDeVenta
        Public Property TipoOperacion As TipoOperacion
        Public Property RequiereFacturaCliente As Boolean
        Public Property FacturaID As Integer?
        Public Sub New()
            Me.RecargaId = 0
            Me.FechaRecarga = Now
            Me.ICCID = String.Empty
            Me.ClienteID = 0
            Me.OfertaID = 0
            Me.Total = 0
            Me.MetodoPagoID = 1
            Me.OrderID = String.Empty
            Me.DistribuidorID = 0
            Me.EstatusPagoDistribuidorID = 0
            Me.Comision = 0
            Me.Impuesto = 0
            Me.CanalDeVenta = CanalDeVenta.App
            Me.TipoOperacion = TipoOperacion.Compra
            Me.RequiereFacturaCliente = False
        End Sub
    End Class
    Public Class VisRecarga
        Inherits Recarga
        Public Property NombreMetodo As String
        Public Property MSISDN As String
        Public Property Oferta As String
        Public Sub New()
            Me.RecargaId = 0
            Me.FechaRecarga = Now
            Me.ICCID = String.Empty
            Me.ClienteID = 0
            Me.OfertaID = 0
            Me.Total = 0
            Me.MetodoPagoID = 1
            Me.OrderID = String.Empty
            Me.DistribuidorID = 0
            Me.EstatusPagoDistribuidorID = 0
            Me.Comision = 0
            Me.Impuesto = 0
            Me.RequiereFacturaCliente = False
            Me.NombreMetodo = String.Empty
            Me.MSISDN = String.Empty
            Me.Oferta = String.Empty
        End Sub
    End Class
End Namespace