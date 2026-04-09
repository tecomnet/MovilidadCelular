Imports System.Web.UI.WebControls.Expressions

Public Class RegistrarLinea
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

        End If
    End Sub

    Protected Sub btnRegistrar_Click(sender As Object, e As EventArgs)
        System.Threading.Thread.Sleep(5000)
        pnlRegistro.Visible = False
        pnlNumeroRegistrar.Visible = False
        pnlVerificarDocumento.Visible = False
        pnlCodigoVerificacion.Visible = True
    End Sub

    Protected Sub btnVerificar_Click(sender As Object, e As EventArgs)
        System.Threading.Thread.Sleep(5000)
        pnlRegistro.Visible = False
        pnlCodigoVerificacion.Visible = False
        pnlNumeroRegistrar.Visible = True
        pnlVerificarDocumento.Visible = False
    End Sub

    Protected Sub btnContinuar_Click(sender As Object, e As EventArgs)
        System.Threading.Thread.Sleep(5000)
        pnlRegistro.Visible = False
        pnlCodigoVerificacion.Visible = False
        pnlNumeroRegistrar.Visible = False
        pnlVerificarDocumento.Visible = True
    End Sub

    Protected Sub btnContinuarDocumento_Click(sender As Object, e As EventArgs)
        System.Threading.Thread.Sleep(5000)
        pnlRegistro.Visible = False
        pnlCodigoVerificacion.Visible = False
        pnlNumeroRegistrar.Visible = False
        pnlVerificarDocumento.Visible = False
        pnlCamaraFrente.Visible = True
    End Sub

    Private Enum TipoCaptura
        Frente = 1
        Reverso = 2
    End Enum

    Private Property CapturaActual As TipoCaptura
        Get
            Return CType(ViewState("CapturaActual"), TipoCaptura)
        End Get
        Set(value As TipoCaptura)
            ViewState("CapturaActual") = value
        End Set
    End Property

    Protected Sub btnSimularCaptura_Click(sender As Object, e As EventArgs)
        CapturaActual = TipoCaptura.Frente
        OcultarTodo()
        pnlConfirmarCaptura.Visible = True
    End Sub

    Protected Sub btnSimularCapturaReverso_Click(sender As Object, e As EventArgs)
        CapturaActual = TipoCaptura.Reverso
        OcultarTodo()
        pnlConfirmarCaptura.Visible = True
    End Sub

    Protected Sub btnContinuarCaptura_Click(sender As Object, e As EventArgs)
        OcultarTodo()
        pnlConfirmarCaptura.Visible = False

        Select Case CapturaActual
            Case TipoCaptura.Frente
                pnlCamaraReverso.Visible = True
            Case TipoCaptura.Reverso
                pnlPruebaVida.Visible = True
        End Select
    End Sub

    Private Sub OcultarTodo()
        pnlRegistro.Visible = False
        pnlCodigoVerificacion.Visible = False
        pnlNumeroRegistrar.Visible = False
        pnlVerificarDocumento.Visible = False
        pnlCamaraFrente.Visible = False
        pnlCamaraReverso.Visible = False
        pnlConfirmarCaptura.Visible = False
        pnlPruebaVida.Visible = False
        pnlCapturarRostro.Visible = False
        pnlRegistroExitoso.Visible = False
        pnlConfirmarDatos.Visible = False
    End Sub

    Protected Sub btnContinuarVerificacionIdentidad_Click(sender As Object, e As EventArgs)
        OcultarTodo()
        pnlCapturarRostro.Visible = True
    End Sub

    Protected Sub btnSimularRostro_Click(sender As Object, e As EventArgs)
        OcultarTodo()
        pnlConfirmarDatos.Visible = True
    End Sub

    Protected Sub btnConfirmarDatos_Click(sender As Object, e As EventArgs)
        OcultarTodo()
        pnlRegistroExitoso.Visible = True
    End Sub
End Class