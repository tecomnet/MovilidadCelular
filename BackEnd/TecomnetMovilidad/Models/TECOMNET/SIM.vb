Imports Models.TECOMNET.Enumeraciones

Namespace TECOMNET
    Public Class SIM
        Public Property SIMID As Integer
        Public Property BE_ID As String
        Public Property IMSI As String
        Public Property IMSI_rb1 As String
        Public Property IMSI_rb2 As String
        Public Property ICCID As String
        Public Property MSISDN As String
        Public Property PIN As String
        Public Property PUK As String
        Public Property Serie As String
        Public Property ClienteId As Integer?
        Public Property Estado As EstatusSIM ' Activa, Suspendida, Retirada
        Public Property FechaActivacion As DateTime?
        Public Property FechaAsignacion As DateTime?
        Public Property FechaVencimiento As DateTime?
        Public Property CreationDate As DateTime
        Public Property LastDate As DateTime?
        Public Property MBAsignados As Integer?
        Public Property MBUsados As Integer?
        Public Property MBDisponibles As Integer?
        Public Property MBAdicionales As Integer?
        Public Property OfertaId As Integer?
    End Class
End Namespace