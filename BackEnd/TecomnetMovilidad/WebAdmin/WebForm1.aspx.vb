Imports System.Security.Cryptography
Imports System.Text

Public Class WebForm1
    Inherits System.Web.UI.Page

    Protected Sub btnDecrypt_Click(sender As Object, e As EventArgs)
        Try
            Dim encryptedBase64 As String = txtEncrypted.Text.Trim()
            Dim decryptedText As String = Decrypt(encryptedBase64)
            lblResult.ForeColor = Drawing.Color.Green
            If IsEmail(decryptedText) Then
                lblResult.Text = "📧 Correo descifrado: " & decryptedText
            Else
                lblResult.Text = "🔓 Contraseña descifrada: " & decryptedText
            End If
        Catch ex As Exception
            lblResult.ForeColor = Drawing.Color.Red
            lblResult.Text = "❌ Error: " & ex.Message
        End Try
    End Sub

    Private Function Decrypt(encryptedBase64 As String) As String
        Dim key As Byte() = Encoding.UTF8.GetBytes("1234567890123456")
        Dim iv As Byte() = Encoding.UTF8.GetBytes("abcdefghijklmnop")
        Dim encryptedBytes As Byte() = Convert.FromBase64String(encryptedBase64)

        Using aes As Aes = Aes.Create()
            aes.Key = key
            aes.IV = iv
            aes.Mode = CipherMode.CBC
            aes.Padding = PaddingMode.PKCS7

            Using decryptor = aes.CreateDecryptor()
                Dim decryptedBytes As Byte() = decryptor.TransformFinalBlock(encryptedBytes, 0, encryptedBytes.Length)
                Return Encoding.UTF8.GetString(decryptedBytes)
            End Using
        End Using
    End Function
    Private Function IsEmail(input As String) As Boolean
        ' Valida si el texto tiene formato de correo
        Return Regex.IsMatch(input, "^[^@\s]+@[^@\s]+\.[^@\s]+$")
    End Function
End Class
