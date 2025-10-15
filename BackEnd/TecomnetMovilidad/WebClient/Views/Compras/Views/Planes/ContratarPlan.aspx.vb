Imports DatabaseConnection
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones

Public Class ContratarPlan
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarOfertas()
        End If
    End Sub

    Protected Sub CargarOfertas()
        Dim objControllerOfertas As New ControllerOferta

        Dim recargas As List(Of Oferta) = objControllerOfertas.ObtenerOfertasActivasPorTipo(TipoServicio.Prepago)
        If recargas IsNot Nothing AndAlso recargas.Count > 0 Then
            lvOfferRecarga.DataSource = recargas
            lvOfferRecarga.DataBind()
        End If

        Dim mensuales As List(Of Oferta) = objControllerOfertas.ObtenerOfertasActivasPorTipo(TipoServicio.RenovacionAutomatica)
        If mensuales IsNot Nothing AndAlso mensuales.Count > 0 Then
            lvOfferMensual.DataSource = mensuales
            lvOfferMensual.DataBind()
        End If

        Dim anuales As List(Of Oferta) = objControllerOfertas.ObtenerOfertasActivasPorTipo(TipoServicio.PagoAnticipado)
        If anuales IsNot Nothing AndAlso anuales.Count > 0 Then
            lvOfferAnual.DataSource = anuales
            lvOfferAnual.DataBind()
        End If
    End Sub
    Protected Sub btnLoQuieroA_Click(sender As Object, e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim ofertaId As Integer = Convert.ToInt32(btn.CommandArgument)

        Dim objControllerOfertas As New ControllerOferta
        Dim ofertaActual As Oferta = objControllerOfertas.ObtenerOferta(ofertaId)

        Session("OfertaID") = ofertaActual.OfertaID
        Session("PlanNombre") = ofertaActual.Oferta
        Session("PlanDescripcion") = ofertaActual.Descripcion
        Session("PlanDatos") = ofertaActual.DatosMB
        Session("PlanMinutos") = ofertaActual.Minutos
        Session("PlanSMS") = ofertaActual.Sms
        Session("PlanPrecio") = ofertaActual.PrecioAnual

        Response.Redirect("~/Views/Compras/Views/Account/Registros.aspx")
    End Sub

    Protected Sub btnLoQuieroM_Click(sender As Object, e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim ofertaId As Integer = Convert.ToInt32(btn.CommandArgument)

        Dim objControllerOfertas As New ControllerOferta
        Dim ofertaActual As Oferta = objControllerOfertas.ObtenerOferta(ofertaId)

        Session("OfertaID") = ofertaActual.OfertaID
        Session("PlanNombre") = ofertaActual.Oferta
        Session("PlanDescripcion") = ofertaActual.Descripcion
        Session("PlanDatos") = ofertaActual.DatosMB
        Session("PlanMinutos") = ofertaActual.Minutos
        Session("PlanSMS") = ofertaActual.Sms
        Session("PlanPrecio") = ofertaActual.PrecioMensual

        Response.Redirect("~/Views/Compras/Views/Account/Registros.aspx")

    End Sub

    Protected Sub btnLoQuieroR_Click(sender As Object, e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim ofertaId As Integer = Convert.ToInt32(btn.CommandArgument)

        Dim objControllerOfertas As New ControllerOferta
        Dim ofertaActual As Oferta = objControllerOfertas.ObtenerOferta(ofertaId)

        Session("OfertaID") = ofertaActual.OfertaID
        Session("PlanNombre") = ofertaActual.Oferta
        Session("PlanDescripcion") = ofertaActual.Descripcion
        Session("PlanDatos") = ofertaActual.DatosMB
        Session("PlanMinutos") = ofertaActual.Minutos
        Session("PlanSMS") = ofertaActual.Sms
        Session("PlanPrecio") = ofertaActual.PrecioRecurrente

        Response.Redirect("~/Views/Compras/Views/Account/Registros.aspx")
    End Sub
End Class