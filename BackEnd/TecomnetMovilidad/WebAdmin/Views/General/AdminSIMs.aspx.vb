Imports DatabaseConnection
Imports Models.TECOMNET

Public Class AdminSIMs
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            CargarSims()
        End If
    End Sub

    Private Sub CargarSims(Optional filtro As String = "")
        Dim controller As New ControllerSIM
        Dim listaSim As List(Of SIM) = controller.ObtenerSIM()

        If Not String.IsNullOrEmpty(filtro) Then
            filtro = filtro.ToLower()

            listaSim = listaSim.
            Where(Function(u) u.ICCID.ToLower().Contains(filtro) _
                            Or u.MSISDN.ToLower().Contains(filtro)).
            ToList()
        End If

        gvSims.DataSource = listaSim
        gvSims.DataBind()
    End Sub

    Private Sub MostrarDetalleSIM(simId As Integer)
        Dim controllerSim As New ControllerSIM
        Dim controllerOferta As New ControllerOferta
        Dim controllerCliente As New ControllerCliente
        Dim sim As SIM = controllerSim.ObtenerSIMPorID(simId)
        Dim oferta As Oferta = Nothing
        Dim cliente As Cliente = Nothing
        If sim.OfertaId.HasValue Then
            oferta = controllerOferta.ObtenerOferta(sim.OfertaId)
        End If
        If sim.ClienteId.HasValue Then
            cliente = controllerCliente.ObtenerClientePorID(sim.ClienteId)
        End If


        If sim IsNot Nothing Then
            lblModalICCID.InnerText = sim.ICCID
            lblModalMSISDN.InnerText = sim.MSISDN
            lblModalEstado.InnerText = sim.Estado
            lblModalMBUsados.InnerText = sim.MBUsados
            lblModalMBDisponibles.InnerText = sim.MBDisponibles
            If sim.FechaVencimiento.HasValue Then
                lblModalVencimiento.InnerText = sim.FechaVencimiento.Value.ToString("yyyy/MM/dd")
            Else
                lblModalVencimiento.InnerText = "-"
            End If
            lblModalPlan.InnerText = If(oferta IsNot Nothing, oferta.Oferta, "-")
            lblModalCliente.InnerText = If(cliente IsNot Nothing, cliente.Nombre, "-")

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "MostrarModal", "var myModal = new bootstrap.Modal(document.getElementById('modalDetalleSIM')); myModal.show();", True)
        End If
    End Sub
    Protected Sub gvSims_RowCommand(sender As Object, e As GridViewCommandEventArgs) Handles gvSims.RowCommand
        If e.CommandName = "VerSim" Then
            Dim simId As Integer = Convert.ToInt32(e.CommandArgument)
            MostrarDetalleSIM(simId)
        End If
    End Sub

    Protected Sub btnToggle_Click(sender As Object, e As EventArgs)
        Dim btn As LinkButton = CType(sender, LinkButton)
        Dim icon As HtmlGenericControl = CType(btn.FindControl("iconToggle"), HtmlGenericControl)

        ' Usamos el ToolTip como indicador del estado actual
        If btn.ToolTip = "Suspender SIM" Then
            ' Cambiar a estado "suspendido"
            btn.CssClass = "text-success"
            btn.ToolTip = "Reanudar SIM"
            icon.Attributes("class") = "bi bi-play-circle-fill"
        Else
            ' Cambiar a estado "activo"
            btn.CssClass = "text-warning"
            btn.ToolTip = "Suspender SIM"
            icon.Attributes("class") = "bi bi-pause-circle-fill"
        End If
    End Sub

    Protected Sub btnToggleTrafico_Click(sender As Object, e As EventArgs)
        Dim btn As LinkButton = CType(sender, LinkButton)
        Dim icon As HtmlGenericControl = CType(btn.FindControl("iconToggleTrafico"), HtmlGenericControl)

        If btn.ToolTip.Contains("Suspender") Then
            btn.CssClass = "text-primary"
            btn.ToolTip = "Reanudar tráfico (Entrada/Salida)"
            icon.Attributes("class") = "bi bi-arrow-repeat"
        Else

            btn.CssClass = "text-danger"
            btn.ToolTip = "Suspender tráfico (Entrada/Salida)"
            icon.Attributes("class") = "bi bi-slash-circle-fill"
        End If
    End Sub

    Protected Sub txtBuscarSIM_TextChanged(sender As Object, e As EventArgs) Handles txtBuscarSIM.TextChanged
        Dim texto As String = txtBuscarSIM.Text.Trim()
        CargarSims(texto)
    End Sub
End Class