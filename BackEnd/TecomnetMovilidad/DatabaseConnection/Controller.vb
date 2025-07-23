Imports Models.TECOMNET
Public Class Controller
    Public Function TransactionsCustomer(Of ReturnType)(opcion As Integer, ByVal objCliente As Cliente) As ReturnType
        Dim parametros As New Collection

        parametros.Add(ConnectionDB.ArmaParametro("@opcion", SqlDbType.Int, opcion))
        parametros.Add(ConnectionDB.ArmaParametro("@ClienteId", SqlDbType.Int, objCliente.ClienteId))
        parametros.Add(ConnectionDB.ArmaParametro("@Nombre", SqlDbType.NVarChar, objCliente.Nombre))
        parametros.Add(ConnectionDB.ArmaParametro("@ApellidoPaterno", SqlDbType.NVarChar, objCliente.ApellidoPaterno))
        parametros.Add(ConnectionDB.ArmaParametro("@ApellidoMaterno", SqlDbType.NVarChar, objCliente.ApellidoMaterno))
        parametros.Add(ConnectionDB.ArmaParametro("@FechaCumpleanios", SqlDbType.DateTime, IIf(IsNothing(objCliente.FechaCumpleanios), DBNull.Value, objCliente.FechaCumpleanios)))
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
End Class
