Imports Models.TECOMNET
Imports Models.TECOMNET.API
Imports Models.TECOMNET.Enumeraciones
Public Class ControllerOferta
    Public Function ObtenerOfertas() As List(Of Oferta)
        Dim controller As New Controller
        Dim lstOferta As New List(Of Oferta)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsOferta(Of DataSet)(1, New Oferta)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstOferta
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstOferta.Add(ConvertObject.Oferta(dr))
                Next
            End If
        Catch ex As Exception
            Return lstOferta
        End Try
        Return lstOferta
    End Function
    Public Function ObtenerOferta(OfertaID As Integer) As Oferta
        Dim controller As New Controller
        Dim objOferta As New Oferta
        objOferta.OfertaID = OfertaID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsOferta(Of DataSet)(2, objOferta)
            objOferta.OfertaID = 0
            For Each dr As DataRow In dt.Tables(0).Rows
                objOferta = ConvertObject.Oferta(dr)
            Next

        Catch ex As Exception
            Return objOferta
        End Try
        Return objOferta
    End Function
    'Public Function GetCustomer() As List(Of Customer)
    '    Dim controller As New Controller
    '    Dim lstCustomers As New List(Of Customer)
    '    Try
    '        Dim dt As New DataSet
    '        dt = controller.TransactionsCustomer(Of DataSet)(1, New Customer)

    '        If dt.Tables(0).Rows.Count = 0 Then
    '            Return lstCustomers
    '        Else
    '            For Each dr As DataRow In dt.Tables(0).Rows
    '                lstCustomers.Add(ConvertObject.Customers(dr))
    '            Next
    '        End If
    '    Catch ex As Exception
    '        Return lstCustomers
    '    End Try
    '    Return lstCustomers
    'End Function
    'Public Function GetCustomer() As List(Of Customer)
    '    Dim controller As New Controller
    '    Dim lstCustomers As New List(Of Customer)
    '    Try
    '        Dim dt As New DataSet
    '        dt = controller.TransactionsCustomer(Of DataSet)(1, New Customer)

    '        If dt.Tables(0).Rows.Count = 0 Then
    '            Return lstCustomers
    '        Else
    '            For Each dr As DataRow In dt.Tables(0).Rows
    '                lstCustomers.Add(ConvertObject.Customers(dr))
    '            Next
    '        End If
    '    Catch ex As Exception
    '        Return lstCustomers
    '    End Try
    '    Return lstCustomers
    'End Function
    'Public Function GetCustomer() As List(Of Customer)
    '    Dim controller As New Controller
    '    Dim lstCustomers As New List(Of Customer)
    '    Try
    '        Dim dt As New DataSet
    '        dt = controller.TransactionsCustomer(Of DataSet)(1, New Customer)

    '        If dt.Tables(0).Rows.Count = 0 Then
    '            Return lstCustomers
    '        Else
    '            For Each dr As DataRow In dt.Tables(0).Rows
    '                lstCustomers.Add(ConvertObject.Customers(dr))
    '            Next
    '        End If
    '    Catch ex As Exception
    '        Return lstCustomers
    '    End Try
    '    Return lstCustomers
    'End Function
    Public Function ObtenerOfertasActivasPorTipo(Tipo As TipoServicio) As List(Of Oferta)
        Dim controller As New Controller
        Dim lstOferta As New List(Of Oferta)
        Dim objOferta As New Oferta
        objOferta.Tipo = Tipo
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsOferta(Of DataSet)(6, objOferta)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstOferta
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstOferta.Add(ConvertObject.Oferta(dr))
                Next
            End If
        Catch ex As Exception
            Return lstOferta
        End Try
        Return lstOferta
    End Function
End Class
