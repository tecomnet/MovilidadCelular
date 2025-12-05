Imports System.Runtime.InteropServices.WindowsRuntime

Public Class RegimenFiscal
    Public Property CodigoRegimenFiscal As String
    Public Property Descripcion As String
    Public Sub New()
    End Sub
    Public Sub New(CodigoRegimenFiscal As String, Descripcion As String)
        Me.CodigoRegimenFiscal = CodigoRegimenFiscal
        Me.Descripcion = Descripcion
    End Sub

    Public Function RegimenFiscalMoral() As List(Of RegimenFiscal)
        Dim listRegimen As New List(Of RegimenFiscal)
        listRegimen.Add(New RegimenFiscal("601", "General de Ley Personas Morales"))
        listRegimen.Add(New RegimenFiscal("603", "Personas Morales con Fines no Lucrativos"))
        listRegimen.Add(New RegimenFiscal("610", "Residentes en el Extranjero sin Establecimiento Permanente en México"))
        listRegimen.Add(New RegimenFiscal("620", "Sociedades Cooperativas de Producción que optan por diferir sus ingresos"))
        listRegimen.Add(New RegimenFiscal("622", "Actividades Agrícolas, Ganaderas, Silvícolas y Pesqueras"))
        listRegimen.Add(New RegimenFiscal("623", "Opcional para Grupos de Sociedades"))
        listRegimen.Add(New RegimenFiscal("624", "Coordinados"))
        listRegimen.Add(New RegimenFiscal("626", "Régimen Simplificado de Confianza"))

        Return listRegimen
    End Function
    Public Function RegimenFiscalFisica() As List(Of RegimenFiscal)
        Dim listRegimen As New List(Of RegimenFiscal)
        listRegimen.Add(New RegimenFiscal("605", "Sueldos y Salarios e Ingresos Asimilados a Salarios"))
        listRegimen.Add(New RegimenFiscal("606", "Arrendamiento"))
        listRegimen.Add(New RegimenFiscal("607", "Régimen de Enajenación o Adquisición de Bienes"))
        listRegimen.Add(New RegimenFiscal("608", "Demás ingresos"))
        listRegimen.Add(New RegimenFiscal("610", "Residentes en el Extranjero sin Establecimiento Permanente en México"))
        listRegimen.Add(New RegimenFiscal("611", "Ingresos por Dividendos (socios y accionistas)"))
        listRegimen.Add(New RegimenFiscal("612", "Personas Físicas con Actividades Empresariales y Profesionales"))
        listRegimen.Add(New RegimenFiscal("614", "Ingresos por intereses"))
        listRegimen.Add(New RegimenFiscal("615", "Régimen de los ingresos por obtención de premios"))
        listRegimen.Add(New RegimenFiscal("616", "Sin obligaciones fiscales"))
        listRegimen.Add(New RegimenFiscal("621", "Incorporación Fiscal"))
        listRegimen.Add(New RegimenFiscal("625", "Régimen de las Actividades Empresariales con ingresos a través de Plataformas Tecnológicas"))
        listRegimen.Add(New RegimenFiscal("626", "Régimen Simplificado de Confianza"))

        Return listRegimen
    End Function
End Class

