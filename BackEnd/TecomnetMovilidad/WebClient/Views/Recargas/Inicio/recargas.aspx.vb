Imports DatabaseConnection

Public Class recargasLogin
    Inherits System.Web.UI.Page
    Private Sub ValidatePay(opr As Integer)
        pnlNumero.Visible = False
        'pnlRecarga.Visible = False
        pnlValidate.Visible = True
        ' El pago fue exitoso                
        hlButton.CssClass = "buttonSuccessfull"
        h1Tittle.InnerText = "¡Gracias por tu pago!"
        h1Tittle.Attributes.Add("class", "h1Successfull")
        pMessage.InnerText = "Tu pago con tarjeta ha sido exitoso. Apreciamos tu confianza y preferencia."
        pMessage.Attributes.Add("class", "pSuccessfull")
    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Page.UnobtrusiveValidationMode = System.Web.UI.UnobtrusiveValidationMode.None

        If Not Page.IsPostBack Then
            Dim opr As String = Request.QueryString("opr")
            If opr <> String.Empty Then
                If Val(Securyty.DecodeBase64ToString(opr)) > 0 Then
                    ValidatePay(Val(Securyty.DecodeBase64ToString(opr)))
                End If
            End If
        End If
    End Sub

    Protected Sub btnValidaPhoneNumber_Click(sender As Object, e As EventArgs)
        Dim objControllerSim As New ControllerSIM
        If objControllerSim.ObtenerSIMPorMSISDN(txtConfirmPhonenumber.Text).SIMID > 0 Then
            Response.Redirect("~/Views/Recargas/Paquetes/Planes.aspx")
        Else
            'txtConfirmPhonenumber.Text = "No existe"
        End If



    End Sub
End Class