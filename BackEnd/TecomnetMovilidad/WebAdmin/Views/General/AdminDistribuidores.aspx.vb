Imports System.Data.SqlClient
Imports DatabaseConnection
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones

Public Class AdminDistribuidores
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarDistribuidores()
        End If
    End Sub

    Protected Sub btnAgregarDistribuidor_Click(sender As Object, e As EventArgs)
        pnlTabla.Visible = False
        pnlAgregar.Visible = True
        pnlAdminDistribuidores.Visible = False
    End Sub

    Private Sub CargarDistribuidores()
        Dim controller As New ControllerDistribuidor
        Dim listaDistribuidores As List(Of Distribuidor) = controller.GetDistribuidor()
        gvDistribuidores.DataSource = listaDistribuidores
        gvDistribuidores.DataBind()
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Dim controllerDistribuidor As New ControllerDistribuidor
        Dim objDistribuidor As New Distribuidor

        objDistribuidor.DistribuidorID = If(String.IsNullOrEmpty(hdnDistribuidorID.Value), 0, Convert.ToInt32(hdnDistribuidorID.Value))
        objDistribuidor.Region = txtRegion.Text
        objDistribuidor.Nombre = txtNombre.Text
        objDistribuidor.Direccion = txtDireccion.Text
        objDistribuidor.NombreContacto = txtNombreContacto.Text
        objDistribuidor.TelefonoContacto = txtTelefonoContacto.Text
        objDistribuidor.EmailContacto = txtEmailContacto.Text
        objDistribuidor.FechaAlta = txtFechaAlta.Text

        objDistribuidor.RFC = txtRFC.Text
        objDistribuidor.TipoPersona = CType(Convert.ToInt32(ddlTipoPersona.SelectedValue), TipoPersona)
        objDistribuidor.DireccionFiscal = txtDireccionFiscal.Text
        objDistribuidor.PorcentajeComision = txtPorcentajeComision.Text
        objDistribuidor.Banco = txtBanco.Text
        objDistribuidor.Cuenta = txtCuenta.Text
        objDistribuidor.Beneficiario = txtBeneficiario.Text
        objDistribuidor.TipoDistribuidor = CType(Convert.ToInt32(ddlTipoDistribuidor.SelectedValue), TipoDistribuidor)

        If objDistribuidor.DistribuidorID = 0 Then
            Dim nuevoID As Integer = controllerDistribuidor.AddDistribuidor(objDistribuidor)
            If nuevoID > 0 Then
                Response.Redirect("AdminDistribuidores.aspx")
            Else
                lblError.Text = "❌ Ocurrió un error al guardar el distribuidor."
            End If
        Else
            Dim actualizado As Integer = controllerDistribuidor.UpdateDistribuidor(objDistribuidor)
            If actualizado > 0 Then
                Response.Redirect("AdminDistribuidores.aspx")
            Else
                lblError.Text = "❌ Ocurrió un error al actualizar el distribuidor."
            End If
        End If

        pnlAgregar.Visible = False
    End Sub

    Private Sub gvDistribuidores_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDistribuidores.RowCommand
        Try
            If e.CommandName = "EditarDistribuidor" Then
                Dim distribuidorId As Integer = Convert.ToInt32(e.CommandArgument)
                Dim controller As New ControllerDistribuidor()
                Dim distribuidor As Distribuidor = controller.ObtenerDistribuidorPorID(distribuidorId)

                If distribuidor IsNot Nothing Then
                    hdnDistribuidorID.Value = distribuidor.DistribuidorID.ToString()

                    txtRegion.Text = distribuidor.Region
                    txtNombre.Text = distribuidor.Nombre
                    txtDireccion.Text = distribuidor.Direccion
                    txtNombreContacto.Text = distribuidor.NombreContacto
                    txtTelefonoContacto.Text = distribuidor.TelefonoContacto
                    txtEmailContacto.Text = distribuidor.EmailContacto
                    txtRFC.Text = distribuidor.RFC
                    If ddlTipoPersona.Items.FindByValue(distribuidor.TipoPersona) IsNot Nothing Then
                        ddlTipoPersona.SelectedValue = distribuidor.TipoPersona
                    End If
                    txtDireccionFiscal.Text = distribuidor.DireccionFiscal
                    txtPorcentajeComision.Text = distribuidor.PorcentajeComision
                    txtBanco.Text = distribuidor.Banco
                    txtCuenta.Text = distribuidor.Cuenta
                    txtBeneficiario.Text = distribuidor.Beneficiario
                    If ddlTipoDistribuidor.Items.FindByValue(CInt(distribuidor.TipoDistribuidor).ToString()) IsNot Nothing Then
                        ddlTipoDistribuidor.SelectedValue = CInt(distribuidor.TipoDistribuidor).ToString()
                    End If

                    If distribuidor.FechaAlta <> Date.MinValue Then
                        txtFechaAlta.Text = distribuidor.FechaAlta.ToString("yyyy-MM-dd")
                    Else
                        txtFechaAlta.Text = ""
                    End If

                    pnlTabla.Visible = False
                    pnlAgregar.Visible = True
                    pnlAdminDistribuidores.Visible = False
                    lblTitulo.Text = "Editar Distribuidor"
                End If
            ElseIf e.CommandName = "BajaDistribuidor" Then
                Dim distribuidorId As Integer = Convert.ToInt32(e.CommandArgument)
                Dim controller As New ControllerDistribuidor()
                Dim resultado As Integer = controller.BajaDistribuidor(distribuidorId)

                If resultado > 0 Then
                    lblMensaje.Text = "✅ Cliente dado de baja correctamente."
                    lblMensaje.CssClass = "alert alert-success"
                Else
                    lblMensaje.Text = "❌ No se pudo dar de baja el cliente."
                    lblMensaje.CssClass = "alert alert-danger"
                End If
                lblMensaje.Visible = True
                CargarDistribuidores()
            End If
        Catch ex As Exception
            lblMensaje.Text = "❌ Error: " & ex.Message
            lblMensaje.CssClass = "alert alert-danger"
            lblMensaje.Visible = True
        End Try
    End Sub
End Class