Imports DatabaseConnection
Imports Models.TECOMNET

Public Class AdminSIMs
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarSims()
        End If
    End Sub

    Private Sub CargarSims()
        Dim controller As New ControllerSIM
        Dim listaSim As List(Of SIM) = controller.ObtenerSIM()
        gvSims.DataSource = listaSim
        gvSims.DataBind()
    End Sub
End Class