<%@ Page Title="Cambiar Contraseña" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="CambioContrasena.aspx.vb" Inherits="WebClient.CambioContrasena" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <style>
        .container-change {
            padding: 24px;
            max-width: 500px;
            margin: auto;
        }

        .card-form {
            border-radius: 16px;
            padding: 20px;
            background-color: #1a3b6d;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .card-header {
            background-color: #1976d2;
            color: white;
            font-weight: 600;
            font-size: 18px;
            text-align: center;
            border-radius: 12px 12px 0 0;
            padding: 12px;
        }

        .form-label {
            font-weight: 600;
            margin-top: 12px;
            color: white;
        }

        .form-control {
            border-radius: 12px;
            padding: 10px;
            background-color: #ffffff;
        }

        .btn-submit {
            background-color: #1976d2;
            color: white;
            font-weight: bold;
            width: 100%;
            padding: 12px;
            margin-top: 16px;
            border-radius: 12px;
            border: none;
        }

        .footer-text {
            text-align: center;
            margin-top: 20px;
            color: white;
            font-weight: bold;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(to bottom, #145991, #0a3472);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-change">
        <div class="card-form">
            <div class="card-header">Cambio de contraseña</div>

            <asp:Label CssClass="form-label" AssociatedControlID="txtContrasenaActual" runat="server" Text="Contraseña actual"></asp:Label>
            <asp:TextBox ID="txtContrasenaActual" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
            <span class="position-absolute top-50 end-0 translate-middle-y me-3" style="cursor: pointer;"
                onclick="togglePassword('txtContrasenaActual','eyeIconActual')">
                <i id="eyeIconActual" class="bi bi-eye"></i>
            </span>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtContrasenaActual" ErrorMessage="La contraseña es obligatoria" Display="Dynamic" ForeColor="Red" />
            <asp:RegularExpressionValidator ID="revContrasena" runat="server" ControlToValidate="txtContrasenaActual" ValidationExpression="^.{6,}$" ErrorMessage="La contraseña debe de tener al menos  6 caracteres" Display="Dynamic" ForeColor="Red" />

            <asp:Label CssClass="form-label" AssociatedControlID="txtNuevaContrasena" runat="server" Text="Nueva contraseña"></asp:Label>
            <asp:TextBox ID="txtNuevaContrasena" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
            <span class="position-absolute top-50 end-0 translate-middle-y me-3" style="cursor: pointer;"
                onclick="togglePassword('txtContrasenaActual','eyeIconActual')">
                <i id="eyeIconActual" class="bi bi-eye"></i>
            </span>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNuevaContrasena" ErrorMessage="La contraseña es obligatoria" Display="Dynamic" ForeColor="Red" />
            <asp:RegularExpressionValidator ID="revNuevaContrasena" runat="server" ControlToValidate="txtNuevaContrasena" ValidationExpression="^.{6,}$" ErrorMessage="La contraseña debe de tener al menos  6 caracteres" Display="Dynamic" ForeColor="Red" />

            <asp:Label CssClass="form-label" AssociatedControlID="txtConfirmarContrasena" runat="server" Text="Confirmar nueva contraseña"></asp:Label>
            <asp:TextBox ID="txtConfirmarContrasena" CssClass="form-control" runat="server" TextMode="Password"></asp:TextBox>
            <span class="position-absolute top-50 end-0 translate-middle-y me-3" style="cursor: pointer;"
                onclick="togglePassword('txtContrasenaActual','eyeIconActual')">
                <i id="eyeIconActual" class="bi bi-eye"></i>
            </span>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtConfirmarContrasena" ErrorMessage="La contraseña es obligatoria" Display="Dynamic" ForeColor="Red" />
            <asp:RegularExpressionValidator ID="revConfirmarContrasena" runat="server" ControlToValidate="txtConfirmarContrasena" ValidationExpression="^.{6,}$" ErrorMessage="La contraseña debe de tener al menos  6 caracteres" Display="Dynamic" ForeColor="Red" />
            <asp:CompareValidator ID="cvConfirmar" runat="server" ControlToCompare="txtNuevaContrasena" ControlToValidate="txtConfirmarContrasena" ErrorMessage="Las contraseñas no coinciden" Display="Dynamic" ForeColor="Red" />
            <asp:Button ID="btnCambiar" runat="server" CssClass="btn-submit" Text="Cambiar contraseña" OnClick="btnCambiar_Click" />

            <div class="d-grid mt-3">
                <div id="SuccessMessageDiv" runat="server" class="alert alert-success" visible="false">
                    <asp:Literal runat="server" ID="SuccessText" />
                </div>
                <div id="ErrorMessageDiv" runat="server" class="alert alert-danger alert-dismissible fade show text-center" visible="false">
                    <asp:Literal runat="server" ID="FailureText" />
                </div>
                <asp:Label ID="lblExito" runat="server"
                    ForeColor="Green"
                    Visible="False" />

                <asp:Label ID="lblError" runat="server"
                    ForeColor="Red"
                    Visible="False" />

            </div>
        </div>
</asp:Content>
