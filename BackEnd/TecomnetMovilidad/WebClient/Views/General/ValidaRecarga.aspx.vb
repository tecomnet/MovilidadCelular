Public Class ValidaRecarga
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim tokenBase64 As String = Request.QueryString("token")

        If Not String.IsNullOrEmpty(tokenBase64) Then
            Try
                Dim tokenBytes As Byte() = Convert.FromBase64String(tokenBase64)
                Dim tokenString As String = Encoding.UTF8.GetString(tokenBytes)
                Dim tokenTime As DateTime = DateTime.Parse(tokenString)

                If DateTime.Now.Subtract(tokenTime).TotalMinutes <= 1 Then
                    pnlSuccess.Visible = True
                Else
                    pnlExpired.Visible = True
                End If
            Catch ex As Exception
                pnlExpired.Visible = True
            End Try
        Else
            pnlExpired.Visible = True
        End If
    End Sub

End Class