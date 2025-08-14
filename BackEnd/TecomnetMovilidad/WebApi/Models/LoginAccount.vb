Imports System.ComponentModel.DataAnnotations
Namespace TECOMNET.API
    Public Class LoginAccount
        <Required>
        Public Property UserName As String
        <Required>
        Public Property Password As String
    End Class
    Public Class ChangePasswordAccount
        Inherits LoginAccount
        <Required>
        Public Property NewPassword As String
    End Class
End Namespace