Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web.Http
Imports WebApi.Controllers
Imports System.Web.Http.Cors
Public Module WebApiConfig
    Public Sub Register(ByVal config As HttpConfiguration)
        ' Configuración y servicios de Web API
        Dim cors = New EnableCorsAttribute("*", "*", "*")
        config.EnableCors(cors)


        ' Rutas de Web API
        config.MapHttpAttributeRoutes()

        ' Agregamos validación de Token
        config.MessageHandlers.Add(New TokenValidationHandler())

        config.Routes.MapHttpRoute(
            name:="DefaultApi",
            routeTemplate:="api/{controller}/{id}",
            defaults:=New With {.id = RouteParameter.Optional}
        )
    End Sub
End Module
