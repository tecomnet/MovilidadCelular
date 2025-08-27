﻿Imports System.Configuration
Imports System.Net
Imports System.Net.Http
Imports System.Text
Imports Models.TECOMNET.AltanRedes
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones
Imports System.Text.Json
Public Class ControllerAltanRedes
    'Public Const url As String = "https://altanredes-prod.apigee.net/cm-sandbox/v1/subscribers"
    'Public Const EndPoint As String = "https://altanredes-prod.apigee.net/v1/oauth/accesstoken?grant-type=client_credentials"
    ''Public Const url As String = "https://altanredes-prod.apigee.net/cm/v1/subscribers"
    ''Public Const EndPoint As String = "https://altanredes-prod.apigee.net/v1/oauth/accesstoken?grant-type=client_credentials"
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
End Class