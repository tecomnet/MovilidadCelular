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
            Dim currentPath As String = ctx.Request.Url.AbsolutePath.ToLower()

            ' Evitar redirección si ya estás en login.aspx o si se trata de recursos estáticos
            If Not currentPath.Contains("/login.aspx") AndAlso Not currentPath.Contains(".axd") AndAlso Not currentPath.Contains(".css") AndAlso Not currentPath.Contains(".js") Then
                ctx.Response.Redirect("~/Views/Account/Login.aspx?ReturnUrl=" & HttpUtility.UrlEncode(ctx.Request.RawUrl))
            End If
        End If
    End Sub


End Class