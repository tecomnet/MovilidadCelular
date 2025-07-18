
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
        Public Property CreationDate As Date
        Public Property LastDate As Date?
    End Class
End Namespace