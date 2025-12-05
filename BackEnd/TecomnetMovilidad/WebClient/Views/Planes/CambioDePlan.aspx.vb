Imports System.Text.Json
Imports Models.TECOMNET
Imports Models.TECOMNET.API
Imports Models.TECOMNET.Enumeraciones
Imports Models.TECOMNET.LinkX
Public Class CambioDePlan
    Inherits System.Web.UI.Page
    Private Property Customer As Cliente
        Get
            Return Session("Usuario")
        End Get
        Set(value As Cliente)
            Session("Usuario") = value
        End Set
    End Property

    Public Property SIMID As Integer
        Get
            Return Request.QueryString("sd")
        End Get
        Set(value As Integer)
            Request.QueryString("sd") = value
        End Set
    End Property
    Public Property ICCID As String
        Get
            Return Request.QueryString("ICCID")
        End Get
        Set(value As String)
            Request.QueryString("ICCID") = value
        End Set
    End Property
    Public Property OfertaActualId As Integer
        Get
            Return Request.QueryString("oi")
        End Get
        Set(value As Integer)
            Request.QueryString("oi") = value
        End Set
    End Property
    Public Property MSISDN As String
        Get
            Return Request.QueryString("MSISDN")
        End Get
        Set(value As String)
            Request.QueryString("MSISDN") = value
        End Set
    End Property


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not Page.IsPostBack Then
            llenaDatos()
        End If
    End Sub

#Region "Function"
    Private Sub GetProductos()
        Dim objController As New ConsumoApis
        lvCambioPlan.DataSource = objController.GetOfertaTipo(3)
        lvCambioPlan.DataBind()
    End Sub
    Public Sub llenaDatos()



        If Val(Request.QueryString("sd")) = 0 Then
            Dim objController As New ConsumoApis
            Dim resultado As MessageResult = objController.GetTablero(Customer.ClienteId)
            If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Dim listaSIMS As List(Of Tablero) = JsonSerializer.Deserialize(Of List(Of Tablero))(resultado.JSON)

                If listaSIMS.Count = 1 Then
                    Dim unicaSim As Tablero = listaSIMS.First()

                    Dim url As String = String.Format("~/Views/Planes/CambioDePlan.aspx?sd={0}&ICCID={1}&oi={2}&MSISDN={3}", unicaSim.SIMID, unicaSim.ICCID, unicaSim.OfertaID, unicaSim.MSISDN)
                    Response.Redirect(url)
                Else
                    lvSIMS.DataSource = listaSIMS
                    lvSIMS.DataBind()
                    pnlSim.Visible = True
                    pnlMenuOpciones.Visible = False
                    pnlPlanes.Visible = False
                End If
            End If

        Else
            CargarTipos()

            pnlSim.Visible = False
            pnlMenuOpciones.Visible = True
            pnlPlanes.Visible = False




        End If
    End Sub




