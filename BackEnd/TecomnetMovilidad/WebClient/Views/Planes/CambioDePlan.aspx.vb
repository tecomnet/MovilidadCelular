Imports System.Text.Json
Imports Models.TECOMNET
Imports Models.TECOMNET.API

Public Class CambioDePlan
    Inherits System.Web.UI.Page
    Private Property Customer As Cliente
        Get
            Return Session("Usuario")
        End Get
        Set(value As Cliente)
            Session("Usuario") = value
        End Set
    End Property
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            lvCambioPlan.DataSource = CambioPlan(Customer.ClienteId)
            lvCambioPlan.DataBind()
        End If
    End Sub

    Public Function CambioPlan(SIMID As Integer) As List(Of Oferta)

        Dim api As New ConsumoApis
        Dim resultado As New MessageResult
        Dim lista As New List(Of Oferta)

        resultado = api.GetOfertaTipo(SIMID)

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            lista = JsonSerializer.Deserialize(Of List(Of Oferta))(resultado.JSON)
        End If
        Return lista
    End Function

End Class