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
        Dim listaEstatusDeposito As List(Of EstatusDeposito) = controller.ObtenerEstatusDeposito

        gvEstatusDeposito.DataSource = listaEstatusDeposito
        gvEstatusDeposito.DataBind()
    End Sub


    Protected Sub gvEstatusDeposito_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvEstatusDeposito.RowCommand

    End Sub

    Protected Sub BtnAgregarEstatusDeposito_Click(sender As Object, e As EventArgs)
        PnlTabla.Visible = False
        PnlAgregarEstatusDeposito.Visible = True
        pnlAdminEstatusDeposito.Visible = False
        lblTitulo.Text = "Estatus Nuevo"
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Dim controllerEstatusDeposito As New ControllerEstatusDeposito
        Dim objEstatusDeposito As New EstatusDeposito

        objEstatusDeposito.EstatusDepositoID = If(String.IsNullOrEmpty(hdnEstatusDeposito.Value), 0, Convert.ToInt32(hdnEstatusDeposito.Value))
        objEstatusDeposito.Estatus = txtEstatus.Text
        objEstatusDeposito.Descripcion = txtDescripcion.Text

        If objEstatusDeposito.EstatusDepositoID = 0 Then
            Dim estatusDeposito As Integer = controllerEstatusDeposito.AddEstatusDeposito(objEstatusDeposito)
            hdnEstatusDeposito.Value = estatusDeposito.ToString()
            PnlAgregarEstatusDeposito.Visible = False

        End If

    End Sub
End Class