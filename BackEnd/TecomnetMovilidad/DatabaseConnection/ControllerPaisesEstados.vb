Imports Models
Imports Models.TECOMNET
Imports Models.TECOMNET.API

Public Class ControllerPaisesEstados

    Public Function GetPaisesEstados() As List(Of PaisesEstados)
        Dim controller As New Controller
        Dim lstPaisesEstados As New List(Of PaisesEstados)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsPaisesEstados(Of DataSet)(1, New PaisesEstados)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstPaisesEstados
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstPaisesEstados.Add(ConvertObject.PaisesEstados(dr))
                Next
            End If
        Catch ex As Exception
            Return lstPaisesEstados
        End Try
        Return lstPaisesEstados
    End Function
    Public Function ObtenerPaises() As List(Of PaisesEstados)
        Dim controller As New Controller
        Dim lstPaisesEstados As New List(Of PaisesEstados)
        Try
            Dim obj As New PaisesEstados()
            obj.Pais = ""
            Dim dt As DataSet = controller.TransactionsPaisesEstados(Of DataSet)(2, obj)

            For Each dr As DataRow In dt.Tables(0).Rows
                lstPaisesEstados.Add(ConvertObject.PaisesEstados(dr))
            Next
        Catch ex As Exception
            Return lstPaisesEstados
        End Try
        Return lstPaisesEstados
    End Function


    Public Function ObtenerEstadosPorPais(codigoPais As String) As List(Of PaisesEstados)
        Dim controller As New Controller
        Dim lstEstados As New List(Of PaisesEstados)
        Try
            Dim obj As New PaisesEstados()
            obj.CodigoPais = codigoPais
            obj.Estado = ""
            obj.CodigoMunicipio = ""
            Dim dt As DataSet = controller.TransactionsPaisesEstados(Of DataSet)(3, obj)

            For Each dr As DataRow In dt.Tables(0).Rows
                lstEstados.Add(ConvertObject.PaisesEstados(dr))
            Next
        Catch ex As Exception
            Return lstEstados
        End Try
        Return lstEstados
    End Function


    Public Function ObtenerMunicipiosPorEstado(codigoPais As String, codigoEstado As String) As List(Of PaisesEstados)
        Dim controller As New Controller
        Dim lstMunicipios As New List(Of PaisesEstados)
        Try
            Dim obj As New PaisesEstados()
            obj.CodigoPais = codigoPais
            obj.CodigoEstado = codigoEstado
            obj.CodigoMunicipio = ""
            Dim dt As DataSet = controller.TransactionsPaisesEstados(Of DataSet)(4, obj)

            For Each dr As DataRow In dt.Tables(0).Rows
                lstMunicipios.Add(ConvertObject.PaisesEstados(dr))
            Next
        Catch ex As Exception
            Return lstMunicipios
        End Try
        Return lstMunicipios
    End Function

End Class
