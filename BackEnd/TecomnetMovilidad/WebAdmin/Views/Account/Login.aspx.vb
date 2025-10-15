Imports DatabaseConnection
Imports Models.TECOMNET

Public Class login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            lblMensaje.Visible = False
        End If
    End Sub
    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        IniciarSesion()
    End Sub

    Private Sub IniciarSesion()
        Dim controllerUsuario As New ControllerUsuario
        Dim passwordCifrada As String = Securyty.Cifrar(txtPassword.Text.Trim())
        Dim usuario As Usuario = controllerUsuario.LoginUsuario(txtEmail.Text.Trim(), passwordCifrada)

        If usuario IsNot Nothing Then
            Session("UsuarioID") = usuario.UsuarioID
            Session("Nombre") = usuario.Nombre
            Session("Email") = usuario.Email
            Response.Redirect("~/Views/General/AdminUsuarios.aspx")
        Else
            lblMensaje.Text = "Correo o contraseña incorrectos."
            lblMensaje.CssClass = "alert alert-danger"
            lblMensaje.Visible = True

            Dim script As String = "<script>setTimeout(function(){document.getElementById('" & lblMensaje.ClientID & "').style.display='none';}, 3000);</script>"
            ClientScript.RegisterStartupScript(Me.GetType(), "HideLabel", script)
        End If
    End Sub
End Class