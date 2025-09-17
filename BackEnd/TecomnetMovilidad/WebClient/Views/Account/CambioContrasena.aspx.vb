Imports System.Text.Json
Imports Models.TECOMNET

Public Class CambioContrasena
    Inherits System.Web.UI.Page
#Region "Property"
    Private Property Customer As Cliente
        Get
            Return Session("Usuario")
        End Get
        Set(value As Cliente)
            Session("Usuario") = value
        End Set
    End Property
#End Region
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            lblError.Visible = False
            lblExito.Visible = False
        End If
    End Sub

    Protected Sub btnCambiar_Click(sender As Object, e As EventArgs)

        Dim objCambiarContrasena As New CambiarContrasena

        objCambiarContrasena.UserName = Customer.Email.Trim()
        objCambiarContrasena.Password = txtContrasenaActual.Text.Trim()
        objCambiarContrasena.NewPassword = txtNuevaContrasena.Text.Trim()

        If txtNuevaContrasena.Text.Trim() <> txtConfirmarContrasena.Text.Trim() Then
            lblError.Text = "Las contraseñas no coinciden."
            lblError.Visible = True
            Return

        End If

        Dim api As New ConsumoApis
        Dim resultado As New MessageResult

        resultado = api.PostCambiarContraseña(JsonSerializer.Serialize(objCambiarContrasena))

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            SuccessMessageDiv.Visible = True
            SuccessText.Text = "Cambio de contraseña exitoso"
            ErrorMessageDiv.Visible = False
        Else
            ErrorMessageDiv.Visible = True
            FailureText.Text = "No se pudo cambiar la contraseña. Intenta nuevamente"
            SuccessMessageDiv.Visible = False
        End If


    End Sub
End Class