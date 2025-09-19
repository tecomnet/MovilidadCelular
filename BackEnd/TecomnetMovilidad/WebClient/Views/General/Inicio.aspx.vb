Imports System.Text.Json
Imports DatabaseConnection
Imports Models.TECOMNET
Imports Models.TECOMNET.API
Imports Models.TECOMNET.Enumeraciones
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

    Private Sub lvPaquetes_ItemCommand(sender As Object, e As ListViewCommandEventArgs) Handles lvPaquetes.ItemCommand
        If e.CommandName = "Renovar" Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim objOrderId As String

            Dim dataKey As DataKey = lvPaquetes.DataKeys(index)

            Dim ofertaID As Integer = Convert.ToInt32(dataKey("OfertaID"))
            Dim ICCID As String = dataKey("ICCID")
            Dim MSISDN As String = dataKey("MSISDN")


            Dim api As New ConsumoApis
            Dim resultadoTablero As New MessageResult

            Dim resultadoOferta As MessageResult = api.GetOfertaId(ofertaID)
            Dim ofertaActual As Oferta = JsonSerializer.Deserialize(Of Oferta)(resultadoOferta.JSON)

            If resultadoOferta.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                ofertaActual = JsonSerializer.Deserialize(Of Oferta)(resultadoOferta.JSON)
            Else
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('No se pudo obtener la información de la oferta.');", True)
                Return
            End If

            Dim precio As Decimal


            Select Case ofertaActual.Tipo
                Case TipoServicio.Prepago
                    precio = ofertaActual.PrecioRecurrente
                Case TipoServicio.RenovacionAutomatica
                    precio = ofertaActual.PrecioMensual
                Case TipoServicio.PagoAnticipado
                    precio = ofertaActual.PrecioAnual
                Case Else
                    precio = ofertaActual.PrecioMensual
            End Select

            Dim body = New With {
        .SolicitudID = "",
        .OrderID = "",
        .MetodoPagoID = "1",'1 pago con tarjeta 
        .OfertaIDActual = ofertaID,
        .OfertaIDNueva = ofertaID,
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
            .email = "daniel.arzate@knesysplus.com",
            .commerceName = "TECOMNET",
            .supportEmail = "recargas@tecomnet.mx",
            .description = "Recarga $600 - 1000 MB",
            .response_url = "https://tecomnet.net/movilidad/webhook/ValidatePay/",
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
                pnlPago.Visible = True
                iframePago.Attributes("src") = linkPago.response.url
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "abrirModal();", True)
            Else
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('No se pudo generar el link de pago.');", True)
            End If
        End If
    End Sub

    Private Sub lvPaquetes_ItemDataBound(sender As Object, e As ListViewItemEventArgs) Handles lvPaquetes.ItemDataBound
        If e.Item.ItemType = ListViewItemType.DataItem Then
            Dim data As Tablero = CType(e.Item.DataItem, Tablero)

            Dim btnRenovar As LinkButton = CType(e.Item.FindControl("btnRenovar"), LinkButton)
            Dim hlRecargarSaldo As HyperLink = CType(e.Item.FindControl("hlRecargarSaldo"), HyperLink)

            Dim tipoPlan As TipoServicio = CType(data.Tipo.GetInt32(), TipoServicio)

            Select Case tipoPlan
                Case TipoServicio.Prepago
                    btnRenovar.Visible = False
                    hlRecargarSaldo.Visible = True
                Case TipoServicio.RenovacionAutomatica, TipoServicio.PagoAnticipado
                    btnRenovar.Visible = True
                    hlRecargarSaldo.Visible = True
            End Select
        End If
    End Sub

End Class