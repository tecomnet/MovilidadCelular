Public Class Bienvenida
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnAceptar_Click(sender As Object, e As EventArgs)
        If Not chkAcceptTerms.Checked Then
            lblError.Text = "Debes de aceptar los términos y condiciones para continuar."
            lblError.ForeColor = System.Drawing.Color.Red
            Exit Sub
        End If

        Response.Redirect("~/Views/Planes/ContratarPlan.aspx")
    End Sub
End Class