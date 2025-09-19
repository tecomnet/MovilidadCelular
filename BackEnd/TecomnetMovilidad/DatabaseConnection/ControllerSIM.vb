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
End Class
