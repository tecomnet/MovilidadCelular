﻿Imports System.Web.Http

Namespace Controllers
    <AllowAnonymous>
    Public Class AccountController
        Inherits ApiController
        <HttpPost>
        Public Function login(objLogin As LoginAccount) As IHttpActionResult
            If Not ModelState.IsValid Then
                Return BadRequest(ModelState)
            End If

            Dim isCredentialValid As Boolean = False

            If objLogin.UserName = "Mobile.TECOMNET.USER_Admin" And objLogin.Password = "VnhmJUD4ZW4564NHAyYD53FSH" Then
                isCredentialValid = True
            End If

            If isCredentialValid Then
                Dim token = TokenGenerator.GenerateTokenJwt(objLogin.userName)
                Return Ok(token)
            Else
                Return Unauthorized()
            End If

        End Function
    End Class
End Namespace