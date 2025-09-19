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
            display: grid;       
            place-items: center;
            background: #e5e5e5; 
            transition: background 0.5s ease;
            margin: 0 auto; 
        }

        .circle-inner {
            width: 120px;   
            height: 120px;
            border-radius: 50%;
            background: #fff;  
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            margin: 0 auto; 
        }

        .footer-text {
            font-size: 14px;
            font-style: italic;
            color: white;
        }

        .card-body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .mt-3 {
            margin-top: 1rem !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container my-4">
        <div class="card text-center mx-auto mt-3" style="max-width: 600px; background-color: #0056b3;">
            <div class="card-body text-white">
                <asp:Label CssClass="card-title" runat="server" Text="Hola Escandón Cruz Enrique"></asp:Label>
            </div>
        </div>

        <asp:ListView ID="lvPaquetes" runat="server" DataKeyNames="SIMID, ICCID, OfertaID, MSISDN">
            <ItemTemplate>
                <div class="card mx-auto mt-4" style="max-width: 600px;">
                    <div class="card-body text-center">
                        <asp:Label CssClass="card-title" ForeColor="Black" runat="server" Text='<%# String.Format("{0} - {1}", Eval("Oferta"), Eval("Descripcion")) %>'></asp:Label>

                        <div class="percent-circle mt-3"
                            style='<%# "background: conic-gradient(#0078D7 0% " & 
                                    (Convert.ToDouble(Eval("MBUsados")) / Convert.ToDouble(Eval("MBAsignados")) * 100).ToString("0") & 
                                    "%, #e5e5e5 " & (Convert.ToDouble(Eval("MBUsados")) / Convert.ToDouble(Eval("MBAsignados")) * 100).ToString("0") & "% 100%)" %>'>
                            <div class="circle-inner">
                                <div><i class="bi bi-globe" style="font-size: 26px; color: #0078D7;"></i></div>
                                <small style="color: gray;">Ha consumido</small>
                                <div style="color: #0078D7; font-size: 18px; font-weight: bold;">
                                    <%# (Convert.ToDouble(Eval("MBUsados")) / 1024).ToString("0.00") %> GB
                                </div>
                                <small>de <%# (Convert.ToDouble(Eval("MBAsignados")) / 1024).ToString("0.00") %> GB</small>
                            </div>
                        </div>

                        <asp:Label runat="server" CssClass="mt-3" 
                            Text='<%# "Vigencia: " & Convert.ToDateTime(Eval("FechaVencimiento")).ToString("yyyy-MM-dd") %>'></asp:Label>

                        <div class="row mt-2">
                            <div class="col">
                                <b>
                                    <%# (Convert.ToDouble(Eval("MBUsados")) / Convert.ToDouble(Eval("MBAsignados")) * 100).ToString("0") %>%
                                </b>
                                <br />Consumido
                            </div>
                            <div class="col">
                                <b>
                                    <%# (Convert.ToDouble(Eval("MBDisponibles")) / 1024).ToString("0.00") %> GB
                                </b>
                                <br />Disponible
                            </div>
                        </div>

                        <div class="mt-4">
                            <asp:LinkButton ID="btnRenovar" runat="server" Text="Renovar Plan" CssClass="btn btn-primary" CommandName="Renovar" CommandArgument='<%# Container.DataItemIndex %>'> </asp:LinkButton>
                            <asp:HyperLink ID="hlRecargarSaldo" runat="server" Text="Recarga" CssClass="btn btn-primary" NavigateUrl='<%# String.Format("~/Views/General/Menu.aspx?OI={0}&ICCID={1}&MSISDN={2}", Eval("OfertaID"), Eval("ICCID"), Eval("MSISDN")) %>'></asp:HyperLink>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:ListView>
    </div>

    <asp:Panel ID="pnlPago" runat="server" Visible="False">
        <div class="modal fade" id="modalPago" tabindex="-1" aria-labelledby="modalPagoLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalPagoLabel">Renovar Plan</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>
                    <div class="modal-body">
                        <iframe id="iframePago" runat="server" style="width: 100%; height: 400px; border: none;"></iframe>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <script type="text/javascript">
        function abrirModal() {
            var myModal = new bootstrap.Modal(document.getElementById('modalPago'));
            myModal.show();
        }
    </script>
</asp:Content>

