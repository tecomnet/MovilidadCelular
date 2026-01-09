Imports Models
Imports Models.TECOMNET
Imports Models.TECOMNET.API
Imports Models.TECOMNET.Enumeraciones
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
            If dr.Table.Columns.Contains("RFC") Then objCliente.RFC = IIf(IsDBNull(dr("RFC")), "", dr("RFC"))
            If dr.Table.Columns.Contains("NombreRazonSocial") Then objCliente.NombreRazonSocial = IIf(IsDBNull(dr("NombreRazonSocial")), "", dr("NombreRazonSocial"))
            If dr.Table.Columns.Contains("FechaBaja") Then objCliente.FechaBaja = IIf(IsDBNull(dr("FechaBaja")), Nothing, dr("FechaBaja"))
            If dr.Table.Columns.Contains("Colonia") Then objCliente.Colonia = IIf(IsDBNull(dr("Colonia")), "", dr("Colonia"))
            If dr.Table.Columns.Contains("Estado") Then objCliente.Estado = IIf(IsDBNull(dr("Estado")), "", dr("Estado"))
            If dr.Table.Columns.Contains("Direccion") Then objCliente.Direccion = IIf(IsDBNull(dr("Direccion")), "", dr("Direccion"))
            If dr.Table.Columns.Contains("CP") Then objCliente.CP = IIf(IsDBNull(dr("CP")), "", dr("CP"))
            If dr.Table.Columns.Contains("CPFacturacion") Then objCliente.CPFacturacion = IIf(IsDBNull(dr("CPFacturacion")), "", dr("CPFacturacion"))
            If dr.Table.Columns.Contains("RFCFacturacion") Then objCliente.RFCFacturacion = IIf(IsDBNull(dr("RFCFacturacion")), "", dr("RFCFacturacion"))
            If dr.Table.Columns.Contains("RegimenFiscal") Then objCliente.RegimenFiscal = IIf(IsDBNull(dr("RegimenFiscal")), "", dr("RegimenFiscal"))
            If dr.Table.Columns.Contains("SiigoID") Then objCliente.SiigoID = dr("SiigoID")
        Catch ex As Exception
        End Try
        Return objCliente

    End Function

    Public Shared Function DatosFiscales(ByVal dr As DataRow) As DatosFiscales
        Dim objDatosFiscales As New DatosFiscales
        Try
            If dr.Table.Columns.Contains("DatosFiscalesID") Then objDatosFiscales.DatosFiscalesID = dr("DatosFiscalesID")
            If dr.Table.Columns.Contains("ClienteId") Then objDatosFiscales.ClienteId = dr("ClienteId")
            If dr.Table.Columns.Contains("Nombre") Then objDatosFiscales.Nombre = dr("Nombre")
            If dr.Table.Columns.Contains("ApellidoPaterno") Then objDatosFiscales.ApellidoPaterno = dr("ApellidoPaterno")
            If dr.Table.Columns.Contains("ApellidoMaterno") Then objDatosFiscales.ApellidoMaterno = dr("ApellidoMaterno")
            If dr.Table.Columns.Contains("TipoPersona") Then objDatosFiscales.TipoPersona = dr("TipoPersona")
            If dr.Table.Columns.Contains("RegimenFiscal") Then objDatosFiscales.RegimenFiscal = dr("RegimenFiscal")
            If dr.Table.Columns.Contains("RazonSocial") Then objDatosFiscales.RazonSocial = dr("RazonSocial")
            If dr.Table.Columns.Contains("RFCFacturacion") Then objDatosFiscales.RFCFacturacion = dr("RFCFacturacion")
            If dr.Table.Columns.Contains("UsoDeComprobante") Then objDatosFiscales.UsoDeComprobante = dr("UsoDeComprobante")
            If dr.Table.Columns.Contains("CPFacturacion") Then objDatosFiscales.CPFacturacion = dr("CPFacturacion")
            If dr.Table.Columns.Contains("Calle") Then objDatosFiscales.Calle = dr("Calle")
            If dr.Table.Columns.Contains("NumeroInterior") Then objDatosFiscales.NumeroInterior = dr("NumeroInterior")
            If dr.Table.Columns.Contains("NumeroExterior") Then objDatosFiscales.NumeroExterior = dr("NumeroExterior")
            If dr.Table.Columns.Contains("Colonia") Then objDatosFiscales.Colonia = dr("Colonia")
            If dr.Table.Columns.Contains("Localidad") Then objDatosFiscales.Localidad = dr("Localidad")
            If dr.Table.Columns.Contains("CodigoPais") Then objDatosFiscales.CodigoPais = dr("CodigoPais")
            If dr.Table.Columns.Contains("CodigoEstado") Then objDatosFiscales.CodigoEstado = dr("CodigoEstado")
            If dr.Table.Columns.Contains("CodigoMunicipio") Then objDatosFiscales.CodigoMunicipio = dr("CodigoMunicipio")
            If dr.Table.Columns.Contains("CodigoPostal") Then objDatosFiscales.CodigoPostal = dr("CodigoPostal")
        Catch ex As Exception
        End Try

        Return objDatosFiscales
    End Function

    Public Shared Function Usuario(ByVal dr As DataRow) As Usuario
        Dim objUsuario As New Usuario
        Try
            If dr.Table.Columns.Contains("UsuarioID") Then objUsuario.UsuarioID = dr("UsuarioID")
            If dr.Table.Columns.Contains("NombreUsuario") Then objUsuario.NombreUsuario = dr("NombreUsuario")
            If dr.Table.Columns.Contains("Nombre") Then objUsuario.Nombre = dr("Nombre")
            If dr.Table.Columns.Contains("Email") Then objUsuario.Email = dr("Email")
            If dr.Table.Columns.Contains("PasswordHash") Then objUsuario.PasswordHash = dr("PasswordHash")
            If dr.Table.Columns.Contains("NumeroTelefono") Then objUsuario.NumeroTelefono = dr("NumeroTelefono")
            If dr.Table.Columns.Contains("fechaBaja") Then objUsuario.fechaBaja = IIf(IsDBNull(dr("fechaBaja")), Nothing, dr("fechaBaja"))
            If dr.Table.Columns.Contains("TipoUsuario") Then objUsuario.TipoUsuario = IIf(IsDBNull(dr("TipoUsuario")), Nothing, dr("TipoUsuario"))
            If dr.Table.Columns.Contains("RelacionTipoID") Then objUsuario.RelacionTipoID = dr("RelacionTipoID")
            If dr.Table.Columns.Contains("UltimoLogin") Then objUsuario.UltimoLogin = IIf(IsDBNull(dr("UltimoLogin")), "", dr("UltimoLogin"))
            If dr.Table.Columns.Contains("FechaAlta") Then objUsuario.FechaAlta = dr("FechaAlta")
            If dr.Table.Columns.Contains("FechaUltimaActualizacion") Then objUsuario.FechaUltimaActualizacion = dr("FechaUltimaActualizacion")
        Catch ex As Exception
        End Try
        Return objUsuario

    End Function

    Public Shared Function Distribuidor(ByVal dr As DataRow) As Distribuidor
        Dim objDistribuidor As New Distribuidor
        Try
            If dr.Table.Columns.Contains("DistribuidorID") Then objDistribuidor.DistribuidorID = dr("DistribuidorID")
            If dr.Table.Columns.Contains("Region") Then objDistribuidor.Region = dr("Region")
            If dr.Table.Columns.Contains("Nombre") Then objDistribuidor.Nombre = dr("Nombre")
            If dr.Table.Columns.Contains("Direccion") Then objDistribuidor.Direccion = dr("Direccion")
            If dr.Table.Columns.Contains("RFC") Then objDistribuidor.RFC = dr("RFC")
            If dr.Table.Columns.Contains("NombreContacto") Then objDistribuidor.NombreContacto = dr("NombreContacto")
            If dr.Table.Columns.Contains("TelefonoContacto") Then objDistribuidor.TelefonoContacto = dr("TelefonoContacto")
            If dr.Table.Columns.Contains("Beneficiario") Then objDistribuidor.Beneficiario = dr("Beneficiario")
            If dr.Table.Columns.Contains("EmailContacto") Then objDistribuidor.EmailContacto = dr("EmailContacto")
            If dr.Table.Columns.Contains("DireccionFiscal") Then objDistribuidor.DireccionFiscal = dr("DireccionFiscal")
            If dr.Table.Columns.Contains("PorcentajeComision") Then objDistribuidor.PorcentajeComision = dr("PorcentajeComision")
            If dr.Table.Columns.Contains("Banco") Then objDistribuidor.Banco = dr("Banco")
            If dr.Table.Columns.Contains("Cuenta") Then objDistribuidor.Cuenta = dr("Cuenta")
            If dr.Table.Columns.Contains("TipoDistribuidor") Then objDistribuidor.TipoDistribuidor = IIf(IsDBNull(dr("TipoDistribuidor")), Nothing, dr("TipoDistribuidor"))
            If dr.Table.Columns.Contains("FechaAlta") Then objDistribuidor.FechaAlta = dr("FechaAlta")
            If dr.Table.Columns.Contains("FechaBaja") Then objDistribuidor.FechaBaja = IIf(IsDBNull(dr("FechaBaja")), Nothing, dr("FechaBaja"))
            If dr.Table.Columns.Contains("TipoPersona") Then objDistribuidor.TipoPersona = IIf(IsDBNull(dr("TipoPersona")), Nothing, dr("TipoPersona"))
            If dr.Table.Columns.Contains("FechaUltimaActualizacion") Then objDistribuidor.FechaUltimaActualizacion = dr("FechaUltimaActualizacion")
        Catch ex As Exception
            ' Manejo opcional de error
        End Try
        Return objDistribuidor
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
    Public Shared Function EstatusDeposito(ByVal dr As DataRow) As EstatusDeposito
        Dim objEstatusDeposito As New EstatusDeposito
        Try
            If dr.Table.Columns.Contains("EstatusDepositoID") Then objEstatusDeposito.EstatusDepositoID = dr("EstatusDepositoID")
            If dr.Table.Columns.Contains("Estatus") Then objEstatusDeposito.Estatus = dr("Estatus")
            If dr.Table.Columns.Contains("Descripcion") Then objEstatusDeposito.Descripcion = dr("Descripcion")
        Catch ex As Exception
        End Try
        Return objEstatusDeposito
    End Function
    Public Shared Function PaisesEstados(ByVal dr As DataRow) As PaisesEstados
        Dim objPaisesEstados As New PaisesEstados
        Try
            If dr.Table.Columns.Contains("PaisID") Then objPaisesEstados.PaisID = dr("PaisID")
            If dr.Table.Columns.Contains("Pais") Then objPaisesEstados.Pais = dr("Pais")
            If dr.Table.Columns.Contains("Estado") Then objPaisesEstados.Estado = dr("Estado")
            If dr.Table.Columns.Contains("Municipio") Then objPaisesEstados.Municipio = dr("Municipio")
            If dr.Table.Columns.Contains("CodigoPais") Then objPaisesEstados.CodigoPais = dr("CodigoPais")
            If dr.Table.Columns.Contains("CodigoEstado") Then objPaisesEstados.CodigoEstado = dr("CodigoEstado")
            If dr.Table.Columns.Contains("CodigoMunicipio") Then objPaisesEstados.CodigoMunicipio = dr("CodigoMunicipio")
        Catch ex As Exception
        End Try
        Return objPaisesEstados
    End Function
    Public Shared Function MetodoPago(ByVal dr As DataRow) As MetodoPago
        Dim objMetodoPago As New MetodoPago
        Try
            If dr.Table.Columns.Contains("MetodoPagoID") Then objMetodoPago.MetodoPagoID = dr("MetodoPagoID")
            If dr.Table.Columns.Contains("NombreMetodo") Then objMetodoPago.NombreMetodo = dr("NombreMetodo")
            If dr.Table.Columns.Contains("Descripcion") Then objMetodoPago.Descripcion = dr("Descripcion")
        Catch ex As Exception
        End Try
        Return objMetodoPago
    End Function
    Public Shared Function Portabilidad(ByVal dr As DataRow) As Portabilidad
        Dim objPortabilidad As New Portabilidad
        Try
            If dr.Table.Columns.Contains("PortabilidadID") Then objPortabilidad.PortabilidadID = dr("PortabilidadID")
            If dr.Table.Columns.Contains("MSISDN_Transitorio") Then objPortabilidad.MSISDN_Transitorio = dr("MSISDN_Transitorio")
            If dr.Table.Columns.Contains("MSISDN") Then objPortabilidad.MSISDN = dr("MSISDN")
            If dr.Table.Columns.Contains("CompaniaOrigen") Then objPortabilidad.CompaniaOrigen = dr("CompaniaOrigen")
            If dr.Table.Columns.Contains("Estatus") Then objPortabilidad.Estatus = dr("Estatus")
            If dr.Table.Columns.Contains("FechaRegistro") Then objPortabilidad.FechaRegistro = IIf(IsDBNull(dr("FechaRegistro")), Nothing, dr("FechaRegistro"))
            If dr.Table.Columns.Contains("FechaTermino") Then objPortabilidad.FechaTermino = IIf(IsDBNull(dr("FechaTermino")), Nothing, dr("FechaTermino"))
            If dr.Table.Columns.Contains("FechaCancelacion") Then objPortabilidad.FechaCancelacion = IIf(IsDBNull(dr("FechaCancelacion")), Nothing, dr("FechaCancelacion"))
            If dr.Table.Columns.Contains("FechaRechazo") Then objPortabilidad.FechaRechazo = IIf(IsDBNull(dr("FechaRechazo")), Nothing, dr("FechaRechazo"))
            If dr.Table.Columns.Contains("TipoPortabilidad") Then objPortabilidad.TipoPortabilidad = dr("TipoPortabilidad")
            If dr.Table.Columns.Contains("Response") Then objPortabilidad.Response = dr("Response")
        Catch ex As Exception
        End Try
        Return objPortabilidad
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
            If dr.Table.Columns.Contains("CanalDeVenta") Then objSolicitudDePago.CanalDeVenta = dr("CanalDeVenta")
            If dr.Table.Columns.Contains("TipoOperacion") Then objSolicitudDePago.TipoOperacion = dr("TipoOperacion")
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
            If dr.Table.Columns.Contains("CanalDeVenta") Then objRecarga.CanalDeVenta = dr("CanalDeVenta")
            If dr.Table.Columns.Contains("TipoOperacion") Then objRecarga.TipoOperacion = dr("TipoOperacion")
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
            If dr.Table.Columns.Contains("Estatus") Then objSIM.Estado = dr("Estatus")
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
            If dr.Table.Columns.Contains("FechaReactivacion") Then objSIM.FechaReactivacion = IIf(IsDBNull(dr("FechaReactivacion")), Nothing, dr("FechaReactivacion"))
            If dr.Table.Columns.Contains("FechaBaja") Then objSIM.FechaBaja = IIf(IsDBNull(dr("FechaBaja")), Nothing, dr("FechaBaja"))
            If dr.Table.Columns.Contains("FechaSuspension") Then objSIM.FechaAsignacion = IIf(IsDBNull(dr("FechaSuspension")), Nothing, dr("FechaSuspension"))
            If dr.Table.Columns.Contains("FechaInicioFacturacion") Then objSIM.FechaInicioFacturacion = IIf(IsDBNull(dr("FechaInicioFacturacion")), Nothing, dr("FechaInicioFacturacion"))
            If dr.Table.Columns.Contains("FechaPortabilidad") Then objSIM.FechaPortabilidad = IIf(IsDBNull(dr("FechaPortabilidad")), Nothing, dr("FechaPortabilidad"))
            If dr.Table.Columns.Contains("CompaniaOrigen") Then objSIM.CompaniaOrigen = dr("CompaniaOrigen")
            If dr.Table.Columns.Contains("MSISDN_Transcitorio") Then objSIM.MSISDN_Transcitorio = dr("MSISDN_Transcitorio")

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