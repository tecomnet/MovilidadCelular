Public Class AdminMetodoPago
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub lnkEditarPagoTarjeta_Click(sender As Object, e As EventArgs)
        txtEditarMetodoPago.Text = "Pago con tarjeta"
        txtEditarDescripcion.Text = "Pago con tarjeta"
        PnlAdminMetodoPago.Visible = False
        PnlTabla.Visible = False
        PnlEditarMetodoPago.Visible = True
    End Sub
End Class