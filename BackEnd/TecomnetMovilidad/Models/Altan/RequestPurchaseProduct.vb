Imports System.Text.Json.Serialization
Namespace TECOMNET.AltanRedes
    Public Class RequestPurchaseProduct
        <JsonPropertyName("msisdn")>
        Public Property Msisdn As String

        <JsonPropertyName("offerings")>
        Public Property Offerings As List(Of String)

        <JsonPropertyName("startEffectiveDate")>
        Public Property StartEffectiveDate As String

        <JsonPropertyName("expireEffectiveDate")>
        Public Property ExpireEffectiveDate As String

        <JsonPropertyName("scheduleDate")>
        Public Property ScheduleDate As String

        <JsonPropertyName("allowPurchaseOnSuspendBarring")>
        Public Property AllowPurchaseOnSuspendBarring As String

        ''' <summary>
        ''' Constructor por defecto que inicializa la lista de offerings
        ''' </summary>
        Public Sub New()
            Me.Msisdn = String.Empty
            Offerings = New List(Of String)()
            Me.StartEffectiveDate = String.Empty
            Me.ExpireEffectiveDate = String.Empty
            Me.ScheduleDate = String.Empty
            Me.AllowPurchaseOnSuspendBarring = String.Empty
        End Sub

        ''' <summary>
        ''' Constructor con parámetros principales
        ''' </summary>
        Public Sub New(msisdn As String, offerings As List(Of String))
            Me.Msisdn = msisdn
            Me.Offerings = If(offerings, New List(Of String)())
            Me.StartEffectiveDate = String.Empty
            Me.ExpireEffectiveDate = String.Empty
            Me.ScheduleDate = String.Empty
            Me.AllowPurchaseOnSuspendBarring = String.Empty
        End Sub
    End Class
End Namespace