Imports Models.TECOMNET

Public Class ValidarDatos
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim objCliente As Cliente = TryCast(Session("Cliente"), Cliente)
            If objCliente IsNot Nothing Then
                lblNombre.Text = objCliente.Nombre
                lblApellidoPaterno.Text = objCliente.ApellidoPaterno
                lblApellidoMaterno.Text = objCliente.ApellidoMaterno
                lblFechaNacimiento.Text = If(objCliente.FechaCumpleanios.HasValue, objCliente.FechaCumpleanios.Value.ToString("yyyy-MM-dd"), "")
                lblTipoPersona.Text = objCliente.TipoPersona
                lblCURP.Text = objCliente.CURP
                lblTelefono.Text = objCliente.Telefono
                lblEmail.Text = objCliente.Email
                lblDireccion.Text = objCliente.Direccion
                lblColonia.Text = objCliente.Colonia
                lblCP.Text = objCliente.CP
                lblRFC.Text = objCliente.RFC
                lblRegimenFiscal.Text = objCliente.RegimenFiscal
            End If
        End If
    End Sub

    Protected Sub btnConfirmar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/Compras/Views/SIM/CompraSim.aspx")
    End Sub

    Protected Sub btnRegresar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/Compras/Views/Account/Registros.aspx")
    End Sub
End Class