Imports System.Text.Json
Imports Models.TECOMNET
Imports Models.TECOMNET.Enumeraciones
Imports Models.TECOMNET.LinkX

Public Class CompraSim
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim objCliente As Cliente = TryCast(Session("Cliente"), Cliente)
            If objCliente IsNot Nothing Then
                lblNombre.Text = objCliente.Nombre & " " & objCliente.ApellidoPaterno
                lblEmail.Text = objCliente.Email
                lblTelefono.Text = objCliente.Telefono
            End If

            lblPlanNombre.Text = Session("PlanNombre")
            lblPlanDescripcion.Text = Session("PlanDescripcion")
            lblPlanDatos.Text = Session("PlanDatos")
            lblPlanMinutos.Text = Session("PlanMinutos")
            lblPlanSMS.Text = Session("PlanSMS")
            lblPlanPrecio.Text = Session("PlanPrecio")
        End If
    End Sub

    Private Function GenerarLinkPago(ofertaNueva As Oferta) As String
        Dim api As New ConsumoApis
        Dim precio As Decimal
        Dim objOrderId As String

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
    .MetodoPagoID = "1",
    .OfertaIDActual = ofertaNueva.OfertaID,
    .OfertaIDNueva = ofertaNueva.OfertaID,
    .Monto = precio,
    .ICCID = " ",
    .MSISDN = "",
    .Estatus = "",
    .FechaCreacion = "",
    .EstatusDepositoID = "",
    .IdTransaction = "",
    .AuthNumber = "",
    .AuthCode = "",
    .Reason = "",
    .PagoDepositoID = "",
    .CanalDeVenta = "2",
    .TipoOperacion = "1",
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
        .response_url = "https://tecomnet.net/movilidad/webhook/ValidatePay/PortalCompraSIM/",
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
    Protected Sub btnPagar_Click(sender As Object, e As EventArgs)
        Dim ofertaId As Integer = Convert.ToInt32(Session("OfertaID"))
        Dim api As New ConsumoApis
        Dim resultadoOferta As MessageResult = api.GetOfertaId(ofertaId)
        Dim ofertaActual As Oferta = JsonSerializer.Deserialize(Of Oferta)(resultadoOferta.JSON)

        Dim linkPago As String = GenerarLinkPago(ofertaActual)

        iframePago.Attributes("src") = linkPago
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "document.getElementById('pnlPago').style.display='block'; abrirModal();", True)
    End Sub
End Class