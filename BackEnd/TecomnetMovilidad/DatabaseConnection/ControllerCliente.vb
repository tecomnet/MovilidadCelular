Imports Models.TECOMNET
Imports Models.TECOMNET.API

Public Class ControllerCliente

    Public Function GetClientes() As List(Of Cliente)
        Dim controller As New Controller
        Dim lista As New List(Of Cliente)

        Try
            Dim ds As DataSet = controller.TransactionsCliente(Of DataSet)(1, New Cliente)

            If ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
                For Each row As DataRow In ds.Tables(0).Rows
                    lista.Add(ConvertObject.Cliente(row))
                Next
            End If
        Catch ex As Exception

        End Try

        Return lista
    End Function

    Public Function ObtenerClientePorID(ByVal ClienteID As Integer) As Cliente
        Dim controller As New Controller
        Dim objCliente As New Cliente
        objCliente.ClienteId = ClienteID
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCliente(Of DataSet)(2, objCliente)

            For Each dr As DataRow In dt.Tables(0).Rows
                objCliente = ConvertObject.Cliente(dr)
            Next
        Catch ex As Exception
            Return objCliente
        End Try
        Return objCliente
    End Function
    Public Function AddCliente(ByVal objCliente As Cliente) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCliente(Of Integer)(3, objCliente)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function

    Public Function UpdateCliente(ByVal objCliente As Cliente) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsCliente(Of Integer)(4, objCliente)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function

    Public Function BajaCliente(ByVal clienteId As Integer) As Integer
        Dim exito As Integer = 0
        Dim controller As New Controller
        Try
            Dim objCliente As New Cliente()
            objCliente.ClienteId = clienteId
            exito = controller.TransactionsCliente(Of Integer)(9, objCliente)
        Catch ex As Exception
            Return 0
        End Try
        Return exito
    End Function

    Public Function LoginCustomer(ByVal email As String, ByVal password As String) As Cliente
        Dim controller As New Controller
        Dim objCliente As New Cliente
        objCliente.Email = email
        objCliente.ContrasenaHash = password
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCliente(Of DataSet)(5, objCliente)

            For Each dr As DataRow In dt.Tables(0).Rows
                objCliente = ConvertObject.Cliente(dr)
            Next
        Catch ex As Exception
            Return objCliente
        End Try
        Return objCliente
    End Function
    Public Function ObtenerPlanesPorCliente(ByVal ClienteId As Integer) As List(Of Tablero)
        Dim controller As New Controller
        Dim listTablero As New List(Of Tablero)
        Dim objCliente As New Cliente
        objCliente.ClienteId = ClienteId

        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCliente(Of DataSet)(6, objCliente)

            For Each dr As DataRow In dt.Tables(0).Rows
                Dim objTablero As New Tablero
                objTablero = ConvertObject.Tablero(dr)
                listTablero.Add(objTablero)
            Next
        Catch ex As Exception
            Return listTablero
        End Try
        Return listTablero
    End Function
    Public Function CambiaPassword(ByVal objCliente As Cliente) As Boolean
        Dim controller As New Controller
        Try
            Dim dt As New DataSet
            Return controller.TransactionsCliente(Of Integer)(7, objCliente)

        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function
    Public Function ObtenerClientePorEmail(ByVal email As String) As Cliente
        Dim controller As New Controller
        Dim objCliente As New Cliente
        objCliente.Email = email
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsCliente(Of DataSet)(8, objCliente)

            For Each dr As DataRow In dt.Tables(0).Rows
                objCliente = ConvertObject.Cliente(dr)
            Next
        Catch ex As Exception
            Return objCliente
        End Try
        Return objCliente
    End Function
    'Public Function DesactivateCustomer(ByVal CustomerID As Integer) As Integer
    '    Dim exito As Integer
    '    Dim controller As New Controller
    '    Dim objCustomer As New Customer
    '    objCustomer.CustomerID = CustomerID
    '    objCustomer.LastDate = Now
    '    Try
    '        exito = controller.TransactionsCustomer(Of Integer)(5, objCustomer)
    '    Catch ex As Exception
    '        Return exito
    '    End Try
    '    Return exito
    'End Function
    'Public Function GetCustomerByMatch(ByVal TextSearch As String) As List(Of Customer)
    '    Dim controller As New Controller
    '    Dim lstCustomer As New List(Of Customer)
    '    Try
    '        Dim dt As New DataSet
    '        Dim objCustomer As New Customer
    '        objCustomer.CustomerName = TextSearch
    '        dt = controller.TransactionsCustomer(Of DataSet)(6, objCustomer)

    '        If dt.Tables(0).Rows.Count = 0 Then
    '            Return lstCustomer
    '        Else
    '            For Each dr As DataRow In dt.Tables(0).Rows
    '                lstCustomer.Add(ConvertObject.Customers(dr))
    '            Next
    '        End If
    '    Catch ex As Exception
    '        Return lstCustomer
    '    End Try
    '    Return lstCustomer
    'End Function
    'Public Function ValidateCustomerRegistration(ByVal VIN As String, ByVal RFC As String, ByVal email As String) As Customer
    '    Dim controller As New Controller
    '    Dim objCustomer As New Customer
    '    objCustomer.CustomerName = VIN
    '    objCustomer.RFC = RFC
    '    objCustomer.Email = email
    '    Try
    '        Dim dt As New DataSet
    '        dt = controller.TransactionsCustomer(Of DataSet)(7, objCustomer)

    '        For Each dr As DataRow In dt.Tables(0).Rows
    '            objCustomer = ConvertObject.Customers(dr)
    '        Next
    '    Catch ex As Exception
    '        Return objCustomer
    '    End Try
    '    Return objCustomer
    'End Function
    'Public Function RegistrationCustomer(ByVal objCustomer As Customer) As Integer
    '    Dim exito As Integer
    '    Dim controller As New Controller
    '    Try
    '        exito = controller.TransactionsCustomer(Of Integer)(8, objCustomer)
    '    Catch ex As Exception
    '        Return exito
    '    End Try
    '    Return exito
    'End Function    
    'Public Function ChangePassword(ByVal CustomerID As Integer, ByVal InitialPassword As String, ByVal NewPassword As String) As Integer
    '    Dim exito As Integer
    '    Dim controller As New Controller
    '    Dim objCustomer As New Customer
    '    objCustomer.CustomerID = CustomerID
    '    objCustomer.CustomerName = InitialPassword
    '    objCustomer.Password = NewPassword

    '    Try
    '        exito = controller.TransactionsCustomer(Of Integer)(10, objCustomer)
    '    Catch ex As Exception
    '        Return exito
    '    End Try
    '    Return exito
    'End Function
End Class
