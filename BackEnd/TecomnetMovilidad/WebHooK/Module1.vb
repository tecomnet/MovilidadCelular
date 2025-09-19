Imports System.Net
Imports DatabaseConnection
Imports Models.TECOMNET
Imports Models.TECOMNET.AltanRedes
Imports Models.TECOMNET.LinkX
Imports System.Text.Json

Module Module1
    Dim listener As New HttpListener
    Dim whiteListedIPs As List(Of String) = New List(Of String) From {
        "35.190.175.10",
        "35.196.235.221",
        “34.228.25.112”,
        “54.152.205.27”,
        "127.0.0.1",
        "200.68.170.110"
    }
    Sub Main()
        ' Configura el prefijo para el servicio (puerto 8080 en este caso)
        'QA        
        listener.Prefixes.Add("http://localhost:80/movilidad/webhook/ValidatePay/")

        'Produccion        
        'listener.Prefixes.Add("https://tecomnet.net/movilidad/webhook/ValidatePay/")

        listener.Start()

        Console.WriteLine("Esperando conexiones https WebHook Movilidad")

        Task.Run(AddressOf HandleRequests)

        Console.WriteLine("Presiona ENTER para salir...")
        Console.ReadLine()
        listener.Stop()

    End Sub

    Async Function HandleRequests() As Task
        While listener.IsListening
            Try
                Dim context As HttpListenerContext = Await listener.GetContextAsync()
                Await ProcessRequest(context)
            Catch ex As Exception
                Console.WriteLine($"Error en la escucha: {ex.Message}")
            End Try
        End While
    End Function

    Async Function ProcessRequest(context As HttpListenerContext) As Task
        Dim request As HttpListenerRequest = context.Request
        Dim response As HttpListenerResponse = context.Response

        Try

            Dim requestPath As String = request.Url.AbsolutePath

            ' Procesar según la ruta
            Select Case requestPath
                Case "/movilidad/webhook/ValidatePay/"
                    If Await ProcesarNotificacionEpayment(request, response) Then
                        response.StatusCode = 200
                    Else
                        response.StatusCode = 500
                    End If
                Case Else
                    Console.WriteLine($"Ruta no reconocida: {requestPath}")
                    response.StatusCode = 404 ' Not Found
            End Select
        Catch ex As Exception
            response.StatusCode = 403
            response.Close()
        End Try
        response.Close()
    End Function
    'Public Async Function ProcesarNotificacionAltan(context As HttpListenerContext, request As HttpListenerRequest, response As HttpListenerResponse) As Task(Of Boolean)
    '    ' Código asíncrono aquí
    '    Try
    '        ' Obtén la IP del cliente
    '        'Dim clientIP As String = context.Request.RemoteEndPoint.Address.ToString()

    '        'If whiteListedIPs.Contains(clientIP) Then
    '        Console.WriteLine(String.Format("----{0}----", Now.ToString))
    '        'Console.WriteLine($"Conexión permitida desde {clientIP}")

    '        ' Procesa la notificación recibida (puedes adaptarlo a tus necesidades)
    '        Dim requestBody As String
    '        Using reader As New IO.StreamReader(request.InputStream, request.ContentEncoding)
    '            requestBody = reader.ReadToEnd()
    '        End Using

    '        Console.WriteLine("Datos recibidos:")
    '        'Console.WriteLine(requestBody)

    '        Dim notification As NotificationAltan = JsonConvert.DeserializeObject(Of NotificationAltan)(requestBody)

    '        ' Acceso a las propiedades
    '        Console.WriteLine($"EventType: {notification.EventType}")
    '        Console.WriteLine($"Callback: {notification.Callback}")
    '        Console.WriteLine($"Event ID: {notification.Event.Id}")
    '        Console.WriteLine($"Total Amount: {notification.Event.Detail.TotalAmount}")

    '        ' Responde con 200 OK
    '        Dim responseString As String = "OK"
    '        Dim buffer() As Byte = Encoding.UTF8.GetBytes(responseString)
    '        response.ContentLength64 = buffer.Length
    '        response.OutputStream.Write(buffer, 0, buffer.Length)
    '        ' Else
    '        'Console.WriteLine($"Conexión rechazada desde {clientIP}")
    '        ' Responde con 403 Forbidden
    '        'response.StatusCode = 403
    '        'End If
    '    Catch ex As Exception
    '        Console.WriteLine(ex.Message)
    '        Return False
    '    End Try
    '    Return True
    'End Function
    Public Async Function ProcesarNotificacionEpayment(request As HttpListenerRequest, response As HttpListenerResponse) As Task(Of Boolean)
        Try
            Console.WriteLine(String.Format("----{0}----", Now.ToString))
            Console.WriteLine(String.Format("----{0}----", "Payment TECOMNET MOVILIDAD"))

            ' Procesa la notificación recibida (puedes adaptarlo a tus necesidades)
            Dim requestBody As String
            Using reader As New IO.StreamReader(request.InputStream, request.ContentEncoding)
                requestBody = reader.ReadToEnd()
            End Using

            Console.WriteLine("Datos recibidos:")
            Console.WriteLine(requestBody)

            Dim order As PaymentOrder = JsonSerializer.Deserialize(Of PaymentOrder)(requestBody)

            If order.estatus_pago = "approved" Then
                ' El pago fue exitoso
                Dim ControllerSolicitudDePago As New ControllerSolicitudDePago
                Dim ControllerRecarga As New ControllerRecarga

                Dim objSolicitudPago As New SolicitudDePago
                Dim op As New Operations
                Dim objRecarga As New Recarga
                Dim ValidaCambioCompra As Tuple(Of String, String)

                objSolicitudPago = ControllerSolicitudDePago.ObtenerSolicitud(order.order_id)
                If objSolicitudPago.SolicitudID = 0 Then
                    Console.WriteLine("no existe OrderID: " & order.order_id)
                    Return False
                Else
                    ValidaCambioCompra = op.CompraRecarga(objSolicitudPago.OfertaIDActual, objSolicitudPago.OfertaIDNueva)
                    If ValidaCambioCompra Is Nothing Then
                        Console.WriteLine("No exiten las opciones de cambio.")
                        Return False
                    Else
                        Dim objControllerAltanRedes As New ControllerAltanRedes
                        Select Case ValidaCambioCompra.Item2
                            Case "Compra"
                                Dim lstOffering As New List(Of String)
                                lstOffering.Add(ValidaCambioCompra.Item1)
                                Dim objRequestPurchaseProduct As New RequestPurchaseProduct(objSolicitudPago.MSISDN, lstOffering)
                                Dim objResult As MessageResult
                                objResult = objControllerAltanRedes.PostCompraProducto(JsonSerializer.Serialize(objRequestPurchaseProduct))

                                If objResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                                    Console.WriteLine("Se aplico correctamente la compra en ALTAN.")
                                    'Registramos Recarga
                                    objRecarga.FechaRecarga = Now
                                    objRecarga.ICCID = objSolicitudPago.ICCID
                                    objRecarga.ClienteID = String.Empty 'Falta
                                    objRecarga.OfertaID = objSolicitudPago.OfertaIDNueva
                                    objRecarga.Total = objSolicitudPago.Monto
                                    objRecarga.MetodoPagoID = objSolicitudPago.MetodoPagoID
                                    objRecarga.OrderID = objSolicitudPago.OrderID
                                    objRecarga.DistribuidorID = objSolicitudPago.DistribuidorID
                                    objRecarga.EstatusPagoDistribuidorID = 1
                                    objRecarga.FechaPagoDistribuidor = Nothing
                                    objRecarga.Comision = 0
                                    objRecarga.Impuesto = 0
                                    objRecarga.DepositoID = Nothing
                                    objRecarga.RequiereFacturaCliente = False
                                    objRecarga.FacturaID = Nothing

                                    If ControllerRecarga.AgregarRecarga(objRecarga) > 0 Then
                                        Console.WriteLine("Se aplico correctamente la compra en TECOMNET.")
                                    Else
                                        Console.WriteLine("no se aplicó correctamente la compra en TECOMNET.")
                                    End If
                                Else
                                    Console.WriteLine("No Se aplico la compra")
                                End If

                            Case "Cambio"
                                Dim objRequestPurchaseProduct As New RequestSubscribers(ValidaCambioCompra.Item1)
                                Dim objResult As MessageResult
                                objResult = objControllerAltanRedes.PatchCambioOferta(JsonSerializer.Serialize(objRequestPurchaseProduct), objSolicitudPago.MSISDN)
                                If objResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                                    Console.WriteLine("Se aplico correctamente el cambio.")
                                    'Registramos Recarga
                                    objRecarga.FechaRecarga = Now
                                    objRecarga.ICCID = objSolicitudPago.ICCID
                                    objRecarga.ClienteID = 0
                                    objRecarga.OfertaID = objSolicitudPago.OfertaIDNueva
                                    objRecarga.Total = objSolicitudPago.Monto
                                    objRecarga.MetodoPagoID = objSolicitudPago.MetodoPagoID
                                    objRecarga.OrderID = objSolicitudPago.OrderID
                                    objRecarga.DistribuidorID = objSolicitudPago.DistribuidorID
                                    objRecarga.EstatusPagoDistribuidorID = 1
                                    objRecarga.FechaPagoDistribuidor = Nothing
                                    objRecarga.Comision = 0
                                    objRecarga.Impuesto = 0
                                    objRecarga.DepositoID = Nothing
                                    objRecarga.RequiereFacturaCliente = False
                                    objRecarga.FacturaID = Nothing
                                    If ControllerRecarga.AgregarRecarga(objRecarga) > 0 Then
                                        Console.WriteLine("Se aplico correctamente la compra en TECOMNET.")
                                    Else
                                        Console.WriteLine("no se aplicó correctamente la compra en TECOMNET.")
                                    End If
                                Else
                                    Console.WriteLine("No se aplico el cambio")
                                End If

                        End Select
                    End If
                End If
                Return True
                'Await ActulizaMovimientosTecomnet(order)
            End If
        Catch ex As Exception
            Console.WriteLine(ex.Message)
            Return False
        End Try
        Return True
    End Function
    'Public Async Function ActulizaMovimientosTecomnet(ByVal objOrder As PaymentOrder) As Task(Of Boolean)
    '    Try
    '        Dim objProducto As New ModelsTECOMNET.TECOMNET.Product
    '        Dim objSIM As New SIM
    '        Dim objCustomerPayments As New CustomerPayments
    '        Dim objMovementHistory As New MovementHistory
    '        Dim objPaymentRequestTecomnet As New PaymentRequestTecomnet
    '        Dim objCustomer As New Customer

    '        Dim ObjControllerProduct As New ControllerProduct
    '        Dim ObjControllerPaymentRequest As New ControllerPaymentRequest
    '        Dim ObjControllerSIM As New ControllerSIM
    '        Dim ObjControllerCustomerPayments As New ControllerCustomerPayments
    '        Dim ObjControllerMovementHistory As New ControllerMovementHistory
    '        Dim ObjControllerCustomer As New ControllerCustomer

    '        objPaymentRequestTecomnet = ObjControllerPaymentRequest.GetPaymentRequest(objOrder.order_id)

    '        objProducto = ObjControllerProduct.GetProduct(objPaymentRequestTecomnet.ProductID)
    '        objSIM = ObjControllerSIM.GetSIM(objPaymentRequestTecomnet.SIMID)
    '        'Actualiza Saldo en la base de datos
    '        ObjControllerSIM.UpdateMB(objPaymentRequestTecomnet.SIMID, objProducto.MB)

    '        'Registramos compra de megas
    '        objCustomerPayments.ProductID = objPaymentRequestTecomnet.ProductID
    '        objCustomerPayments.SIMID = objPaymentRequestTecomnet.SIMID
    '        objCustomerPayments.CarID = objSIM.CarID
    '        objCustomerPayments.CustomerID = objPaymentRequestTecomnet.CustomerID
    '        objCustomerPayments.PurchaseDate = Now
    '        objCustomerPayments.PaymentAmount = objProducto.Price
    '        objCustomerPayments.MethodPayment = MethodPayment.Card
    '        objCustomerPayments.InvoiceRequired = objPaymentRequestTecomnet.InvoiceRequired
    '        ObjControllerCustomerPayments.RegisterSale(objCustomerPayments)

    '        'Actualizamos orden de compra
    '        objPaymentRequestTecomnet.estatus_pago = objOrder.estatus_pago
    '        objPaymentRequestTecomnet.id_transaction = objOrder.id_transaction
    '        objPaymentRequestTecomnet.auth_number = objOrder.auth_number
    '        objPaymentRequestTecomnet.authCode = objOrder.authCode
    '        objPaymentRequestTecomnet.reason = objOrder.reason
    '        ObjControllerPaymentRequest.UpdatePaymentRequested(objPaymentRequestTecomnet)

    '        'Aperturamos servicio en Altan
    '        Dim objAltanResult As New AltanResult
    '        Dim objErrorAltan As New ErrorAltan
    '        Dim altan As New ConectionAltanRedes
    '        objAltanResult = altan.PostAPIService(objSIM.MSISDN, "", AltanApisMethod.Resumen)
    '        If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
    '            Dim objOrderInfo As New OrderInfo
    '        Else
    '            objErrorAltan = JsonConvert.DeserializeObject(Of ErrorAltan)(objAltanResult.JSON)
    '        End If

    '        'Registramos movimiento en tabla de historia de movimientos
    '        objMovementHistory.MovementDate = Now
    '        objMovementHistory.MovementType = MovementType.ResumeService
    '        objMovementHistory.SIMID = objPaymentRequestTecomnet.SIMID
    '        objMovementHistory.Description = ""
    '        ObjControllerMovementHistory.AddMovement(objMovementHistory)

    '        'Notificamos por correo electronico la compra
    '        objCustomer = ObjControllerCustomer.GetCustomer(objPaymentRequestTecomnet.CustomerID)

    '        EmailSender.RechargeNotification(objCustomer.CustomerName, objProducto.ProductName, objCustomer.Email, TypeMessageMail.Recharge)

    '    Catch ex As Exception
    '        Console.Write(ex.Message)
    '        Return False
    '    End Try
    '    Return True
    'End Function
End Module
