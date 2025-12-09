Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports DatabaseConnection
Imports Models.TECOMNET

Namespace Controllers.Compra
    <Authorize>
    Public Class CompraController
        Inherits ApiController
        <HttpPost>
        <Route("api/Compra/SIM/{ICCID}/{MSISDN}/{OfertaID}")>
        Public Function RechargeRequest(<FromBody> Cliente As Cliente, ICCID As String, MSISDN As String, OfertaID As Integer) As HttpResponseMessage
            Try
                If Cliente Is Nothing Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "1",
                        Key .ErrorMessage = "Objeto no valido.",
                        Key .Description = "El cliente no puede ser nulo."
                        })
                End If

                If String.IsNullOrEmpty(ICCID) Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "1",
                        Key .ErrorMessage = "Datos no validos.",
                        Key .Description = "El OrderID es obligatorio."
                        })
                End If

                If String.IsNullOrEmpty(MSISDN) Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .CodeError = "1",
                        Key .ErrorMessage = "Datos no validos.",
                        Key .Description = "El OrderID es obligatorio."
                        })
                End If

                'If objSolicitudDePago.SolicitudID > 0 Then
                Return Request.CreateResponse(HttpStatusCode.OK, New With {
                    Key .ClienteID = 2222,
                    Key .ICCID = "DSGDFFDGFD",
                    Key .MSISDN = "DSFSDFDSF",
                    Key .QRBASE64 = "dsgfhdfggfgdgdfggd"
                    })
                'End If

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