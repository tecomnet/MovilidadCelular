Imports System
Imports System.Net
Imports System.Net.Http
Imports System.Text
Imports System.Text.Json
Imports System.Threading.Tasks
Imports Models.TECOMNET


Public Class ConsumoApis
    Public Const JsonDataKey As String = "{""UserName"":""Mobile.TECOMNET.USER_Admin"",""Password"":""VnhmJUD4ZW4564NHAyYD53FSH""}"
    Public Const urlGetToken As String = "https://tecomnet.net/movilidad/WebApi/api/Account"
    Public Const urlPostResponseLogin As String = "https://tecomnet.net/movilidad/WebApi/api/Cliente/Login"
    Public Const JsonDataKeyLink As String = "{""email"":""h.martinez@tecomnet.mx"",""apiKey"":""api-113f2717-c412-48d1-8da3-d3df93b2954c-29vpbp""}"
    Public Const urlGetTokenLink As String = "https://lklapi.lklpay.com.mx/pef1d7972c8ro/auth/ecommerce/login"
    Public Const urlPostResponseSolicitudPago As String = "https://tecomnet.net/movilidad/WebApi/api/RegistrarSolicitudDePago"
    Public Const urlPostResponsePago As String = "https://lklapi.lklpay.com.mx/f2c65bd1289pm/link/ecommerce"
    Public Const urlGetResponseTablero As String = "https://tecomnet.net/movilidad/WebApi/api/Cliente/Tablero/$clienteId"
    Public Const urlGetResponseOfertaTipo As String = "https://tecomnet.net/movilidad/WebApi/api/Ofertas/Activa/Tipo/$tipo"
    Public Const urlPostCambiarContraseña As String = "https://tecomnet.net/movilidad/WebApi/api/Cliente/CambiaPassword"
    Public Const urlPostSolicitudCambioContraseña As String = "https://tecomnet.net/movilidad/WebApi/api/Cliente/SolicitudCambioPassword"
    Public Const urlGetRecargaCliente As String = "https://tecomnet.net/movilidad/WebApi/api/Recargas/Cliente/$clienteId"
    Public Const urlGetOfertaID As String = "https://tecomnet.net/movilidad/WebApi/api/Ofertas/$ofertaId"

