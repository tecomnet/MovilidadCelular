Imports DatabaseConnection
Imports Models.TECOMNET

Public Class AdminMetodoPago
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarMetodoPago()
        End If
    End Sub
    Private Sub CargarMetodoPago()
        Dim controller As New ControllerMetodoPago
        Dim listaMetodoPago As List(Of MetodoPago) = controller.ObtenerMetodoPago

        gvMetodoPago.DataSource = listaMetodoPago
        gvMetodoPago.DataBind()
        PnlAdminMetodoPago.Visible = True
    End Sub
    Protected Sub BtnAgregarMetodoPago_Click(sender As Object, e As EventArgs)
        PnlTabla.Visible = False
        PnlAgregarMetodoPago.Visible = True
        PnlAdminMetodoPago.Visible = False
        lblTitulo.Text = "Método de Pago Nuevo"
        limpiarFormulario()
    End Sub


    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Dim controllerMetodoPago As New ControllerMetodoPago
        Dim objMetodoPago As New MetodoPago

        objMetodoPago.MetodoPagoID = If(String.IsNullOrEmpty(hdnMetodoPago.Value), 0, Convert.ToInt32(hdnMetodoPago.Value))
        objMetodoPago.NombreMetodo = txtNombreMetodo.Text
        objMetodoPago.Descripcion = txtDescripcion.Text

        If objMetodoPago.MetodoPagoID = 0 Then
            Dim metodoPago As Integer = controllerMetodoPago.AddMetodoPago(objMetodoPago)
            hdnMetodoPago.Value = metodoPago.ToString()
            PnlAgregarMetodoPago.Visible = False
            PnlTabla.Visible = True
            PnlAdminMetodoPago.Visible = False
            CargarMetodoPago()
        Else
            Dim actualizado As Integer = controllerMetodoPago.UpdateMetodoPago(objMetodoPago)
            If actualizado > 0 Then
                lblMensaje.Text = "✅ Método de pago actualizado correctamente."
                lblMensaje.CssClass = "alert alert-success"
                lblMensaje.Visible = True
            Else
                lblMensaje.Text = "❌ Error al actualizar el método de pago."
                lblMensaje.CssClass = "alert alert-danger"
                lblMensaje.Visible = True
            End If
            PnlAgregarMetodoPago.Visible = False
            lblTitulo.Text = "Editar Metodo Pago"
            PnlTabla.Visible = True
            PnlAdminMetodoPago.Visible = True
            CargarMetodoPago()
        End If
    End Sub

    Protected Sub gvMetodoPago_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvMetodoPago.RowCommand
        Try
            If e.CommandName = "Editar" Then
                Dim metodoPagoId As Integer = Convert.ToInt32(e.CommandArgument)
                Dim controller As New ControllerMetodoPago()
                Dim metodoPago As MetodoPago = controller.ObtenerMetodoPagoPorID(metodoPagoId)

                If metodoPago IsNot Nothing Then
                    hdnMetodoPago.Value = metodoPago.MetodoPagoID.ToString()

                    txtNombreMetodo.Text = metodoPago.NombreMetodo
                    txtDescripcion.Text = metodoPago.Descripcion


                    PnlTabla.Visible = False
                    PnlAgregarMetodoPago.Visible = True
                    PnlAdminMetodoPago.Visible = False
                    lblTitulo.Text = "Editar Estatus Deposito"
                End If
            End If
        Catch ex As Exception
            lblMensaje.Text = "❌ Error: " & ex.Message
            lblMensaje.CssClass = "alert alert-danger"
            lblMensaje.Visible = True
        End Try
    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        PnlAgregarMetodoPago.Visible = False
        PnlTabla.Visible = True
        PnlAdminMetodoPago.Visible = True
        LimpiarFormulario()
    End Sub
    Private Sub limpiarFormulario()
        hdnMetodoPago.Value = ""
        txtNombreMetodo.Text = ""
        txtDescripcion.Text = ""
    End Sub
End Class