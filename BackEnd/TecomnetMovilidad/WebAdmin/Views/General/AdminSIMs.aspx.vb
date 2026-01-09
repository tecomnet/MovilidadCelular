Imports System.Drawing
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
        If e.CommandName = "Cancelar" Then
            Dim SIMID As Integer = Convert.ToInt32(e.CommandArgument)

            Dim obj As New SIM With {
                .SIMID = SIMID,
                .Estado = "Cancelada",
                .FechaBaja = DateTime.Now
            }
            Dim controller As New ControllerSIM()
            controller.UpdateSIM(obj)

            CargarSims()
        End If

    End Sub

    Protected Sub btnToggle_Click(sender As Object, e As EventArgs)
        Dim btn As LinkButton = CType(sender, LinkButton)
        Dim SIMID As Integer = Convert.ToInt32(btn.CommandArgument)
        Dim icon As HtmlGenericControl = CType(btn.FindControl("iconToggle"), HtmlGenericControl)

        Dim controller As New ControllerSIM
        Dim objSIM As New SIM
        objSIM.SIMID = SIMID

        If btn.ToolTip = "Suspender Tráfico Saliente" Then
            objSIM.Estado = "Suspendida tráfico Saliente"
        Else
            objSIM.Estado = "Activa"
        End If

        controller.UpdateSIM(objSIM)
        CargarSims() 
    End Sub

    Protected Sub btnToggleTrafico_Click(sender As Object, e As EventArgs)
        Dim btn As LinkButton = CType(sender, LinkButton)
        Dim SIMID As Integer = Convert.ToInt32(btn.CommandArgument)
        Dim icon As HtmlGenericControl = CType(btn.FindControl("iconToggleTrafico"), HtmlGenericControl)

        Dim controller As New ControllerSIM
        Dim objSIM As New SIM
        objSIM.SIMID = SIMID

        If btn.ToolTip.Contains("Suspender") Then
            objSIM.Estado = "Suspendida Trafico E/S"
        Else
            objSIM.Estado = "Activa"
        End If

        controller.UpdateSIM(objSIM)
        CargarSims()
    End Sub


    Protected Sub gvSims_RowDataBound(sender As Object, e As GridViewRowEventArgs) Handles gvSims.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim estado As String = DataBinder.Eval(e.Row.DataItem, "Estado").ToString()

            Dim btnToggle As LinkButton = CType(e.Row.FindControl("btnToggle"), LinkButton)
            Dim iconToggle As HtmlGenericControl = CType(e.Row.FindControl("iconToggle"), HtmlGenericControl)

            Dim btnToggleTrafico As LinkButton = CType(e.Row.FindControl("btnToggleTrafico"), LinkButton)
            Dim iconToggleTrafico As HtmlGenericControl = CType(e.Row.FindControl("iconToggleTrafico"), HtmlGenericControl)

            If estado = "Cancelada" Then
                btnToggle.Enabled = False
                btnToggle.CssClass = "text-secondary"
                iconToggle.Attributes("class") = "bi bi-slash-circle-fill"

                btnToggleTrafico.Enabled = False
                btnToggleTrafico.CssClass = "text-secondary"
                iconToggleTrafico.Attributes("class") = "bi bi-slash-circle-fill"
            Else
                If estado.Contains("Suspendida tráfico Saliente") Then
                    btnToggle.ToolTip = "Reanudar SIM"
                    btnToggle.CssClass = "text-success"
                    iconToggle.Attributes("class") = "bi bi-play-circle-fill"
                Else
                    btnToggle.ToolTip = "Suspender Tráfico Saliente"
                    btnToggle.CssClass = "text-warning"
                    iconToggle.Attributes("class") = "bi bi-pause-circle-fill"
                End If

                If estado.Contains("Suspendida Trafico E/S") Then
                    btnToggleTrafico.ToolTip = "Reanudar tráfico (E/S)"
                    btnToggleTrafico.CssClass = "text-primary"
                    iconToggleTrafico.Attributes("class") = "bi bi-arrow-repeat"
                Else
                    btnToggleTrafico.ToolTip = "Suspender tráfico (Entrada/Salida)"
                    btnToggleTrafico.CssClass = "text-danger"
                    iconToggleTrafico.Attributes("class") = "bi bi-slash-circle-fill"
                End If
            End If
        End If
    End Sub

    Protected Sub txtBuscarSIM_TextChanged(sender As Object, e As EventArgs) Handles txtBuscarSIM.TextChanged
        Dim texto As String = txtBuscarSIM.Text.Trim()
        CargarSims(texto)
    End Sub

    Protected Sub gvSims_PageIndexChanging(sender As Object, e As GridViewPageEventArgs)
        Dim controller As New ControllerSIM
        Dim listaSim As List(Of SIM) = controller.ObtenerSIM()

        gvSims.PageIndex = e.NewPageIndex
        gvSims.DataSource = listaSim
        gvSims.DataBind()
    End Sub
End Class