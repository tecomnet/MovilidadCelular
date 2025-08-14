Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports Models.TECOMNET
Imports DatabaseConnection
Imports WebApi.TECOMNET.API
Imports Models.TECOMNET.API

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

                listTablero = objControlller.ObtenerPlanesPorCliente(ClienteId)

                If listTablero.Count = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No existen ofertas asociados al cliente."
                        })
                Else
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
    End Class
End Namespace