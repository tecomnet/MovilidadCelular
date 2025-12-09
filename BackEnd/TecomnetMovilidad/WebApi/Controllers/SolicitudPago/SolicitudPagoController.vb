Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports DatabaseConnection
Imports Models.TECOMNET

Namespace Controllers.SolicitudPago
    <Authorize>
    Public Class SolicitudPagoController
        Inherits ApiController
        <HttpPost>
        <Route("api/RegistrarSolicitudDePago")>
        Public Function RechargeRequest(<FromBody> objSolicitudDePago As SolicitudDePago) As HttpResponseMessage
            Try
                If objSolicitudDePago Is Nothing Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "1",
                        Key .ErrorMessage = "Objeto no valido.",
                        Key .Description = "El objeto solicitud de pago no puede ser nulo."
                        })
                End If

                If String.IsNullOrEmpty(objSolicitudDePago.ICCID) Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "2",
                        Key .ErrorMessage = "Datos no validos.",
                        Key .Description = "El ICCID es obligatorio."
                        })
                ElseIf objSolicitudDePago.MetodoPagoID = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "2",
                        Key .ErrorMessage = "Datos no validos.",
                        Key .Description = "El metodo de pago es obligatorio."
                        })
                ElseIf objSolicitudDePago.OfertaIDActual = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "2",
                        Key .ErrorMessage = "Datos no validos.",
                        Key .Description = "La ofertaIDActual es obligatoria."
                        })
                ElseIf objSolicitudDePago.OfertaIDNueva = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "2",
                        Key .ErrorMessage = "Datos no validos.",
                        Key .Description = "La ofertaIDNueva es obligatoria."
                        })
                ElseIf objSolicitudDePago.Monto = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "2",
                        Key .ErrorMessage = "Datos no validos.",
                        Key .Description = "El monto es obligatorio."
                        })
                End If

                Dim objController As New ControllerSolicitudDePago
                Dim objPaymentRequests As New SolicitudDePago

                Dim nuevoGuid As Guid = Guid.NewGuid()
                Dim OrderID As String = String.Format("{0}|{1}", "TMV", nuevoGuid.ToString())

                objPaymentRequests.SolicitudID = 0
                objSolicitudDePago.OrderID = OrderID
                objSolicitudDePago.Estatus = "Created"
                objSolicitudDePago.FechaCreacion = Now
                objSolicitudDePago.EstatusDepositoID = 1
                objSolicitudDePago.IdTransaction = String.Empty
                objSolicitudDePago.AuthNumber = String.Empty
                objSolicitudDePago.AuthCode = String.Empty
                objSolicitudDePago.Reason = String.Empty
                objSolicitudDePago.PagoDepositoID = Nothing
                objSolicitudDePago.UltimaActualizacion = Now
                objSolicitudDePago.NumeroReintentos = 0

                objSolicitudDePago = objController.AgregaSolicitudDePago(objSolicitudDePago)

                If objSolicitudDePago.SolicitudID > 0 Then
                    Return Request.CreateResponse(HttpStatusCode.OK, New With {
                        Key .OrderID = objSolicitudDePago.OrderID,
                        Key .SolicitudID = objSolicitudDePago.SolicitudID
                        })
                End If

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "3",
                        Key .ErrorMessage = "Ocurrió un error al generar la solicitud.",
                        Key .Description = ex.Message
                        })
                Return errorResponse
            End Try

            Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "4",
                        Key .ErrorMessage = "Ocurrió un error al generar la solicitud.",
                        Key .Description = "Ocurrió un error al generar la solicitud."
                        })
        End Function
        <HttpGet>
        <Route("api/ObtenerSolicitudDePago/{OrderID}")>
        Public Function ObtenerSolicitudDePago(OrderID As String) As HttpResponseMessage
            Try
                If String.IsNullOrEmpty(OrderID) Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "1",
                        Key .ErrorMessage = "Valor obligatorio.",
                        Key .Description = "La variable OrderID es obligatoria."
                        })

                Else
                    Dim controllerSolicitudDePago As New ControllerSolicitudDePago
                    Dim objSolicitudDePago As New SolicitudDePago
                    objSolicitudDePago = controllerSolicitudDePago.ObtenerSolicitud(OrderID)
                    Return Request.CreateResponse(HttpStatusCode.OK, New With {
                        objSolicitudDePago
                        })
                End If

            Catch ex As Exception
                ' Manejo de errores: devuelve un mensaje JSON con el error
                Dim errorResponse As HttpResponseMessage = Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "2",
                        Key .ErrorMessage = "Ocurrió un error al generar la solicitud.",
                        Key .Description = ex.Message
                        })
                Return errorResponse
            End Try

            Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "4",
                        Key .ErrorMessage = "Ocurrió un error al generar la solicitud.",
                        Key .Description = "Ocurrió un error al generar la solicitud."
                        })
        End Function
    End Class
End Namespace