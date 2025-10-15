Imports DatabaseConnection
Imports Models.TECOMNET

Public Class AdminEstatusDeposito
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarEstatus()
        End If
    End Sub

    Private Sub CargarEstatus()
        Dim controller As New ControllerEstatusDeposito
        Dim listaEstatusDeposito As List(Of EstatusDeposito) = controller.GetEstatusDeposito

        gvEstatusDeposito.DataSource = listaEstatusDeposito
        gvEstatusDeposito.DataBind()
    End Sub
    Protected Sub lnkEditarEstatusDeposito_Click(sender As Object, e As EventArgs)
        txtEditarEstatusDeposito.Text = "Estatus deposito"
        txtEditarDescripcion.Text = "Estatus deposito"
        pnlAdminEstatusDeposito.Visible = False
        PnlTabla.Visible = False
        PnlEditarEstatusDeposito.Visible = True
    End Sub

    Protected Sub gvEstatusDeposito_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvEstatusDeposito.RowCommand

    End Sub
End Class