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
            background-color: #1a3b6d; /* azul oscuro */
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
            color: white; /* texto en blanco */
        }

        .form-control {
            border-radius: 12px;
            padding: 10px;
            background-color: #ffffff; /* fondo blanco para los inputs */
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

            <label class="form-label">Contraseña actual</label>
            <input type="password" class="form-control" />

            <label class="form-label">Nueva contraseña</label>
            <input type="password" class="form-control" />

            <label class="form-label">Confirmar nueva contraseña</label>
            <input type="password" class="form-control" />

            <button class="btn-submit">Cambiar contraseña</button>
        </div>    
    </div>
</asp:Content>
