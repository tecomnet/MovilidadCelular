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

        @media (max-width: 576px) {
            .plan-card {
                width: 100% !important;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
                            <p class="plan-price">$<%# Eval("PrecioMensual") %></p>
                            <asp:Button ID="btnLoQuiero" runat="server" CssClass="btn btn-success mt-2" Text="Lo quiero" CommandArgument='<%# Eval("OfertaID") %>' />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:ListView>
    </div>
</asp:Content>

