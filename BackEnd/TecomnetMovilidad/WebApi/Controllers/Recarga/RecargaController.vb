Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports DatabaseConnection
Imports Models.TECOMNET

Namespace Controllers.Recarga
    Public Class RecargaController
        Inherits ApiController
        <HttpGet>
        <Route("api/Recargas/Cliente/{ClienteID}")>
        Public Function ObtenerOferta(ClienteID As Integer) As HttpResponseMessage
            Try
                Dim listVisRecarga As New List(Of VisRecarga)
                Dim objControlller As New ControllerRecarga

                listVisRecarga = objControlller.ObtenRecargasPorCliente(ClienteID)

                If listVisRecarga.Count = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No existen recargas."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.OK, listVisRecarga)
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