<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ForgotPassword.aspx.vb" Inherits="WebClient.ForgotPassword" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Recuperar contraseña</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background: linear-gradient(to bottom, #000000, #003575ff);
            color: white;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Arial', sans-serif;
        }

        .forgot-container {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.4);
            max-width: 400px;
            width: 100%;
        }

            .forgot-container h2 {
                text-align: center;
                margin-bottom: 20px;
                font-size: 1.8rem;
                font-weight: bold;
            }

        .btn-custom {
            background-color: #3f7dc0;
            border-color: #3f7dc0;
            font-weight: bold;
            color: white;
        }

            .btn-custom:hover {
                background-color: #233251;
                border-color: #233251;
            }

        .form-control:focus {
            box-shadow: 0 0 5px rgba(255, 87, 34, 0.8);
            border-color: #76cbc4;
        }

        .logo {
            display: block;
            margin: 0 auto 20px;
            max-width: 180px;
        }

        .small-text {
            font-size: 14px;
            text-align: center;
            margin-top: 12px;
            color: white;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="forgot-container">
        <asp:Image ID="imgLogo" CssClass="logo" runat="server" ImageUrl="~/Resources/Imagenes/Logo.png" />
        <h2>Recuperar contraseña</h2>

        <div class="mb-3">
            <label for="txtCorreo" class="form-label">Correo electrónico</label>
            <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email"
                placeholder="name@example.com"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCorreo"
                ErrorMessage="El correo es requerido" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
        </div>
        <asp:RegularExpressionValidator runat="server" ControlToValidate="txtCorreo" ErrorMessage="Ingresa un correo válido" CssClass="text-danger" Display="Dynamic" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />

        <div class="d-grid mt-3">
            <asp:Button ID="btnEnviar" runat="server" CssClass="btn btn-custom w-100" Text="Enviar" OnClick="btnEnviar_Click" />
        </div>
        <div class="d-grid mt-3">
            <asp:Label ID="lblMensaje" runat="server" ForeColor="LightGreen" CssClass="small-text"></asp:Label>
            <div id="SuccessMessageDiv" runat="server" class="alert alert-success" visible="false">
                <asp:Literal runat="server" ID="SuccessText" />
            </div>
            <div id="ErrorMessageDiv" runat="server" class="alert alert-danger alert-dismissible fade show text-center" visible="false">
                <asp:Literal runat="server" ID="FailureText" />
            </div>
        </div>

        <div class="text-center mt-3">
            <asp:HyperLink ID="hlLogin" runat="server" NavigateUrl="~/Views/Account/Login.aspx" CssClass="btn btn-link text-white">
                Regresar
            </asp:HyperLink>
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
