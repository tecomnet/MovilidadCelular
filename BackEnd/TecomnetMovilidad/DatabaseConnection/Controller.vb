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
        parametros.Add(ConnectionDB.ArmaParametro("@Estatus", SqlDbType.NVarChar, objSolicitudDePago.Estatus))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaCreacion", SqlDbType.DateTime, objSolicitudDePago.FechaCreacion))
        parametros.Add(ConnectionDB.ArmaParametro("@EstatusDepositoID", SqlDbType.Int, objSolicitudDePago.EstatusDepositoID))
        parametros.Add(ConnectionDB.ArmaParametro("@IdTransaction", SqlDbType.NVarChar, objSolicitudDePago.IdTransaction))
        parametros.Add(ConnectionDB.ArmaParametro("@AuthNumber", SqlDbType.NVarChar, objSolicitudDePago.AuthNumber))
        parametros.Add(ConnectionDB.ArmaParametro("@AuthCode", SqlDbType.NVarChar, objSolicitudDePago.AuthCode))
        parametros.Add(ConnectionDB.ArmaParametro("@Reason", SqlDbType.NVarChar, objSolicitudDePago.Reason))
        parametros.Add(ConnectionDB.ArmaParametro("@PagoDepositoID", SqlDbType.Int, IIf(IsNothing(objSolicitudDePago.PagoDepositoID), DBNull.Value, objSolicitudDePago.PagoDepositoID)))
        parametros.Add(ConnectionDB.ArmaParametro("@UltimaActualizacion", SqlDbType.DateTime, objSolicitudDePago.UltimaActualizacion))
        parametros.Add(ConnectionDB.ArmaParametro("@NumeroReintentos", SqlDbType.Int, objSolicitudDePago.NumeroReintentos))
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
End Class