Imports System.Text.Json
Imports DatabaseConnection
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones
Imports Models.TECOMNET.LinkX

Public Class recargasLogin
    Inherits System.Web.UI.Page
    Private Sub ValidatePay(opr As Integer)
        pnlNumero.Visible = False
        pnlRecarga.Visible = False
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
            pnlSalir.Visible = False
            Dim opr As String = Request.QueryString("opr")
            If opr <> String.Empty Then
                If Val(Securyty.DecodeBase64ToString(opr)) > 0 Then
                    ValidatePay(Val(Securyty.DecodeBase64ToString(opr)))
                End If
            End If
            CargarOfertas(TipoServicio.Prepago)
        End If
    End Sub

    Protected Sub btnValidaPhoneNumber_Click(sender As Object, e As EventArgs)
        Dim objControllerSim As New ControllerSIM
        Dim sim = objControllerSim.ObtenerSIMPorMSISDN(txtConfirmPhonenumber.Text)

        If sim.SIMID > 0 Then
            pnlNumero.Visible = False
            pnlRecarga.Visible = True
            hfMSISDN.Value = sim.MSISDN
            hfICCID.Value = sim.ICCID
            pnlSalir.Visible = True
        Else
            FailureText.Text = "Número no encontrado"
            ErrorMessageDiv.Visible = True
        End If

    End Sub

    Protected Sub CargarOfertas(Tipo As TipoServicio)
        Dim objControllerOfertas As New ControllerOferta

        Dim Ofertas As List(Of Oferta) = objControllerOfertas.ObtenerOfertasActivasPorTipo(Tipo)

        If Ofertas IsNot Nothing AndAlso Ofertas.Count > 0 Then
            lvOffer.DataSource = Ofertas
            lvOffer.DataBind()
        Else
            pnlRecarga.Visible = False
        End If
    End Sub

    Private Function GenerarLinkPago(ofertaNueva As Oferta) As String
        Dim api As New ConsumoApis
        Dim precio As Decimal
        Dim objOrderId As String
        Dim MSISDN As String = hfMSISDN.Value
        Dim ICCID As String = hfICCID.Value

        Select Case ofertaNueva.Tipo
            Case TipoServicio.Prepago
                precio = ofertaNueva.PrecioRecurrente
            Case TipoServicio.RenovacionAutomatica
                precio = ofertaNueva.PrecioMensual
            Case TipoServicio.PagoAnticipado
                precio = ofertaNueva.PrecioAnual
            Case Else
                precio = ofertaNueva.PrecioMensual
        End Select

        Dim body = New With {
    .SolicitudID = "",
    .OrderID = "",
    .MetodoPagoID = "1",'1 pago con tarjeta 
    .OfertaIDActual = ofertaNueva.OfertaID,
    .OfertaIDNueva = ofertaNueva.OfertaID,
    .Monto = precio,
    .ICCID = ICCID,
    .MSISDN = MSISDN,
    .Estatus = "",
    .FechaCreacion = "",
    .EstatusDepositoID = "",
    .IdTransaction = "",
    .AuthNumber = "",
    .AuthCode = "",
    .Reason = "",
    .PagoDepositoID = "",
    .CanalDeVenta = "3",
    .TipoOperacion = "2",
    .UltimaActualizacion = "",
    .NumeroReintentos = "",
    .DistribuidorID = "1"
            }

        Dim bodyJson As String = JsonSerializer.Serialize(body)
        Dim resultado As New MessageResult

        resultado = api.SolicitudPago(bodyJson)

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            objOrderId = resultado.JSON
        End If

        Dim tokenString As String = DateTime.Now.ToString("o") ' ISO 8601
        Dim tokenBytes As Byte() = Encoding.UTF8.GetBytes(tokenString)
        Dim tokenBase64 As String = Convert.ToBase64String(tokenBytes)

        Dim urlExito As String = $"https://tecomnet.net/movilidad/clientes/Views/General/ValidaRecarga.aspx?token={tokenBase64}"

        Dim bodyLkl = New With {
        .amount = precio,
        .displayAmount = precio,
        .displayCurrency = "MXN",
        .language = "es",
        .email = "cliente@correo.com",
        .commerceName = "TECOMNET",
        .supportEmail = "recargas@tecomnet.mx",
        .description = "Recarga " & ofertaNueva.Oferta,
        .response_url = "https://tecomnet.net/movilidad/webhook/ValidatePay/PortalCautivo/",
        .redirectUrl = urlExito,
        .order_id = objOrderId,
        .origin = "ecommerce",
        .imageUrl = "https://www.tecomnet.mx/wp-content/uploads/2024/11/888-removebg-preview.png",
        .userData = New With {
            .firstName = "",
            .lastName = "",
            .phone = "",
            .email = "",
            .country = "",
            .state = "",
            .locality = "",
            .address = "",
            .zipCode = ""
        }
    }

        Dim bodyJsonLkl As String = JsonSerializer.Serialize(bodyLkl)
        Dim resultadoLink As New MessageResult

        resultado = api.Pago(bodyJsonLkl)

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            Dim linkPago As PaymentResponse = JsonSerializer.Deserialize(Of PaymentResponse)(resultado.JSON)
            Return linkPago.response.url
        Else
            Return String.Empty
        End If
    End Function
    Protected Sub btnPay_Click(sender As Object, e As EventArgs)

        Dim btn As Button = CType(sender, Button)
        Dim ofertaId As Integer = Convert.ToInt32(btn.CommandArgument)

        Dim api As New ConsumoApis
        Dim resultadoOferta As MessageResult = api.GetOfertaId(ofertaId)
        Dim ofertaActual As Oferta = JsonSerializer.Deserialize(Of Oferta)(resultadoOferta.JSON)

        Dim linkPago As String = GenerarLinkPago(ofertaActual)

        iframePago.Attributes("src") = linkPago
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "document.getElementById('pnlPago').style.display='block'; abrirModal();", True)

    End Sub
End Class