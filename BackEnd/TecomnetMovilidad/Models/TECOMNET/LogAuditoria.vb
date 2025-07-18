Imports Models.TECOMNET.Enumeraciones

Namespace TECOMNET
    Public Class LogAuditoria
        Public Property LogAuditoriaId As Integer
        Public Property UsuarioId As Integer
        Public Property Accion As String
        Public Property Modulo As String
        Public Property FechaHora As Date
        Public Property Detalle As String
    End Class
End Namespace