Imports System.Web.SessionState

Public Class Global_asax
    Inherits System.Web.HttpApplication

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena al iniciar la aplicación
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena al iniciar la sesión
    End Sub

    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena al comienzo de cada solicitud
    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena al intentar autenticar el uso
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena cuando se produce un error
    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena cuando finaliza la sesión
    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Se desencadena cuando finaliza la aplicación
    End Sub
    Sub Application_PostAcquireRequestState()
        Dim ctx As HttpContext = HttpContext.Current

        If ctx.Session IsNot Nothing AndAlso ctx.Session("UsuarioID") Is Nothing Then
            Dim loginPath As String = "/views/account/login.aspx"
            Dim currentPath As String = ctx.Request.Url.AbsolutePath.ToLower()

            If currentPath <> loginPath Then
                Server.ClearError()
                Response.Clear()
                FormsAuthentication.RedirectToLoginPage()
            End If
        End If
    End Sub

End Class