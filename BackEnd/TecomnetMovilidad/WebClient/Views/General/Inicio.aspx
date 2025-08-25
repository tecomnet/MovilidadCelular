<%@ Page Title="Inicio" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="Inicio.aspx.vb" Inherits="WebClient.Inicio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        .card-title {
            color: #ffff;
            font-weight: 600;
        }

        .percent-circle {
            width: 160px;
            height: 160px;
            border-radius: 50%;
            border: 14px solid #0078D7;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f5f5f5;
            margin: auto;
        }

        .footer-text {
            font-size: 14px;
            font-style: italic;
            color: white;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container my-4">
        <div class="card text-center mx-auto mt-3" style="max-width: 600px; background-color: #0056b3;">
            <div class="card-body text-white">
                <h5 class="card-title">Hola Escandón Cruz Enrique</h5>
            </div>
        </div>

        <div class="card mx-auto mt-4" style="max-width: 600px;">
            <div class="card-body text-center">
                <h5 class="card-title">Plan 10GB - Internet Ilimitado</h5>
                
                <div class="percent-circle">
                    <div>
                        <div><i class="bi bi-globe" style="font-size:26px;color:#0078D7;"></i></div>
                        <small style="color: gray;">Ha consumido</small>
                        <div style="color:#0078D7; font-size:18px; font-weight:bold;">2.50 GB</div>
                        <small>de 10.00 GB</small>
                    </div>
                </div>

                <p class="mt-3"><b>Vigencia:</b> 2025-08-31</p>
                <div class="row mt-2">
                    <div class="col"><b>25%</b><br>Consumido</div>
                    <div class="col"><b>7.50 GB</b><br>Disponible</div>
                </div>

                <div class="mt-4">
                    <asp:Button ID="btnRenovarPlan" runat="server" CssClass="btn btn-primary me-2" Text="Renovar Plan" />
                    <asp:Button ID="btnRecargarSaldo" runat="server" CssClass="btn btn-primary" Text="Recargar Saldo" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
