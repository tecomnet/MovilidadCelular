'------------------------------------------------------------------------------
' <generado automáticamente>
'     Este código fue generado por una herramienta.
'
'     Los cambios en este archivo podrían causar un comportamiento incorrecto y se perderán si
'     se vuelve a generar el código. 
' </generado automáticamente>
'------------------------------------------------------------------------------

Option Strict On
Option Explicit On


Partial Public Class AdminOfertas

    '''<summary>
    '''Control pnlAdminOfertas.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pnlAdminOfertas As Global.System.Web.UI.WebControls.Panel

    '''<summary>
    '''Control btnAgregarOfertas.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnAgregarOfertas As Global.System.Web.UI.WebControls.Button

    '''<summary>
    '''Control ddlFiltroTipoOferta.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ddlFiltroTipoOferta As Global.System.Web.UI.WebControls.DropDownList

    '''<summary>
    '''Control pnlTabla.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pnlTabla As Global.System.Web.UI.WebControls.Panel

    '''<summary>
    '''Control gvOfertas.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents gvOfertas As Global.System.Web.UI.WebControls.GridView

    '''<summary>
    '''Control pnlAgregar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents pnlAgregar As Global.System.Web.UI.WebControls.Panel

    '''<summary>
    '''Control hdnOfertaId.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents hdnOfertaId As Global.System.Web.UI.WebControls.HiddenField

    '''<summary>
    '''Control lblMensaje.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents lblMensaje As Global.System.Web.UI.WebControls.Label

    '''<summary>
    '''Control txtOfertaIdAltan.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtOfertaIdAltan As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvOfertaIdAltan.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvOfertaIdAltan As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control txtHomologacioId.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtHomologacioId As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvHomologacioId.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvHomologacioId As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control ddlTipoOferta.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ddlTipoOferta As Global.System.Web.UI.WebControls.DropDownList

    '''<summary>
    '''Control rfvTipoOferta.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvTipoOferta As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control divPrecioRecarga.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents divPrecioRecarga As Global.System.Web.UI.WebControls.Panel

    '''<summary>
    '''Control txtPrecioRecarga.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtPrecioRecarga As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvPrecioRecarga.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvPrecioRecarga As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control revPrecioRecarga.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents revPrecioRecarga As Global.System.Web.UI.WebControls.RegularExpressionValidator

    '''<summary>
    '''Control divPrecioAnual.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents divPrecioAnual As Global.System.Web.UI.WebControls.Panel

    '''<summary>
    '''Control txtPrecioAnual.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtPrecioAnual As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvPrecioAnual.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvPrecioAnual As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control revPrecioAnual.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents revPrecioAnual As Global.System.Web.UI.WebControls.RegularExpressionValidator

    '''<summary>
    '''Control divPrecioMensual.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents divPrecioMensual As Global.System.Web.UI.WebControls.Panel

    '''<summary>
    '''Control txtPrecioMensual.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtPrecioMensual As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvPrecioMensual.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvPrecioMensual As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control revPrecioMensual.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents revPrecioMensual As Global.System.Web.UI.WebControls.RegularExpressionValidator

    '''<summary>
    '''Control txtOferta.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtOferta As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvOferta.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvOferta As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control txtDescripcion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtDescripcion As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvDescripcion.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvDescripcion As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control txtDatosMB.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtDatosMB As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvDatosMB.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvDatosMB As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control revDatosMB.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents revDatosMB As Global.System.Web.UI.WebControls.RegularExpressionValidator

    '''<summary>
    '''Control txtMinutos.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtMinutos As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvMinutos.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvMinutos As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control revMinutos.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents revMinutos As Global.System.Web.UI.WebControls.RegularExpressionValidator

    '''<summary>
    '''Control txtSms.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtSms As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvSms.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvSms As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control revSms.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents revSms As Global.System.Web.UI.WebControls.RegularExpressionValidator

    '''<summary>
    '''Control txtValidezDias.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtValidezDias As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvValidezDias.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvValidezDias As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control revValidezDias.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents revValidezDias As Global.System.Web.UI.WebControls.RegularExpressionValidator

    '''<summary>
    '''Control ddlAplicaRoaming.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ddlAplicaRoaming As Global.System.Web.UI.WebControls.DropDownList

    '''<summary>
    '''Control rfvAplicaRoaming.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvAplicaRoaming As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control ddlTarifaPrimaria.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ddlTarifaPrimaria As Global.System.Web.UI.WebControls.DropDownList

    '''<summary>
    '''Control rfvTarifaPrimaria.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvTarifaPrimaria As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control ddlRedesSociales.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents ddlRedesSociales As Global.System.Web.UI.WebControls.DropDownList

    '''<summary>
    '''Control rfvRedesSociales.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvRedesSociales As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control txtFechaAlta.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents txtFechaAlta As Global.System.Web.UI.WebControls.TextBox

    '''<summary>
    '''Control rfvFechaAlta.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents rfvFechaAlta As Global.System.Web.UI.WebControls.RequiredFieldValidator

    '''<summary>
    '''Control btnGuardar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnGuardar As Global.System.Web.UI.WebControls.Button

    '''<summary>
    '''Control btnCancelar.
    '''</summary>
    '''<remarks>
    '''Campo generado automáticamente.
    '''Para modificarlo, mueva la declaración del campo del archivo del diseñador al archivo de código subyacente.
    '''</remarks>
    Protected WithEvents btnCancelar As Global.System.Web.UI.WebControls.Button
End Class
