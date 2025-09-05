<%@ Page Title="Menú" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="Menu.aspx.vb" Inherits="WebClient.Menu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        .container-menu {
            padding: 24px;
            min-height: 80vh;
        }

        .card-oferta {
            background-color: #fff;
            margin: 12px auto;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.2s;
            overflow: hidden;
        }

        .card-oferta:hover {
            transform: scale(1.02);
        }

        .card-header-oferta {
            background-color: #1d6f4b;
            color: #fff;
            font-weight: bold;
            text-align: center;
            padding: 10px;
            font-size: 18px;
        }

        .card-body-oferta {
            padding: 15px;
            color: #000;
            line-height: 1.6;
        }

        .btn-primary-oferta {
            background-color: #0d6efd;
            color: #fff;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }

        .btn-primary-oferta:hover {
            background-color: #0b5ed7;
        }

        p {
            margin: 5px 0;
        }

        @media (max-width: 576px) {
            .card-oferta {
                width: 100% !important;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container container-menu">
        <asp:ListView ID="lvMenu" runat="server" DataKeyNames="OfertaID, PrecioRecurrente">
            <LayoutTemplate>
                <div class="row">
                    <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                </div>
            </LayoutTemplate>

            <ItemTemplate>
                <div class="col-12 col-md-6 col-lg-4">
                    <div class="card-oferta shadow">
                        <div class="card-header-oferta">
                            <asp:Label ID="lblOferta" runat="server" Text='<%# Eval("Oferta") %>'></asp:Label>
                        </div>
                        <div class="card-body-oferta">
                            <p><strong>Descripción:</strong> <asp:Label ID="lblDescripcion" runat="server" Text='<%# Eval("Descripcion") %>'></asp:Label></p>
                            <p><strong>Minutos:</strong> <asp:Label ID="lblMinutos" runat="server" Text='<%# Eval("Minutos") %>'></asp:Label></p>
                            <p><strong>SMS:</strong> <asp:Label ID="lblSms" runat="server" Text='<%# Eval("Sms") %>'></asp:Label></p>
                            <p><strong>Datos MB:</strong> <asp:Label ID="lblDatos" runat="server" Text='<%# Eval("DatosMB") %>'></asp:Label></p>
                            <p><strong>Precio Recurrente:</strong> $<asp:Label ID="lblPrecio" runat="server" Text='<%# Eval("PrecioRecurrente") %>'></asp:Label> MXN</p>
                            <p><strong>Validez:</strong> <asp:Label ID="lblValidez" runat="server" Text='<%# Eval("ValidezDias") %>'></asp:Label> días</p>
                            <div class="text-center mt-2">
                                <asp:Button ID="btnLoQuiero" runat="server" CssClass="btn-primary-oferta" Text="Lo quiero" OnClick="btnLoQuiero_Click" CommandArgument='<%# Eval("OfertaID") %>' />
                            </div>
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
                    <iframe id="iframePago" runat="server" style="width:100%; height:400px; border:none;"></iframe>
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
