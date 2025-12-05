Imports Models.TECOMNET.Enumeraciones

Public Class Portabilidad
    Public Property PortabilidadID As Integer
    Public Property MSISDN_Transitorio As String
    Public Property MSISDN As String
    Public Property CompaniaOrigen As String
    Public Property Estatus As String ' Pediente, Completada, Rechazada, Cancelada
    Public Property FechaRegistro As DateTime?
    Public Property FechaTermino As DateTime?
    Public Property FechaCancelacion As DateTime?
    Public Property FechaRechazo As DateTime?
    Public Property TipoPortabilidad As TipoPortabilidad
    Public Property Response As String

    Public Sub New()
        Me.PortabilidadID = 0
        Me.MSISDN_Transitorio = String.Empty
        Me.MSISDN = String.Empty
        Me.CompaniaOrigen = String.Empty
        Me.Estatus = String.Empty
        Me.FechaRegistro = Nothing
        Me.FechaTermino = Nothing
        Me.FechaCancelacion = Nothing
        Me.FechaRechazo = Nothing
        Me.TipoPortabilidad = TipoPortabilidad.Api
        Me.Response = String.Empty
    End Sub
End Class
