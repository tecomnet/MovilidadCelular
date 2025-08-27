Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports Models.TECOMNET
Imports DatabaseConnection
Imports WebApi.TECOMNET.API
Imports Models.TECOMNET.API
Imports Models.TECOMNET.Enumeraciones
Imports Models.TECOMNET.AltanRedes
Imports System.Text.Json
Imports System.Threading.Tasks

Namespace Controllers.Clientes
    <Authorize>
    Public Class ClienteController
        Inherits ApiController

        <HttpPost>
        <Route("api/Cliente/Login")>
        Public Function Login(objLogin As LoginAccount) As HttpResponseMessage
            Try
                Dim objCliente As New Cliente
                Dim objControlller As New ControllerCliente

                If Not ModelState.IsValid Then
                    Return Request.CreateResponse(HttpStatusCode.Unauthorized, New With {
                        Key .mensaje = "Usuario o contraseña no valida."
                        })
                End If

                objCliente = objControlller.LoginCustomer(objLogin.UserName, Securyty.Cifrar(objLogin.Password))

                If Val(objCliente.ClienteId) = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.Unauthorized, New With {
                        Key .mensaje = "Usuario o contraseña no valida."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.OK, objCliente)
                End If

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                    Key .error = "Ocurrió un error al generar la solicitud.",
                    Key .detalle = ex.Message
                    })
                Return errorResponse
            End Try
        End Function
        <HttpGet>
        <Route("api/Cliente/Tablero/{ClienteId}")>
        Public Function Tablero(ClienteId As Integer) As HttpResponseMessage
            Try
                Dim listTablero As New List(Of Tablero)
                Dim objControlller As New ControllerCliente
                Dim objControlllerAltan As New ControllerAltanRedes
                Dim objResult As New MessageResult

                listTablero = objControlller.ObtenerPlanesPorCliente(ClienteId)

                If listTablero.Count = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No existen ofertas asociados al cliente."
                        })
                Else
                    For Each objTablero As Tablero In listTablero
                        objResult = objControlllerAltan.GetProfile(objTablero.MSISDN)
                        If objResult.ErrorID = TipoErroresAPI.Exito Then

                            Dim profile As New ResponseSubscriber
                            profile = JsonSerializer.Deserialize(Of ResponseSubscriber)(objResult.JSON)
                            objTablero.Estatus = profile.ResponseSubscriber.Status.SubStatus

                            If profile.ResponseSubscriber.FreeUnits.Count > 0 Then
                                objTablero.MBDisponibles = profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.UnusedAmt
                                objTablero.MBAsignados = profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.TotalAmt
                                objTablero.MBUsados = (profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.TotalAmt - profile.ResponseSubscriber.FreeUnits(0).FreeUnitDetails.UnusedAmt)
                                objTablero.MBAdicionales = 0
                            Else
                                objTablero.MBDisponibles = 0
                                objTablero.MBAsignados = 0
                                objTablero.MBUsados = 0
                                objTablero.MBAdicionales = 0
                            End If
                        Else
                            objTablero.Estatus = "No activo"
                            objTablero.MBDisponibles = 0
                            objTablero.MBAsignados = 0
                            objTablero.MBUsados = 0
                        End If
                    Next
                    Return Request.CreateResponse(HttpStatusCode.OK, listTablero)
                End If

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                    Key .error = "Ocurrió un error al generar la solicitud.",
                    Key .detalle = ex.Message
                    })
                Return errorResponse
            End Try
        End Function
        <HttpPost>
        <Route("api/Cliente/CambiaPassword")>
        Public Function CambiaPassword(objLogin As ChangePasswordAccount) As HttpResponseMessage
            Try
                Dim objCliente As New Cliente
                Dim objControlller As New ControllerCliente

                If Not ModelState.IsValid Then
                    Return Request.CreateResponse(HttpStatusCode.Unauthorized, New With {
                        Key .mensaje = "Usuario o contraseña no valida."
                        })
                End If

                objCliente.Email = objLogin.UserName
                objCliente.ContrasenaHash = Securyty.Cifrar(objLogin.Password)
                objCliente.NombreRazonSocial = Securyty.Cifrar(objLogin.NewPassword)

                If objControlller.CambiaPassword(objCliente) = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "Error al cambiar la contraseña, valida la información e intenta nuevamente."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.OK, New With {
                        Key .mensaje = "La contraseña se cambio correctamente"
                        })
                End If

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                    Key .error = "Ocurrió un error al generar la solicitud.",
                    Key .detalle = ex.Message
                    })
                Return errorResponse
            End Try
        End Function
        <HttpPost>
        <Route("api/Cliente/SolicitudCambioPassword")>
        Public Async Function SolicitudCambioPassword(objEmail As EmailRequest) As Task(Of HttpResponseMessage)
            Try
                Dim objCliente As New Cliente
                Dim objControlller As New ControllerCliente

                If Not ModelState.IsValid Then
                    Return Request.CreateResponse(HttpStatusCode.Unauthorized, New With {
                        Key .mensaje = "Modelo no valido."
                        })
                End If

                objCliente = objControlller.ObtenerClientePorEmail(objEmail.email)

                If objCliente.ClienteId = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "El correo no existe o no se pudo enviar la solicitud, intente nuevamente."
                        })
                Else

                    ' Generar token único
                    'Dim token As String = GenerarTokenSeguro()
                    'Dim expiracion As DateTime = DateTime.Now.AddHours(1)

                    '' Guardar token en BD
                    'Await tokenRepository.GuardarTokenAsync(Usuario.Id, token, expiracion)

                    '' Generar URL segura
                    'Dim urlReset As String = GenerarUrlReset(Usuario.Id, token)

                    If EmailSender.EnvioCorreo(objCliente.Nombre, "www.google.com", objCliente.Email, TipoDeEmail.SolicitudCambioContrasena) Then
                        Return Request.CreateResponse(HttpStatusCode.OK, New With {
                        Key .mensaje = "La solicitud fue enviada correctamente a su correo electronico, favor de revisar la carpeta de SPAM"
                        })
                    Else
                        Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "No se pudo enviar la solicitud, intente nuevamente."
                        })
                    End If
                End If

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                    Key .error = "Ocurrió un error al generar la solicitud.",
                    Key .detalle = ex.Message
                    })
                Return errorResponse
            End Try
        End Function
        'Private Function GenerarTokenSeguro() As String
        '    Using rng As New RNGCryptoServiceProvider()
        '        Dim tokenData(31) As Byte ' 256 bits
        '        rng.GetBytes(tokenData)
        '        Return Convert.ToBase64String(tokenData)
        '        .Replace("+", "-")
        '        .Replace("/", "_")
        '        .Replace("=", "")
        '    End Using
        'End Function
        Private Function GenerarUrlReset(usuarioId As Integer, token As String) As String
            Dim baseUrl As String = ConfigurationManager.AppSettings("BaseUrl")
            Return $"{baseUrl}/cambio-password.aspx?uid={usuarioId}&token={HttpUtility.UrlEncode(token)}"
        End Function
    End Class
End Namespace