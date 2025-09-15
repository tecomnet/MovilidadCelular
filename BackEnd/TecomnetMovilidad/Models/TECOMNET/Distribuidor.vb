Namespace TECOMNET
    Public Class Distribuidor
        ' Propiedades de la clase
        Public Property DistribuidorID As Integer
        Public Property Nombre As String
        Public Property Direccion As String
        Public Property TelefonoContacto As String
        Public Property EmailContacto As String
        Public Property PorcentajeComision As Decimal
        Public Property FechaAlta As Date
        Public Property FechaBaja As Date?
        Public Property FechaUltimaActualizacion As DateTime
        ' Constructor
        Public Sub New()
        End Sub
        Public Sub New(DistribuidorID As Integer, Nombre As String, Direccion As String, TelefonoContacto As String, EmailContacto As String,
            PorcentajeComision As Decimal, FechaAlta As Date)
            DistribuidorID = 0
            Nombre = String.Empty
            Direccion = String.Empty
            TelefonoContacto = String.Empty
            EmailContacto = String.Empty
            PorcentajeComision = 0
            FechaAlta = Now
        End Sub
    End Class
End Namespace