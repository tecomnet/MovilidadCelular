Imports System.IO

Public Class _Default
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim page As String = Path.GetFileNameWithoutExtension(Request.AppRelativeCurrentExecutionFilePath)

            Select Case page
                Case "Inicio"
                    ChangeEstatusNav(hlHome)
                Case "CambioContrasena"
                    ChangeEstatusNav(hlChagePassword)
                Case "MiPerfil"
                    ChangeEstatusNav(hlProfile)
                Case "MisRecargas"
                    ChangeEstatusNav(hlRecharge)
                Case "CambioDePlan"
                    ChangeEstatusNav(hlRecharge)
            End Select
        Catch ex As Exception
            Throw ex
        End Try
    End Sub
    Public Sub ChangeEstatusNav(ByRef objHyperlink As HyperLink)
        objHyperlink.CssClass = "nav-link active"
    End Sub
    Protected Sub lbCerrarSesion_Click(sender As Object, e As EventArgs)
        Try
            Session("Usuario") = Nothing
            Dim nameCookie As HttpCookie = Request.Cookies("ID")
            nameCookie.Expires = DateTime.Now.AddDays(-1)
            Response.Cookies.Add(nameCookie)
            FormsAuthentication.RedirectToLoginPage()
        Catch ex As Exception
            FormsAuthentication.RedirectToLoginPage()
        End Try
    End Sub
End Class