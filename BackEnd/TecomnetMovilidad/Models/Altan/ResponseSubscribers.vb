Imports System.Text.Json.Serialization
Namespace TECOMNET.AltanRedes
    Public Class ResponseSubscribers
        <JsonPropertyName("msisdn")>
        Public Property Msisdn As String

        <JsonPropertyName("effectiveDate")>
        Public Property EffectiveDate As String

        <JsonPropertyName("offeringId")>
        Public Property OfferingId As String

        <JsonPropertyName("order")>
        Public Property Order As OrderInfo

        ''' <summary>
        ''' Constructor por defecto que inicializa las propiedades
        ''' </summary>
        Public Sub New()
            Order = New OrderInfo()
        End Sub

        ''' <summary>
        ''' Constructor con parámetros principales
        ''' </summary>
        Public Sub New(msisdn As String, effectiveDate As String, offeringId As String, orderId As String)
            Me.Msisdn = msisdn
            Me.EffectiveDate = effectiveDate
            Me.OfferingId = offeringId
            Me.Order = New OrderInfo() With {.Id = orderId}
        End Sub
    End Class
End Namespace