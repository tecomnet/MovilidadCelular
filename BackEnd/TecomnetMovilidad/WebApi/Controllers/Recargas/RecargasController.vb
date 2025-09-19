Imports System.Net
Imports System.Net.Http
Imports System.Text.Json
Imports System.Web.Http
Imports DatabaseConnection
Imports Models.TECOMNET
Imports Models.TECOMNET.AltanRedes
Imports Models.TECOMNET.API
Imports Models.TECOMNET.Enumeraciones
Imports WebApi.TECOMNET.API

Namespace Controllers.Recarga
    Public Class RecargasController
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
        <HttpPost>
        <Route("api/Recargas/CompraProducto")>
        Public Async Function CompraProducto(objCompraProducto As CompraProducto) As Threading.Tasks.Task(Of HttpResponseMessage)
            Try
                Dim lstOffering As New List(Of String)
                lstOffering.Add(objCompraProducto.OfferingId)
                Dim objRequestPurchaseProduct As New RequestPurchaseProduct(objCompraProducto.MSISDN, lstOffering)
                Dim objControlller As New ControllerAltanRedes
                Dim objResult As MessageResult

                If Not ModelState.IsValid Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "El objeto enviado no es valido"
                        })
                End If

                objResult = objControlller.PostCompraProducto(JsonSerializer.Serialize(objRequestPurchaseProduct))
                'Dim dsfdsf As String = objControlller.PurchaseProduct(JsonSerializer.Serialize(objRequestPurchaseProduct))
                'Dim dsfdsf As String = objControlller.PurchaseProduct()
                If objResult.ErrorID = TipoErroresAPI.Exito Then
                    Return Request.CreateResponse(HttpStatusCode.OK, New With {
                        Key .mensaje = "La compra se realizo correctamente."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "Error al realizar la compra"
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
        <HttpPatch>
        <Route("api/Recargas/CambiaProducto")>
        Public Function CambiaProducto(objCompraProducto As CompraProducto) As HttpResponseMessage
            Try
                Dim objRequestSubscribers As New RequestSubscribers()
                objRequestSubscribers.OfferingId = objCompraProducto.OfferingId

                Dim objControlller As New ControllerAltanRedes
                Dim objResult As MessageResult

                If Not ModelState.IsValid Then
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "El objeto enviado no es valido"
                        })
                End If

                objResult = objControlller.PatchCambioOferta(JsonSerializer.Serialize(objRequestSubscribers), objCompraProducto.MSISDN)
                If objResult.ErrorID = TipoErroresAPI.Exito Then
                    Return Request.CreateResponse(HttpStatusCode.OK, New With {
                        Key .mensaje = "La compra se realizo correctamente."
                        })
                Else
                    Return Request.CreateResponse(HttpStatusCode.InternalServerError, New With {
                        Key .mensaje = "Error al realizar la compra"
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