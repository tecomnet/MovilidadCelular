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
        Public Property Estado As String ' Activa, Suspendida, Retirada, Idle, Suspender/Tráfico, Cancelada
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
        Public Property Tipo As String ' SIM, ESIM
        Public Property FechaReactivacion As DateTime?
        Public Property FechaBaja As DateTime?
        Public Property FechaSuspension As DateTime?
        Public Property FechaInicioFacturacion As DateTime?
        Public Property FechaPortabilidad As DateTime?
        Public Property CompaniaOrigen As String
        Public Property MSISDN_Transcitorio As String
        Public Sub New()
            Me.SIMID = 0
            Me.BE_ID = String.Empty
            Me.IMSI = String.Empty
            Me.IMSI_rb1 = String.Empty
            Me.IMSI_rb2 = String.Empty
            Me.ICCID = String.Empty
            Me.MSISDN = String.Empty
            Me.PIN = String.Empty
            Me.PUK = String.Empty
            Me.Serie = String.Empty
            Me.ClienteId = Nothing
            Me.Estado = "Idle"
            Me.FechaActivacion = Nothing
            Me.FechaAsignacion = Nothing
            Me.FechaVencimiento = Nothing
            Me.CreationDate = DateTime.Now
            Me.LastDate = Nothing
            Me.MBAsignados = Nothing
            Me.MBUsados = Nothing
            Me.MBDisponibles = Nothing
            Me.MBAdicionales = Nothing
            Me.OfertaId = Nothing
            Me.Tipo = String.Empty ' SIM, ESIM
            Me.CompaniaOrigen = String.Empty
            Me.MSISDN_Transcitorio = String.Empty
        End Sub

    End Class
End Namespace