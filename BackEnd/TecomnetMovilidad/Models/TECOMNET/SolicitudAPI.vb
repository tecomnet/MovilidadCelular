Imports Models.TECOMNET.Enumeraciones

Namespace TECOMNET
    Public Class SolicitudAPI
        Public Property Id As Integer
        Public Property TipoOperacion As TipoSolicitud
        Public Property JsonRequest As String
        Public Property JsonResponse As String
        Public Property FechaSolicitud As Date
        Public Property Exito As Boolean
    End Class
End Namespace