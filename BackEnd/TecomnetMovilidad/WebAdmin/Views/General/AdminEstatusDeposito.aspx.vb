Imports DatabaseConnection
Imports Models.TECOMNET

Public Class AdminEstatusDeposito
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarEstatus()
        End If
    End Sub

    Private Sub CargarEstatus()
        Dim controller As New ControllerEstatusDeposito
        Dim listaEstatusDeposito As List(Of EstatusDeposito) = controller.ObtenerEstatusDeposito

        gvEstatusDeposito.DataSource = listaEstatusDeposito
        gvEstatusDeposito.DataBind()
        pnlAdminEstatusDeposito.Visible = True
    End Sub


    Protected Sub gvEstatusDeposito_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvEstatusDeposito.RowCommand
        Try
            If e.CommandName = "Editar" Then
                Dim estatusDepositoId As Integer = Convert.ToInt32(e.CommandArgument)
                Dim controller As New ControllerEstatusDeposito()
                Dim estatusDeposito As EstatusDeposito = controller.ObtenerEstatusDepositoPorID(estatusDepositoId)

                If estatusDeposito IsNot Nothing Then
                    hdnEstatusDeposito.Value = estatusDeposito.EstatusDepositoID.ToString()

                    txtEstatus.Text = estatusDeposito.Estatus
                    txtDescripcion.Text = estatusDeposito.Descripcion


                    PnlTabla.Visible = False
                    PnlAgregarEstatusDeposito.Visible = True
                    pnlAdminEstatusDeposito.Visible = False
                    lblTitulo.Text = "Editar Estatus Deposito"
                End If
            End If
        Catch ex As Exception
            lblMensaje.Text = "❌ Error: " & ex.Message
            lblMensaje.CssClass = "alert alert-danger"
            lblMensaje.Visible = True
        End Try
    End Sub

    Protected Sub BtnAgregarEstatusDeposito_Click(sender As Object, e As EventArgs)
        PnlTabla.Visible = False
        PnlAgregarEstatusDeposito.Visible = True
        pnlAdminEstatusDeposito.Visible = False
        lblTitulo.Text = "Estatus Nuevo"
        limpiarFormulario()
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Dim controllerEstatusDeposito As New ControllerEstatusDeposito
        Dim objEstatusDeposito As New EstatusDeposito

        objEstatusDeposito.EstatusDepositoID = If(String.IsNullOrEmpty(hdnEstatusDeposito.Value), 0, Convert.ToInt32(hdnEstatusDeposito.Value))
        objEstatusDeposito.Estatus = txtEstatus.Text
        objEstatusDeposito.Descripcion = txtDescripcion.Text

        If objEstatusDeposito.EstatusDepositoID = 0 Then
            Dim estatusDeposito As Integer = controllerEstatusDeposito.AddEstatusDeposito(objEstatusDeposito)
            hdnEstatusDeposito.Value = estatusDeposito.ToString()
            PnlAgregarEstatusDeposito.Visible = False
            PnlTabla.Visible = True
            pnlAdminEstatusDeposito.Visible = True
        Else
            Dim actualizado As Integer = controllerEstatusDeposito.UpdateEstatusDeposito(objEstatusDeposito)
            If actualizado > 0 Then
                lblMensaje.Text = "✅ Cliente actualizado correctamente."
                lblMensaje.CssClass = "alert alert-success"
                lblMensaje.Visible = True
            Else
                lblMensaje.Text = "❌ Error al actualizar el cliente."
                lblMensaje.CssClass = "alert alert-danger"
                lblMensaje.Visible = True
            End If
            PnlAgregarEstatusDeposito.Visible = False
            lblTitulo.Text = "Editar Estatus"
            PnlTabla.Visible = True
            pnlAdminEstatusDeposito.Visible = False
            CargarEstatus()
        End If

    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        PnlAgregarEstatusDeposito.Visible = False
        PnlTabla.Visible = True
        pnlAdminEstatusDeposito.Visible = True
        LimpiarFormulario()
    End Sub

    Private Sub limpiarFormulario()
        hdnEstatusDeposito.Value = ""
        txtEstatus.Text = ""
        txtDescripcion.Text = ""
    End Sub
End Class