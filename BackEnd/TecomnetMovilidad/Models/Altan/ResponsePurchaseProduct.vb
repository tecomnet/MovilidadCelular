Imports System.Text.Json.Serialization
Namespace TECOMNET.AltanRedes
    Public Class ResponsePurchaseProduct
        <JsonPropertyName("msisdn")>
        Public Property Msisdn As String

        <JsonPropertyName("effectiveDate")>
        Public Property EffectiveDate As String

        <JsonPropertyName("offerings")>
        Public Property Offerings As List(Of String)

        <JsonPropertyName("order")>
        Public Property Order As OrderInfo

        ''' <summary>
        ''' Constructor por defecto que inicializa las propiedades
        ''' </summary>
        Public Sub New()
            Offerings = New List(Of String)()
            Order = New OrderInfo()
        End Sub

        ''' <summary>
        ''' Constructor con parámetros principales
        ''' </summary>
        Public Sub New(msisdn As String, effectiveDate As String, offerings As List(Of String), orderId As String)
            Me.Msisdn = msisdn
            Me.EffectiveDate = effectiveDate
            Me.Offerings = If(offerings, New List(Of String)())
            Me.Order = New OrderInfo() With {.Id = orderId}
        End Sub
    End Class

    Public Class OrderInfo
        <JsonPropertyName("id")>
        Public Property Id As String

        ''' <summary>
        ''' Constructor por defecto
        ''' </summary>
        Public Sub New()
        End Sub

        ''' <summary>
        ''' Constructor con parámetro id
        ''' </summary>
        Public Sub New(id As String)
            Me.Id = id
        End Sub
    End Class
End Namespace