Imports DatabaseConnection
Imports Models.TECOMNET

Public Class AdminUsuarios
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarUsuarios()
        End If
    End Sub

    Protected Sub btnAgregarUsuario_Click(sender As Object, e As EventArgs)

        pnlTabla.Visible = False
        pnlAgregar.Visible = True
        pnlAdminUsuarios.Visible = False
        lblTitulo.Text = "Usuario Nuevo"
        LimpiarFormulario()

    End Sub

    Private Sub CargarUsuarios()
        Dim controller As New ControllerUsuario
        Dim listaUsuarios As List(Of Usuario) = controller.ObtenerUsuarios()

        gvUsuarios.DataSource = listaUsuarios
        gvUsuarios.DataBind()
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Dim controllerUsuario As New ControllerUsuario
        Dim objUsuario As New Usuario

        objUsuario.NombreUsuario = txtNombreUsuario.Text.Trim()
        objUsuario.Nombre = txtNombre.Text.Trim()
        objUsuario.Email = txtCorreo.Text.Trim()
        objUsuario.NumeroTelefono = txtTelefono.Text.Trim()
        If Not String.IsNullOrEmpty(hdnUsuarioID.Value) Then
            objUsuario.UsuarioID = Convert.ToInt32(hdnUsuarioID.Value)

            If String.IsNullOrWhiteSpace(tbPassword.Text) Then
                objUsuario.PasswordHash = Nothing
            Else
                objUsuario.PasswordHash = Securyty.Cifrar(tbPassword.Text)
            End If
        Else
            objUsuario.UsuarioID = 0
            objUsuario.PasswordHash = Securyty.Cifrar(tbPassword.Text)
        End If

        objUsuario.TipoUsuario = CType([Enum].Parse(GetType(Enumeraciones.TipoUsuario), ddlTipoPersona.SelectedValue), Enumeraciones.TipoUsuario)
        If Not String.IsNullOrWhiteSpace(txtFechaAlta.Text) Then
            objUsuario.FechaAlta = Date.Parse(txtFechaAlta.Text)
        Else
            objUsuario.FechaAlta = Nothing
        End If

        If Not String.IsNullOrEmpty(hdnUsuarioID.Value) Then
            objUsuario.UsuarioID = Convert.ToInt32(hdnUsuarioID.Value)
        Else
            objUsuario.UsuarioID = 0
        End If

        If objUsuario.UsuarioID = 0 Then
            Dim nuevoID As Integer = controllerUsuario.AgregarUsuario(objUsuario)
            hdnUsuarioID.Value = nuevoID.ToString()
        Else
            controllerUsuario.AtualizarUsuario(objUsuario)
        End If


        pnlAgregar.Visible = False
        pnlTabla.Visible = True
        pnlAdminUsuarios.Visible = True

        CargarUsuarios()

    End Sub

    Private Sub gvUsuarios_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvUsuarios.RowCommand
        If e.CommandName = "EditarUsuario" Then
            Dim UsuarioId As Integer = Convert.ToInt32(e.CommandArgument)
            Dim controller As New ControllerUsuario()
            Dim usuario As Usuario = controller.ObtenerUsuario(UsuarioId)

            If usuario IsNot Nothing Then
                hdnUsuarioID.Value = usuario.UsuarioID.ToString()
                txtNombreUsuario.Text = usuario.NombreUsuario
                txtNombre.Text = usuario.Nombre
                txtCorreo.Text = usuario.Email
                tbPassword.Text = String.Empty
                txtTelefono.Text = usuario.NumeroTelefono

                ddlTipoPersona.SelectedValue = usuario.TipoUsuario.ToString()

                If usuario.FechaAlta <> Date.MinValue Then
                    txtFechaAlta.Text = usuario.FechaAlta.ToString("yyyy-MM-dd")
                Else
                    txtFechaAlta.Text = ""
                End If

                pnlAgregar.Visible = True
                pnlTabla.Visible = False
                pnlAdminUsuarios.Visible = False
                lblTitulo.Text = "Editar Usuario"

            End If
        ElseIf e.CommandName = "BajaUsuario" Then
            Dim UsuarioId As Integer = Convert.ToInt32(e.CommandArgument)
            Dim controller As New ControllerUsuario()
            Dim resultado As Integer = controller.DesactivaUsuario(UsuarioId)

            If resultado > 0 Then
                lblMensaje.Text = "✅ Usuario dado de baja correctamente."
                lblMensaje.CssClass = "alert alert-success"
                lblMensaje.Visible = True
            Else
                lblMensaje.Text = "❌ No se pudo dar de baja el usuario."
                lblMensaje.CssClass = "alert alert-danger"
                lblMensaje.Visible = True
            End If

            CargarUsuarios()

        End If
    End Sub

    Private Sub LimpiarFormulario()
        hdnUsuarioID.Value = ""
        txtNombreUsuario.Text = ""
        txtNombre.Text = ""
        txtCorreo.Text = ""
        txtTelefono.Text = ""
        tbPassword.Text = String.Empty
        ddlTipoPersona.SelectedIndex = 0
        txtFechaAlta.Text = ""
    End Sub

End Class