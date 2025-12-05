Imports System.Text.Json
Imports DatabaseConnection
Imports Models.TECOMNET

Public Class CompraRealizada
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim orderId As String = Request.QueryString("orderId")

            If String.IsNullOrEmpty(orderId) Then
                lblMensaje.Text = "OrderID no proporcionado."
                Return
            End If

            Dim api As New ConsumoApis
            Dim resultado As MessageResult = api.ObtenerSolicitudPago(orderId)

            If resultado.ErrorID = Enumeraciones.TipoErroresAPI.Exito Then
                Dim respuestaWrapper As RespuestaSolicitudPago = JsonSerializer.Deserialize(Of RespuestaSolicitudPago)(resultado.JSON)
                Dim respuesta As SolicitudDePago = respuestaWrapper.objSolicitudDePago

                Select Case respuesta.Estatus.ToLower()
                    Case "approved"
                        lblMensaje.Text = $"Pago aprobado: ICCID: {respuesta.ICCID}, MSISDN: {respuesta.MSISDN}, SolicitudID: {respuesta.SolicitudID}, Estatus: {respuesta.Estatus}"
                    Case "created"
                        lblMensaje.Text = "El pago está en estado creado, aún no aprobado."
                    Case Else
                        lblMensaje.Text = $"Pago en estado: {respuesta.Estatus}. No aprobado."
                End Select

            Else
                lblMensaje.Text = "No se pudo obtener la información del pago: " & resultado.JSON
            End If
        End If
    End Sub

End Class
