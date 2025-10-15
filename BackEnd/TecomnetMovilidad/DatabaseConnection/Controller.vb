Imports Models
Imports Models.TECOMNET
Public Class Controller
    Public Function TransactionsCliente(Of ReturnType)(opcion As Integer, ByVal objCliente As Cliente) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@ClienteId", SqlDbType.Int, objCliente.ClienteId))
        parametros.Add(ConnectionDB.ArmaParametro("@Nombre", SqlDbType.NVarChar, objCliente.Nombre))
        parametros.Add(ConnectionDB.ArmaParametro("@ApellidoPaterno", SqlDbType.NVarChar, objCliente.ApellidoPaterno))
        parametros.Add(ConnectionDB.ArmaParametro("@ApellidoMaterno", SqlDbType.NVarChar, objCliente.ApellidoMaterno))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaCumpleanios", SqlDbType.DateTime, IIf(IsNothing(objCliente.FechaCumpleanios), DBNull.Value, objCliente.FechaCumpleanios)))
        parametros.Add(ConnectionDB.ArmaParametro("@TipoPersona", SqlDbType.NVarChar, objCliente.TipoPersona))
        parametros.Add(ConnectionDB.ArmaParametro("@CURP", SqlDbType.NVarChar, objCliente.CURP))
        parametros.Add(ConnectionDB.ArmaParametro("@Telefono", SqlDbType.NVarChar, objCliente.Telefono))
        parametros.Add(ConnectionDB.ArmaParametro("@Email", SqlDbType.NVarChar, objCliente.Email))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaAlta", SqlDbType.DateTime, objCliente.FechaAlta))
        parametros.Add(ConnectionDB.ArmaParametro("@Estatus", SqlDbType.Int, objCliente.Estatus))
        parametros.Add(ConnectionDB.ArmaParametro("@ContrasenaHash", SqlDbType.NVarChar, objCliente.ContrasenaHash))
        parametros.Add(ConnectionDB.ArmaParametro("@Estado", SqlDbType.NVarChar, objCliente.Estado))
        parametros.Add(ConnectionDB.ArmaParametro("@Colonia", SqlDbType.NVarChar, objCliente.Colonia))
        parametros.Add(ConnectionDB.ArmaParametro("@Direccion", SqlDbType.NVarChar, objCliente.Direccion))
        parametros.Add(ConnectionDB.ArmaParametro("@CP", SqlDbType.NVarChar, objCliente.CP))
        parametros.Add(ConnectionDB.ArmaParametro("@RFC", SqlDbType.NVarChar, objCliente.RFC))
        parametros.Add(ConnectionDB.ArmaParametro("@RFCFacturacion", SqlDbType.NVarChar, objCliente.RFCFacturacion))
        parametros.Add(ConnectionDB.ArmaParametro("@NombreRazonSocial", SqlDbType.NVarChar, objCliente.NombreRazonSocial))
        parametros.Add(ConnectionDB.ArmaParametro("@CPFacturacion", SqlDbType.NVarChar, objCliente.CPFacturacion))
        parametros.Add(ConnectionDB.ArmaParametro("@RegimenFiscal", SqlDbType.NVarChar, objCliente.RegimenFiscal))
        parametros.Add(ConnectionDB.ArmaParametro("@UsoDeComprobante", SqlDbType.NVarChar, objCliente.UsoDeComprobante))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaBaja", SqlDbType.DateTime, IIf(IsNothing(objCliente.FechaBaja), DBNull.Value, objCliente.FechaBaja)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_Cliente]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_Cliente]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_Cliente]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsOferta(Of ReturnType)(opcion As Integer, ByVal objOferta As Oferta) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@OfertaID", SqlDbType.Int, objOferta.OfertaID))
        parametros.Add(ConnectionDB.ArmaParametro("@Oferta", SqlDbType.NVarChar, objOferta.Oferta))
        parametros.Add(ConnectionDB.ArmaParametro("@Descripcion", SqlDbType.NVarChar, objOferta.Descripcion))
        parametros.Add(ConnectionDB.ArmaParametro("@PrecioMensual", SqlDbType.Decimal, objOferta.PrecioMensual))
        parametros.Add(ConnectionDB.ArmaParametro("@PrecioAnual", SqlDbType.Decimal, objOferta.PrecioAnual))
        parametros.Add(ConnectionDB.ArmaParametro("@PrecioRecurrente", SqlDbType.Decimal, objOferta.PrecioRecurrente))
        parametros.Add(ConnectionDB.ArmaParametro("@DatosMB", SqlDbType.Int, objOferta.DatosMB))
        parametros.Add(ConnectionDB.ArmaParametro("@Minutos", SqlDbType.Int, objOferta.Minutos))
        parametros.Add(ConnectionDB.ArmaParametro("@Sms", SqlDbType.Int, objOferta.Sms))
        parametros.Add(ConnectionDB.ArmaParametro("@EsPrepago", SqlDbType.Bit, objOferta.EsPrepago))
        parametros.Add(ConnectionDB.ArmaParametro("@Tipo", SqlDbType.Int, objOferta.Tipo))
        parametros.Add(ConnectionDB.ArmaParametro("@OfferIDAltan", SqlDbType.NVarChar, objOferta.OfferIDAltan))
        parametros.Add(ConnectionDB.ArmaParametro("@ValidezDias", SqlDbType.Int, objOferta.ValidezDias))
        parametros.Add(ConnectionDB.ArmaParametro("@AplicaRoaming", SqlDbType.Bit, objOferta.AplicaRoaming))
        parametros.Add(ConnectionDB.ArmaParametro("@BolsaCompartirDatos", SqlDbType.Bit, objOferta.BolsaCompartirDatos))
        parametros.Add(ConnectionDB.ArmaParametro("@RedesSociales", SqlDbType.Bit, objOferta.RedesSociales))
        parametros.Add(ConnectionDB.ArmaParametro("@TarifaPrimaria", SqlDbType.Bit, objOferta.TarifaPrimaria))
        parametros.Add(ConnectionDB.ArmaParametro("@HomologacionID", SqlDbType.Int, objOferta.HomologacionID))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaAlta", SqlDbType.DateTime, objOferta.FechaAlta))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaBaja", SqlDbType.DateTime, IIf(IsNothing(objOferta.FechaBaja), DBNull.Value, objOferta.FechaBaja)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_Ofertas]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_Ofertas]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_Ofertas]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsSolicitudDePago(Of ReturnType)(opcion As Integer, ByVal objSolicitudDePago As SolicitudDePago) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@SolicitudID", SqlDbType.Int, objSolicitudDePago.SolicitudID))
        parametros.Add(ConnectionDB.ArmaParametro("@OrderID", SqlDbType.NVarChar, objSolicitudDePago.OrderID))
        parametros.Add(ConnectionDB.ArmaParametro("@MetodoPagoID", SqlDbType.Int, objSolicitudDePago.MetodoPagoID))
        parametros.Add(ConnectionDB.ArmaParametro("@OfertaIDActual", SqlDbType.Int, objSolicitudDePago.OfertaIDActual))
        parametros.Add(ConnectionDB.ArmaParametro("@OfertaIDNueva", SqlDbType.Int, objSolicitudDePago.OfertaIDNueva))
        parametros.Add(ConnectionDB.ArmaParametro("@Monto", SqlDbType.Float, objSolicitudDePago.Monto))
        parametros.Add(ConnectionDB.ArmaParametro("@ICCID", SqlDbType.NVarChar, objSolicitudDePago.ICCID))
        parametros.Add(ConnectionDB.ArmaParametro("@MSISDN", SqlDbType.NVarChar, objSolicitudDePago.MSISDN))
        parametros.Add(ConnectionDB.ArmaParametro("@Estatus", SqlDbType.NVarChar, objSolicitudDePago.Estatus))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaCreacion", SqlDbType.DateTime, objSolicitudDePago.FechaCreacion))
        parametros.Add(ConnectionDB.ArmaParametro("@EstatusDepositoID", SqlDbType.Int, objSolicitudDePago.EstatusDepositoID))
        parametros.Add(ConnectionDB.ArmaParametro("@IdTransaction", SqlDbType.NVarChar, objSolicitudDePago.IdTransaction))
        parametros.Add(ConnectionDB.ArmaParametro("@AuthNumber", SqlDbType.NVarChar, objSolicitudDePago.AuthNumber))
        parametros.Add(ConnectionDB.ArmaParametro("@AuthCode", SqlDbType.NVarChar, objSolicitudDePago.AuthCode))
        parametros.Add(ConnectionDB.ArmaParametro("@Reason", SqlDbType.NVarChar, objSolicitudDePago.Reason))
        parametros.Add(ConnectionDB.ArmaParametro("@PagoDepositoID", SqlDbType.Int, IIf(IsNothing(objSolicitudDePago.PagoDepositoID), DBNull.Value, objSolicitudDePago.PagoDepositoID)))
        parametros.Add(ConnectionDB.ArmaParametro("@CanalDeVenta", SqlDbType.Int, objSolicitudDePago.CanalDeVenta))
        parametros.Add(ConnectionDB.ArmaParametro("@TipoOperacion", SqlDbType.Int, objSolicitudDePago.TipoOperacion))
        parametros.Add(ConnectionDB.ArmaParametro("@UltimaActualizacion", SqlDbType.DateTime, objSolicitudDePago.UltimaActualizacion))
        parametros.Add(ConnectionDB.ArmaParametro("@NumeroReintentos", SqlDbType.Int, objSolicitudDePago.NumeroReintentos))
        parametros.Add(ConnectionDB.ArmaParametro("@DistribuidorID", SqlDbType.Int, objSolicitudDePago.DistribuidorID))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_SolicitudDePago]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_SolicitudDePago]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_SolicitudDePago]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsRecarga(Of ReturnType)(opcion As Integer, ByVal objRecarga As Recarga) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@RecargaId", SqlDbType.Int, objRecarga.RecargaId))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaRecarga", SqlDbType.DateTime, objRecarga.FechaRecarga))
        parametros.Add(ConnectionDB.ArmaParametro("@ICCID", SqlDbType.NVarChar, objRecarga.ICCID))
        parametros.Add(ConnectionDB.ArmaParametro("@ClienteID", SqlDbType.Int, objRecarga.ClienteID))
        parametros.Add(ConnectionDB.ArmaParametro("@OfertaID", SqlDbType.Int, objRecarga.OfertaID))
        parametros.Add(ConnectionDB.ArmaParametro("@Total", SqlDbType.Decimal, objRecarga.Total))
        parametros.Add(ConnectionDB.ArmaParametro("@MetodoPagoID", SqlDbType.Int, objRecarga.MetodoPagoID))
        parametros.Add(ConnectionDB.ArmaParametro("@OrderID", SqlDbType.NVarChar, objRecarga.OrderID))
        parametros.Add(ConnectionDB.ArmaParametro("@DistribuidorID", SqlDbType.Int, objRecarga.DistribuidorID))
        parametros.Add(ConnectionDB.ArmaParametro("@EstatusPagoDistribuidorID", SqlDbType.Int, objRecarga.EstatusPagoDistribuidorID))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaPagoDistribuidor", SqlDbType.DateTime, IIf(IsNothing(objRecarga.FechaPagoDistribuidor), DBNull.Value, objRecarga.FechaPagoDistribuidor)))
        parametros.Add(ConnectionDB.ArmaParametro("@Comision", SqlDbType.Decimal, objRecarga.Comision))
        parametros.Add(ConnectionDB.ArmaParametro("@Impuesto", SqlDbType.Decimal, objRecarga.Impuesto))
        parametros.Add(ConnectionDB.ArmaParametro("@DepositoID", SqlDbType.Int, IIf(IsNothing(objRecarga.DepositoID), DBNull.Value, objRecarga.DepositoID)))
        parametros.Add(ConnectionDB.ArmaParametro("@CanalDeVenta", SqlDbType.Int, objRecarga.CanalDeVenta))
        parametros.Add(ConnectionDB.ArmaParametro("@TipoOperacion", SqlDbType.Int, objRecarga.TipoOperacion))
        parametros.Add(ConnectionDB.ArmaParametro("@RequiereFacturaCliente", SqlDbType.Bit, objRecarga.RequiereFacturaCliente))
        parametros.Add(ConnectionDB.ArmaParametro("@FacturaID", SqlDbType.Int, IIf(IsNothing(objRecarga.FacturaID), DBNull.Value, objRecarga.FacturaID)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_Recargas]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_Recargas]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_Recargas]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsSIM(Of ReturnType)(opcion As Integer, ByVal objSIM As SIM) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@SIMID", SqlDbType.Int, objSIM.SIMID))
        parametros.Add(ConnectionDB.ArmaParametro("@BE_ID", SqlDbType.NVarChar, objSIM.BE_ID))
        parametros.Add(ConnectionDB.ArmaParametro("@IMSI", SqlDbType.NVarChar, objSIM.IMSI))
        parametros.Add(ConnectionDB.ArmaParametro("@IMSI_rb1", SqlDbType.NVarChar, objSIM.IMSI_rb1))
        parametros.Add(ConnectionDB.ArmaParametro("@IMSI_rb2", SqlDbType.NVarChar, objSIM.IMSI_rb2))
        parametros.Add(ConnectionDB.ArmaParametro("@ICCID", SqlDbType.NVarChar, objSIM.ICCID))
        parametros.Add(ConnectionDB.ArmaParametro("@MSISDN", SqlDbType.NVarChar, objSIM.MSISDN))
        parametros.Add(ConnectionDB.ArmaParametro("@PIN", SqlDbType.NVarChar, objSIM.PIN))
        parametros.Add(ConnectionDB.ArmaParametro("@PUK", SqlDbType.NVarChar, objSIM.PUK))
        parametros.Add(ConnectionDB.ArmaParametro("@Serie", SqlDbType.NVarChar, objSIM.Serie))
        parametros.Add(ConnectionDB.ArmaParametro("@ClienteId", SqlDbType.Int, IIf(IsNothing(objSIM.ClienteId), DBNull.Value, objSIM.ClienteId)))
        parametros.Add(ConnectionDB.ArmaParametro("@Estatus", SqlDbType.NVarChar, objSIM.Estado))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaActivacion", SqlDbType.DateTime, IIf(IsNothing(objSIM.FechaActivacion), DBNull.Value, objSIM.FechaActivacion)))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaAsignacion", SqlDbType.DateTime, IIf(IsNothing(objSIM.FechaAsignacion), DBNull.Value, objSIM.FechaAsignacion)))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaVencimiento", SqlDbType.DateTime, IIf(IsNothing(objSIM.FechaVencimiento), DBNull.Value, objSIM.FechaVencimiento)))
        parametros.Add(ConnectionDB.ArmaParametro("@CreationDate", SqlDbType.DateTime, objSIM.CreationDate))
        parametros.Add(ConnectionDB.ArmaParametro("@LastDate", SqlDbType.DateTime, IIf(IsNothing(objSIM.LastDate), DBNull.Value, objSIM.LastDate)))
        parametros.Add(ConnectionDB.ArmaParametro("@MBAsignados", SqlDbType.Int, IIf(IsNothing(objSIM.MBAsignados), DBNull.Value, objSIM.MBAsignados)))
        parametros.Add(ConnectionDB.ArmaParametro("@MBUsados", SqlDbType.Int, IIf(IsNothing(objSIM.MBUsados), DBNull.Value, objSIM.MBUsados)))
        parametros.Add(ConnectionDB.ArmaParametro("@MBDisponibles", SqlDbType.Int, IIf(IsNothing(objSIM.MBDisponibles), DBNull.Value, objSIM.MBDisponibles)))
        parametros.Add(ConnectionDB.ArmaParametro("@MBAdicionales", SqlDbType.Int, IIf(IsNothing(objSIM.MBAdicionales), DBNull.Value, objSIM.MBAdicionales)))
        parametros.Add(ConnectionDB.ArmaParametro("@OfertaId", SqlDbType.Int, IIf(IsNothing(objSIM.OfertaId), DBNull.Value, objSIM.OfertaId)))
        parametros.Add(ConnectionDB.ArmaParametro("@Tipo", SqlDbType.NVarChar, objSIM.Tipo))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaReactivacion", SqlDbType.DateTime, IIf(IsNothing(objSIM.FechaReactivacion), DBNull.Value, objSIM.FechaReactivacion)))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaBaja", SqlDbType.DateTime, IIf(IsNothing(objSIM.FechaBaja), DBNull.Value, objSIM.FechaBaja)))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaSuspension", SqlDbType.DateTime, IIf(IsNothing(objSIM.FechaSuspension), DBNull.Value, objSIM.FechaSuspension)))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaInicioFacturacion", SqlDbType.DateTime, IIf(IsNothing(objSIM.FechaInicioFacturacion), DBNull.Value, objSIM.FechaInicioFacturacion)))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaPortabilidad", SqlDbType.DateTime, IIf(IsNothing(objSIM.FechaPortabilidad), DBNull.Value, objSIM.FechaPortabilidad)))
        parametros.Add(ConnectionDB.ArmaParametro("@CompaniaOrigen", SqlDbType.NVarChar, objSIM.CompaniaOrigen))
        parametros.Add(ConnectionDB.ArmaParametro("@MSISDN_Transcitorio", SqlDbType.NVarChar, objSIM.MSISDN_Transcitorio))

        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_SIM]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_SIM]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_SIM]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function

    Public Function TransactionsUsuario(Of ReturnType)(opcion As Integer, ByVal objUsuario As Usuario) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@UsuarioID", SqlDbType.Int, objUsuario.UsuarioID))
        parametros.Add(ConnectionDB.ArmaParametro("@NombreUsuario", SqlDbType.NVarChar, objUsuario.NombreUsuario))
        parametros.Add(ConnectionDB.ArmaParametro("@Nombre", SqlDbType.NVarChar, objUsuario.Nombre))
        parametros.Add(ConnectionDB.ArmaParametro("@Email", SqlDbType.NVarChar, objUsuario.Email))
        parametros.Add(ConnectionDB.ArmaParametro("@PasswordHash", SqlDbType.NVarChar, objUsuario.PasswordHash))
        parametros.Add(ConnectionDB.ArmaParametro("@TipoUsuario", SqlDbType.Int, objUsuario.TipoUsuario))
        parametros.Add(ConnectionDB.ArmaParametro("@NumeroTelefono", SqlDbType.NVarChar, objUsuario.NumeroTelefono))
        parametros.Add(ConnectionDB.ArmaParametro("@RelacionTipoID", SqlDbType.Int, objUsuario.RelacionTipoID))
        parametros.Add(ConnectionDB.ArmaParametro("@UltimoLogin", SqlDbType.DateTime, IIf(IsNothing(objUsuario.UltimoLogin), DBNull.Value, objUsuario.UltimoLogin)))
        parametros.Add(ConnectionDB.ArmaParametro("@fechaBaja", SqlDbType.DateTime, IIf(IsNothing(objUsuario.fechaBaja), DBNull.Value, objUsuario.fechaBaja)))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaAlta", SqlDbType.DateTime, objUsuario.FechaAlta))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaUltimaActualizacion", SqlDbType.DateTime, objUsuario.FechaUltimaActualizacion))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_Usuario]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_Usuario]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_Usuario]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function

    Public Function TransactionsDistribuidores(Of ReturnType)(opcion As Integer, ByVal objDistribuidor As Distribuidor) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@DistribuidorID", SqlDbType.Int, objDistribuidor.DistribuidorID))
        parametros.Add(ConnectionDB.ArmaParametro("@Region", SqlDbType.Int, objDistribuidor.Region))
        parametros.Add(ConnectionDB.ArmaParametro("@Nombre", SqlDbType.NVarChar, objDistribuidor.Nombre))
        parametros.Add(ConnectionDB.ArmaParametro("@TipoPersona", SqlDbType.Char, objDistribuidor.TipoPersona))
        parametros.Add(ConnectionDB.ArmaParametro("@TipoDistribuidor", SqlDbType.Int, objDistribuidor.TipoDistribuidor))
        parametros.Add(ConnectionDB.ArmaParametro("@Direccion", SqlDbType.NVarChar, objDistribuidor.Direccion))
        parametros.Add(ConnectionDB.ArmaParametro("@RFC", SqlDbType.NVarChar, objDistribuidor.RFC))
        parametros.Add(ConnectionDB.ArmaParametro("@NombreContacto", SqlDbType.NVarChar, objDistribuidor.NombreContacto))
        parametros.Add(ConnectionDB.ArmaParametro("@TelefonoContacto", SqlDbType.NVarChar, objDistribuidor.TelefonoContacto))
        parametros.Add(ConnectionDB.ArmaParametro("@EmailContacto", SqlDbType.NVarChar, objDistribuidor.EmailContacto))
        parametros.Add(ConnectionDB.ArmaParametro("@DireccionFiscal", SqlDbType.NVarChar, objDistribuidor.DireccionFiscal))
        parametros.Add(ConnectionDB.ArmaParametro("@PorcentajeComision", SqlDbType.Decimal, objDistribuidor.PorcentajeComision))
        parametros.Add(ConnectionDB.ArmaParametro("@Banco", SqlDbType.NVarChar, objDistribuidor.Banco))
        parametros.Add(ConnectionDB.ArmaParametro("@Cuenta", SqlDbType.NVarChar, objDistribuidor.Cuenta))
        parametros.Add(ConnectionDB.ArmaParametro("@Beneficiario", SqlDbType.NVarChar, objDistribuidor.Beneficiario))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaAlta", SqlDbType.DateTime, IIf(IsNothing(objDistribuidor.FechaAlta), DBNull.Value, objDistribuidor.FechaAlta)))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaUltimaActualizacion", SqlDbType.DateTime, IIf(IsNothing(objDistribuidor.FechaUltimaActualizacion), DBNull.Value, objDistribuidor.FechaUltimaActualizacion)))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaBaja", SqlDbType.DateTime, IIf(IsNothing(objDistribuidor.FechaBaja), DBNull.Value, objDistribuidor.FechaBaja)))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_Distribuidores]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_Distribuidores]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_Distribuidores]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function
    Public Function TransactionsEstatusDeposito(Of ReturnType)(opcion As Integer, ByVal objEstatusDeposito As EstatusDeposito) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@EstatusDepositoID", SqlDbType.Int, objEstatusDeposito.EstatusDepositoID))
        parametros.Add(ConnectionDB.ArmaParametro("@Estatus", SqlDbType.NVarChar, objEstatusDeposito.Estatus))
        parametros.Add(ConnectionDB.ArmaParametro("@Descripcion", SqlDbType.NVarChar, objEstatusDeposito.Descripcion))
        parametros.Add(ConnectionDB.ArmaParametro("@Result", SqlDbType.Int, 0, ParameterDirection.Output))

        Dim cnx As New ConnectionDB
        cnx.ActivarConexion()
        Dim result As Object
        If GetType(ReturnType) Is GetType(Integer) Then
            result = cnx.ejecutasp_int("[sp_EstatusDeposito]", parametros)
        ElseIf GetType(ReturnType) Is GetType(DataSet) Then
            result = cnx.ejecutasp_consulta("[sp_EstatusDeposito]", parametros)
        ElseIf GetType(ReturnType) Is GetType(Boolean) Then
            result = cnx.ejecutasp("[sp_EstatusDeposito]", parametros)
        Else
            Throw New NotSupportedException("No se puede convertir de '" & GetType(ReturnType).ToString & "'")
        End If
        cnx.DesactivarConexion()
        cnx = Nothing
        Return DirectCast(result, ReturnType)
    End Function

End Class