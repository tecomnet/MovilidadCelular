Public Class AdminUsuarios
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnAgregarUsuario_Click(sender As Object, e As EventArgs)

        pnlTabla.Visible = False
        pnlAgregar.Visible = True
        pnlAdminUsuarios.Visible = False
    End Sub
End Class