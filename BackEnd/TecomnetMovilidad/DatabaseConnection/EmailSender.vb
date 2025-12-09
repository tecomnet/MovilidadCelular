Imports System.Configuration
Imports System.Net.Mail
Imports Models.TECOMNET.Enumeraciones
Imports System.IO

Public Class EmailSender
    Public Shared Function EnvioCorreo(Nombre As String, Link As String, email As String, Template As TipoDeEmail) As Boolean
        Try
            Dim mail As New MailMessage()
            Dim templatePath As String = String.Empty
            Dim htmlBody As String = String.Empty

            ' 📌 Cargar la plantilla HTML
            Select Case Template
                Case TipoDeEmail.SolicitudCambioContrasena
                    templatePath = ConfigurationManager.AppSettings("PathTempleatesMail").ToString & "SolicitudCambioContrasena.html"
                    htmlBody = File.ReadAllText(templatePath)
                    htmlBody = htmlBody.Replace("{Nombre}", Nombre)
                    htmlBody = htmlBody.Replace("{Link}", Link)
                    mail.Subject = "¡Solicitud de cambio de contraseña!"

                    'Case TypeMessageMail.WelcomeCustomer
                    'Case TypeMessageMail.NotificationRecharge

            End Select

            'Configurar el correo            
            mail.From = New MailAddress("c.anaya@tecomnet.mx", "TECOMNET")
            mail.To.Add(email)
            mail.Body = htmlBody
            mail.IsBodyHtml = True ' Indicamos que es HTML
            mail.SubjectEncoding = System.Text.Encoding.UTF8 'Codificacion
            mail.BodyEncoding = System.Text.Encoding.UTF8
            mail.Priority = System.Net.Mail.MailPriority.Normal

            ' 📌 Configurar el servidor SMTP
            Dim smtp As New SmtpClient("smtp.hostinger.com")
            smtp.Port = 587
            smtp.Credentials = New System.Net.NetworkCredential("c.anaya@tecomnet.mx", "Gfv456yh54o2#")
            smtp.EnableSsl = True


            ' 📌 Enviar el correo            
            smtp.Send(mail)

            Return True

        Catch ex As Exception
            Return False
        End Try
    End Function
    Public Shared Function NotificacionDeRecarga(Nombre As String, plan As String, email As String, Template As TipoDeEmail) As Boolean
        Try
            Dim mail As New MailMessage()
            Dim templatePath As String = String.Empty
            Dim htmlBody As String = String.Empty

            templatePath = ConfigurationManager.AppSettings("PathTempleatesMail").ToString & "Recharge.html"
            htmlBody = File.ReadAllText(templatePath)

            htmlBody = htmlBody.Replace("{Nombre}", Nombre)
            htmlBody = htmlBody.Replace("{plan}", plan)

            'Configurar el correo            
            mail.From = New MailAddress("c.anaya@tecomnet.mx", "TECOMNET")
            mail.To.Add(email)
            mail.Subject = "Recarga Exitosa"
            mail.Body = htmlBody
            mail.IsBodyHtml = True ' Indicamos que es HTML
            mail.SubjectEncoding = System.Text.Encoding.UTF8 'Codificacion
            mail.BodyEncoding = System.Text.Encoding.UTF8
            mail.Priority = System.Net.Mail.MailPriority.Normal

            ' 📌 Configurar el servidor SMTP
            Dim smtp As New SmtpClient("smtp.hostinger.com")
            smtp.Port = 587
            smtp.Credentials = New System.Net.NetworkCredential("c.anaya@tecomnet.mx", "Gfv456yh54o2#")
            smtp.EnableSsl = True

            ' 📌 Enviar el correo            
            smtp.Send(mail)

            Return True
        Catch ex As Exception
            Return False
        End Try

    End Function
End Class