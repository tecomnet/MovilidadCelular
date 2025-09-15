Namespace TECOMNET.Enumeraciones
    Public Enum TipoUsuario
        Administrator = 1
        Soporte = 2
        Distribuidor = 3
    End Enum
    Public Enum EstatusSIM
        Activa = 1
        Suspendida = 2
        Retirada = 3
    End Enum
    Public Enum TipoServicio
        Prepago = 1
        PagoAnticipado = 2
        RenovacionAutomatica = 3
    End Enum
    Public Enum EstatusFactura
        Pagada = 1
        Pendiente = 2
        Vencida = 3
    End Enum
    Public Enum EstatusTicket
        Abierto = 1
        EnProceso = 2
        Cerrado = 3
    End Enum
    Public Enum TipoOperacion
        Activacion = 1
        Suspension = 2
        ConsultaSaldo = 3
    End Enum
    Public Enum EstatusCliente
        Activo = 1
        Suspendido = 2
        Desactivado = 3
    End Enum
    Public Enum TipoErroresAPI
        Desconocido = 0
        Exito = 1
        Errors = 2
        Advertencia = 3
    End Enum
    Public Enum TipoDeEmail
        Recarga = 1
        Bienvenida = 2
        SolicitudCambioContrasena = 3
    End Enum
End Namespace