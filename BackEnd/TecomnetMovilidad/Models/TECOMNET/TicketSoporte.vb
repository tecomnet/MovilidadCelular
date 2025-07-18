Imports Models.TECOMNET.Enumeraciones

Namespace TECOMNET
    Public Class TicketSoporte
        Public Property TicketSoporteId As Integer
        Public Property ClienteId As Integer
        Public Property FechaCreacion As Date
        Public Property Asunto As String
        Public Property Descripcion As String
        Public Property Estatus As EstatusTicket
        Public Property FechaCierre As Date?
    End Class
End Namespace