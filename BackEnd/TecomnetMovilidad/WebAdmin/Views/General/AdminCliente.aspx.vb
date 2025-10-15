Imports DatabaseConnection
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones

Public Class AdminCliente
    Inherits System.Web.UI.Page
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarClientes()
            CargarSIMAsignadas()
            CargarSimDisponible()
        End If
    End Sub

    Protected Sub btnAgregarCliente_Click(sender As Object, e As EventArgs)
        pnlTabla.Visible = False
        pnlAgregar.Visible = True
        pnlAdminCliente.Visible = False
        lblTitulo.Text = "Cliente Nuevo"
        PnlBotonDatos.Visible = True

    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Dim controllerClientes As New ControllerCliente
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
        objClientes.FechaAlta = Date.Now
        objClientes.Estatus = CType(Convert.ToInt32(ddlEstatus.SelectedValue), EstatusCliente)
        objClientes.ContrasenaHash = Securyty.Cifrar(tbPassword.Text)
        objClientes.Estado = txtEstado.Text
        objClientes.Colonia = txtColonia.Text
        objClientes.Direccion = txtDireccion.Text
        objClientes.CP = txtCP.Text

        objClientes.RFC = txtRFC.Text
        objClientes.RFCFacturacion = txtRfcFacturacion.Text
        objClientes.NombreRazonSocial = txtNombreRazonSocial.Text
        objClientes.CPFacturacion = txtCPFacturacion.Text
        objClientes.RegimenFiscal = txtRegimenFiscal.Text
        objClientes.UsoDeComprobante = txtUsoComprobante.Text

        If objClientes.ClienteId = 0 Then
            Dim cliente As Integer = controllerClientes.AddCliente(objClientes)
            hdnClienteId.Value = cliente.ToString()
            pnlAgregar.Visible = False
            PnlBotonDatos.Visible = True
            PnlBotonGuardarCancelar.Visible = True
            CargarSimDisponible()
        Else
            Dim actualizado As Integer = controllerClientes.UpdateCliente(objClientes)
            If actualizado > 0 Then
                lblMensaje.Text = "✅ Cliente actualizado correctamente."
                lblMensaje.CssClass = "alert alert-success"
                lblMensaje.Visible = True
            Else
                lblMensaje.Text = "❌ Error al actualizar el cliente."
                lblMensaje.CssClass = "alert alert-danger"
                lblMensaje.Visible = True
            End If
            pnlAgregar.Visible = False
            lblTitulo.Text = "Editar Cliente"
            pnlTabla.Visible = True
            pnlAdminCliente.Visible = False
            PnlBotonSIM.Visible = False
            CargarClientes()

        End If
    End Sub
    Private Sub CargarClientes()
        Dim controller As New ControllerCliente
        Dim listaClientes As List(Of Cliente) = controller.GetClientes()
        gvClientes.DataSource = listaClientes
        gvClientes.DataBind()
        PnlBotonDatos.Visible = False
    End Sub

    Protected Sub gvClientes_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvClientes.RowCommand
        Try
            If e.CommandName = "EditarCliente" Then
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
                    End If
                    txtCURP.Text = cliente.CURP
                    txtTelefono.Text = cliente.Telefono
                    txtEmail.Text = cliente.Email

                    If ddlEstatus.Items.FindByValue(CInt(cliente.Estatus).ToString()) IsNot Nothing Then
                        ddlEstatus.SelectedValue = CInt(cliente.Estatus).ToString()
                    End If

                    tbPassword.Text = cliente.ContrasenaHash
                    txtEstado.Text = cliente.Estado
                    txtColonia.Text = cliente.Colonia
                    txtDireccion.Text = cliente.Direccion
                    txtCP.Text = cliente.CP
                    txtRFC.Text = cliente.RFC
                    txtRfcFacturacion.Text = cliente.RFCFacturacion
                    txtNombreRazonSocial.Text = cliente.NombreRazonSocial
                    txtCPFacturacion.Text = cliente.CPFacturacion
                    txtRegimenFiscal.Text = cliente.RegimenFiscal
                    txtUsoComprobante.Text = cliente.UsoDeComprobante

                    pnlTabla.Visible = False
                    pnlAgregar.Visible = True
                    pnlAdminCliente.Visible = False
                    PnlAsignarSIM.Visible = False
                    PnlBotonSIM.Visible = True
                    PnlBotonDatos.Visible = True
                    pnlPassword.Visible = False
                    CargarSIMAsignadas()
                    lblTitulo.Text = "Editar Cliente"
                End If

            ElseIf e.CommandName = "BajaCliente" Then
                Dim clienteId As Integer = Convert.ToInt32(e.CommandArgument)
                Dim controller As New ControllerCliente()
                Dim resultado As Integer = controller.BajaCliente(clienteId)

                If resultado > 0 Then
                    lblMensaje.Text = "✅ Cliente dado de baja correctamente."
                    lblMensaje.CssClass = "alert alert-success"
                Else
                    lblMensaje.Text = "❌ No se pudo dar de baja el cliente."
                    lblMensaje.CssClass = "alert alert-danger"
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
        PnlBotonGuardarCancelar.Visible = False
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
    End Sub

    Protected Sub BtnNuevaSIM_Click(sender As Object, e As EventArgs)
        CargarListaDeSIMDisponibles()
        CargarSIMAsignadas()
        PnlAsignarSIM.Visible = True
        pnlSIMDisponibles.Visible = True
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
                lblMensaje.Text = "✅ SIM asignada correctamente al cliente."
                lblMensaje.CssClass = "alert alert-success"
                lblMensaje.Visible = True

                CargarSIMAsignadas()
                CargarSimDisponible()
                pnlSIMDisponibles.Visible = False
            Else
                lblMensaje.Text = "❌ Error al asignar la SIM."
                lblMensaje.CssClass = "alert alert-danger"
                lblMensaje.Visible = True
            End If
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



End Class