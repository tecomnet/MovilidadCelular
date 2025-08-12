Imports Models.TECOMNET.Enumeraciones

Namespace TECOMNET.API
    Public Class Tablero
        Public Property SIMID As Integer
        Public Property ICCID As String
        Public Property MSISDN As String
        Public Property FechaVencimiento As DateTime?
        Public Property MBAsignados As Integer?
        Public Property MBUsados As Integer?
        Public Property MBDisponibles As Integer?
        Public Property MBAdicionales As Integer?
        Public Property Oferta As String
        Public Property Descripcion As String
        Public Property Minutos As Integer
        Public Property Sms As Integer
        Public Property Tipo = Enumeraciones.TipoServicio.Prepago
        Public Property Estatus As String
    End Class
End Namespace