Imports Models
Imports Models.TECOMNET

Public Class ControllerPortabilidad
    Public Function GetPortabilidad() As List(Of Portabilidad)
        Dim controller As New Controller
        Dim lstPortabilidad As New List(Of Portabilidad)
        Try
            Dim dt As New DataSet
            dt = controller.TransactionsPortabilidad(Of DataSet)(1, New Portabilidad)

            If dt.Tables(0).Rows.Count = 0 Then
                Return lstPortabilidad
            Else
                For Each dr As DataRow In dt.Tables(0).Rows
                    lstPortabilidad.Add(ConvertObject.Portabilidad(dr))
                Next
            End If
        Catch ex As Exception
            Return lstPortabilidad
        End Try
        Return lstPortabilidad
    End Function

    Public Function AddPortabilidad(ByVal objPortabilidad As Portabilidad) As Integer
        Dim exito As Integer
        Dim controller As New Controller

        Try
            exito = controller.TransactionsPortabilidad(Of Integer)(2, objPortabilidad)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function

    Public Function UpdatePortabilidad(ByVal objPortabilidad As Portabilidad) As Integer
        Dim exito As Integer
        Dim controller As New Controller
        Try
            exito = controller.TransactionsPortabilidad(Of Integer)(3, objPortabilidad)
        Catch ex As Exception
            Return exito
        End Try
        Return exito
    End Function
End Class
