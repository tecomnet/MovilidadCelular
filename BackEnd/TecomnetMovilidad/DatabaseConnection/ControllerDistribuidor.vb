Imports Models.TECOMNET
Imports Models.TECOMNET.API

Public Class ControllerDistribuidor
    Public Function GetDistribuidor() As List(Of Distribuidor)
        Dim controller As New Controller
        Dim lista As New List(Of Distribuidor)

        Try
            Dim ds As DataSet = controller.TransactionsDistribuidores(Of DataSet)(1, New Distribuidor)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                For Each row As DataRow In ds.Tables(0).Rows
                    lista.Add(ConvertObject.Distribuidor(row))
                Next
            End If
        Catch ex As Exception

        End Try

        Return lista
    End Function

    Public Function AddDistribuidor(ByVal objDistribuidor As Distribuidor) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsDistribuidores(Of Integer)(3, objDistribuidor)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function

    Public Function BajaDistribuidor(ByVal distribuidorId As Integer) As Integer
        Dim exito As Integer = 0
        Dim controller As New Controller
        Try
            Dim objDistribuidor As New Distribuidor()
            objDistribuidor.DistribuidorID = distribuidorId
            exito = controller.TransactionsDistribuidores(Of Integer)(4, objDistribuidor)
        Catch ex As Exception
            Return 0
        End Try
        Return exito
    End Function

    Public Function UpdateDistribuidor(ByVal objDistribuidor As Distribuidor) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsDistribuidores(Of Integer)(5, objDistribuidor)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function

    Public Function ObtenerDistribuidorPorID(ByVal DistribuidorID As Integer) As Distribuidor
        Dim controller As New Controller
        Dim objDistribuidor As New Distribuidor
        objDistribuidor.DistribuidorID = DistribuidorID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsDistribuidores(Of DataSet)(2, objDistribuidor)

            For Each dr As DataRow In dt.Tables(0).Rows
                objDistribuidor = ConvertObject.Distribuidor(dr)
            Next
        Catch ex As Exception
            Return objDistribuidor
        End Try
        Return objDistribuidor
    End Function
End Class
