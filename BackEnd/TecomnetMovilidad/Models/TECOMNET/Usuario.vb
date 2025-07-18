Imports Models.TECOMNET.Enumeraciones
Namespace TECOMNET

    Public Class Usuario
        Public Property UsuarioId As Integer
        Public Property NombreUsuario As String
        Public Property Nombre As String
        Public Property ContrasenaHash As String
        Public Property TipoUsuario As TipoUsuario
        Public Property FechaAlta As DateTime
        Public Property UltimoLogin As DateTime?
        Public Property FechaBaja As DateTime?
        Public Property Activo As Boolean

        'Public Function ValidarContraseña(contraseña As String) As Boolean
        '    Return BCrypt.Net.BCrypt.Verify(contraseña, ContraseñaHash)
        'End Function

        'Public Sub SetContraseña(contraseña As String)
        '    ContraseñaHash = BCrypt.Net.BCrypt.HashPassword(contraseña)
        'End Sub
    End Class
End Namespace