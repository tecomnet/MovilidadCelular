Imports DatabaseConnection
Imports Models.TECOMNET

Public Class Registros
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Dim controllerClientes As New ControllerCliente
        Dim objCliente As New Cliente

        objCliente.Nombre = txtNombre.Text
        objCliente.ApellidoPaterno = txtApellidoPaterno.Text
        objCliente.ApellidoMaterno = txtApellidoMaterno.Text
        objCliente.FechaCumpleanios = Convert.ToDateTime(txtFechaNacimiento.Text)
        objCliente.TipoPersona = ddlTipoPersona.SelectedValue
        objCliente.CURP = txtCurp.Text
        objCliente.Telefono = txtTelefono.Text
        objCliente.Email = txtEmail.Text
        objCliente.FechaAlta = Convert.ToDateTime(txtFechaAlta.Text)
        objCliente.ContrasenaHash = txtContrasena.Text
        objCliente.Colonia = txtColonia.Text
        objCliente.Direccion = txtDireccion.Text
        objCliente.CP = txtCP.Text
        objCliente.RFC = txtRFC.Text
        objCliente.RFCFacturacion = txtRFCFacturacion.Text
        objCliente.NombreRazonSocial = txtNombreRazonSocial.Text
        objCliente.CPFacturacion = txtCPFacturacion.Text
        objCliente.RegimenFiscal = ddlRegimenFiscal.SelectedValue

        If controllerClientes.AddCliente(objCliente) > 0 Then
            LblMensajeN.CssClass = "alert alert-success text-center"
            LblMensajeN.Text = "El registro se guardó correctamente."
            LblMensajeN.Visible = True

        Else
            LblMensajeN.CssClass = "mensaje-error"
            LblMensajeN.Text = "No se pudo guardar el registro."
            LblMensajeN.Visible = True
        End If
        Session("Cliente") = objCliente
        Response.Redirect("~/Views/Compras/Views/Account/ValidarDatos.aspx")
    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/Compras/Views/Planes/ContratarPlan.aspx")
    End Sub
End Class