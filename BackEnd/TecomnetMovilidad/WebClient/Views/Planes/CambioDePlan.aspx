<%@ Page Title="Actualizar Plan" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="CambioDePlan.aspx.vb" Inherits="WebClient.CambioDePlan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        .container-plan {
            padding: 24px;
            min-height: 80vh;
        }

        .btn-option {
            margin-right: 8px;
            margin-bottom: 8px;
        }

        .plan-card {
            margin: 12px auto;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }

            .plan-card:hover {
                transform: scale(1.02);
            }

        .card-title {
            color: #4ab1e5;
            font-weight: 600;
        }

        .plan-description {
            font-size: 0.95rem;
            color: #555;
        }

        .plan-price {
            font-weight: bold;
            font-size: 1rem;
            margin-top: 4px;
        }

        .container-plan h3,
        .container-plan label,
        .container-plan h5.mb-3 {
            color: #ffffff;
        }

        .containerCar {
            text-align: center;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 1024px;
            margin-top: .3em;
            margin-left: auto;
            margin-right: auto;
        }

        .containerProduct {
            background: #f8f9fa;
            max-width: 1024px;
            margin-left: auto;
            margin-right: auto;
        }

        @media (max-width: 576px) {
            .plan-card {
                width: 100% !important;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="pnlSim" runat="server" Visible="false">
    <div class="container-fluid text-center pt-2 containerTitle">
        <label class="h3 text-white">Selecciona una SIM</label>
    </div>
        <div class="text-center pt-2">
        </div>
        <asp:ListView ID="lvSIMS" runat="server" DataKeyNames="SIMID">
            <ItemTemplate>
                <div class="containerCar container">
                    <div class="row">
                        <div class="col-md-10">
                            <strong>
                                <%# String.Format("{0} - {1} - {2}", Eval("MSISDN"), Eval("ICCID"), Eval("OfertaID")) %>
                            </strong>
                        </div>
                        <div class="text-center col-md-2">
                            <asp:HyperLink ID="hlMore" runat="server" Text="Seleccionar" CssClass="btn btn-primary" NavigateUrl='<%# String.Format("~/Views/Planes/CambioDePlan.aspx?sd={0}&ICCID={1}&oi={2}", Eval("SIMID"), Eval("ICCID"), Eval("OfertaID")) %>'></asp:HyperLink>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:ListView>
    </asp:Panel>
    <asp:Panel ID="pnlPlanes" runat="server" Visible="False">
        <div class="container-fluid text-center pt-2 containerTitle">
    <label class="h3 text-white">Selecciona una oferta</label>
</div>
    <div class="container container-plan">
        <hr />

        <div class="mb-4 text-center">
            <asp:Button ID="btnRecarga" runat="server" CssClass="btn btn-primary btn-option" Text="Recarga" />
            <asp:Button ID="btnPlanMensual" runat="server" CssClass="btn btn-primary btn-option" Text="Plan Mensual" />
            <asp:Button ID="btnPlanAnual" runat="server" CssClass="btn btn-primary btn-option" Text="Plan Anual" />
        </div>

        <h5 class="mb-3">Opciones disponibles (Recarga)</h5>

        <asp:ListView ID="lvCambioPlan" runat="server" DataKeyNames="OfertaID">
            <LayoutTemplate>
                <div class="row">
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                </div>
            </LayoutTemplate>

            <ItemTemplate>
                <div class="col-12 col-md-6 col-lg-4">
                    <div class="card plan-card shadow">
                        <div class="card-body text-center">
                            <h5 class="card-title"><%# Eval("Oferta") %></h5>
                            <p class="plan-description"><%# Eval("Descripcion") %></p>
                            <p class="plan-price"><%# If(Eval("Tipo") IsNot Nothing, [Enum].GetName(GetType(Models.TECOMNET.Enumeraciones.TipoServicio), CInt(Eval("Tipo"))), "N/A") %></p>
                            <asp:Button ID="btnLoQuiero" runat="server" CssClass="btn btn-success mt-2" Text="Lo quiero" CommandArgument='<%# Eval("OfertaID") %>' OnClick="btnLoQuiero_Click" />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:ListView>
    </div>
        </asp:Panel>
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

