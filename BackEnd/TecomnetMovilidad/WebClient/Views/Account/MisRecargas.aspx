<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="MisRecargas.aspx.vb" Inherits="WebClient.MisRecargas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container-recargas {
            padding: 20px;
        }
        .card-header {
            background-color: #1565C0;
            color: white;
            padding: 16px;
            border-radius: 8px;
            text-align: center;
            font-weight: 600;
            font-size: 18px;
            margin-bottom: 20px;
        }
        .grid-card {
            background-color: white;
            color: black;
            border-radius: 16px;
            padding: 16px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            overflow-x: auto;
            max-height: 400px; /* Para scroll vertical si hay muchas filas */
            overflow-y: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th {
            background-color: #E0E0E0;
            padding: 8px;
            text-align: left;
        }
        td {
            padding: 8px;
        }
        .footer {
            text-align: center;
            margin: 20px 0;
            font-size: 14px;
            font-weight: bold;
            color: white;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-recargas">
        <div class="card-header">
            Consulta tus recargas
        </div>

        <div class="grid-card">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>Producto</th>
                        <th>Auto</th>
                        <th>Costo</th>
                        <th>Fecha</th>
                        <th>Método de pago</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Mas MB para tu BYD 2</td>
                        <td>HAN MOTORS</td>
                        <td>$10.00</td>
                        <td>2/6/2025 1:48:24 PM</td>
                        <td>Card</td>
                    </tr>
                    <tr>
                        <td>ILIMITADO BYD TOTAL</td>
                        <td>ALL RAIN</td>
                        <td>$10.00</td>
                        <td>2/6/2025 1:52:38 PM</td>
                        <td>Card</td>
                    </tr>
                    <tr>
                        <td>Mas MB para tu BYD 4</td>
                        <td>HAN MOTORS</td>
                        <td>$10.00</td>
                        <td>2/6/2025 1:55:30 PM</td>
                        <td>Card</td>
                    </tr>
                    <tr>
                        <td>Mas MB para tu BYD 4</td>
                        <td>HAN MOTORS</td>
                        <td>$10.00</td>
                        <td>2/6/2025 1:55:30 PM</td>
                        <td>Card</td>
                    </tr>
                    <tr>
                        <td>Mas MB para tu BYD 4</td>
                        <td>HAN MOTORS</td>
                        <td>$10.00</td>
                        <td>2/6/2025 1:55:30 PM</td>
                        <td>Card</td>
                    </tr>
                    <tr>
                        <td>Mas MB para tu BYD 4</td>
                        <td>HAN MOTORS</td>
                        <td>$10.00</td>
                        <td>2/6/2025 1:55:30 PM</td>
                        <td>Card</td>
                    </tr>
                    <tr>
                        <td>Mas MB para tu BYD 4</td>
                        <td>HAN MOTORS</td>
                        <td>$10.00</td>
                        <td>2/6/2025 1:55:30 PM</td>
                        <td>Card</td>
                    </tr>
                    <tr>
                        <td>Mas MB para tu BYD 4</td>
                        <td>HAN MOTORS</td>
                        <td>$10.00</td>
                        <td>2/6/2025 1:55:30 PM</td>
                        <td>Card</td>
                    </tr>
                    <tr>
                        <td>Mas MB para tu BYD 4</td>
                        <td>HAN MOTORS</td>
                        <td>$10.00</td>
                        <td>2/6/2025 1:55:30 PM</td>
                        <td>Card</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>