#Region "POST"
    Public Function GetToken() As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Using client As New HttpClient()
                Dim content = New StringContent(JsonDataKey, Encoding.UTF8, "application/json")
                client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                Try
                    Dim response As HttpResponseMessage = client.PostAsync(urlGetToken, content).Result

                    If response.IsSuccessStatusCode Then
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                        objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                        Return objectMessageResult
                    Else
                        If response.StatusCode = HttpStatusCode.BadRequest Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        End If
                    End If
                Catch ex As Exception
                    objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors And
                        objectMessageResult.JSON = ex.Message
                    Return objectMessageResult
                End Try
            End Using
        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try
        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function

    Public Function Postlogin(body As String) As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Dim objToken As New MessageResult
            objToken = GetToken()
            If objToken.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Using client As New HttpClient()
                    Dim content = New StringContent(body, Encoding.UTF8, "application/json")
                    client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                    client.DefaultRequestHeaders.Add("Authorization", objToken.JSON.Replace("""", ""))
                    Try
                        Dim response As HttpResponseMessage = client.PostAsync(urlPostResponseLogin, content).Result

                        If response.IsSuccessStatusCode Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        Else
                            If response.StatusCode = HttpStatusCode.BadRequest Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            End If
                        End If
                    Catch ex As Exception
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors And
                            objectMessageResult.JSON = ex.Message
                        Return objectMessageResult
                    End Try
                End Using
            Else
                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                objectMessageResult.JSON = "No se genero el token"
            End If

        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try


        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function

    Public Function PostCambiarContraseña(body As String) As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Dim objToken As New MessageResult
            objToken = GetToken()
            If objToken.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Using client As New HttpClient()
                    Dim content = New StringContent(body, Encoding.UTF8, "application/json")
                    client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                    client.DefaultRequestHeaders.Add("Authorization", objToken.JSON.Replace("""", ""))
                    Try
                        Dim response As HttpResponseMessage = client.PostAsync(urlPostCambiarContraseña, content).Result

                        If response.IsSuccessStatusCode Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        Else
                            If response.StatusCode = HttpStatusCode.BadRequest Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            End If
                        End If
                    Catch ex As Exception
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors And
                            objectMessageResult.JSON = ex.Message
                        Return objectMessageResult
                    End Try
                End Using
            Else
                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                objectMessageResult.JSON = "No se genero el token"
            End If

        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try


        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function

    Public Function PostSolicitudCambioContraseña(body As String) As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Dim objToken As New MessageResult
            objToken = GetToken()
            If objToken.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Using client As New HttpClient()
                    Dim content = New StringContent(body, Encoding.UTF8, "application/json")
                    client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                    client.DefaultRequestHeaders.Add("Authorization", objToken.JSON.Replace("""", ""))
                    Try
                        Dim response As HttpResponseMessage = client.PostAsync(urlPostSolicitudCambioContraseña, content).Result

                        If response.IsSuccessStatusCode Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        Else
                            If response.StatusCode = HttpStatusCode.BadRequest Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            End If
                        End If
                    Catch ex As Exception
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors And
                            objectMessageResult.JSON = ex.Message
                        Return objectMessageResult
                    End Try
                End Using
            Else
                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                objectMessageResult.JSON = "No se genero el token"
            End If

        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try


        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function
    Public Function GetTokenLink() As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Using client As New HttpClient()
                Dim content = New StringContent(JsonDataKeyLink, Encoding.UTF8, "application/json")
                client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                Try
                    Dim response As HttpResponseMessage = client.PostAsync(urlGetTokenLink, content).Result

                    If response.IsSuccessStatusCode Then
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                        objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                        Return objectMessageResult
                    Else
                        If response.StatusCode = HttpStatusCode.BadRequest Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        End If
                    End If
                Catch ex As Exception
                    objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors And
                        objectMessageResult.JSON = ex.Message
                    Return objectMessageResult
                End Try
            End Using
        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try
        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function

    Public Function SolicitudPago(body As String) As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Dim objToken As New MessageResult
            objToken = GetToken()
            If objToken.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Using client As New HttpClient()
                    Dim content = New StringContent(body, Encoding.UTF8, "application/json")
                    client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                    client.DefaultRequestHeaders.Add("Authorization", objToken.JSON.Replace("""", ""))
                    Try
                        Dim response As HttpResponseMessage = client.PostAsync(urlPostResponseSolicitudPago, content).Result

                        If response.IsSuccessStatusCode Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        Else
                            If response.StatusCode = HttpStatusCode.BadRequest Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            End If
                        End If
                    Catch ex As Exception
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors And
                            objectMessageResult.JSON = ex.Message
                        Return objectMessageResult
                    End Try
                End Using
            Else
                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                objectMessageResult.JSON = "No se genero el token"
            End If

        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try


        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function
    Public Function Pago(body As String) As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Dim objToken As New MessageResult
            objToken = GetTokenLink()
            If objToken.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Dim tokenResponse = JsonSerializer.Deserialize(Of Dictionary(Of String, Object))(objToken.JSON)
                Dim responseObj = CType(tokenResponse("response"), JsonElement)
                Dim token As String = responseObj.GetProperty("token").GetString()
                Using client As New HttpClient()
                    Dim content = New StringContent(body, Encoding.UTF8, "application/json")
                    client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                    client.DefaultRequestHeaders.Authorization = New System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token)
                    Try
                        Dim response As HttpResponseMessage = client.PostAsync(urlPostResponsePago, content).Result

                        If response.IsSuccessStatusCode Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        Else
                            If response.StatusCode = HttpStatusCode.BadRequest Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            End If
                        End If
                    Catch ex As Exception
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors And
                            objectMessageResult.JSON = ex.Message
                        Return objectMessageResult
                    End Try
                End Using
            Else
                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                objectMessageResult.JSON = "No se genero el token"
            End If

        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try


        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function

#End Region

#Region "GET"
    Public Function GetTablero(ClienteId As Integer) As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Dim objToken As New MessageResult
            objToken = GetToken()
            If objToken.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Using client As New HttpClient()
                    client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                    client.DefaultRequestHeaders.Add("Authorization", objToken.JSON.Replace("""", ""))
                    Try
                        Dim url As String = urlGetResponseTablero.Replace("$clienteId", ClienteId)
                        Dim response As HttpResponseMessage = client.GetAsync(url).Result
                        If response.IsSuccessStatusCode Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        Else
                            If response.StatusCode = HttpStatusCode.BadRequest Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            End If
                        End If
                    Catch ex As Exception
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                        objectMessageResult.JSON = ex.Message
                        Return objectMessageResult
                    End Try
                End Using
            Else
                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                objectMessageResult.JSON = "No se genero el token"
            End If

        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try


        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function

    Public Function GetOfertaTipo(SIMID As Integer) As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Dim objToken As New MessageResult
            objToken = GetToken()
            If objToken.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Using client As New HttpClient()
                    client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                    client.DefaultRequestHeaders.Add("Authorization", objToken.JSON.Replace("""", ""))
                    Try
                        Dim url As String = urlGetResponseOfertaTipo.Replace("$tipo", SIMID)
                        Dim response As HttpResponseMessage = client.GetAsync(url).Result
                        If response.IsSuccessStatusCode Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        Else
                            If response.StatusCode = HttpStatusCode.BadRequest Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            End If
                        End If
                    Catch ex As Exception
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                        objectMessageResult.JSON = ex.Message
                        Return objectMessageResult
                    End Try
                End Using
            Else
                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                objectMessageResult.JSON = "No se genero el token"
            End If

        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try


        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function

    Public Function GetRecargasCliente(ClienteId As Integer) As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Dim objToken As New MessageResult
            objToken = GetToken()
            If objToken.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Using client As New HttpClient()
                    client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                    client.DefaultRequestHeaders.Add("Authorization", objToken.JSON.Replace("""", ""))
                    Try
                        Dim url As String = urlGetRecargaCliente.Replace("$clienteId", ClienteId)
                        Dim response As HttpResponseMessage = client.GetAsync(url).Result
                        If response.IsSuccessStatusCode Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        Else
                            If response.StatusCode = HttpStatusCode.BadRequest Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            End If
                        End If
                    Catch ex As Exception
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                        objectMessageResult.JSON = ex.Message
                        Return objectMessageResult
                    End Try
                End Using
            Else
                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                objectMessageResult.JSON = "No se genero el token"
            End If

        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try


        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function
    Public Function GetOfertaId(OfertaID As Integer) As MessageResult
        Dim objectMessageResult As New MessageResult
        Try
            Dim objToken As New MessageResult
            objToken = GetToken()
            If objToken.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Using client As New HttpClient()
                    client.DefaultRequestHeaders.UserAgent.ParseAdd("MiAplicacion/1.0 (VB.NET)")
                    client.DefaultRequestHeaders.Add("Authorization", objToken.JSON.Replace("""", ""))
                    Try
                        Dim url As String = urlGetOfertaID.Replace("$ofertaId", OfertaID)
                        Dim response As HttpResponseMessage = client.GetAsync(url).Result
                        If response.IsSuccessStatusCode Then
                            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito
                            objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                            Return objectMessageResult
                        Else
                            If response.StatusCode = HttpStatusCode.BadRequest Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Advertencia
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.Unauthorized Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            ElseIf response.StatusCode = HttpStatusCode.InternalServerError Then
                                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                                objectMessageResult.JSON = response.Content.ReadAsStringAsync().Result
                                Return objectMessageResult
                            End If
                        End If
                    Catch ex As Exception
                        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                        objectMessageResult.JSON = ex.Message
                        Return objectMessageResult
                    End Try
                End Using
            Else
                objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
                objectMessageResult.JSON = "No se genero el token"
            End If

        Catch ex As Exception
            objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
            objectMessageResult.JSON = ex.Message
            Return objectMessageResult
        End Try


        objectMessageResult.ErrorID = Enumeraciones.TipoErroresAPI.Errors
        objectMessageResult.JSON = "Error desconocido"
        Return objectMessageResult
    End Function
#End Region
End Class
