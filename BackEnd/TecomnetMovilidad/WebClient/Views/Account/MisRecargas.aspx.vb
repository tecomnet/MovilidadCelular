Imports System.Text.Json
Imports Models.TECOMNET

Public Class MisRecargas
    Inherits System.Web.UI.Page
#Region "Property"
    Private Property Customer As Cliente
        Get
            Return Session("Usuario")
        End Get
        Set(value As Cliente)
            Session("Usuario") = value
        End Set
    End Property
#End Region
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            CargarRecargas(Customer.ClienteId)

        End If
    End Sub

    Private Sub CargarRecargas(clienteId As Integer)
        Dim api As New ConsumoApis
        Dim resultado As New MessageResult
        Dim recargas As New List(Of VisRecarga)

        resultado = api.GetRecargasCliente(clienteId)

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            recargas = JsonSerializer.Deserialize(Of List(Of VisRecarga))(resultado.JSON)
            gvRecargas.DataSource = recargas
            gvRecargas.DataBind()
        End If
    End Sub
End Class
