Public Class ContratarPlan
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnAnual1_Click(sender As Object, e As EventArgs)
        Session("PlanNombre") = "Plan Anual Básico"
        Session("PlanDuracion") = "12 Meses"
        Session("PlanDatos") = "50GB de datos"
        Session("PlanMinutos") = "1000 minutos"
        Session("PlanSMS") = "SMS ilimitados"
        Response.Redirect("~/Views/Account/Registros.aspx")
    End Sub

    Protected Sub btnAnual2_Click(sender As Object, e As EventArgs)
        Session("PlanNombre") = "Plan Anual Básico"
        Session("PlanDuracion") = "12 Meses"
        Session("PlanDatos") = "50GB de datos"
        Session("PlanMinutos") = "1000 minutos"
        Session("PlanSMS") = "SMS ilimitados"
        Response.Redirect("~/Views/Account/Registros.aspx")
    End Sub

    Protected Sub btnAnual3_Click(sender As Object, e As EventArgs)
        Session("PlanNombre") = "Plan Anual Básico"
        Session("PlanDuracion") = "12 Meses"
        Session("PlanDatos") = "50GB de datos"
        Session("PlanMinutos") = "1000 minutos"
        Session("PlanSMS") = "SMS ilimitados"
        Response.Redirect("~/Views/Account/Registros.aspx")
    End Sub

    Protected Sub btnMensual1_Click(sender As Object, e As EventArgs)
        Session("PlanNombre") = "Plan Mensual Básico"
        Session("PlanDuracion") = "30 días"
        Session("PlanDatos") = "5GB de datos"
        Session("PlanMinutos") = "200 minutos"
        Session("PlanSMS") = "SMS ilimitados"
        Response.Redirect("~/Views/Account/Registros.aspx")
    End Sub

    Protected Sub btnMensual2_Click(sender As Object, e As EventArgs)
        Response.Write("Has contratado el Plan Mensual Plus")
    End Sub

    Protected Sub btnRecarga1_Click(sender As Object, e As EventArgs)
        Session("PlanNombre") = "Recarga 50"
        Session("PlanDuracion") = "7 días ilimitados"
        Session("PlanDatos") = "5GB de datos"
        Session("PlanMinutos") = "200 minutos"
        Session("PlanSMS") = "SMS ilimitados"
        Response.Redirect("~/Views/Account/Registros.aspx")
    End Sub

    Protected Sub btnRecarga2_Click1(sender As Object, e As EventArgs)
        Response.Write("Has contratado la Recarga Plus")

    End Sub
End Class