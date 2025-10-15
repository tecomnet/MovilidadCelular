Public Class ValidaRecarga
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Dim tokenBase64 As String = Request.QueryString("token")

        'If Not String.IsNullOrEmpty(tokenBase64) Then
        '    Try
        '        Dim tokenDecoded As String = HttpUtility.UrlDecode(tokenBase64)
        '        Dim tokenBytes As Byte() = Convert.FromBase64String(tokenDecoded)
        '        Dim tokenString As String = Encoding.UTF8.GetString(tokenBytes)
        '        Dim tokenTime As DateTime = DateTime.ParseExact(tokenString, "o", Nothing, Globalization.DateTimeStyles.RoundtripKind)

        '        If DateTime.UtcNow.Subtract(tokenTime.ToUniversalTime()).TotalMinutes <= 5 Then
        '            pnlSuccess.Visible = True
        '        Else
        '            pnlExpired.Visible = True
        '        End If
        '    Catch ex As Exception
        '        pnlExpired.Visible = True
        '    End Try
        'Else
        '    pnlExpired.Visible = True
        'End If
        pnlSuccess.Visible = True
    End Sub

End Class