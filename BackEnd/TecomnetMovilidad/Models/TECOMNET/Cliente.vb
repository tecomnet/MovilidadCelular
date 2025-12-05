Imports Models.TECOMNET.Enumeraciones

Namespace TECOMNET
    Public Class Cliente
        Public Property ClienteId As Integer
        Public Property Nombre As String
        Public Property ApellidoPaterno As String
        Public Property ApellidoMaterno As String
        Public Property FechaCumpleanios As Date?
        Public Property TipoPersona As String
        Public Property CURP As String
        Public Property Telefono As String
        Public Property Email As String
        Public Property FechaAlta As Date
        Public Property Estatus As EstatusCliente
        Public Property ContrasenaHash As String
        Public Property Estado As String
        Public Property Colonia As String
        Public Property Direccion As String
        Public Property CP As String
        Public Property RFC As String
        Public Property RFCFacturacion As String
        Public Property NombreRazonSocial As String
        Public Property CPFacturacion As String
        Public Property RegimenFiscal As String
        Public Property UsoDeComprobante As String
        Public Property FechaBaja As DateTime?
        Public Property Calle As String
        Public Property NumeroInterior As String
        Public Property NumeroExterior As String
        Public Property Localidad As String
        Public Property CodigoPais As String
        Public Property CodigoEstado As String
        Public Property CodigoCiudad As String
        Public Property SiigoID As String

        Public Sub New()
            Me.ClienteId = 0
            Me.Nombre = String.Empty
            Me.ApellidoPaterno = String.Empty
            Me.ApellidoMaterno = String.Empty
            Me.FechaCumpleanios = Nothing
            Me.TipoPersona = String.Empty
            Me.CURP = String.Empty
            Me.Telefono = String.Empty
            Me.Email = String.Empty
            Me.FechaAlta = Now
            Me.Estatus = EstatusCliente.Activo
            Me.ContrasenaHash = String.Empty
            Me.Estado = String.Empty
            Me.Colonia = String.Empty
            Me.Direccion = String.Empty
            Me.CP = String.Empty
            Me.RFC = String.Empty
            Me.RFCFacturacion = String.Empty
            Me.NombreRazonSocial = String.Empty
            Me.CPFacturacion = String.Empty
            Me.RegimenFiscal = String.Empty
            Me.UsoDeComprobante = String.Empty
            Me.FechaBaja = Nothing
            Me.Calle = String.Empty
            Me.NumeroInterior = String.Empty
            Me.NumeroExterior = String.Empty
            Me.Localidad = String.Empty
            Me.CodigoPais = String.Empty
            Me.CodigoEstado = String.Empty
            Me.CodigoCiudad = String.Empty
            Me.SiigoID = String.Empty
        End Sub
    End Class
End Namespace