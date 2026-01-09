Imports System.Web.Services
Imports DatabaseConnection
Imports Models
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones

Public Class AdminCliente
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarClientes()
            CargarSIMAsignadas()
            CargarSimDisponible()
            llenaRegimen()
            txtFechaAlta.Text = DateTime.Now.ToString("yyyy-MM-dd")
            pnlFisica.Visible = True
            CargarPaises()
        End If
    End Sub

    Protected Sub btnAgregarCliente_Click(sender As Object, e As EventArgs)
        pnlTabla.Visible = False
        pnlAgregar.Visible = True
        pnlAdminCliente.Visible = False
        lblTitulo.Text = "Cliente Nuevo"
        PnlBotonDatos.Visible = True
        PnlBotonGuardarCancelar.Visible = True
        LimpiarCampos()
        If ddlTipoPersona.SelectedValue = "F" Then
            pnlFisica.Visible = True
            pnlPassword.Visible = True
            pnlFisicaFecha.Visible = True
            pnlRFC.Visible = True
        ElseIf ddlTipoPersona.SelectedValue = "M" Then
            pnlFisica.Visible = False
            pnlPassword.Visible = True
            pnlFisicaFecha.Visible = False
            pnlRFC.Visible = True
        End If
        OcultarMensaje()
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Dim controllerClientes As New ControllerCliente
        Dim controllerDatosFiscales As New ControllerDatosFiscales
        Dim objDatosFiscales As New DatosFiscales
        Dim objClientes As New Cliente

        objClientes.ClienteId = If(String.IsNullOrEmpty(hdnClienteId.Value), 0, Convert.ToInt32(hdnClienteId.Value))
        objClientes.Nombre = txtNombre.Text
        objClientes.ApellidoPaterno = txtApellidoPaterno.Text
        objClientes.ApellidoMaterno = txtApellidoMaterno.Text
        If Not String.IsNullOrWhiteSpace(txtFechaCumpleanios.Text) Then
            objClientes.FechaCumpleanios = Date.Parse(txtFechaCumpleanios.Text)
        Else
            objClientes.FechaCumpleanios = Nothing
        End If
        objClientes.TipoPersona = ddlTipoPersona.SelectedValue
        objClientes.CURP = txtCURP.Text
        objClientes.Telefono = txtTelefono.Text
        objClientes.Email = txtEmail.Text
        If Not String.IsNullOrWhiteSpace(txtFechaAlta.Text) Then
            objClientes.FechaAlta = Date.Parse(txtFechaAlta.Text)
        Else
            objClientes.FechaAlta = DateTime.Now
        End If
        objClientes.Estatus = CType(Convert.ToInt32(ddlEstatus.SelectedValue), EstatusCliente)
        objClientes.ContrasenaHash = Securyty.Cifrar(tbPassword.Text)
        objClientes.RFC = txtRFC.Text
        objClientes.NombreRazonSocial = txtNombreRazonSocial.Text

        objDatosFiscales.Nombre = txtNombreFiscal.Text
        objDatosFiscales.ApellidoPaterno = txtApellidoPaternoFiscal.Text
        objDatosFiscales.ApellidoMaterno = txtApellidoMaternoFiscal.Text
        objDatosFiscales.RazonSocial = txtRazonSocialFiscal.Text
        objDatosFiscales.RFCFacturacion = txtRfcFacturacion.Text
        objDatosFiscales.UsoDeComprobante = txtUsoComprobante.Text
        objDatosFiscales.CPFacturacion = txtCPFacturacion.Text
        objDatosFiscales.Calle = txtCalleFiscal.Text
        objDatosFiscales.Colonia = txtColoniaFiscal.Text
        objDatosFiscales.NumeroExterior = txtNumeroExterior.Text
        objDatosFiscales.NumeroInterior = txtNumeroInterior.Text
        objDatosFiscales.Localidad = txtLocalidad.Text
        objDatosFiscales.TipoPersona = ddlTipoPersonaRegimen.SelectedValue
        objDatosFiscales.RegimenFiscal = ddlRegimenFiscal.SelectedValue
        objDatosFiscales.CodigoPostal = txtCodigoPostalFiscal.Text
        objDatosFiscales.CodigoPais = ddlPaisFiscal.SelectedValue
        objDatosFiscales.CodigoEstado = ddlEstadoFiscal.SelectedValue
        objDatosFiscales.CodigoMunicipio = ddlCiudadFiscal.SelectedValue

        If objClientes.ClienteId = 0 Then
            Dim cliente As Integer = controllerClientes.AddCliente(objClientes)
            hdnClienteId.Value = cliente.ToString()
            CargarClientes()
            objDatosFiscales.ClienteId = cliente

            Dim resultadoFiscal As Integer = controllerDatosFiscales.AddDatosFiscales(objDatosFiscales)

            pnlAdminCliente.Visible = True
            pnlAgregar.Visible = False
            pnlTabla.Visible = True
            PnlBotonDatos.Visible = False
            PnlBotonGuardarCancelar.Visible = False
            LimpiarCampos()
            MostrarMensaje("✅ Cliente agregado correctamente.", "success")

        Else
            Dim actualizado As Integer = controllerClientes.UpdateCliente(objClientes)
            objDatosFiscales.ClienteId = objClientes.ClienteId

            Dim datosExistentes As DatosFiscales = controllerDatosFiscales.ObtenerDatosFiscalesPorClienteID(objClientes.ClienteId)
            Dim resultadoFiscal As Integer
            If datosExistentes IsNot Nothing AndAlso datosExistentes.ClienteId > 0 Then
                objDatosFiscales.DatosFiscalesID = datosExistentes.DatosFiscalesID
                resultadoFiscal = controllerDatosFiscales.UpdateDatosFiscales(objDatosFiscales)
            End If
            If actualizado > 0 Then
                MostrarMensaje("✅ Cliente actualizado correctamente al cliente.", "success")

            Else
                MostrarMensaje("❌ Error al actualizar el cliente.", "danger")
            End If
            pnlAgregar.Visible = False
            pnlTabla.Visible = True
            pnlAdminCliente.Visible = True
            PnlBotonDatos.Visible = False
            PnlBotonSIM.Visible = False
            PnlBotonGuardarCancelar.Visible = False
            pnlPassword.Visible = True

            CargarClientes()

        End If
    End Sub
    Private Sub CargarClientes(Optional filtro As String = "")
        Dim controller As New ControllerCliente
        Dim listaClientes As List(Of Cliente) = controller.GetClientes()
        If Not String.IsNullOrEmpty(filtro) Then
            filtro = filtro.ToLower()

            listaClientes = listaClientes.
            Where(Function(u) u.Nombre.ToLower().Contains(filtro) _
                            Or u.ApellidoPaterno.ToLower().Contains(filtro)).
            ToList()
        End If
        gvClientes.DataSource = listaClientes
        gvClientes.DataBind()
    End Sub

    Protected Sub gvClientes_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvClientes.RowCommand
        Try
            If e.CommandName = "EditarCliente" Then
                OcultarMensaje()
                Dim clienteId As Integer = Convert.ToInt32(e.CommandArgument)
                Dim controller As New ControllerCliente()
                Dim cliente As Cliente = controller.ObtenerClientePorID(clienteId)

                If cliente IsNot Nothing Then
                    hdnClienteId.Value = cliente.ClienteId.ToString()

                    txtNombre.Text = cliente.Nombre
                    txtApellidoPaterno.Text = cliente.ApellidoPaterno
                    txtApellidoMaterno.Text = cliente.ApellidoMaterno
                    If cliente.FechaAlta <> Date.MinValue Then
                        txtFechaAlta.Text = cliente.FechaAlta.ToString("yyyy-MM-dd")
                    Else
                        txtFechaAlta.Text = ""
                    End If
                    If ddlTipoPersona.Items.FindByValue(cliente.TipoPersona) IsNot Nothing Then
                        ddlTipoPersona.SelectedValue = cliente.TipoPersona
                        If cliente.TipoPersona = "F" Then
                            pnlFisica.Visible = True
                            pnlPassword.Visible = True
                            pnlFisicaFecha.Visible = True
                            pnlRFC.Visible = True
                        ElseIf cliente.TipoPersona = "M" Then
                            pnlFisica.Visible = False
                            pnlPassword.Visible = True
                            pnlFisicaFecha.Visible = False
                            pnlRFC.Visible = True
                        End If
                    End If
                    txtCURP.Text = cliente.CURP
                    txtTelefono.Text = cliente.Telefono
                    txtEmail.Text = cliente.Email
                    If cliente.FechaCumpleanios.HasValue AndAlso cliente.FechaCumpleanios.Value <> DateTime.MinValue Then
                        txtFechaCumpleanios.Text = cliente.FechaCumpleanios.Value.ToString("yyyy-MM-dd")
                    Else
                        txtFechaCumpleanios.Text = ""
                    End If
                    If ddlEstatus.Items.FindByValue(CInt(cliente.Estatus).ToString()) IsNot Nothing Then
                        ddlEstatus.SelectedValue = CInt(cliente.Estatus).ToString()
                    End If

                    txtRFC.Text = cliente.RFC
                    txtNombreRazonSocial.Text = cliente.NombreRazonSocial

                    Dim controllerFiscal As New ControllerDatosFiscales()
                    Dim datosFiscales As DatosFiscales = controllerFiscal.ObtenerDatosFiscalesPorClienteID(cliente.ClienteId)

                    If datosFiscales IsNot Nothing AndAlso datosFiscales.ClienteId > 0 Then
                        txtNombreFiscal.Text = datosFiscales.Nombre
                        txtApellidoPaternoFiscal.Text = datosFiscales.ApellidoPaterno
                        txtApellidoMaternoFiscal.Text = datosFiscales.ApellidoMaterno
                        txtRazonSocialFiscal.Text = datosFiscales.RazonSocial
                        txtRfcFacturacion.Text = datosFiscales.RFCFacturacion
                        txtUsoComprobante.Text = datosFiscales.UsoDeComprobante
                        txtCPFacturacion.Text = datosFiscales.CPFacturacion
                        txtCalleFiscal.Text = datosFiscales.Calle
                        txtColoniaFiscal.Text = datosFiscales.Colonia
                        txtNumeroExterior.Text = datosFiscales.NumeroExterior
                        txtNumeroInterior.Text = datosFiscales.NumeroInterior
                        txtLocalidad.Text = datosFiscales.Localidad
                        txtCodigoPostalFiscal.Text = datosFiscales.CodigoPostal

                        If ddlTipoPersonaRegimen.Items.FindByValue(datosFiscales.TipoPersona) IsNot Nothing Then
                            ddlTipoPersonaRegimen.SelectedValue = datosFiscales.TipoPersona
                            If datosFiscales.TipoPersona = "F" Then
                                pnlFiscaFiscales.Visible = True
                                pnlDatosMoralFiscales.Visible = True
                                pnlApellidoPaternoFiscal.Visible = True
                            ElseIf datosFiscales.TipoPersona = "M" Then
                                pnlFiscaFiscales.Visible = False
                                pnlDatosMoralFiscales.Visible = True
                                pnlApellidoPaternoFiscal.Visible = False
                            End If
                        End If
                        If ddlRegimenFiscal.Items.FindByValue(datosFiscales.RegimenFiscal) IsNot Nothing Then
                            ddlRegimenFiscal.SelectedValue = datosFiscales.RegimenFiscal
                        End If
                    End If

                    pnlTabla.Visible = False
                    pnlAgregar.Visible = True
                    pnlAdminCliente.Visible = False
                    PnlAsignarSIM.Visible = False
                    PnlBotonSIM.Visible = True
                    PnlBotonDatos.Visible = True
                    pnlPassword.Visible = False
                    PnlBotonGuardarCancelar.Visible = True
                    pnlSIMDisponibles.Visible = False
                    CargarSIMAsignadas()
                    lblTitulo.Text = "Editar Cliente"
                End If

            ElseIf e.CommandName = "BajaCliente" Then
                Dim clienteId As Integer = Convert.ToInt32(e.CommandArgument)
                Dim controller As New ControllerCliente()
                Dim resultado As Integer = controller.BajaCliente(clienteId)

                If resultado > 0 Then
                    MostrarMensaje("✅ Cliente dado de baja correctamente.", "success")
                Else
                    MostrarMensaje("❌ No se pudo dar de baja el cliente.", "danger")
                End If
                lblMensaje.Visible = True
                CargarClientes()
            End If
        Catch ex As Exception
            lblMensaje.Text = "❌ Error: " & ex.Message
            lblMensaje.CssClass = "alert alert-danger"
            lblMensaje.Visible = True
        End Try
    End Sub

    Private Sub CargarSimDisponible()
        Dim controllerSim As New ControllerSIM
        Dim sim As List(Of SIM) = controllerSim.ObtenerSIM()
        If sim IsNot Nothing AndAlso sim.Count > 0 Then
            lblICCID.Text = sim(0).ICCID
            lblMSISDN.Text = sim(0).MSISDN
            lblEstadoSIM.Text = sim(0).Estado
        Else
            lblICCID.Text = "No hay SIM disponible"
            lblMSISDN.Text = "-"
            lblEstadoSIM.Text = "-"
        End If
        PnlBotonGuardarCancelar.Visible = False


    End Sub

    Protected Sub btnDatosGenerales_Click(sender As Object, e As EventArgs)
        pnlSeccionGenerales.Visible = True
        pnlSeccionFiscales.Visible = False
        PnlAsignarSIM.Visible = False
        PnlBotonGuardarCancelar.Visible = True
    End Sub

    Protected Sub btnDatosFiscales_Click(sender As Object, e As EventArgs)
        pnlSeccionGenerales.Visible = False
        pnlSeccionFiscales.Visible = True
        PnlAsignarSIM.Visible = False
        PnlBotonGuardarCancelar.Visible = True
    End Sub

    Protected Sub btnAsignarSIM_Click(sender As Object, e As EventArgs)
        pnlSeccionGenerales.Visible = False
        pnlSeccionFiscales.Visible = False
        PnlAsignarSIM.Visible = True
        CargarSimDisponible()
        PnlBotonGuardarCancelar.Visible = True
    End Sub

    Protected Sub BtnNuevaSIM_Click(sender As Object, e As EventArgs)
        CargarListaDeSIMDisponibles()
        CargarSIMAsignadas()
        PnlAsignarSIM.Visible = True
    End Sub

    Private Sub CargarListaDeSIMDisponibles()
        Dim controllerSim As New ControllerSIM
        Dim listaSim As List(Of SIM) = controllerSim.ObtenerSIMDisponibles()

        If listaSim IsNot Nothing AndAlso listaSim.Count > 0 Then
            gvSIMDisponibles.DataSource = listaSim
            gvSIMDisponibles.DataBind()
            pnlSIMDisponibles.Visible = True
        Else
            pnlSIMDisponibles.Visible = False
        End If
    End Sub

    Protected Sub gvSIMDisponibles_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "AsignarSIM" Then
            Dim simId As Integer = Convert.ToInt32(e.CommandArgument)
            Dim clienteId As Integer = Convert.ToInt32(hdnClienteId.Value)

            Dim controllerSim As New ControllerSIM
            Dim resultado As Boolean = controllerSim.AsignarSIM(simId, clienteId)

            If resultado Then
                MostrarMensaje("✅ SIM asignada correctamente.", "success")


                CargarSIMAsignadas()
                CargarSimDisponible()
                pnlSIMDisponibles.Visible = False
            Else
                MostrarMensaje("❌ Error al asignar la SIM.", "danger")
            End If
        ElseIf e.CommandName = "VerDetalle" Then
            Dim simId As Integer = Convert.ToInt32(e.CommandArgument)
            MostrarDetalleSIM(simId)
        End If
    End Sub

    Private Sub CargarSIMAsignadas()
        If Not String.IsNullOrWhiteSpace(hdnClienteId.Value) AndAlso IsNumeric(hdnClienteId.Value) Then
            Dim clienteId As Integer = Convert.ToInt32(hdnClienteId.Value)
            Dim controllerSim As New ControllerSIM
            Dim listaSimAsignadas As List(Of SIM) = controllerSim.ObtenerSIMPorCliente(clienteId)

            If listaSimAsignadas IsNot Nothing AndAlso listaSimAsignadas.Count > 0 Then
                gvSIMAsignadas.DataSource = listaSimAsignadas
                gvSIMAsignadas.DataBind()
            Else
                gvSIMAsignadas.DataSource = Nothing
                gvSIMAsignadas.DataBind()
            End If
        End If
    End Sub

    Protected Sub gvSIMAsignadas_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "VerDetalle" Then
            Dim simId As Integer = Convert.ToInt32(e.CommandArgument)
            MostrarDetalleSIM(simId)
        ElseIf e.CommandName = "AsignarOferta" Then
            Dim simId As Integer = Convert.ToInt32(e.CommandArgument)
            hdnSIMId.Value = simId

            Dim controllerOferta As New ControllerOferta
            Dim listaOfertas = controllerOferta.ObtenerOfertas()

            gvOfertas.DataSource = listaOfertas
            gvOfertas.DataBind()


            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "MostrarModalOfertas",
        "var modal = new bootstrap.Modal(document.getElementById('modalOfertas')); modal.show();", True)

        End If
    End Sub

    Private Sub MostrarDetalleSIM(simId As Integer)
        Dim controllerSim As New ControllerSIM
        Dim controllerOferta As New ControllerOferta
        Dim sim As SIM = controllerSim.ObtenerSIMPorID(simId)
        Dim oferta As Oferta = Nothing
        If sim.OfertaId.HasValue Then
            oferta = controllerOferta.ObtenerOferta(sim.OfertaId)
        End If

        If sim IsNot Nothing Then
            lblModalICCID.InnerText = sim.ICCID
            lblModalMSISDN.InnerText = sim.MSISDN
            lblModalEstado.InnerText = sim.Estado
            lblModalPlan.InnerText = If(oferta IsNot Nothing, oferta.Oferta, "-")

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "MostrarModal", "var myModal = new bootstrap.Modal(document.getElementById('modalDetalleSIM')); myModal.show();", True)
        End If
    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        LimpiarCampos()
        pnlAgregar.Visible = False
        pnlTabla.Visible = True
        pnlAdminCliente.Visible = True
        PnlBotonDatos.Visible = False
        PnlBotonSIM.Visible = False

        pnlSeccionGenerales.Visible = True
        pnlSeccionFiscales.Visible = False
        PnlAsignarSIM.Visible = False
        PnlBotonGuardarCancelar.Visible = False
        pnlSIMDisponibles.Visible = False
        OcultarMensaje()
    End Sub

    Private Sub LimpiarCampos()
        hdnClienteId.Value = ""

        txtNombre.Text = ""
        txtApellidoPaterno.Text = ""
        txtApellidoMaterno.Text = ""
        txtFechaAlta.Text = DateTime.Now.ToString("yyyy-MM-dd")
        txtFechaCumpleanios.Text = ""
        ddlTipoPersona.SelectedIndex = 0
        ddlEstatus.SelectedIndex = 0
        txtCURP.Text = ""
        txtTelefono.Text = ""
        txtEmail.Text = ""
        tbPassword.Text = ""       
        txtRFC.Text = ""
        txtRfcFacturacion.Text = ""
        txtNombreRazonSocial.Text = ""
        txtCPFacturacion.Text = ""
        txtUsoComprobante.Text = ""

        OcultarMensaje()
    End Sub

    <WebMethod()>
    Public Shared Function VerificarEmailExistente(email As String, clienteId As Integer) As Boolean
        If clienteId < 0 Then clienteId = 0

        If String.IsNullOrEmpty(email) OrElse Not email.Contains("@") Then
            Return False
        End If

        Dim controller As New ControllerCliente()
        Dim cliente = controller.ObtenerClientePorEmail(email)

        If cliente IsNot Nothing AndAlso cliente.ClienteId <> clienteId Then
            Return True
        End If

        Return False
    End Function

    Protected Sub txtBuscarClientes_TextChanged(sender As Object, e As EventArgs) Handles txtBuscarClientes.TextChanged
        Dim texto As String = txtBuscarClientes.Text.Trim()
        CargarClientes(texto)
    End Sub

    Protected Sub gvOfertas_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvOfertas.RowCommand
        If e.CommandName = "SeleccionarOferta" Then

            Dim ofertaId As Integer = Convert.ToInt32(e.CommandArgument)
            Dim simId As Integer = Convert.ToInt32(hdnSIMId.Value)

            Dim controllerSim As New ControllerSIM
            Dim resultado As Boolean = controllerSim.AsignarOferta(simId, ofertaId)

            If resultado Then
                MostrarMensaje("✅ Oferta asignada correctamente.", "success")

            Else
                MostrarMensaje("❎ Error al asignar Oferta", "success")

            End If

            lblMensaje.Visible = True

            CargarSIMAsignadas()

        End If
    End Sub

    Private Sub ddlTipoPersonaRegimen_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTipoPersonaRegimen.SelectedIndexChanged
        llenaRegimen()
    End Sub
    Public Sub llenaRegimen()
        Dim regimen As New RegimenFiscal

        If ddlTipoPersonaRegimen.SelectedValue = "F" Then
            ddlRegimenFiscal.DataSource = regimen.RegimenFiscalFisica

        ElseIf ddlTipoPersonaRegimen.SelectedValue = "M" Then

            ddlRegimenFiscal.DataSource = regimen.RegimenFiscalMoral

        End If


        ddlRegimenFiscal.DataTextField = "Descripcion"
        ddlRegimenFiscal.DataValueField = "CodigoRegimenFiscal"
        ddlRegimenFiscal.DataBind()
    End Sub

    Protected Sub ddlTipoPersona_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlTipoPersona.SelectedIndexChanged
        If ddlTipoPersona.SelectedValue = "F" Then
            pnlFisica.Visible = True
            pnlPassword.Visible = True
            pnlFisicaFecha.Visible = True
            pnlRFC.Visible = True

        ElseIf ddlTipoPersona.SelectedValue = "M" Then
            pnlFisica.Visible = False
            pnlPassword.Visible = True
            pnlFisicaFecha.Visible = False
            pnlRFC.Visible = True

        End If
    End Sub

    Protected Sub ddlTipoPersonaRegimen_SelectedIndexChanged1(sender As Object, e As EventArgs)
        If ddlTipoPersonaRegimen.SelectedValue = "F" Then
            pnlFiscaFiscales.Visible = True
            pnlDatosMoralFiscales.Visible = True
            pnlApellidoPaternoFiscal.Visible = True

        ElseIf ddlTipoPersonaRegimen.SelectedValue = "M" Then
            pnlFiscaFiscales.Visible = False
            pnlDatosMoralFiscales.Visible = True
            pnlApellidoPaternoFiscal.Visible = False

        End If
    End Sub

    Protected Sub CargarPaises()
        Dim controller As New ControllerPaisesEstados
        Dim listaPaises As List(Of PaisesEstados) = controller.ObtenerPaises

        ddlPaisFiscal.DataSource = listaPaises
        ddlPaisFiscal.DataTextField = "Pais"
        ddlPaisFiscal.DataValueField = "CodigoPais"
        ddlPaisFiscal.DataBind()
    End Sub
    Protected Sub ddlPaisFiscal_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim codigoPais As String = ddlPaisFiscal.SelectedValue
        CargarEstados(codigoPais)
    End Sub

    Protected Sub CargarEstados(codigoPais As String)
        Dim controller As New ControllerPaisesEstados()
        Dim listaEstados As List(Of PaisesEstados) = controller.ObtenerEstadosPorPais(codigoPais)

        ddlEstadoFiscal.DataSource = listaEstados
        ddlEstadoFiscal.DataTextField = "Estado"
        ddlEstadoFiscal.DataValueField = "CodigoEstado"
        ddlEstadoFiscal.DataBind()

    End Sub

    Protected Sub ddlEstadoFiscal_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim codigoPais As String = ddlPaisFiscal.SelectedValue
        Dim codigoEstado As String = ddlEstadoFiscal.SelectedValue
        CargarMunicipios(codigoPais, codigoEstado)
    End Sub

    Protected Sub CargarMunicipios(codigoPais As String, codigoEstado As String)
        Dim controller As New ControllerPaisesEstados()
        Dim listaMunicipios As List(Of PaisesEstados) = controller.ObtenerMunicipiosPorEstado(codigoPais, codigoEstado)

        ddlCiudadFiscal.DataSource = listaMunicipios
        ddlCiudadFiscal.DataTextField = "Municipio"
        ddlCiudadFiscal.DataValueField = "CodigoMunicipio"
        ddlCiudadFiscal.DataBind()

    End Sub

    Protected Function ObtenerNombreCompleto(tipo As Object, nombre As Object, apePat As Object, apeMat As Object, razon As Object) As String
        If tipo.ToString() = "F" Then
            Return String.Format("{0} {1} {2}", nombre, apePat, apeMat)
        Else
            Return razon.ToString()
        End If
    End Function

    Private Sub MostrarMensaje(texto As String, tipo As String)
        ' tipo = "success", "danger", "warning", "info"
        lblMensaje.Text = texto
        lblMensaje.CssClass = "alert alert-" & tipo & " w-100 d-block mb-3"
        lblMensaje.Visible = True
    End Sub

    Private Sub OcultarMensaje()
        lblMensaje.Visible = False
        lblMensaje.Text = ""
    End Sub

    Protected Sub gvClientes_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        Dim controller As New ControllerCliente
        Dim listaClientes As List(Of Cliente) = controller.GetClientes()

        gvClientes.PageIndex = e.NewPageIndex
        gvClientes.DataSource = listaClientes
        gvClientes.DataBind()
    End Sub

End Class