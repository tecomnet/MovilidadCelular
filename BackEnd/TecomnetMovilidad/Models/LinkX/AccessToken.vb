Namespace TECOMNET.LinkX
    Public Class AccessToken
        Public Property message As String
        Public Property response As responseAccessTokenLinkX
        Public Class responseAccessTokenLinkX
            Public Property token As String
            Public Property expiresIn As Integer
        End Class
    End Class
End Namespace