Imports Models.TECOMNET
Public Class MiPerfil
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
        ValidationSettings.UnobtrusiveValidationMode = UnobtrusiveValidationMode.None
        If Not Page.IsPostBack Then
            lblNombre.Text = Customer.Nombre
            lblApellidoP.Text = Customer.ApellidoPaterno
            lblApellidoM.Text = Customer.ApellidoMaterno
            lblFechaCumpleanios.Text = Customer.FechaCumpleanios.GetValueOrDefault().ToString("dd/MM/yyyy")
            lblCurp.Text = Customer.CURP
            lblTelefono.Text = Customer.Telefono
            lblEmail.Text = Customer.Email
            lblEstado.Text = Customer.Estado
            lblColonia.Text = Customer.Colonia
            lblDireccion.Text = Customer.Direccion
            lblCP.Text = Customer.CP
            lblRFC.Text = Customer.RFC
            lblRFCFacturacion.Text = Customer.RFCFacturacion
            lblRazonSocial.Text = Customer.NombreRazonSocial
            lblRegimenFiscal.Text = Customer.RegimenFiscal

            'rtbPaternalSurname.Text = Customer.PaternalSurname
            'rtbMaternalSurname.Text = Customer.MaternalSurname
            'rtbName.Text = Customer.Name
            'rdpDateBirth.SelectedDate = Customer.DateBirth
            'rtbCustomerName.Text = Customer.CustomerName
            'tbEmail.Text = Customer.Email
            'tbPhoneNumber.Text = Customer.PhoneNumber
            'rtbRFC.Text = Customer.RFC
            'ddlSex.SelectedValue = Customer.Sex
            'ddlCountry.SelectedValue = Customer.Country
            'ddlState.SelectedValue = Customer.State
            'rtbCologne.Text = Customer.Cologne
            'rtbAddress.Text = Customer.Address
            'rtbZipCode.Text = Customer.ZipCode
        End If
    End Sub

End Class