Imports Models.TECOMNET
Imports System.Text.Json

Public Class Login
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None

        If Not Page.IsPostBack Then
            Try
                Recordar()
            Catch ex As Exception
            End Try
        End If
    End Sub

    Private Sub btnIngresar_Click(sender As Object, e As EventArgs) Handles btnIngresar.Click

        Dim objLoginUsuario As New LoginUsuario
        Dim objCliente As New Cliente

        objLoginUsuario.UserName = txtCorreo.Text
        objLoginUsuario.Password = txtPassword.Text

        Dim objController As New ConsumoApis
        Dim objResult As New MessageResult

        objResult = objController.Postlogin(JsonSerializer.Serialize(objLoginUsuario))

        If objResult.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            objCliente = JsonSerializer.Deserialize(Of Cliente)(objResult.JSON)
            Session("Usuario") = objCliente
            If cbRecordarme.Checked Then
                Dim nameCookie As New HttpCookie("ID")
                nameCookie.Values("ID") = objCliente.ClienteId
                nameCookie.Expires = DateTime.Now.AddDays(30)
                Response.Cookies.Add(nameCookie)
            End If
            Response.Redirect("../General/Inicio.aspx")
        Else
            ErrorMessageDiv.Visible = True
            FailureText.Text = objResult.JSON
        End If
    End Sub
    Protected Sub Recordar()
        Dim ID As Integer = 0
        Dim nameCookie As HttpCookie = Request.Cookies("ID")

        If nameCookie IsNot Nothing Then
            Dim name As String = If(nameCookie IsNot Nothing, nameCookie.Value.Split("="c)(1), "undefined")
            ID = Val(name)

            'Dim objCustomer As New Customer
            'Dim objController As New ControllerCustomer

            'objCustomer = objController.GetCustomer(ID)
            'Session("Usuario") = objCustomer
            Response.Redirect("../../Home.aspx")
        End If
    End Sub

End Class