Imports System.Net
Imports System.Net.Http
Imports System.Web.Http
Imports DatabaseConnection
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones

Namespace Controllers.Ofertas
    <Authorize>
    Public Class OfertaController
        Inherits ApiController
        <HttpGet>
        <Route("api/Ofertas/{OfertaID}")>
        Public Function ObtenerOferta(OfertaID As Integer) As HttpResponseMessage
            Try
                Dim objOferta As New Oferta
                Dim objControlller As New ControllerOferta

                objOferta = objControlller.ObtenerOferta(OfertaID)

                If objOferta.OfertaID = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No existe la oferta."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.OK, objOferta)
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
        <Route("api/Ofertas/Activa/Tipo/{Tipo}")>
        Public Function ObtenerOfertasActivasTipo(Tipo As TipoServicio) As HttpResponseMessage
            Try
                Dim listOferta As New List(Of Oferta)
                Dim objControlller As New ControllerOferta

                listOferta = objControlller.ObtenerOfertasActivasPorTipo(Tipo)

                If listOferta.Count = 0 Then
                    Return Request.CreateResponse(HttpStatusCode.NoContent, New With {
                        Key .mensaje = "No existen ofertas activas."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.OK, listOferta)
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