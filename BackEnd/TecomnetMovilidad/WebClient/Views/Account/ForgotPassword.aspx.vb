Imports System.Text.Json
Imports Models.TECOMNET

Public Class ForgotPassword
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub btnEnviar_Click(sender As Object, e As EventArgs)

        Dim objEmail As New SolicitudCambioContrasena

        objEmail.email = txtCorreo.Text.Trim()

        If String.IsNullOrEmpty(objEmail.email) Then
            lblMensaje.ForeColor = Drawing.Color.Red
            lblMensaje.Text = "Por favor ingresa tu correo"
            Return

        End If

        Dim api As New ConsumoApis
        Dim resultado As New MessageResult

        resultado = api.PostSolicitudCambioContraseña(JsonSerializer.Serialize(objEmail))

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            SuccessMessageDiv.Visible = True
            SuccessText.Text = "Se ha enviado la contraseña correctamente"
            ErrorMessageDiv.Visible = False
        Else
            ErrorMessageDiv.Visible = True
            FailureText.Text = "El correo ingresado no existe. Inténtalo de nuevo."
            SuccessMessageDiv.Visible = False
        End If

    End Sub
End Class