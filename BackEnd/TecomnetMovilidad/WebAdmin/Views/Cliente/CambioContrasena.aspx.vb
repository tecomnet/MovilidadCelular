Imports System.Net.Http
Imports System.Net.Http.Headers
Imports Newtonsoft.Json

Public Class CambioContrasena
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ValidarToken()
        End If
    End Sub

    Private Async Sub ValidarToken()
        Try
            Dim usuarioId As Integer = Convert.ToInt32(Request.QueryString("uid"))
            Dim token As String = Server.UrlDecode(Request.QueryString("token"))

            If usuarioId = 0 OrElse String.IsNullOrEmpty(token) Then
                MostrarError("Parámetros inválidos")
                Return
            End If

            ' Validar token con API
            Using client As New HttpClient()
                client.BaseAddress = New Uri("https://tuapi.com/")
                client.DefaultRequestHeaders.Accept.Clear()

                Dim response As HttpResponseMessage = Await client.GetAsync($"api/password/validar-token?usuarioId={usuarioId}&token={token}")

                If response.IsSuccessStatusCode Then
                    Dim content As String = Await response.Content.ReadAsStringAsync()
                    'Dim resultado = JsonConvert.DeserializeObject(Of Dynamic)(content)

                    'If resultado.valido Then
                    '    ViewState("UsuarioId") = usuarioId
                    '    ViewState("Token") = token
                    '    pnlFormulario.Visible = True
                    'Else
                    '    MostrarError("El enlace ha expirado o es inválido")
                    'End If
                Else
                    MostrarError("Error al validar el enlace")
                End If
            End Using

        Catch ex As Exception
            MostrarError("Error: " & ex.Message)
        End Try
    End Sub

    Protected Async Sub btnCambiarPassword_Click(sender As Object, e As EventArgs)
        Try
            If txtNuevaPassword.Text <> txtConfirmarPassword.Text Then
                litMensajeError.Text = "Las contraseñas no coinciden"
                pnlError.Visible = True
                Return
            End If

            If txtNuevaPassword.Text.Length < 8 Then
                litMensajeError.Text = "La contraseña debe tener al menos 8 caracteres"
                pnlError.Visible = True
                Return
            End If

            Dim cambioRequest As New With {
                .UsuarioId = Convert.ToInt32(ViewState("UsuarioId")),
                .Token = ViewState("Token").ToString(),
                .NuevaPassword = txtNuevaPassword.Text,
                .ConfirmarPassword = txtConfirmarPassword.Text
            }

            Using client As New HttpClient()
                client.BaseAddress = New Uri("https://tuapi.com/")
                client.DefaultRequestHeaders.Accept.Clear()
                client.DefaultRequestHeaders.Accept.Add(New MediaTypeWithQualityHeaderValue("application/json"))

                Dim json = JsonConvert.SerializeObject(cambioRequest)
                Dim content As New StringContent(json, Encoding.UTF8, "application/json")

                Dim response As HttpResponseMessage = Await client.PostAsync("api/password/cambiar", content)

                If response.IsSuccessStatusCode Then
                    pnlFormulario.Visible = False
                    pnlExito.Visible = True
                Else
                    Dim errorContent As String = Await response.Content.ReadAsStringAsync()
                    'Dim errorObj = JsonConvert.DeserializeObject(Of Dynamic)(errorContent)
                    'litMensajeError.Text = errorObj.mensaje
                    pnlError.Visible = True
                End If
            End Using

        Catch ex As Exception
            litMensajeError.Text = "Error al cambiar contraseña: " & ex.Message
            pnlError.Visible = True
        End Try
    End Sub

    Private Sub MostrarError(mensaje As String)
        litMensajeError.Text = mensaje
        pnlTokenInvalido.Visible = True
        pnlFormulario.Visible = False
    End Sub

End Class