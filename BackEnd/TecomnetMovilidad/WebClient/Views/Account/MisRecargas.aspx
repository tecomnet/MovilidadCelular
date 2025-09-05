<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="MisRecargas.aspx.vb" Inherits="WebClient.MisRecargas" culture="es-MX" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(to bottom, #145991, #0a3472);
        }
        .container-recargas {
            padding: 20px;
        }
        .card-custom {
            background-color: rgba(255,255,255,0.95);
            border-radius: 16px;
            padding: 20px;
            margin: 20px auto;
            max-width: 1000px;
            box-shadow: 0 8px 15px rgba(0,0,0,0.3);
        }
        .header-card {
            background-color: #145991;
            color: white;
            font-weight: bold;
            text-align: center;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .grid-card {
            max-height: 400px;
            overflow: auto;
        }
        .footer-text {
            text-align: center;
            font-size: 14px;
            font-weight: bold;
            color: white;
            margin-top: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-recargas">
        <div class="card card-custom">
            <div class="header-card">Consulta tus recargas</div>
            <asp:Panel ID="pnlRecargas" runat="server">
                <asp:Label ID="lblNoRecargas" runat="server" CssClass="text-center d-block mb-3" 
                           Text="Aún no hay recargas disponibles" Visible="False"></asp:Label>
                <div class="grid-card table-responsive">
                    <asp:GridView ID="gvRecargas" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered table-striped"
                        EmptyDataText="No hay recargas disponibles">
                        <Columns>
                            <asp:BoundField HeaderText="Oferta" DataField="Oferta" />
                            <asp:BoundField HeaderText="MSISDN" DataField="MSISDN" />
                            <asp:BoundField HeaderText="Total" DataField="Total" DataFormatString="{0:C}" />
                            <asp:BoundField HeaderText="Fecha" DataField="FechaRecarga" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                            <asp:BoundField HeaderText="Método de pago" DataField="NombreMetodo" />
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>
            </div>
    </div>
</asp:Content>
