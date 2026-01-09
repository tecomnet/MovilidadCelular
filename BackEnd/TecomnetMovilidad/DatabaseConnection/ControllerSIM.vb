Imports Models
Imports Models.TECOMNET

Public Class ControllerSIM
    '1 Obtiene todas las SIMS
    Public Function ObtenerSIM() As List(Of SIM)
        Dim controller As New Controller
        Dim lstSIM As New List(Of SIM)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSIM(Of DataSet)(1, New SIM)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstSIM
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstSIM.Add(ConvertObject.SIM(dr))
                Next
            End If
        Catch ex As Exception
            Return lstSIM
        End Try
        Return lstSIM
    End Function
    '2 Obtiene una SIM en especifica por ID
    Public Function ObtenerSIMPorID(ByVal SIMID As Integer) As SIM
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.SIMID = SIMID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSIM(Of DataSet)(2, objSIM)

            For Each dr As DataRow In dt.Tables(0).Rows
                objSIM = ConvertObject.SIM(dr)
            Next
        Catch ex As Exception
            Return objSIM
        End Try
        Return objSIM
    End Function
    '3 Obtiene una SIM en especifica por ICCID
    Public Function ObtenerSIMPorICCID(ByVal ICCID As String) As SIM
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.ICCID = ICCID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSIM(Of DataSet)(3, objSIM)

            For Each dr As DataRow In dt.Tables(0).Rows
                objSIM = ConvertObject.SIM(dr)
            Next
        Catch ex As Exception
            Return objSIM
        End Try
        Return objSIM
    End Function
    '4 Inserta un SIM
    Public Function AgregarSIM(ByVal objSIM As SIM) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsSIM(Of Integer)(4, objSIM)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
    '5 Obtiene una SIM en especifico por MSISDN
    Public Function ObtenerSIMPorMSISDN(ByVal MSISDN As String) As SIM
        Dim controller As New Controller
        Dim objSIM As New SIM
        objSIM.MSISDN = MSISDN
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSIM(Of DataSet)(5, objSIM)

            For Each dr As DataRow In dt.Tables(0).Rows
                objSIM = ConvertObject.SIM(dr)
            Next
        Catch ex As Exception
            Return objSIM
        End Try
        Return objSIM
    End Function
    '6 Obtiene todas las SIM disponibles (no asignadas)
    Public Function ObtenerSIMDisponibles() As List(Of SIM)
        Dim controller As New Controller
        Dim lstSIM As New List(Of SIM)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSIM(Of DataSet)(6, New SIM)

            If dt.Tables(0).Rows.Count > 0 Then
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstSIM.Add(ConvertObject.SIM(dr))
                Next
            End If
        Catch ex As Exception
            Return lstSIM
        End Try
        Return lstSIM
    End Function
    '7 Asigna una SIM a un cliente
    Public Function AsignarSIM(ByVal SIMID As Integer, ByVal ClienteId As Integer) As Boolean
        Dim controller As New Controller
        Dim objSIM As New SIM
        Try
            objSIM.SIMID = SIMID
            objSIM.ClienteId = ClienteId
            controller.TransactionsSIM(Of Integer)(7, objSIM)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function
    '8 Obtiene todas las SIM asignadas a un cliente
    Public Function ObtenerSIMPorCliente(ByVal ClienteId As Integer) As List(Of SIM)
        Dim controller As New Controller
        Dim lstSIM As New List(Of SIM)
        Dim objSIM As New SIM
        objSIM.ClienteId = ClienteId
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsSIM(Of DataSet)(8, objSIM)

            If dt.Tables(0).Rows.Count > 0 Then
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstSIM.Add(ConvertObject.SIM(dr))
                Next
            End If
        Catch ex As Exception
            Return lstSIM
        End Try
        Return lstSIM
    End Function
    '9 Aplica recarga
    Public Function AplicaRecarga(ByVal objSIM As SIM) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsSIM(Of Integer)(9, objSIM)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function

    Public Function AsignarOferta(simId As Integer, ofertaId As Integer) As Boolean
        Dim controller As New Controller
        Dim objSIM As New SIM

        Try
            objSIM.SIMID = simId
            objSIM.OfertaId = ofertaId

            controller.TransactionsSIM(Of Integer)(10, objSIM)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function

    Public Function UpdateSIM(ByVal objSIM As SIM) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsSIM(Of Integer)(11, objSIM)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
