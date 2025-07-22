Imports Models.TECOMNET
Imports System.Security.Cryptography
Imports System.Text

Public Class ConvertObject
    Public Shared Function Cliente(ByVal dr As DataRow) As Cliente
        Dim objCliente As New Cliente
        Try
            If dr.Table.Columns.Contains("ClienteId") Then objCliente.ClienteId = dr("ClienteId")
            If dr.Table.Columns.Contains("Nombre") Then objCliente.Nombre = dr("Nombre")
            If dr.Table.Columns.Contains("ApellidoPaterno") Then objCliente.ApellidoPaterno = dr("ApellidoPaterno")
            If dr.Table.Columns.Contains("ApellidoMaterno") Then objCliente.ApellidoMaterno = dr("ApellidoMaterno")
            If dr.Table.Columns.Contains("FechaCumpleanios") Then objCliente.FechaCumpleanios = IIf(IsDBNull(dr("FechaCumpleanios")), Nothing, dr("FechaCumpleanios"))
            If dr.Table.Columns.Contains("CURP") Then objCliente.CURP = IIf(IsDBNull(dr("CURP")), "", dr("CURP"))
            If dr.Table.Columns.Contains("Telefono") Then objCliente.Telefono = dr("Telefono")
            If dr.Table.Columns.Contains("Email") Then objCliente.Email = dr("Email")
            If dr.Table.Columns.Contains("FechaAlta") Then objCliente.FechaAlta = dr("FechaAlta")
            If dr.Table.Columns.Contains("Estatus") Then objCliente.Estatus = dr("Estatus")
            If dr.Table.Columns.Contains("ContrasenaHash") Then objCliente.ContrasenaHash = dr("ContrasenaHash")
            If dr.Table.Columns.Contains("Estado") Then objCliente.Estado = dr("Estado")
            If dr.Table.Columns.Contains("Colonia") Then objCliente.Colonia = dr("Colonia")
            If dr.Table.Columns.Contains("Direccion") Then objCliente.Direccion = dr("Direccion")
            If dr.Table.Columns.Contains("CP") Then objCliente.CP = dr("CP")
            If dr.Table.Columns.Contains("RFC") Then objCliente.RFC = IIf(IsDBNull(dr("RFC")), "", dr("RFC"))
            If dr.Table.Columns.Contains("RFCFacturacion") Then objCliente.RFCFacturacion = IIf(IsDBNull(dr("RFCFacturacion")), "", dr("RFCFacturacion"))
            If dr.Table.Columns.Contains("NombreRazonSocial") Then objCliente.NombreRazonSocial = IIf(IsDBNull(dr("NombreRazonSocial")), "", dr("NombreRazonSocial"))
            If dr.Table.Columns.Contains("CPFacturacion") Then objCliente.CPFacturacion = IIf(IsDBNull(dr("CPFacturacion")), "", dr("CPFacturacion"))
            If dr.Table.Columns.Contains("RegimenFiscal") Then objCliente.RegimenFiscal = IIf(IsDBNull(dr("RegimenFiscal")), "", dr("RegimenFiscal"))
            If dr.Table.Columns.Contains("UsoDeComprobante") Then objCliente.UsoDeComprobante = IIf(IsDBNull(dr("UsoDeComprobante")), "", dr("UsoDeComprobante"))
            If dr.Table.Columns.Contains("FechaBaja") Then objCliente.FechaBaja = IIf(IsDBNull(dr("FechaBaja")), Nothing, dr("FechaBaja"))
        Catch ex As Exception
        End Try
        Return objCliente

    End Function
End Class
Public Class Securyty
    Public Shared Function Cifrar(ByVal cadena As String) As String
        Dim strEncriptar As String
        Dim Codificar As New UnicodeEncoding()
        Dim BytesTexto() As Byte = Codificar.GetBytes(cadena)
        Dim Md5 As New MD5CryptoServiceProvider()
        Dim TablaBytes() As Byte = Md5.ComputeHash(BytesTexto)
        strEncriptar = Convert.ToBase64String(TablaBytes).ToString

        Return strEncriptar
    End Function
    Public Shared Function DecodeBase64ToString(valor As String) As String
        Dim myBase64ret As Byte() = Convert.FromBase64String(valor)
        Dim myStr As String = System.Text.Encoding.UTF8.GetString(myBase64ret)
        Return myStr
    End Function
    Public Shared Function EncodeStrToBase64(valor As String) As String
        Dim myByte As Byte() = System.Text.Encoding.UTF8.GetBytes(valor)
        Dim myBase64 As String = Convert.ToBase64String(myByte)
        Return myBase64
    End Function

End Class