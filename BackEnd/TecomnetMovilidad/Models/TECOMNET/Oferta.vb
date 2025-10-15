
Imports Models.TECOMNET.Enumeraciones

Namespace TECOMNET
    Public Class Oferta
        Public Property OfertaID As Integer
        Public Property Oferta As String
        Public Property Descripcion As String
        Public Property PrecioMensual As Decimal
        Public Property PrecioAnual As Decimal
        Public Property PrecioRecurrente As Decimal
        Public Property DatosMB As Integer
        Public Property Minutos As Integer
        Public Property Sms As Integer
        Public Property EsPrepago As Boolean
        Public Property Tipo As TipoServicio
        Public Property OfferIDAltan As String
        Public Property ValidezDias As Integer
        Public Property AplicaRoaming As Boolean
        Public Property BolsaCompartirDatos As Boolean
        Public Property RedesSociales As Boolean
        Public Property TarifaPrimaria As Boolean
        Public Property HomologacionID As Integer
        Public Property FechaAlta As Date
        Public Property FechaBaja As Date?
        Public Sub New()
            Me.OfertaID = 0
            Me.Oferta = String.Empty
            Me.Descripcion = String.Empty
            Me.PrecioMensual = 0
            Me.PrecioAnual = 0
            Me.PrecioRecurrente = 0
            Me.DatosMB = 0
            Me.Minutos = 0
            Me.Sms = 0
            Me.EsPrepago = False
            Me.Tipo = TipoServicio.Prepago
            Me.OfferIDAltan = String.Empty
            Me.ValidezDias = 0
            Me.AplicaRoaming = False
            Me.BolsaCompartirDatos = False
            Me.RedesSociales = False
            Me.TarifaPrimaria = True
            Me.HomologacionID = 0
            Me.FechaAlta = Now
            Me.FechaBaja = Nothing
        End Sub
    End Class
End Namespace