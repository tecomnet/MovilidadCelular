<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CambioContrasena.aspx.vb" Inherits="WebAdmin.CambioContrasena" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Cambio de Contraseña</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fb;
            margin: 0;
            padding: 20px;
        }

        .container {
            max-width: 500px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        h2 {
            color: #4e73df;
            text-align: center;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #5a5c69;
        }

        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

            input[type="password"]:focus {
                outline: none;
                border-color: #4e73df;
                box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.2);
            }

        .btn {
            background-color: #4e73df;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            width: 100%;
            transition: background-color 0.3s;
        }

            .btn:hover {
                background-color: #2e59d9;
            }

            .btn:disabled {
                background-color: #b7b7b7;
                cursor: not-allowed;
            }

        .alert {
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .password-strength {
            margin-top: 5px;
            font-size: 12px;
            color: #6c757d;
        }

        .strength-weak {
            color: #dc3545;
        }

        .strength-medium {
            color: #fd7e14;
        }

        .strength-strong {
            color: #28a745;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Cambio de Contraseña</h2>

            <asp:Panel ID="pnlTokenInvalido" runat="server" Visible="false" CssClass="alert alert-danger">
                <strong>Error:</strong> El enlace ha expirado o es inválido. 
                <asp:HyperLink ID="lnkSolicitarNuevo" runat="server" Text="Solicitar nuevo enlace" />
            </asp:Panel>

            <asp:Panel ID="pnlFormulario" runat="server" Visible="false">
                <div class="form-group">
                    <label for="txtNuevaPassword">Nueva Contraseña:</label>
                    <asp:TextBox ID="txtNuevaPassword" runat="server" TextMode="Password"
                        placeholder="Mínimo 8 caracteres" required="true"></asp:TextBox>
                    <div class="password-strength">
                        <span id="passwordStrength"></span>
                    </div>
                </div>

                <div class="form-group">
                    <label for="txtConfirmarPassword">Confirmar Contraseña:</label>
                    <asp:TextBox ID="txtConfirmarPassword" runat="server" TextMode="Password"
                        placeholder="Repite tu contraseña" required="true"></asp:TextBox>
                    <div id="passwordMatch" class="password-strength"></div>
                </div>

                <asp:Button ID="btnCambiarPassword" runat="server" Text="Cambiar Contraseña"
                    CssClass="btn" OnClick="btnCambiarPassword_Click" />
            </asp:Panel>

            <asp:Panel ID="pnlExito" runat="server" Visible="false" CssClass="alert alert-success">
                <strong>¡Éxito!</strong> Tu contraseña ha sido cambiada correctamente.
                <asp:HyperLink ID="lnkLogin" runat="server" Text="Iniciar Sesión" NavigateUrl="~/login.aspx" />
            </asp:Panel>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger">
                <strong>Error:</strong>
                <asp:Literal ID="litMensajeError" runat="server"></asp:Literal>
            </asp:Panel>
        </div>
    </form>

    <script>
        // Validación de fortaleza de contraseña en cliente
        document.getElementById('<%= txtNuevaPassword.ClientID %>').addEventListener('input', function () {
            var password = this.value;
            var strength = document.getElementById('passwordStrength');

            if (password.length === 0) {
                strength.textContent = '';
                return;
            }

            var hasUpperCase = /[A-Z]/.test(password);
            var hasLowerCase = /[a-z]/.test(password);
            var hasNumbers = /\d/.test(password);
            var hasSpecial = /[!@#$%^&*(),.?":{}|<>]/.test(password);

            var score = 0;
            if (password.length >= 8) score++;
            if (hasUpperCase) score++;
            if (hasLowerCase) score++;
            if (hasNumbers) score++;
            if (hasSpecial) score++;

            switch (score) {
                case 0:
                case 1:
                    strength.textContent = 'Muy débil';
                    strength.className = 'strength-weak';
                    break;
                case 2:
                case 3:
                    strength.textContent = 'Débil';
                    strength.className = 'strength-weak';
                    break;
                case 4:
                    strength.textContent = 'Media';
                    strength.className = 'strength-medium';
                    break;
                case 5:
                    strength.textContent = 'Fuerte';
                    strength.className = 'strength-strong';
                    break;
            }
        });

        // Validación de coincidencia de contraseñas
        document.getElementById('<%= txtConfirmarPassword.ClientID %>').addEventListener('input', function () {
            var password = document.getElementById('<%= txtNuevaPassword.ClientID %>').value;
            var confirm = this.value;
            var match = document.getElementById('passwordMatch');

            if (confirm.length === 0) {
                match.textContent = '';
                return;
            }

            if (password === confirm) {
                match.textContent = 'Las contraseñas coinciden';
                match.className = 'strength-strong';
            } else {
                match.textContent = 'Las contraseñas no coinciden';
                match.className = 'strength-weak';
            }
        });
    </script>
</body>
</html>
