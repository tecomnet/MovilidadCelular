Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports DatabaseConnection
Imports models

Namespace Controllers.SIM
    Public Class SIMController
        Inherits ApiController
        <HttpGet>
        <Route("api/ValidaSIM/{MSISDN}")>
        Public Function ValidaSIM(MSISDN As String) As HttpResponseMessage
            Try
                Dim objControlller As New ControllerSIM
                Dim objSIM As New Models.TECOMNET.SIM

                objSIM = objControlller.ObtenerSIMPorMSISDN(MSISDN)

                If objSIM.ICCID = String.Empty Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, False)
                Else
                    Return Request.CreateResponse(HttpStatusCode.OK, True)
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