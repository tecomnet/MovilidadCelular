Public Class VinculacionCurp
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnRegistrar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/Vinculacion/RegistrarLinea.aspx")
    End Sub
End Class