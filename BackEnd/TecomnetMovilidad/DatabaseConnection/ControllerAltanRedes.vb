Imports System.Configuration
Imports System.Net
Imports System.Net.Http
Imports System.Text
Imports Models.TECOMNET.AltanRedes
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones
Imports System.Text.Json
Imports System.Net.Http.Headers
Imports System.IO
Public Class ControllerAltanRedes
#Region "POST"
    'Function PostAPIService(MSISDN As String, jsonData As String, Method As AltanApisMethod) As MessageResult
    '    Dim EndPoint As String = String.Empty
    '    Dim token As String = String.Empty

    '    Select Case Method
    '        Case AltanApisMethod.Resumen
    '            EndPoint = String.Format("{0}/{1}/resume", url, MSISDN)
    '        Case AltanApisMethod.Suspend
    '            EndPoint = String.Format("{0}/{1}/suspend", url, MSISDN)
    '    End Select

    '    Dim result As New MessageResult
    '    result.ErrorID = AltanErrors.Unknown
    '    result.JSON = String.Empty

    '    Try
    '        ' Crear el cliente HTTP
    '        Using client As New HttpClient()

    '            Dim content As New StringContent("")
    '            ' Configurar los encabezados (headers)                
    '            If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
    '                token = "6c2NnSWNMRmxhNmZwWHVFVw=="
    '            Else
    '                Dim objAltanResult As New AltanResult
    '                objAltanResult = PostAPIAccessToken()
    '                If objAltanResult.ErrorID = AltanErrors.Susssuccessful Then
    '                    Dim objToken As New AccessToken
    '                    objToken = JsonSerializer.Deserialize(Of AccessToken)(objAltanResult.JSON)
    '                    token = objToken.accessToken
    '                Else
    '                    result.ErrorID = AltanErrors.Mistake
    '                    result.JSON = objAltanResult.JSON
    '                    Return result
    '                End If
    '            End If

    '            client.DefaultRequestHeaders.Add("Authorization", "Bearer " & token)

    '            ' Convertir los datos a JSON
    '            If jsonData <> String.Empty Then
    '                content = New StringContent(jsonData, Encoding.UTF8, "application/json")
    '            End If

    '            ' Enviar la solicitud POST de forma síncrona
    '            Dim response As HttpResponseMessage = client.PostAsync(EndPoint, content).Result

    '            ' Verificar si la respuesta fue exitosa
    '            If response.IsSuccessStatusCode Then
    '                result.ErrorID = AltanErrors.Susssuccessful
    '                result.JSON = response.Content.ReadAsStringAsync().Result
    '                Return result ' Devuelve la respuesta en formato JSON o texto
    '            Else
    '                If response.StatusCode = HttpStatusCode.BadRequest Then
    '                    result.ErrorID = AltanErrors.Mistake
    '                    result.JSON = response.Content.ReadAsStringAsync().Result
    '                    Return result
    '                    ' Return ""
    '                ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
    '                    result.ErrorID = AltanErrors.Mistake
    '                    result.JSON = response.Content.ReadAsStringAsync().Result
    '                    Return result
    '                ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
    '                    result.ErrorID = AltanErrors.Mistake
    '                    result.JSON = response.Content.ReadAsStringAsync().Result
    '                    Return result
    '                End If
    '            End If
    '        End Using
    '    Catch ex As Exception
    '        Return result
    '    End Try
    '    Return result
    'End Function
    Public Function PostCompraProducto(jsonData As String) As MessageResult
        Dim EndPoint As String = String.Empty
        Dim url As String = String.Empty
        Dim token As String = String.Empty

        If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
            url = ConfigurationManager.AppSettings("UrlBaseTest").ToString
        Else
            url = ConfigurationManager.AppSettings("UrlBaseProd").ToString
        End If

        EndPoint = String.Format("{0}/v1/products/purchase", url)

        Dim result As New MessageResult
        result.ErrorID = TipoErroresAPI.Errors
        result.JSON = String.Empty

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()

                ' Configurar los encabezados (headers)                
                If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
                    token = "6c2NnSWNMRmxhNmZwWHVFVw=="
                Else
                    Dim objAltanResult As New MessageResult
                    objAltanResult = PostAPIAccessToken()
                    If objAltanResult.ErrorID = TipoErroresAPI.Exito Then
                        Dim objToken As New AccessToken
                        objToken = JsonSerializer.Deserialize(Of AccessToken)(objAltanResult.JSON)
                        token = objToken.accessToken
                    Else
                        result.ErrorID = TipoErroresAPI.Errors
                        result.JSON = objAltanResult.JSON
                        Return result
                    End If
                End If
                'jsonData, Encoding.Default, "application/json"
                Dim jsonData1 As String = "{""msisdn"":""5554316832"",""offerings"":[""1082674367""],""startEffectiveDate"":"""",""expireEffectiveDate"":"""",""scheduleDate"":"""",""allowPurchaseOnSuspendBarring"":""""}"
                Dim content = New StringContent(jsonData1, Encoding.UTF8, "application/json")
                client.DefaultRequestHeaders.Accept.Add(New MediaTypeWithQualityHeaderValue("application/json"))
                client.DefaultRequestHeaders.Add("Authorization", "Bearer " & token)
                client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                Try
                    ' Enviar la solicitud POST
                    Dim response As HttpResponseMessage = client.PostAsync(EndPoint, content).Result

                    ' Verificar si la respuesta fue exitosa
                    If response.IsSuccessStatusCode Then
                        result.ErrorID = TipoErroresAPI.Exito
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result ' Devuelve la respuesta en formato JSON o texto
                    Else
                        If response.StatusCode = HttpStatusCode.BadRequest Then
                            result.ErrorID = TipoErroresAPI.Errors
                            result.JSON = response.Content.ReadAsStringAsync().Result
                            Return result
                        ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                            result.ErrorID = TipoErroresAPI.Errors
                            result.JSON = response.Content.ReadAsStringAsync().Result
                            Return result
                        ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                            result.ErrorID = TipoErroresAPI.Errors
                            result.JSON = response.Content.ReadAsStringAsync().Result
                            Return result
                        End If
                    End If
                Catch ex As Exception
                    Return result
                End Try
            End Using
        Catch ex As Exception
            Return result
        End Try
        Return result
    End Function

    Public Function PurchaseProduct(jsonData As String) As String
        Dim url As String = "https://altanredes-prod.apigee.net/cm-sandbox/v1/products/purchase"
        Dim bearerToken As String = "6c2NnSWNMRmxhNmZwWHVFVw=="

        'Dim jsonData1 As String = "{""msisdn"":""5554316832"",""offerings"":[""1082674367""],""startEffectiveDate"":"""",""expireEffectiveDate"":"""",""scheduleDate"":"""",""allowPurchaseOnSuspendBarring"":""""}"

        'If jsonData1 <> jsonData Then
        '    Dim fg As String = jsonData & "--" & jsonData1
        '    Dim ff As String = "dfsdf"
        'End If

        Try
            ServicePointManager.Expect100Continue = True
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12
            ServicePointManager.ServerCertificateValidationCallback = Function(sender, certificate, chain, sslPolicyErrors) True

            Dim request As HttpWebRequest = CType(WebRequest.Create(url), HttpWebRequest)
            request.Method = "POST"
            request.ContentType = "application/json"
            request.Accept = "*/*"
            request.Headers.Add("Authorization", "Bearer " & bearerToken)
            request.Headers.Add("Accept-Encoding", "gzip, deflate, br")
            request.Headers.Add("Accept-Language", "es-419,es;q=0.9")
            request.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            request.Headers.Add("sec-ch-ua", """Not A(Brand"";v=""99"", ""Google Chrome"";v=""121"", ""Chromium"";v=""121""")
            request.Headers.Add("sec-ch-ua-mobile", "?0")
            request.Headers.Add("sec-ch-ua-platform", """Windows""")
            request.Headers.Add("Sec-Fetch-Dest", "empty")
            request.Headers.Add("Sec-Fetch-Mode", "cors")
            request.Headers.Add("Sec-Fetch-Site", "cross-site")

            ' Headers que Postman agrega automáticamente
            request.Headers.Add("X-Forwarded-For", "127.0.0.1")
            request.Headers.Add("X-Forwarded-Port", "443")
            request.Headers.Add("X-Forwarded-Proto", "https")

            ' Escribir el body
            Dim byteData As Byte() = Encoding.UTF8.GetBytes(jsonData)
            request.ContentLength = byteData.Length

            Using stream As Stream = request.GetRequestStream()
                stream.Write(byteData, 0, byteData.Length)
            End Using

            ' Obtener respuesta
            Using response As HttpWebResponse = CType(request.GetResponse(), HttpWebResponse)
                Using reader As New StreamReader(response.GetResponseStream())
                    Return reader.ReadToEnd()
                End Using
            End Using

        Catch ex As WebException
            If ex.Response IsNot Nothing Then
                Using reader As New StreamReader(ex.Response.GetResponseStream())
                    Dim errorResponse As String = reader.ReadToEnd()
                    Console.WriteLine("Error Response: " & errorResponse)

                    Dim errorHttp As HttpWebResponse = CType(ex.Response, HttpWebResponse)
                    Console.WriteLine("Status Code: " & CInt(errorHttp.StatusCode))
                    For Each header As String In errorHttp.Headers.AllKeys
                        Console.WriteLine(header & ": " & errorHttp.Headers(header))
                    Next

                    Return "Error: " & errorResponse
                End Using
            End If
            Return "Error: " & ex.Message

        Catch ex As Exception
            Return "Error: " & ex.Message
        End Try
    End Function
    Function PostAPIAccessToken() As MessageResult

        Dim result As New MessageResult
        result.ErrorID = TipoErroresAPI.Errors
        result.JSON = String.Empty

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()
                Dim UrlEndPoint As String
                Dim content As New StringContent("")
                ' Configurar los encabezados (headers)
                client.DefaultRequestHeaders.Add("Authorization", "Basic " & ConfigurationManager.AppSettings("ALConexion").ToString) '                

                If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
                    UrlEndPoint = ConfigurationManager.AppSettings("UrlTokenTest").ToString
                Else
                    UrlEndPoint = ConfigurationManager.AppSettings("UrlTokenProd").ToString
                End If

                ' Enviar la solicitud POST de forma síncrona
                Dim response As HttpResponseMessage = client.PostAsync(UrlEndPoint, content).Result

                ' Verificar si la respuesta fue exitosa
                If response.IsSuccessStatusCode Then
                    result.ErrorID = TipoErroresAPI.Exito
                    result.JSON = response.Content.ReadAsStringAsync().Result
                    Return result ' Devuelve la respuesta en formato JSON o texto
                Else
                    If response.StatusCode = HttpStatusCode.BadRequest Then
                        result.ErrorID = TipoErroresAPI.Errors
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                        ' Return ""
                    ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                        result.ErrorID = TipoErroresAPI.Errors
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                    ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                        result.ErrorID = TipoErroresAPI.Errors
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                    End If
                End If
            End Using
        Catch ex As Exception
            Return result
        End Try
        Return result
    End Function
