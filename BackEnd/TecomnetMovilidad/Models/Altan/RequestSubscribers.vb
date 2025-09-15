Imports System.Text.Json.Serialization
Namespace TECOMNET.AltanRedes
    Public Class RequestSubscribers
        <JsonPropertyName("offeringId")>
        Public Property OfferingId As String

        <JsonPropertyName("address")>
        Public Property Address As String

        <JsonPropertyName("scheduleDate")>
        Public Property ScheduleDate As String

        <JsonPropertyName("startEffectiveDate")>
        Public Property StartEffectiveDate As String

        <JsonPropertyName("expireEffectiveDate")>
        Public Property ExpireEffectiveDate As String

        <JsonPropertyName("allowChangeOfferInSuspendBarring")>
        Public Property AllowChangeOfferInSuspendBarring As String

        ''' <summary>
        ''' Constructor por defecto
        ''' </summary>
        Public Sub New()
        End Sub

        ''' <summary>
        ''' Constructor con parámetros
        ''' </summary>
        Public Sub New(offeringId As String)
            Me.OfferingId = offeringId
            Me.Address = String.Empty
            Me.ScheduleDate = String.Empty
            Me.StartEffectiveDate = String.Empty
            Me.ExpireEffectiveDate = String.Empty
            Me.AllowChangeOfferInSuspendBarring = String.Empty
        End Sub
    End Class
End Namespace