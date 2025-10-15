Imports System.Net
Imports DatabaseConnection
Imports Models.TECOMNET
Imports Models.TECOMNET.AltanRedes
Imports Models.TECOMNET.LinkX
Imports System.Text.Json
Imports System.Data.SqlClient
Imports System.Configuration

Module Module1
    Dim listener As New HttpListener
    Dim whiteListedIPs As List(Of String) = New List(Of String) From {
        "35.190.175.10",
        "32.245.215.98",
        "35.196.235.221",
        “34.228.25.112”,
        “54.152.205.27”,
        "127.0.0.1",
        "200.68.170.110"
    }
    Sub Main()
        ' Configura el prefijo para el servicio (puerto 8080 en este caso)
        'QA                
        'listener.Prefixes.Add("http://localhost:80/movilidad/webhook/ValidatePay/CompraRecarga/")
        'listener.Prefixes.Add("http://localhost:80/movilidad/webhook/ValidatePay/PortalCompraSIM/")
        'listener.Prefixes.Add("http://localhost:80/movilidad/webhook/ValidatePay/PortalCautivo/")
        'listener.Prefixes.Add("http://localhost:80/movilidad/webhook/ValidatePay/RecargaWallet/")

        'Produccion        
        listener.Prefixes.Add("https://tecomnet.net/movilidad/webhook/ValidatePay/CompraRecarga/")
        listener.Prefixes.Add("https://tecomnet.net/movilidad/webhook/ValidatePay/PortalCompraSIM/")
        listener.Prefixes.Add("https://tecomnet.net/movilidad/webhook/ValidatePay/PortalCautivo/")
        listener.Prefixes.Add("https://tecomnet.net/movilidad/webhook/ValidatePay/RecargaWallet/")

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
                Case "/movilidad/webhook/ValidatePay/CompraRecarga/", "/movilidad/webhook/ValidatePay/CompraRecarga"
                    If Await ProcesarNotificacionEpayment(request, response) Then
                        response.StatusCode = 200
                    Else
                        response.StatusCode = 500
                    End If
                Case "/movilidad/webhook/ValidatePay/PortalCompraSIM/"
                    response.StatusCode = 500
                Case "/movilidad/webhook/ValidatePay/PortalCautivo/"
                    response.StatusCode = 500
                Case "/movilidad/webhook/ValidatePay/RecargaWallet/"
                    If Await ProcesarRecargaWallet(request, response) Then
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
            Console.WriteLine(String.Format("----{0}----", "Paso1"))
            If order.estatus_pago = "approved" Then
                ' El pago fue exitoso
                'Dim ControllerSolicitudDePago As New ControllerSolicitudDePago
                'Dim ControllerRecarga As New ControllerRecarga

                'Dim objSolicitudPago As New SolicitudDePago
                'Dim op As New Operations
                'Dim objRecarga As New Recarga
                'Dim ValidaCambioCompra As Tuple(Of String, String)

                'objSolicitudPago = ControllerSolicitudDePago.ObtenerSolicitud(order.order_id)
                'If objSolicitudPago.SolicitudID = 0 Then
                '    Console.WriteLine("no existe OrderID: " & order.order_id)
                '    Return False
                'Else
                '    ValidaCambioCompra = op.CompraRecarga(objSolicitudPago.OfertaIDActual, objSolicitudPago.OfertaIDNueva)
                '    If ValidaCambioCompra Is Nothing Then
                '        Console.WriteLine("No exiten las opciones de cambio.")
                '        Return False
                '    Else
                '        Dim objControllerAltanRedes As New ControllerAltanRedes
                '        Select Case ValidaCambioCompra.Item2
                '            Case "Compra"
                '                Dim lstOffering As New List(Of String)
                '                lstOffering.Add(ValidaCambioCompra.Item1)
                '                Dim objRequestPurchaseProduct As New RequestPurchaseProduct(objSolicitudPago.MSISDN, lstOffering)
                '                Dim objResult As MessageResult
                '                objResult = objControllerAltanRedes.PostCompraProducto(JsonSerializer.Serialize(objRequestPurchaseProduct))

                '                If objResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                '                    Console.WriteLine("Se aplico correctamente la compra en ALTAN.")
                '                    'Registramos Recarga
                '                    objRecarga.FechaRecarga = Now
                '                    objRecarga.ICCID = objSolicitudPago.ICCID
                '                    objRecarga.ClienteID = String.Empty 'Falta
                '                    objRecarga.OfertaID = objSolicitudPago.OfertaIDNueva
                '                    objRecarga.Total = objSolicitudPago.Monto
                '                    objRecarga.MetodoPagoID = objSolicitudPago.MetodoPagoID
                '                    objRecarga.OrderID = objSolicitudPago.OrderID
                '                    objRecarga.DistribuidorID = objSolicitudPago.DistribuidorID
                '                    objRecarga.EstatusPagoDistribuidorID = 1
                '                    objRecarga.FechaPagoDistribuidor = Nothing
                '                    objRecarga.Comision = 0
                '                    objRecarga.Impuesto = 0
                '                    objRecarga.DepositoID = Nothing
                '                    objRecarga.RequiereFacturaCliente = False
                '                    objRecarga.FacturaID = Nothing

                '                    If ControllerRecarga.AgregarRecarga(objRecarga) > 0 Then
                '                        Console.WriteLine("Se aplico correctamente la compra en TECOMNET.")
                '                    Else
                '                        Console.WriteLine("no se aplicó correctamente la compra en TECOMNET.")
                '                    End If
                '                Else
                '                    Console.WriteLine("No Se aplico la compra")
                '                End If

                '            Case "Cambio"
                '                Dim objRequestPurchaseProduct As New RequestSubscribers(ValidaCambioCompra.Item1)
                '                Dim objResult As MessageResult
                '                objResult = objControllerAltanRedes.PatchCambioOferta(JsonSerializer.Serialize(objRequestPurchaseProduct), objSolicitudPago.MSISDN)
                '                If objResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                '                    Console.WriteLine("Se aplico correctamente el cambio.")
                '                    'Registramos Recarga
                '                    objRecarga.FechaRecarga = Now
                '                    objRecarga.ICCID = objSolicitudPago.ICCID
                '                    objRecarga.ClienteID = 0
                '                    objRecarga.OfertaID = objSolicitudPago.OfertaIDNueva
                '                    objRecarga.Total = objSolicitudPago.Monto
                '                    objRecarga.MetodoPagoID = objSolicitudPago.MetodoPagoID
                '                    objRecarga.OrderID = objSolicitudPago.OrderID
                '                    objRecarga.DistribuidorID = objSolicitudPago.DistribuidorID
                '                    objRecarga.EstatusPagoDistribuidorID = 1
                '                    objRecarga.FechaPagoDistribuidor = Nothing
                '                    objRecarga.Comision = 0
                '                    objRecarga.Impuesto = 0
                '                    objRecarga.DepositoID = Nothing
                '                    objRecarga.RequiereFacturaCliente = False
                '                    objRecarga.FacturaID = Nothing
                '                    If ControllerRecarga.AgregarRecarga(objRecarga) > 0 Then
                '                        Console.WriteLine("Se aplico correctamente la compra en TECOMNET.")
                '                    Else
                '                        Console.WriteLine("no se aplicó correctamente la compra en TECOMNET.")
                '                    End If
                '                Else
                '                    Console.WriteLine("No se aplico el cambio")
                '                End If

                '        End Select
                '    End If
                'End If

                'Eliminar''
                'Dim objPagoStripe As PagoStripe = JsonSerializer.Deserialize(Of PagoStripe)(requestBody)
                Console.WriteLine(String.Format("----{0}----", "Paso3"))
                Dim objController As New ControllerAltanRedes
                Dim dt As New DataTable
                dt = BuscaSolicitudDePago(order.order_id)
                Console.WriteLine(String.Format("----{0}----", "Paso4"))


                'Select Case OfertaIDNueva,Monto,s.ICCID,s.MSISDN,ClienteId


                Dim lstOffering As New List(Of String)
                lstOffering.Add(BuscaOferta(dt(0)("OfertaIDNueva")))
                Console.WriteLine(String.Format("----{0}----", "Paso5"))
                Dim objRequestPurchaseProduct As New RequestPurchaseProduct(dt(0)("MSISDN"), lstOffering)
                Console.WriteLine(String.Format("----{0}----", "Paso6"))
                Dim objControlller As New ControllerAltanRedes
                Dim objResult As New MessageResult

                Console.WriteLine(String.Format("----{0}----", "Paso7"))
                objResult = objControlller.PostCompraProducto(JsonSerializer.Serialize(objRequestPurchaseProduct))
                Console.WriteLine(String.Format("----{0}----", "Paso8"))

                RegistraPago(dt(0)("ICCID"), dt(0)("ClienteId"), dt(0)("OfertaIDNueva"), dt(0)("Monto"))
                Console.WriteLine(String.Format("----{0}----", "Paso9"))
                Return True
                'Eliminar''

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

    Public Async Function ProcesarRecargaWallet(request As HttpListenerRequest, response As HttpListenerResponse) As Task(Of Boolean)
        'Try
        '    Console.WriteLine(String.Format("----{0}----", Now.ToString))
        '    Console.WriteLine(String.Format("----{0}----", "Payment RecargaWallet"))

        '    ' Procesa la notificación recibida (puedes adaptarlo a tus necesidades)
        '    Dim requestBody As String
        '    Using reader As New IO.StreamReader(request.InputStream, request.ContentEncoding)
        '        requestBody = reader.ReadToEnd()
        '    End Using

        '    Console.WriteLine("Datos recibidos:")
        '    Console.WriteLine(requestBody)

        '    Dim objPagoStripe As PagoStripe = JsonSerializer.Deserialize(Of PagoStripe)(requestBody)
        '    Dim objController As New ControllerAltanRedes


        '    Dim lstOffering As New List(Of String)
        '    lstOffering.Add(BuscaOferta(Val(objPagoStripe.OfertaID)))
        '    Dim objRequestPurchaseProduct As New RequestPurchaseProduct(objPagoStripe.MSISDN, lstOffering)
        '    Dim objControlller As New ControllerAltanRedes
        '    Dim objResult As MessageResult

        '    objResult = objControlller.PostCompraProducto(JsonSerializer.Serialize(objRequestPurchaseProduct))

        '    RegistraPago(BuscaICCID(objPagoStripe.MSISDN), Val(objPagoStripe.userId), Val(objPagoStripe.OfertaID), objPagoStripe.amount)
        '    Return True
        '    'Await ActulizaMovimientosTecomnet(order)

        'Catch ex As Exception
        '    Console.WriteLine(ex.Message)
        '    Return False
        'End Try
        Return True
    End Function

    Public Function BuscaOferta(ByVal OfertaID As Integer) As String
        Try
            Using connection As New SqlConnection(ConfigurationManager.ConnectionStrings("ConnectionString").ConnectionString)
                connection.Open()

                Dim query As String = String.Format("select OfferIDAltan from Ofertas where HomologacionID in (select HomologacionID from Ofertas where OfertaID={0}) and TarifaPrimaria=0", OfertaID)
                Dim valor As String = String.Empty

                Using adapter As New SqlDataAdapter(query, connection)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)

                    For Each dr As DataRow In dt.Rows
                        valor = dr(0).ToString
                    Next
                    Return valor
                End Using
            End Using

        Catch ex As Exception
            Return ""
        End Try
    End Function
    'Public Function BuscaMSISDN(ByVal clienteid As Integer) As String
    '    Try
    '        Using connection As New SqlConnection(ConfigurationManager.ConnectionStrings("ConnectionString").ConnectionString)
    '            connection.Open()

    '            Dim query As String = String.Format("select MSISDN from SIMs where ClienteId={0}", clienteid)
    '            Dim valor As String = String.Empty

    '            Using adapter As New SqlDataAdapter(query, connection)
    '                Dim dt As New DataTable()
    '                adapter.Fill(dt)

    '                For Each dr As DataRow In dt.Rows
    '                    valor = dr(0).ToString
    '                Next
    '                Return valor
    '            End Using
    '        End Using

    '    Catch ex As Exception
    '        Return ""
    '    End Try
    'End Function
    Public Sub RegistraPago(ICCID As String, ClienteID As Integer, OfertaID As Integer, Total As Double)
        ' Conexión a tu base de datos
        Using connection As New SqlConnection(ConfigurationManager.ConnectionStrings("ConnectionString").ConnectionString)
            connection.Open()

            Dim query As String = String.Format("INSERT INTO Recargas
                  (FechaRecarga, ICCID, ClienteID, OfertaID, Total, MetodoPagoID, OrderID, DistribuidorID, 
				  EstatusPagoDistribuidorID, FechaPagoDistribuidor, Comision, Impuesto, CanalDeVenta, 
				  TipoOperacion, RequiereFacturaCliente)
                  VALUES     (getdate(), @ICCID, @ClienteID, @OfertaID, @Total, 1, 'XXX', 1, 
				  1, null, 0, 16, 4, 
				  2, 0)", ICCID, ClienteID, OfertaID, Total)

            Using command As New SqlCommand(query, connection)
                command.Parameters.AddWithValue("@ICCID", ICCID)
                command.Parameters.AddWithValue("@ClienteID", ClienteID)
                command.Parameters.AddWithValue("@OfertaID", OfertaID)
                command.Parameters.AddWithValue("@Total", Total)

                command.ExecuteNonQuery()
            End Using
        End Using
    End Sub
    Public Function BuscaICCID(ByVal MSISDN As String) As String
        Try
            Using connection As New SqlConnection(ConfigurationManager.ConnectionStrings("ConnectionString").ConnectionString)
                connection.Open()

                Dim query As String = String.Format("select ICCID from SIMs where MSISDN='{0}'", MSISDN)
                Dim valor As String = String.Empty

                Using adapter As New SqlDataAdapter(query, connection)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)

                    For Each dr As DataRow In dt.Rows
                        valor = dr(0).ToString
                    Next
                    Return valor
                End Using
            End Using

        Catch ex As Exception
            Return ""
        End Try
    End Function
    Public Function BuscaSolicitudDePago(ByVal OrderID As String) As DataTable
        Try
            Using connection As New SqlConnection(ConfigurationManager.ConnectionStrings("ConnectionString").ConnectionString)
                connection.Open()

                Dim query As String = String.Format("select OfertaIDNueva,Monto,s.ICCID,s.MSISDN,ClienteId from [dbo].[SolicitudDePago] as sp
				  inner join SIMs as s on sp.ICCID = s.ICCID where OrderID='{0}'", OrderID)
                Dim valor As String = String.Empty

                Using adapter As New SqlDataAdapter(query, connection)
                    Dim dt As New DataTable()
                    adapter.Fill(dt)
                    Return dt
                End Using
            End Using

        Catch ex As Exception
            Return New DataTable
        End Try
    End Function
End Module
