Public Class Registros
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Session("Nombre") = txtNombre.Text
        Session("ApellidoPaterno") = txtApellidoPaterno.Text
        Session("ApellidoMaterno") = txtApellidoMaterno.Text
        Session("FechaNacimiento") = txtFechaNacimiento.Text
        Session("TipoPersona") = ddlTipoPersona.SelectedValue
        Session("CURP") = txtCurp.Text
        Session("Telefono") = txtTelefono.Text
        Session("Email") = txtEmail.Text
        Session("FechaAlta") = txtFechaAlta.Text
        Session("Contrasena") = txtContrasena.Text
        Session("Colonia") = txtColonia.Text
        Session("Direccion") = txtDireccion.Text
        Session("CP") = txtCP.Text
        Session("RFC") = txtRFC.Text
        Session("RFCFacturacion") = txtRFCFacturacion.Text
        Session("NombreRazonSocial") = txtNombreRazonSocial.Text
        Session("CPFacturacion") = txtCPFacturacion.Text
        Session("RegimenFiscal") = ddlRegimenFiscal.SelectedValue
        Response.Redirect("~/Views/Account/ValidarDatos.aspx")
    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/Planes/ContratarPlan.aspx")
    End Sub
End Class