#End Region
#Region "GET"
    Function GetProfile(MSISDN As String) As MessageResult
        Dim EndPoint As String = String.Empty
        Dim url As String = String.Empty
        Dim token As String = String.Empty

        If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
            url = ConfigurationManager.AppSettings("UrlBaseTest").ToString
        Else
            url = ConfigurationManager.AppSettings("UrlBaseProd").ToString
        End If

        EndPoint = String.Format("{0}/v1/subscribers/{1}/profile", url, MSISDN)

        Dim result As New MessageResult
        result.ErrorID = TipoErroresAPI.Errors
        result.JSON = String.Empty

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()

                ' Configurar los encabezados (headers)                
                If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
                    token = "6c2NnSWNMRmxhNmZwWHVFVw=="
                Else
                    Dim objAltanResult As New MessageResult
                    objAltanResult = PostAPIAccessToken()
                    If objAltanResult.ErrorID = TipoErroresAPI.Exito Then
                        Dim objToken As New AccessToken
                        objToken = JsonSerializer.Deserialize(Of AccessToken)(objAltanResult.JSON)
                        token = objToken.accessToken
                    Else
                        result.ErrorID = TipoErroresAPI.Errors
                        result.JSON = objAltanResult.JSON
                        Return result
                    End If
                End If

                client.DefaultRequestHeaders.Add("Authorization", "Bearer " & token)

                ' Enviar la solicitud GET de forma síncrona
                Dim response As HttpResponseMessage = client.GetAsync(EndPoint).Result

                ' Verificar si la respuesta fue exitosa
                If response.IsSuccessStatusCode Then
                    result.ErrorID = TipoErroresAPI.Exito
                    result.JSON = response.Content.ReadAsStringAsync().Result
                    Return result ' Devuelve la respuesta en formato JSON o texto
                Else
                    If response.StatusCode = HttpStatusCode.BadRequest Then
                        result.ErrorID = TipoErroresAPI.Errors
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                        ' Return ""
                    ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                        result.ErrorID = TipoErroresAPI.Errors
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                    ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                        result.ErrorID = TipoErroresAPI.Errors
                        result.JSON = response.Content.ReadAsStringAsync().Result
                        Return result
                    End If
                End If
            End Using
        Catch ex As Exception
            Return result
        End Try
        Return result
    End Function
