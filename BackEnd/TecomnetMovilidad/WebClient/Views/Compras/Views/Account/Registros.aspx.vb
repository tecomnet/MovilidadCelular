Imports DatabaseConnection
Imports Models
Imports Models.TECOMNET
Imports System.Web.Services


Public Class Registros
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtFechaAlta.Text = DateTime.Now.ToString("yyyy-MM-dd")
            llenaRegimen()
            pnlDatosFisica.Visible = True
            CargarPaises()
        End If
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)

        Dim controllerClientes As New ControllerCliente
        Dim controllerDatosFiscales As New ControllerDatosFiscales

        Dim objCliente As New Cliente
        Dim objDatosFiscales As New DatosFiscales

        objCliente.Nombre = txtNombre.Text
        objCliente.ApellidoPaterno = txtApellidoPaterno.Text
        objCliente.ApellidoMaterno = txtApellidoMaterno.Text
        If Not String.IsNullOrWhiteSpace(txtFechaNacimiento.Text) Then
            objCliente.FechaCumpleanios = Date.Parse(txtFechaNacimiento.Text)
        Else
            objCliente.FechaCumpleanios = Nothing
        End If
        objCliente.TipoPersona = ddlTipoPersona.SelectedValue
        objCliente.CURP = txtCurp.Text
        objCliente.Telefono = txtTelefono.Text
        objCliente.Email = txtEmail.Text
        objCliente.FechaAlta = DateTime.Now
        objCliente.ContrasenaHash = txtContrasena.Text
        objCliente.Colonia = txtColonia.Text
        objCliente.Direccion = txtDireccion.Text
        objCliente.NombreRazonSocial = txtNombreCompleto.Text
        objCliente.CP = txtCP.Text
        objCliente.RFC = txtRFC.Text
        objCliente.RegimenFiscal = ddlRegimenFiscal.SelectedValue

        Dim clienteId As Integer = controllerClientes.AddCliente(objCliente)

        If clienteId <= 0 Then
            LblMensajeN.CssClass = "alert alert-danger"
            LblMensajeN.Text = "No se pudo guardar el cliente."
            LblMensajeN.Visible = True

            Dim script As String = "setTimeout(function() { " & LblMensajeN.ClientID & ".style.display='none'; }, 3000);"
            ClientScript.RegisterStartupScript(Me.GetType(), "OcultarMensaje", script, True)
            Exit Sub
        End If

        objDatosFiscales.ClienteId = clienteId
        objDatosFiscales.Nombre = txtNombreFiscal.Text
        objDatosFiscales.ApellidoPaterno = txtApellidoPaternoFiscal.Text
        objDatosFiscales.ApellidoMaterno = txtApellidoMaternoFiscal.Text
        objDatosFiscales.RazonSocial = txtRazonSocialFiscal.Text
        objDatosFiscales.RFCFacturacion = txtRFCFacturacion.Text
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


        Dim resultadoFiscal As Integer = controllerDatosFiscales.AddDatosFiscales(objDatosFiscales)

        If resultadoFiscal <= 0 Then
            LblMensajeN.CssClass = "alert alert-success"
            LblMensajeN.Text = "Cliente y datos fiscales guardados correctamente."
            LblMensajeN.Visible = True
        End If

        Session("Cliente") = objCliente
        Response.Redirect("~/Views/Compras/Views/Account/ValidarDatos.aspx")

    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/Compras/Views/Planes/ContratarPlan.aspx")
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

    Protected Sub ddlTipoPersona_SelectedIndexChanged(sender As Object, e As EventArgs)
        If ddlTipoPersona.SelectedValue = "F" Then
            pnlDatosFisica.Visible = True
        ElseIf ddlTipoPersona.SelectedValue = "M" Then
            pnlDatosFisica.Visible = False
        End If
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
End Class