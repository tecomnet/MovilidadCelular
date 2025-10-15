Imports DatabaseConnection
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones

Public Class AdminOfertas
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarOfertas()
            pnlAdminOfertas.Visible = True
            pnlTabla.Visible = True
            pnlAgregar.Visible = False
        End If
    End Sub

    Protected Sub btnAgregarOfertas_Click(sender As Object, e As EventArgs)
        hdnOfertaId.Value = ""
        txtOferta.Text = ""
        txtDescripcion.Text = ""
        txtOfertaIdAltan.Text = ""
        txtHomologacioId.Text = ""
        ddlTipoOferta.SelectedIndex = 0
        ddlTipoOferta_SelectedIndexChanged(Nothing, Nothing)
        txtPrecioRecarga.Text = ""
        txtPrecioAnual.Text = ""
        txtPrecioMensual.Text = ""
        txtDatosMB.Text = ""
        txtMinutos.Text = ""
        txtSms.Text = ""
        txtValidezDias.Text = ""
        ddlAplicaRoaming.SelectedIndex = 0
        ddlTarifaPrimaria.SelectedIndex = 0
        ddlRedesSociales.SelectedIndex = 0
        txtFechaAlta.Text = ""

        pnlTabla.Visible = False
        pnlAgregar.Visible = True
        pnlAdminOfertas.Visible = False
    End Sub


    Private Sub CargarOfertas()
        Dim controller As New ControllerOferta
        Dim listaOferta As List(Of Oferta) = controller.ObtenerOfertas()

        Dim tipoSeleccionado As Integer = Convert.ToInt32(ddlFiltroTipoOferta.SelectedValue)

        If tipoSeleccionado <> 0 Then
            listaOferta = listaOferta.Where(Function(o) CInt(o.Tipo) = tipoSeleccionado).ToList()
        End If

        gvOfertas.DataSource = listaOferta
        gvOfertas.DataBind()
    End Sub

    Protected Sub ddlFiltroTipoOferta_SelectedIndexChanged(sender As Object, e As EventArgs)
        CargarOfertas()
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Dim controllerOfertas As New ControllerOferta
        Dim objOferta As New Oferta

        objOferta.OfertaID = If(String.IsNullOrEmpty(hdnOfertaId.Value), 0, Convert.ToInt32(hdnOfertaId.Value))

        objOferta.Oferta = txtOferta.Text
        objOferta.Descripcion = txtDescripcion.Text
        objOferta.DatosMB = If(String.IsNullOrWhiteSpace(txtDatosMB.Text), 0, Convert.ToInt32(txtDatosMB.Text))
        objOferta.Minutos = If(String.IsNullOrWhiteSpace(txtMinutos.Text), 0, Convert.ToInt32(txtMinutos.Text))
        objOferta.Sms = If(String.IsNullOrWhiteSpace(txtSms.Text), 0, Convert.ToInt32(txtSms.Text))
        objOferta.OfferIDAltan = If(String.IsNullOrWhiteSpace(txtOfertaIdAltan.Text), 0, Convert.ToInt32(txtOfertaIdAltan.Text))
        objOferta.HomologacionID = If(String.IsNullOrWhiteSpace(txtHomologacioId.Text), 0, Convert.ToInt32(txtHomologacioId.Text))
        objOferta.Tipo = CType(Convert.ToInt32(ddlTipoOferta.SelectedValue), TipoServicio)
        objOferta.PrecioMensual = If(String.IsNullOrWhiteSpace(txtPrecioMensual.Text), 0D, Convert.ToDecimal(txtPrecioMensual.Text))
        objOferta.PrecioAnual = If(String.IsNullOrWhiteSpace(txtPrecioAnual.Text), 0D, Convert.ToDecimal(txtPrecioAnual.Text))
        objOferta.PrecioRecurrente = If(String.IsNullOrWhiteSpace(txtPrecioRecarga.Text), 0D, Convert.ToDecimal(txtPrecioRecarga.Text))
        objOferta.ValidezDias = txtValidezDias.Text
        objOferta.AplicaRoaming = Convert.ToBoolean(ddlAplicaRoaming.SelectedValue)
        objOferta.RedesSociales = Convert.ToBoolean(ddlRedesSociales.SelectedValue)
        objOferta.TarifaPrimaria = Convert.ToBoolean(ddlTarifaPrimaria.SelectedValue)
        objOferta.FechaAlta = Date.Now
        objOferta.FechaBaja = Nothing

        Dim resultado As Integer
        If objOferta.OfertaID > 0 Then
            resultado = controllerOfertas.UpdateOferta(objOferta)
        Else
            resultado = controllerOfertas.AddOferta(objOferta)
        End If

        If resultado > 0 Then
            lblMensaje.Text = "✅ Oferta guardada correctamente."
            lblMensaje.CssClass = "alert alert-success"
        Else
            lblMensaje.Text = "❌ Error al guardar la oferta."
            lblMensaje.CssClass = "alert alert-danger"
        End If

        lblMensaje.Visible = True
        CargarOfertas()
        pnlAgregar.Visible = False
        pnlTabla.Visible = True
        pnlAdminOfertas.Visible = True
    End Sub


    Protected Sub ddlTipoOferta_SelectedIndexChanged(sender As Object, e As EventArgs)

        Dim tipoSeleccionado As String = ddlTipoOferta.SelectedValue

        divPrecioRecarga.Visible = False
        divPrecioAnual.Visible = False
        divPrecioMensual.Visible = False

        Select Case tipoSeleccionado
            Case "1" ' Prepago
                divPrecioRecarga.Visible = True
            Case "2" ' PagoAnticipado
                divPrecioAnual.Visible = True
            Case "3" ' RenovacionAutomatica
                divPrecioMensual.Visible = True
        End Select
    End Sub

    Protected Sub gvOfertas_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvOfertas.RowCommand
        If e.CommandName = "EditarOferta" Then
            Dim ofertaId As Integer = Convert.ToInt32(e.CommandArgument)
            Dim controller As New ControllerOferta()
            Dim oferta As Oferta = controller.ObtenerOferta(ofertaId)

            If oferta IsNot Nothing Then
                hdnOfertaId.Value = oferta.OfertaID.ToString()
                txtOferta.Text = oferta.Oferta
                txtDescripcion.Text = oferta.Descripcion
                txtOfertaIdAltan.Text = oferta.OfferIDAltan.ToString()
                txtHomologacioId.Text = oferta.HomologacionID.ToString()
                ddlTipoOferta.SelectedValue = CInt(oferta.Tipo).ToString()

                ddlTipoOferta_SelectedIndexChanged(Nothing, Nothing)

                txtPrecioRecarga.Text = oferta.PrecioRecurrente.ToString()
                txtPrecioAnual.Text = oferta.PrecioAnual.ToString()
                txtPrecioMensual.Text = oferta.PrecioMensual.ToString()

                txtDatosMB.Text = oferta.DatosMB.ToString()
                txtMinutos.Text = oferta.Minutos.ToString()
                txtSms.Text = oferta.Sms.ToString()
                txtValidezDias.Text = oferta.ValidezDias.ToString()
                ddlAplicaRoaming.SelectedValue = oferta.AplicaRoaming.ToString()
                ddlTarifaPrimaria.SelectedValue = oferta.TarifaPrimaria.ToString()
                ddlRedesSociales.SelectedValue = oferta.RedesSociales.ToString()
                txtFechaAlta.Text = oferta.FechaAlta.ToString("yyyy-MM-dd")

                pnlAgregar.Visible = True
                pnlTabla.Visible = False
                pnlAdminOfertas.Visible = False
            End If

        ElseIf e.CommandName = "BajaOferta" Then
            Dim ofertaId As Integer = Convert.ToInt32(e.CommandArgument)
            Dim controller As New ControllerOferta()
            Dim resultado As Integer = controller.BajaOferta(ofertaId)

            If resultado > 0 Then
                lblMensaje.Text = "✅ Oferta dada de baja correctamente."
                lblMensaje.CssClass = "alert alert-success"
            Else
                lblMensaje.Text = "❌ No se pudo dar de baja la Oferta."
                lblMensaje.CssClass = "alert alert-danger"
            End If
            lblMensaje.Visible = True
        End If
    End Sub
End Class