#End Region
#Region "PATCH"
    Public Function PatchCambioOferta(jsonData As String, MSISDN As String) As MessageResult
        Dim EndPoint As String = String.Empty
        Dim url As String = String.Empty
        Dim token As String = String.Empty

        If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
            url = ConfigurationManager.AppSettings("UrlBaseTest").ToString
        Else
            url = ConfigurationManager.AppSettings("UrlBaseProd").ToString
        End If

        EndPoint = String.Format("{0}/v1/subscribers/{1}", url, MSISDN)

        Dim result As New MessageResult
        result.ErrorID = TipoErroresAPI.Errors
        result.JSON = String.Empty

        Try
            ' Crear el cliente HTTP
            Using client As New HttpClient()

                ' Configurar los encabezados (headers)                
                If Val(ConfigurationManager.AppSettings("IsSanbox").ToString) = 1 Then
                    token = "6c2NnSWNMRmxhNmZwWHVFVw=="
                Else
                    Dim objAltanResult As New MessageResult
                    objAltanResult = PostAPIAccessToken()
                    If objAltanResult.ErrorID = TipoErroresAPI.Exito Then
                        Dim objToken As New AccessToken
                        objToken = JsonSerializer.Deserialize(Of AccessToken)(objAltanResult.JSON)
                        token = objToken.accessToken
                    Else
                        result.ErrorID = TipoErroresAPI.Errors
                        result.JSON = objAltanResult.JSON
                        Return result
                    End If
                End If

                client.DefaultRequestHeaders.Add("Authorization", "Bearer " & token)
                client.DefaultRequestHeaders.Accept.Add(New MediaTypeWithQualityHeaderValue("application/json"))

                ' Crear el contenido de la solicitud PATCH
                Dim content As New StringContent(jsonData, Encoding.UTF8, "application/json")

                ' Crear la solicitud PATCH personalizada
                Dim request As New HttpRequestMessage(New HttpMethod("PATCH"), EndPoint)
                request.Content = content

                ' Enviar la solicitud PATCH de forma síncrona
                Dim response As HttpResponseMessage = client.SendAsync(request).Result

                ' Verificar si la respuesta fue exitosa
                If response.IsSuccessStatusCode Then
                    result.ErrorID = TipoErroresAPI.Exito
                    result.JSON = response.Content.ReadAsStringAsync().Result
                    Return result ' Devuelve la respuesta en formato JSON o texto
                Else
                    Select Case response.StatusCode
                        Case HttpStatusCode.BadRequest
                            result.ErrorID = TipoErroresAPI.Errors
                            result.JSON = response.Content.ReadAsStringAsync().Result
                        Case HttpStatusCode.Unauthorized
                            result.ErrorID = TipoErroresAPI.Errors
                            result.JSON = response.Content.ReadAsStringAsync().Result
                        Case HttpStatusCode.InternalServerError
                            result.ErrorID = TipoErroresAPI.Errors
                            result.JSON = response.Content.ReadAsStringAsync().Result
                        Case HttpStatusCode.NotFound
                            result.ErrorID = TipoErroresAPI.Errors
                            result.JSON = "Recurso no encontrado"
                        Case HttpStatusCode.MethodNotAllowed
                            result.ErrorID = TipoErroresAPI.Errors
                            result.JSON = "Método PATCH no permitido en este endpoint"
                        Case Else
                            result.ErrorID = TipoErroresAPI.Errors
                            result.JSON = response.Content.ReadAsStringAsync().Result
                    End Select
                    Return result
                End If
            End Using
        Catch ex As Exception
            result.JSON = ex.Message
            Return result
        End Try
        Return result
    End Function
#End Region
End Class