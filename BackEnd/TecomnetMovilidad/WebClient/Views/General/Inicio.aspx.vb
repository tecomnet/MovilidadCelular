Imports Models.TECOMNET
Imports DatabaseConnection
Imports Models.TECOMNET.API
Imports System.Text.Json
Imports Models.TECOMNET.LinkX


Public Class Inicio
    Inherits System.Web.UI.Page
#Region "Property"
    Private Property Customer As Cliente
        Get
            Return Session("Usuario")
        End Get
        Set(value As Cliente)
            Session("Usuario") = value
        End Set
    End Property
#End Region
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            lvPaquetes.DataSource = Datos(Customer.ClienteId)
            lvPaquetes.DataBind()
        End If
    End Sub
    Public Function Datos(ClienteId As Integer) As List(Of Tablero)
        Dim api As New ConsumoApis
        Dim resultado As New MessageResult
        Dim lista As New List(Of Tablero)

        resultado = api.GetTablero(ClienteId)

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            lista = JsonSerializer.Deserialize(Of List(Of Tablero))(resultado.JSON)
        End If
        Return lista
    End Function

    Protected Sub btnRenovarPlan_Click(sender As Object, e As EventArgs)
        Dim api As New ConsumoApis
        Dim resultadoTablero As New MessageResult
        Dim listaTablero As New List(Of Tablero)

        resultadoTablero = api.GetTablero(Customer.ClienteId)
        listaTablero = JsonSerializer.Deserialize(Of List(Of Tablero))(resultadoTablero.JSON)

        Dim ofertaActiva As Tablero = listaTablero.First()
        Dim ofertaId As Integer = ofertaActiva.SIMID
        Dim resultadoOferta As MessageResult = api.GetOfertaId(ofertaId)
        Dim ofertaActual As Oferta = JsonSerializer.Deserialize(Of Oferta)(resultadoOferta.JSON)

        If resultadoOferta.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            ofertaActual = JsonSerializer.Deserialize(Of Oferta)(resultadoOferta.JSON)
        Else
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('No se pudo obtener la información de la oferta.');", True)
            Return
        End If

        Dim orderID As String = "GTW|" & Guid.NewGuid().ToString()
        Dim body = New With {
    .SolicitudID = "",
    .OrderID = orderID,
    .MetodoPagoID = "1",
    .OfertaIDActual = ofertaActual.OfertaID,
    .OfertaIDNueva = "6544",
    .Monto = ofertaActual.OfertaID,
    .ICCID = "HJFDKJHSF98743978",
    .Estatus = "",
    .FechaCreacion = "",
    .EstatusDepositoID = "",
    .IdTransaction = "",
    .AuthNumber = "",
    .AuthCode = "",
    .Reason = "",
    .PagoDepositoID = "",
    .UltimaActualizacion = "",
    .NumeroReintentos = ""
            }

        Dim bodyJson As String = JsonSerializer.Serialize(body)
        Dim resultado As New MessageResult

        resultado = api.SolicitudPago(bodyJson)

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            Dim objOrderId As String = resultado.JSON
        End If

        Dim bodyLkl = New With {
            .amount = ofertaActual.PrecioMensual,
        .displayAmount = ofertaActual.PrecioMensual,
        .displayCurrency = "MXN",
        .language = "es",
        .email = "daniel.arzate@knesysplus.com",
        .commerceName = "TECOMNET",
        .supportEmail = "recargas@tecomnet.mx",
        .description = "Recarga $600 - 1000 MB",
        .response_url = "https://tecomnet.net/TECOMNET/webhook/ValidatePay/",
        .redirectUrl = "https://tecomnet.net/TECOMNET/WebClient/Views/Recharge/RechargeSure.aspx?opr=R1RXfDkxZTYyZGJlLWQxYWMtNDAzMC1hNTNkLTNiZWZmNjFiOTFjMQ==",
        .order_id = orderID,
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
        resultado = api.Pago(bodyJsonLkl)
        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            Dim linkPago As PaymentResponse = JsonSerializer.Deserialize(Of PaymentResponse)(resultado.JSON)
            Dim objLinkPago As String = linkPago.response.url
            pnlPago.Visible = True
            iframePago.Attributes("src") = objLinkPago
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "abrirModal();", True)
        End If
    End Sub
End Class