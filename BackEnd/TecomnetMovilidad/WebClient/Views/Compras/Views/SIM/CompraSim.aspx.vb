Public Class CompraSim
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            lblNombre.Text = Session("Nombre") & " " & Session("ApellidoPaterno")
            lblEmail.Text = Session("Email")
            lblTelefono.Text = Session("Telefono")

            lblPlanNombre.Text = Session("PlanNombre")
            lblPlanDuracion.Text = Session("PlanDuracion")
            lblPlanDatos.Text = Session("PlanDatos")
            lblPlanMinutos.Text = Session("PlanMinutos")
            lblPlanSMS.Text = Session("PlanSMS")
        End If
    End Sub

    Protected Sub btnPagar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/SIM/PagoSim.aspx")
    End Sub
End Class