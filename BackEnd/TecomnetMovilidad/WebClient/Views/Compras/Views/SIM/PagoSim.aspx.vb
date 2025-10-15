Public Class PagoSim
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnPagar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/Compras/Views/Bienvenida/CompraRealizada.aspx")
    End Sub
End Class