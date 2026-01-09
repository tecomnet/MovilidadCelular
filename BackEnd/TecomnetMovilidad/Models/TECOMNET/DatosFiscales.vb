Public Class DatosFiscales

    Public Property DatosFiscalesID As Integer
    Public Property ClienteId As Integer
    Public Property Nombre As String
    Public Property ApellidoMaterno As String
    Public Property ApellidoPaterno As String
    Public Property TipoPersona As String
    Public Property RegimenFiscal As String
    Public Property RazonSocial As String
    Public Property RFCFacturacion As String
    Public Property UsoDeComprobante As String
    Public Property CPFacturacion As String
    Public Property Calle As String
    Public Property NumeroInterior As String
    Public Property NumeroExterior As String
    Public Property Colonia As String
    Public Property Localidad As String
    Public Property CodigoPais As String
    Public Property CodigoEstado As String
    Public Property CodigoMunicipio As String
    Public Property CodigoPostal As String

    Public Sub New()
        Me.DatosFiscalesID = 0
        Me.ClienteId = 0
        Me.TipoPersona = String.Empty
        Me.RegimenFiscal = String.Empty
        Me.RazonSocial = String.Empty
        Me.RFCFacturacion = String.Empty
        Me.UsoDeComprobante = String.Empty
        Me.CPFacturacion = String.Empty
        Me.Calle = String.Empty
        Me.NumeroInterior = String.Empty
        Me.NumeroExterior = String.Empty
        Me.Colonia = String.Empty
        Me.Localidad = String.Empty
        Me.CodigoPais = String.Empty
        Me.CodigoEstado = String.Empty
        Me.CodigoMunicipio = String.Empty
        Me.CodigoPostal = String.Empty
    End Sub
End Class
