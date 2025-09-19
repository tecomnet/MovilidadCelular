Public Class ValidarDatos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            lblNombre.Text = Session("Nombre")
            lblApellidoPaterno.Text = Session("ApellidoPaterno")
            lblApellidoMaterno.Text = Session("ApellidoMaterno")
            lblFechaNacimiento.Text = Session("FechaNacimiento")
            lblTipoPersona.Text = Session("TipoPersona")
            lblCURP.Text = Session("CURP")
            lblTelefono.Text = Session("Telefono")
            lblEmail.Text = Session("Email")
            lblDireccion.Text = Session("Direccion")
            lblColonia.Text = Session("Colonia")
            lblCP.Text = Session("CP")
            lblRFC.Text = Session("RFC")
            lblRegimenFiscal.Text = Session("RegimenFiscal")
        End If
    End Sub

    Protected Sub btnConfirmar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/SIM/CompraSim.aspx")
    End Sub

    Protected Sub btnRegresar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/Account/Registros.aspx")
    End Sub
End Class