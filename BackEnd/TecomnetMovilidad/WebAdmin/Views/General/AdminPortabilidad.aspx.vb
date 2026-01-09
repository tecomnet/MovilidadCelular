Imports System.IO
Imports DatabaseConnection
Imports Models
Imports Models.TECOMNET.Enumeraciones

Public Class AdminPortabilidad
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarDatos()
            TxtFechaRegistro.Text = DateTime.Now.ToString("yyyy-MM-dd")
            ddlTipoPortabilidad.SelectedValue = "2"

        End If
    End Sub

    Private Sub CargarDatos(Optional filtro As String = "")
        Dim controller As New ControllerPortabilidad
        Dim listaPortabilidad As List(Of Portabilidad) = controller.GetPortabilidad

        If Not String.IsNullOrEmpty(filtro) Then
            filtro = filtro.ToLower()

            listaPortabilidad = listaPortabilidad.
            Where(Function(u) u.MSISDN_Transitorio.ToLower().Contains(filtro) _
                            Or u.MSISDN.ToLower().Contains(filtro)).
            ToList()
        End If

        gvDatosPortabilidad.DataSource = listaPortabilidad
        gvDatosPortabilidad.DataBind()
        pnlDatosGenerales.Visible = False
        PnlBotones.Visible = True
    End Sub

    Protected Sub btnAgregarManual_Click(sender As Object, e As EventArgs)
        PnlAdminPortabilidad.Visible = True
        pnlDatosGenerales.Visible = True
        PnlTabla.Visible = False
        PnlBotones.Visible = False
    End Sub

    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Dim controllerPortabilidad As New ControllerPortabilidad
        Dim objPortabilidad As New Portabilidad

        objPortabilidad.PortabilidadID = If(String.IsNullOrEmpty(hdnPortabilidadId.Value), 0, Convert.ToInt32(hdnPortabilidadId.Value))
        objPortabilidad.MSISDN = txtMSISDN.Text
        objPortabilidad.MSISDN_Transitorio = txtMSISDN_Transitorio.Text
        objPortabilidad.CompaniaOrigen = txtCompaniaOrigen.Text
        objPortabilidad.Estatus = "Pendiente"
        objPortabilidad.Response = ""
        If Not String.IsNullOrWhiteSpace(TxtFechaRegistro.Text) Then
            objPortabilidad.FechaRegistro = Date.Parse(TxtFechaRegistro.Text).Date
        Else
            objPortabilidad.FechaRegistro = DateTime.Now.Date
        End If
        objPortabilidad.TipoPortabilidad = Models.TECOMNET.Enumeraciones.TipoPortabilidad.Manual
        If objPortabilidad.PortabilidadID = 0 Then
            Dim portabilidad As Integer = controllerPortabilidad.AddPortabilidad(objPortabilidad)
            hdnPortabilidadId.Value = portabilidad.ToString()
            LimpiarCampos()
            CargarDatos()
            PnlBotones.Visible = True
            PnlAdminPortabilidad.Visible = True
            PnlBotones.Visible = True
            PnlTabla.Visible = True

        Else

        End If

    End Sub

    Private Sub LimpiarCampos()
        hdnPortabilidadId.Value = ""

        txtMSISDN.Text = ""
        txtMSISDN_Transitorio.Text = ""
        txtCompaniaOrigen.Text = ""
        TxtFechaRegistro.Text = DateTime.Now.ToString("yyyy-MM-dd")

    End Sub

    Protected Sub btnCargarBatch_Click(sender As Object, e As EventArgs)
        If fileUploadBatch.HasFile Then
            Try
                Dim rutaTemp As String = Server.MapPath("~/Temp/")

                If Not Directory.Exists(rutaTemp) Then
                    Directory.CreateDirectory(rutaTemp)
                End If

                Dim filePath As String = Path.Combine(rutaTemp, Path.GetFileName(fileUploadBatch.FileName))

                fileUploadBatch.SaveAs(filePath)

                Dim lineas() As String = File.ReadAllLines(filePath)
                Dim controller As New ControllerPortabilidad()

                For i As Integer = 0 To lineas.Length - 1
                    Dim campos() As String = lineas(i).Split("|"c)

                    If campos.Length >= 3 Then

                        Dim objPortabilidad As New Portabilidad()
                        objPortabilidad.MSISDN_Transitorio = campos(0).Trim()
                        objPortabilidad.MSISDN = campos(2).Trim()
                        objPortabilidad.CompaniaOrigen = ""
                        objPortabilidad.Estatus = "Pendiente"
                        objPortabilidad.FechaRegistro = DateTime.Now.Date
                        objPortabilidad.TipoPortabilidad = TipoPortabilidad.Batch
                        objPortabilidad.Response = ""

                        controller.AddPortabilidad(objPortabilidad)
                    End If
                Next

                lblMensajeBatch.Text = "✅ Archivo CSV cargado correctamente."
                File.Delete(filePath)
                CargarDatos()

            Catch ex As Exception
                lblMensajeBatch.Text = "❌ Error: " & ex.Message
            End Try
        Else
            lblMensajeBatch.Text = "Por favor selecciona un archivo CSV."
        End If
        ClientScript.RegisterStartupScript(Me.GetType(), "HideMessage", "setTimeout(function(){ document.getElementById('" & lblMensajeBatch.ClientID & "').innerText = ''; }, 3000);", True)
    End Sub

    Private Sub gvDatosPortabilidad_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvDatosPortabilidad.RowCommand
        If e.CommandName = "AceptarSolicitud" Then

            Dim btn As Control = CType(e.CommandSource, Control)
            Dim row As GridViewRow = CType(btn.NamingContainer, GridViewRow)

            Dim pnlOrderId As Panel = CType(row.FindControl("pnlOrderId"), Panel)
            pnlOrderId.Visible = True

        End If


        If e.CommandName = "GuardarOrderId" Then

            Dim portabilidadID As Integer = Convert.ToInt32(e.CommandArgument)

            Dim btn As Control = CType(e.CommandSource, Control)
            Dim row As GridViewRow = CType(btn.NamingContainer, GridViewRow)

            Dim txtOrderId As TextBox = CType(row.FindControl("txtOrderId"), TextBox)
            Dim orderId As String = txtOrderId.Text.Trim()


            Dim obj As New Portabilidad With {
                .PortabilidadID = portabilidadID,
                .Response = orderId,
                .Estatus = "Completada",
                .FechaTermino = DateTime.Now
            }

            Dim controller As New ControllerPortabilidad
            controller.UpdatePortabilidad(obj)

            CargarDatos()

        End If

        If e.CommandName = "Rechazar" Then
            Dim portabilidadID As Integer = Convert.ToInt32(e.CommandArgument)

            Dim obj As New Portabilidad With {
        .PortabilidadID = portabilidadID,
        .Estatus = "Rechazada",
        .FechaRechazo = DateTime.Now
    }

            Dim controller As New ControllerPortabilidad()
            controller.UpdatePortabilidad(obj)

            CargarDatos()
        End If

        If e.CommandName = "Cancelar" Then
            Dim portabilidadID As Integer = Convert.ToInt32(e.CommandArgument)

            Dim obj As New Portabilidad With {
        .PortabilidadID = portabilidadID,
        .Estatus = "Cancelada",
        .FechaCancelacion = DateTime.Now
    }

            Dim controller As New ControllerPortabilidad()
            controller.UpdatePortabilidad(obj)

            CargarDatos()
        End If

        If e.CommandName = "Descargar" Then
            Dim portabilidadID As Integer = Convert.ToInt32(e.CommandArgument)

            Dim controller As New ControllerPortabilidad
            Dim lista As List(Of Portabilidad) = controller.GetPortabilidad
            Dim registro As Portabilidad = lista.FirstOrDefault(Function(p) p.PortabilidadID = portabilidadID)

            If registro IsNot Nothing Then
                Dim sb As New Text.StringBuilder()
                sb.AppendLine($"{registro.MSISDN_Transitorio}||{registro.MSISDN}||||||Y|")

                Response.Clear()
                Response.ContentType = "text/csv"
                Response.AddHeader("Content-Disposition", $"attachment; filename=portabilidad_{portabilidadID}.csv")
                Response.Write(sb.ToString())
                Response.End()

            End If
        End If

    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        Response.Redirect("~/Views/General/AdminPortabilidad.aspx")
    End Sub

    Protected Sub btnGenerarCsv_Click(sender As Object, e As EventArgs)
        Try
            Dim controller As New ControllerPortabilidad
            Dim lista As New List(Of Portabilidad)

            lista = controller.GetPortabilidad

            Dim sb As New Text.StringBuilder()

            For Each p In lista
                sb.AppendLine($"{p.MSISDN_Transitorio}||{p.MSISDN}||||||Y|")
            Next

            Response.Clear()
            Response.ContentType = "text/csv"
            Response.AddHeader("Content-Disposition", "attachment; filename=portabilidades.csv")
            Response.Write(sb.ToString())
            Response.End()
        Catch ex As Exception

        End Try
    End Sub

    Protected Sub txtBuscarPortabilidad_TextChanged(sender As Object, e As EventArgs) Handles txtBuscarPortabilidad.TextChanged
        Dim texto As String = txtBuscarPortabilidad.Text.Trim()
        CargarDatos(texto)
    End Sub

    Protected Sub gvDatosPortabilidad_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        Dim controller As New ControllerPortabilidad
        Dim listaPortabilidad As List(Of Portabilidad) = controller.GetPortabilidad

        gvDatosPortabilidad.PageIndex = e.NewPageIndex
        gvDatosPortabilidad.DataSource = listaPortabilidad
        gvDatosPortabilidad.DataBind()
    End Sub
End Class