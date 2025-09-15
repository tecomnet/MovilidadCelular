Imports Models.TECOMNET.Enumeraciones
Namespace TECOMNET

    Public Class Usuario
        Public Property UsuarioID As Integer
        Public Property NombreUsuario As String
        Public Property Nombre As String
        Public Property Email As String
        Public Property PasswordHash As String
        Public Property NumeroTelefono As String
        Public Property TipoUsuario As TipoUsuario?
        Public Property RelacionTipoID As Integer?
        Public Property FechaAlta As DateTime
        Public Property fechaBaja As DateTime?
        Public Property UltimoLogin As DateTime?
        Public Property FechaUltimaActualizacion As DateTime
        Public Sub New()
            Me.UsuarioID = 0
            Me.NombreUsuario = String.Empty
            Me.Nombre = String.Empty
            Me.Email = String.Empty
            Me.PasswordHash = String.Empty
            Me.NumeroTelefono = String.Empty
            Me.TipoUsuario = Enumeraciones.TipoUsuario.Administrator
            Me.RelacionTipoID = Nothing
            Me.FechaAlta = Now
            Me.fechaBaja = Nothing
            Me.UltimoLogin = Now
            Me.FechaUltimaActualizacion = Now
        End Sub
    End Class
End Namespace