#End Region
    Public Function CambioPlan(SIMID As Integer) As List(Of Oferta)

        Dim api As New ConsumoApis
        Dim resultado As New MessageResult
        Dim lista As New List(Of Oferta)

        resultado = api.GetOfertaTipo(SIMID)

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            lista = JsonSerializer.Deserialize(Of List(Of Oferta))(resultado.JSON)
        End If
        Return lista
    End Function
    Private Function GenerarLinkPago(ofertaNueva As Oferta) As String
        Dim api As New ConsumoApis
        Dim precio As Decimal
        Dim objOrderId As String
        Dim MSISDN As String = Request.QueryString("MSISDN")


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
    .OfertaIDActual = Request.QueryString("oi"),
    .OfertaIDNueva = ofertaNueva.OfertaID,
    .Monto = precio,
    .ICCID = Request.QueryString("ICCID"),
    .MSISDN = Request.QueryString("MSISDN"),
    .Estatus = "",
    .FechaCreacion = "",
    .EstatusDepositoID = "",
    .IdTransaction = "",
    .AuthNumber = "",
    .AuthCode = "",
    .Reason = "",
    .PagoDepositoID = "",
    .CanalDeVenta = "2",
    .TipoOperacion = "3",
    .UltimaActualizacion = "",
    .NumeroReintentos = "",
    .DistribuidorID = "1"
            }

        Dim bodyJson As String = JsonSerializer.Serialize(body)
        Dim resultado As New MessageResult

        resultado = api.SolicitudPago(bodyJson)

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            Dim jsonDoc = JsonDocument.Parse(resultado.JSON)
            objOrderId = jsonDoc.RootElement.GetProperty("OrderID").GetString()
        End If

        Dim tokenString As String = DateTime.Now.ToString("o") ' ISO 8601
        Dim tokenBytes As Byte() = Encoding.UTF8.GetBytes(tokenString)
        Dim tokenBase64 As String = Convert.ToBase64String(tokenBytes)

        Dim urlExito As String = $"https://tecomnet.net/movilidad/clientes/Views/General/ValidaRecarga.aspx?token={tokenBase64}"
        'Dim urlExito As String = "https://tecomnet.net/movilidad/clientes/Views/General/ValidaRecarga.aspx"


        Dim bodyLkl = New With {
        .amount = precio,
        .displayAmount = precio,
        .displayCurrency = "MXN",
        .language = "es",
        .email = "cliente@correo.com",
        .commerceName = "TECOMNET",
        .supportEmail = "recargas@tecomnet.mx",
        .description = "Recarga " & ofertaNueva.Oferta,
        .response_url = "https://tecomnet.net/movilidad/webhook/ValidatePay/CompraRecarga/",
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

    Protected Sub btnLoQuiero_Click(sender As Object, e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim ofertaId As Integer = Convert.ToInt32(btn.CommandArgument)

        Dim api As New ConsumoApis
        Dim resultadoOferta As MessageResult = api.GetOfertaId(ofertaId)
        Dim ofertaActual As Oferta = JsonSerializer.Deserialize(Of Oferta)(resultadoOferta.JSON)

        Dim linkPago As String = GenerarLinkPago(ofertaActual)

        If Not String.IsNullOrEmpty(linkPago) Then
            pnlPago.Visible = True
            iframePago.Attributes("src") = linkPago
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "abrirModal();", True)
        Else
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('No se pudo generar el link de pago.');", True)
        End If
    End Sub
    Private Sub CargarTipos()

        Dim api As New ConsumoApis
        Dim resultadoOferta As MessageResult = api.GetOfertaId(OfertaActualId)
        If resultadoOferta.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            Dim ofertaActual As Oferta = JsonSerializer.Deserialize(Of Oferta)(resultadoOferta.JSON)



            Dim tipos As New List(Of Object) From {
    New With {.TipoPlan = TipoServicio.RenovacionAutomatica, .Titulo = "Mensual", .Descripcion = "Contrata un plan recurrente con pago mensual", .IconoCss = "bi bi-calendar3", ICCID, OfertaActualId, SIMID, MSISDN},
    New With {.TipoPlan = TipoServicio.Prepago, .Titulo = "Recarga", .Descripcion = "Compra paquetes de datos de forma inmediata", .IconoCss = "bi bi-lightning-fill", ICCID, OfertaActualId, SIMID, MSISDN},
    New With {.TipoPlan = TipoServicio.PagoAnticipado, .Titulo = "Anual", .Descripcion = "Planes con pago anticipado por 12 meses", .IconoCss = "bi bi-award", ICCID, OfertaActualId, SIMID, MSISDN}
}


            Dim tiposAlternativos As List(Of Object) = New List(Of Object)()

            Select Case ofertaActual.Tipo
                Case TipoServicio.RenovacionAutomatica
                    tiposAlternativos = tipos.Where(Function(t) t.TipoPlan = TipoServicio.Prepago Or t.TipoPlan = TipoServicio.PagoAnticipado).ToList()
                Case TipoServicio.Prepago
                    tiposAlternativos = tipos.Where(Function(t) t.TipoPlan = TipoServicio.RenovacionAutomatica Or t.TipoPlan = TipoServicio.PagoAnticipado).ToList()
                Case TipoServicio.PagoAnticipado
                    tiposAlternativos = tipos.Where(Function(t) t.TipoPlan = TipoServicio.RenovacionAutomatica Or t.TipoPlan = TipoServicio.Prepago).ToList()
                Case Else
                    tiposAlternativos = tipos.ToList()
            End Select

            lvTipos.DataSource = tiposAlternativos
            lvTipos.DataBind()
        End If

    End Sub


    Protected Sub lvTipos_ItemCommand(source As Object, e As ListViewCommandEventArgs) Handles lvTipos.ItemCommand
        If e.CommandName = "SeleccionarTipo" Then
            Dim index As Integer = Convert.ToInt32(e.CommandArgument)
            Dim simid As Integer = Convert.ToInt32(lvTipos.DataKeys(index)("SIMID"))
            Dim iccid As String = lvTipos.DataKeys(index)("ICCID").ToString()
            Dim ofertaId As Integer = Convert.ToInt32(lvTipos.DataKeys(index)("OfertaID"))
            Dim msisdn As String = lvTipos.DataKeys(index)("MSISDN").ToString()

            Session("ICCIDSeleccionada") = iccid
            Session("OfertaActualId") = ofertaId
            Session("MSISDN") = msisdn

            Dim tipoSeleccionado As Integer = CInt(lvTipos.DataKeys(index)("TipoPlan"))

            Select Case tipoSeleccionado
                Case TipoServicio.RenovacionAutomatica
                    lblTituloPlanes.Text = "Opciones disponibles (Mensual)"
                Case TipoServicio.Prepago
                    lblTituloPlanes.Text = "Opciones disponibles (Recarga)"
                Case TipoServicio.PagoAnticipado
                    lblTituloPlanes.Text = "Opciones disponibles (Anual)"
            End Select


            pnlMenuOpciones.Visible = False
            pnlPlanes.Visible = True
            lvCambioPlan.DataSource = CambioPlanFiltrado(simid, tipoSeleccionado)
            lvCambioPlan.DataBind()
        End If
    End Sub
    Public Function CambioPlanFiltrado(SIMID As Integer, tipoPlan As Integer) As List(Of Oferta)
        Dim api As New ConsumoApis
        Dim resultado As New MessageResult
        Dim lista As New List(Of Oferta)

        resultado = api.GetOfertaTipo(tipoPlan)

        If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
            lista = JsonSerializer.Deserialize(Of List(Of Oferta))(resultado.JSON)
            ' Filtra por el tipo de plan seleccionado
            lista = lista.Where(Function(o) CInt(o.Tipo) = tipoPlan).ToList()
        End If

        Return lista
    End Function

End Class