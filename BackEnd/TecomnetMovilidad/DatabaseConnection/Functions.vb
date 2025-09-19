Imports Models.TECOMNET
Imports Models.TECOMNET.API
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
            If dr.Table.Columns.Contains("TipoPersona") Then objCliente.TipoPersona = IIf(IsDBNull(dr("TipoPersona")), Nothing, dr("TipoPersona"))
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
    Public Shared Function Tablero(ByVal dr As DataRow) As Tablero
        Dim objTablero As New Tablero
        Try
            If dr.Table.Columns.Contains("SIMID") Then objTablero.SIMID = dr("SIMID")
            If dr.Table.Columns.Contains("ICCID") Then objTablero.ICCID = dr("ICCID")
            If dr.Table.Columns.Contains("MSISDN") Then objTablero.MSISDN = dr("MSISDN")
            If dr.Table.Columns.Contains("FechaVencimiento") Then objTablero.FechaVencimiento = IIf(IsDBNull(dr("FechaVencimiento")), Nothing, dr("FechaVencimiento"))
            If dr.Table.Columns.Contains("MBAsignados") Then objTablero.MBAsignados = IIf(IsDBNull(dr("MBAsignados")), 0, dr("MBAsignados"))
            If dr.Table.Columns.Contains("MBUsados") Then objTablero.MBUsados = IIf(IsDBNull(dr("MBUsados")), 0, dr("MBUsados"))
            If dr.Table.Columns.Contains("MBDisponibles") Then objTablero.MBDisponibles = IIf(IsDBNull(dr("MBDisponibles")), 0, dr("MBDisponibles"))
            If dr.Table.Columns.Contains("MBAdicionales") Then objTablero.MBAdicionales = IIf(IsDBNull(dr("MBAdicionales")), 0, dr("MBAdicionales"))
            If dr.Table.Columns.Contains("OfertaID") Then objTablero.OfertaID = dr("OfertaID")
            If dr.Table.Columns.Contains("Oferta") Then objTablero.Oferta = dr("Oferta")
            If dr.Table.Columns.Contains("Descripcion") Then objTablero.Descripcion = dr("Descripcion")
            If dr.Table.Columns.Contains("Minutos") Then objTablero.Minutos = dr("Minutos")
            If dr.Table.Columns.Contains("Sms") Then objTablero.Sms = dr("Sms")
            If dr.Table.Columns.Contains("Tipo") Then objTablero.Tipo = dr("Tipo")
            If dr.Table.Columns.Contains("Estatus") Then objTablero.Estatus = dr("Estatus")
        Catch ex As Exception
        End Try
        Return objTablero
    End Function
    Public Shared Function Oferta(ByVal dr As DataRow) As Oferta
        Dim objOferta As New Oferta
        Try
            If dr.Table.Columns.Contains("OfertaID") Then objOferta.OfertaID = dr("OfertaID")
            If dr.Table.Columns.Contains("Oferta") Then objOferta.Oferta = dr("Oferta")
            If dr.Table.Columns.Contains("Descripcion") Then objOferta.Descripcion = dr("Descripcion")
            If dr.Table.Columns.Contains("PrecioMensual") Then objOferta.PrecioMensual = dr("PrecioMensual")
            If dr.Table.Columns.Contains("PrecioAnual") Then objOferta.PrecioAnual = dr("PrecioAnual")
            If dr.Table.Columns.Contains("PrecioRecurrente") Then objOferta.PrecioRecurrente = dr("PrecioRecurrente")
            If dr.Table.Columns.Contains("DatosMB") Then objOferta.DatosMB = dr("DatosMB")
            If dr.Table.Columns.Contains("Minutos") Then objOferta.Minutos = dr("Minutos")
            If dr.Table.Columns.Contains("Sms") Then objOferta.Sms = dr("Sms")
            If dr.Table.Columns.Contains("EsPrepago") Then objOferta.EsPrepago = dr("EsPrepago")
            If dr.Table.Columns.Contains("Tipo") Then objOferta.Tipo = dr("Tipo")
            If dr.Table.Columns.Contains("OfferIDAltan") Then objOferta.OfferIDAltan = dr("OfferIDAltan")
            If dr.Table.Columns.Contains("ValidezDias") Then objOferta.ValidezDias = dr("ValidezDias")
            If dr.Table.Columns.Contains("AplicaRoaming") Then objOferta.AplicaRoaming = dr("AplicaRoaming")
            If dr.Table.Columns.Contains("BolsaCompartirDatos") Then objOferta.BolsaCompartirDatos = dr("BolsaCompartirDatos")
            If dr.Table.Columns.Contains("RedesSociales") Then objOferta.RedesSociales = dr("RedesSociales")
            If dr.Table.Columns.Contains("TarifaPrimaria") Then objOferta.TarifaPrimaria = dr("TarifaPrimaria")
            If dr.Table.Columns.Contains("HomologacionID") Then objOferta.HomologacionID = dr("HomologacionID")
            If dr.Table.Columns.Contains("FechaAlta") Then objOferta.FechaAlta = dr("FechaAlta")
            If dr.Table.Columns.Contains("FechaBaja") Then objOferta.FechaBaja = dr("FechaBaja")
        Catch ex As Exception
        End Try
        Return objOferta
    End Function
    Public Shared Function SolicitudDePago(ByVal dr As DataRow) As SolicitudDePago
        Dim objSolicitudDePago As New SolicitudDePago
        Try
            If dr.Table.Columns.Contains("SolicitudID") Then objSolicitudDePago.SolicitudID = dr("SolicitudID")
            If dr.Table.Columns.Contains("OrderID") Then objSolicitudDePago.OrderID = dr("OrderID")
            If dr.Table.Columns.Contains("MetodoPagoID") Then objSolicitudDePago.MetodoPagoID = dr("MetodoPagoID")
            If dr.Table.Columns.Contains("OfertaIDActual") Then objSolicitudDePago.OfertaIDActual = dr("OfertaIDActual")
            If dr.Table.Columns.Contains("OfertaIDNueva") Then objSolicitudDePago.OfertaIDNueva = dr("OfertaIDNueva")
            If dr.Table.Columns.Contains("Monto") Then objSolicitudDePago.Monto = dr("Monto")
            If dr.Table.Columns.Contains("ICCID") Then objSolicitudDePago.ICCID = dr("ICCID")
            If dr.Table.Columns.Contains("MSISDN") Then objSolicitudDePago.MSISDN = dr("MSISDN")
            If dr.Table.Columns.Contains("Estatus") Then objSolicitudDePago.Estatus = dr("Estatus")
            If dr.Table.Columns.Contains("FechaCreacion") Then objSolicitudDePago.FechaCreacion = dr("FechaCreacion")
            If dr.Table.Columns.Contains("EstatusDepositoID") Then objSolicitudDePago.EstatusDepositoID = dr("EstatusDepositoID")
            If dr.Table.Columns.Contains("IdTransaction") Then objSolicitudDePago.IdTransaction = dr("IdTransaction")
            If dr.Table.Columns.Contains("AuthNumber") Then objSolicitudDePago.AuthNumber = dr("AuthNumber")
            If dr.Table.Columns.Contains("AuthCode") Then objSolicitudDePago.AuthCode = dr("AuthCode")
            If dr.Table.Columns.Contains("Reason") Then objSolicitudDePago.Reason = dr("Reason")
            If dr.Table.Columns.Contains("PagoDepositoID") Then objSolicitudDePago.PagoDepositoID = IIf(IsDBNull(dr("PagoDepositoID")), Nothing, dr("PagoDepositoID"))
            If dr.Table.Columns.Contains("UltimaActualizacion") Then objSolicitudDePago.UltimaActualizacion = dr("UltimaActualizacion")
            If dr.Table.Columns.Contains("NumeroReintentos") Then objSolicitudDePago.NumeroReintentos = dr("NumeroReintentos")
            If dr.Table.Columns.Contains("DistribuidorID") Then objSolicitudDePago.NumeroReintentos = dr("DistribuidorID")
        Catch ex As Exception
        End Try
        Return objSolicitudDePago
    End Function
    Public Shared Function Recarga(ByVal dr As DataRow) As Recarga
        Dim objRecarga As New Recarga
        Try
            If dr.Table.Columns.Contains("RecargaId") Then objRecarga.RecargaId = dr("RecargaId")
            If dr.Table.Columns.Contains("FechaRecarga") Then objRecarga.FechaRecarga = dr("FechaRecarga")
            If dr.Table.Columns.Contains("ICCID") Then objRecarga.ICCID = dr("ICCID")
            If dr.Table.Columns.Contains("ClienteID") Then objRecarga.ClienteID = dr("ClienteID")
            If dr.Table.Columns.Contains("OfertaID") Then objRecarga.OfertaID = dr("OfertaID")
            If dr.Table.Columns.Contains("Total") Then objRecarga.Total = dr("Total")
            If dr.Table.Columns.Contains("MetodoPagoID") Then objRecarga.MetodoPagoID = dr("MetodoPagoID")
            If dr.Table.Columns.Contains("OrderID") Then objRecarga.OrderID = dr("OrderID")
            If dr.Table.Columns.Contains("DistribuidorID") Then objRecarga.DistribuidorID = dr("DistribuidorID")
            If dr.Table.Columns.Contains("EstatusPagoDistribuidorID") Then objRecarga.EstatusPagoDistribuidorID = dr("EstatusPagoDistribuidorID")
            If dr.Table.Columns.Contains("FechaPagoDistribuidor") Then objRecarga.FechaPagoDistribuidor = IIf(IsDBNull(dr("FechaPagoDistribuidor")), Nothing, dr("FechaPagoDistribuidor"))
            If dr.Table.Columns.Contains("Comision") Then objRecarga.Comision = dr("Comision")
            If dr.Table.Columns.Contains("Impuesto") Then objRecarga.Impuesto = dr("Impuesto")
            If dr.Table.Columns.Contains("DepositoID") Then objRecarga.DepositoID = IIf(IsDBNull(dr("DepositoID")), Nothing, dr("DepositoID"))
            If dr.Table.Columns.Contains("RequiereFacturaCliente") Then objRecarga.RequiereFacturaCliente = dr("RequiereFacturaCliente")
            If dr.Table.Columns.Contains("FacturaID") Then objRecarga.FacturaID = IIf(IsDBNull(dr("FacturaID")), Nothing, dr("FacturaID"))
        Catch ex As Exception
        End Try
        Return objRecarga
    End Function
    Public Shared Function VisRecarga(ByVal dr As DataRow) As VisRecarga
        Dim objRecarga As New VisRecarga
        Try
            If dr.Table.Columns.Contains("RecargaId") Then objRecarga.RecargaId = dr("RecargaId")
            If dr.Table.Columns.Contains("FechaRecarga") Then objRecarga.FechaRecarga = dr("FechaRecarga")
            If dr.Table.Columns.Contains("ICCID") Then objRecarga.ICCID = dr("ICCID")
            If dr.Table.Columns.Contains("ClienteID") Then objRecarga.ClienteID = dr("ClienteID")
            If dr.Table.Columns.Contains("OfertaID") Then objRecarga.OfertaID = dr("OfertaID")
            If dr.Table.Columns.Contains("Total") Then objRecarga.Total = dr("Total")
            If dr.Table.Columns.Contains("MetodoPagoID") Then objRecarga.MetodoPagoID = dr("MetodoPagoID")
            If dr.Table.Columns.Contains("OrderID") Then objRecarga.OrderID = dr("OrderID")
            If dr.Table.Columns.Contains("DistribuidorID") Then objRecarga.DistribuidorID = dr("DistribuidorID")
            If dr.Table.Columns.Contains("EstatusPagoDistribuidorID") Then objRecarga.EstatusPagoDistribuidorID = dr("EstatusPagoDistribuidorID")
            If dr.Table.Columns.Contains("FechaPagoDistribuidor") Then objRecarga.FechaPagoDistribuidor = IIf(IsDBNull(dr("FechaPagoDistribuidor")), Nothing, dr("FechaPagoDistribuidor"))
            If dr.Table.Columns.Contains("Comision") Then objRecarga.Comision = dr("Comision")
            If dr.Table.Columns.Contains("Impuesto") Then objRecarga.Impuesto = dr("Impuesto")
            If dr.Table.Columns.Contains("DepositoID") Then objRecarga.DepositoID = IIf(IsDBNull(dr("DepositoID")), Nothing, dr("DepositoID"))
            If dr.Table.Columns.Contains("RequiereFacturaCliente") Then objRecarga.RequiereFacturaCliente = dr("RequiereFacturaCliente")
            If dr.Table.Columns.Contains("FacturaID") Then objRecarga.FacturaID = IIf(IsDBNull(dr("FacturaID")), Nothing, dr("FacturaID"))
            If dr.Table.Columns.Contains("NombreMetodo") Then objRecarga.NombreMetodo = IIf(IsDBNull(dr("NombreMetodo")), Nothing, dr("NombreMetodo"))
            If dr.Table.Columns.Contains("MSISDN") Then objRecarga.MSISDN = IIf(IsDBNull(dr("MSISDN")), Nothing, dr("MSISDN"))
            If dr.Table.Columns.Contains("Oferta") Then objRecarga.Oferta = IIf(IsDBNull(dr("Oferta")), Nothing, dr("Oferta"))
        Catch ex As Exception
        End Try
        Return objRecarga
    End Function
    Public Shared Function SIM(ByVal dr As DataRow) As SIM
        Dim objSIM As New SIM
        Try
            If dr.Table.Columns.Contains("SIMID") Then objSIM.SIMID = dr("SIMID")
            If dr.Table.Columns.Contains("BE_ID") Then objSIM.BE_ID = dr("BE_ID")
            If dr.Table.Columns.Contains("IMSI") Then objSIM.IMSI = dr("IMSI")
            If dr.Table.Columns.Contains("IMSI_rb1") Then objSIM.IMSI_rb1 = dr("IMSI_rb1")
            If dr.Table.Columns.Contains("IMSI_rb2") Then objSIM.IMSI_rb2 = dr("IMSI_rb2")
            If dr.Table.Columns.Contains("ICCID") Then objSIM.ICCID = dr("ICCID")
            If dr.Table.Columns.Contains("MSISDN") Then objSIM.MSISDN = dr("MSISDN")
            If dr.Table.Columns.Contains("PIN") Then objSIM.PIN = dr("PIN")
            If dr.Table.Columns.Contains("PUK") Then objSIM.PUK = dr("PUK")
            If dr.Table.Columns.Contains("Serie") Then objSIM.Serie = dr("Serie")
            If dr.Table.Columns.Contains("ClienteId") Then objSIM.ClienteId = IIf(IsDBNull(dr("ClienteId")), Nothing, dr("ClienteId"))
            If dr.Table.Columns.Contains("Estado") Then objSIM.Estado = dr("Estado")
            If dr.Table.Columns.Contains("FechaActivacion") Then objSIM.FechaActivacion = IIf(IsDBNull(dr("FechaActivacion")), Nothing, dr("FechaActivacion"))
            If dr.Table.Columns.Contains("FechaAsignacion") Then objSIM.FechaAsignacion = IIf(IsDBNull(dr("FechaAsignacion")), Nothing, dr("FechaAsignacion"))
            If dr.Table.Columns.Contains("FechaVencimiento") Then objSIM.FechaVencimiento = IIf(IsDBNull(dr("FechaVencimiento")), Nothing, dr("FechaVencimiento"))
            If dr.Table.Columns.Contains("CreationDate") Then objSIM.CreationDate = dr("CreationDate")
            If dr.Table.Columns.Contains("LastDate") Then objSIM.LastDate = IIf(IsDBNull(dr("LastDate")), Nothing, dr("LastDate"))
            If dr.Table.Columns.Contains("MBAsignados") Then objSIM.MBAsignados = IIf(IsDBNull(dr("MBAsignados")), Nothing, dr("MBAsignados"))
            If dr.Table.Columns.Contains("MBUsados") Then objSIM.MBUsados = IIf(IsDBNull(dr("MBUsados")), Nothing, dr("MBUsados"))
            If dr.Table.Columns.Contains("MBDisponibles") Then objSIM.MBDisponibles = IIf(IsDBNull(dr("MBDisponibles")), Nothing, dr("MBDisponibles"))
            If dr.Table.Columns.Contains("MBAdicionales") Then objSIM.MBAdicionales = IIf(IsDBNull(dr("MBAdicionales")), Nothing, dr("MBAdicionales"))
            If dr.Table.Columns.Contains("OfertaId") Then objSIM.OfertaId = IIf(IsDBNull(dr("OfertaId")), Nothing, dr("OfertaId"))
            If dr.Table.Columns.Contains("Tipo") Then objSIM.Tipo = dr("Tipo")
        Catch ex As Exception
        End Try
        Return objSIM
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
Public Class Operations
    Public Function CompraRecarga(OfferIDOrigen As Integer, OfferIdDestino As Integer) As Tuple(Of String, String)
        'Definir la tabla de ofertas
        Dim listOfertas As New List(Of Oferta)
        Dim controller As New ControllerOferta
        Dim Origen As New Oferta
        Dim Destino As New Oferta
        Dim OfferIdFinal As String = String.Empty

        listOfertas = controller.ObtenerOfertas
        Origen = listOfertas.FirstOrDefault(Function(x) x.OfertaID = OfferIDOrigen)
        Destino = listOfertas.FirstOrDefault(Function(x) x.OfertaID = OfferIdDestino)

        ' Definir las reglas de relacionamiento
        Dim reglas_relacionamiento As New Dictionary(Of Tuple(Of Integer, Integer, Integer), String) From {
                {Tuple.Create(1, 1, 0), "Compra"},
                {Tuple.Create(1, 2, 0), "Compra"},
                {Tuple.Create(1, 3, 1), "Cambio"},
                {Tuple.Create(2, 1, 0), "Compra"},
                {Tuple.Create(2, 2, 0), "Compra"},
                {Tuple.Create(2, 3, 1), "Cambio"},
                {Tuple.Create(3, 1, 0), "Compra"},
                {Tuple.Create(3, 2, 1), "Cambio"},
                {Tuple.Create(3, 3, 1), "Cambio"}
            }

        ' Validar que origen y destino estén en los valores permitidos
        Dim valoresPermitidos As Integer() = {1, 2, 3}
        If Not valoresPermitidos.Contains(Origen.Tipo) OrElse Not valoresPermitidos.Contains(Destino.Tipo) Then
            Return Nothing
        End If

        ' Buscar la regla correspondiente
        Dim regla_encontrada As KeyValuePair(Of Tuple(Of Integer, Integer, Integer), String) = Nothing

        For Each regla In reglas_relacionamiento
            If regla.Key.Item1 = Origen.Tipo AndAlso regla.Key.Item2 = Destino.Tipo Then
                regla_encontrada = regla
                Exit For
            End If
        Next

        If regla_encontrada.Equals(New KeyValuePair(Of Tuple(Of Integer, Integer, Integer), String)()) Then
            Return Nothing
        End If

        OfferIdFinal = listOfertas.FirstOrDefault(Function(x) x.HomologacionID = Destino.HomologacionID And x.TarifaPrimaria = CBool(regla_encontrada.Key.Item3)).OfferIDAltan
        Return Tuple.Create(OfferIdFinal, regla_encontrada.Value)

    End Function
End Class