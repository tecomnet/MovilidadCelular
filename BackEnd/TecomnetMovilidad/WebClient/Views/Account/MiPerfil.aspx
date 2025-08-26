<%@ Page Title="Mi Perfil" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="MiPerfil.aspx.vb" Inherits="WebClient.MiPerfil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="../../Css/bootstrap.css" />
    <script src="../../Scripts/js/bootstrap.js"></script>
    <style>
        /* Contenedor principal sin fondo, responsive */
        .container-perfil {
            padding: 24px;
        }

        /* Tarjetas */
        .card-section {
            margin-bottom: 20px;
            border-radius: 16px;
            width: 100%;
        }

            .card-section .card-header {
                background-color: #1976d2;
                color: white;
                font-weight: 600;
                font-size: 1.2rem;
                text-align: center;
            }

        /* Campos flexibles */
        .field-row {
            display: flex;
            flex-wrap: wrap;
            padding: 8px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .field-label {
            flex: 1 1 40%;
            font-weight: bold;
            color: #000;
            min-width: 150px;
        }

        .field-value {
            flex: 1 1 60%;
            color: #000;
            min-width: 150px;
        }

        /* Footer */
        .footer-text {
            color: #666;
            text-align: center;
            margin-top: 24px;
            font-size: 0.9rem;
        }

        @media (max-width: 576px) {
            .field-row {
                flex-direction: column;
            }

            .field-label, .field-value {
                flex: 1 1 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid container-perfil">
        <div class="row justify-content-center">
            <div class="col-12 col-md-10 col-lg-8">

                <div class="card card-section shadow">
                    <div class="card-header">Mis datos personales</div>
                    <div class="card-body">
                        <div class="field-row">
                            <span class="field-label">Nombre:</span>
                            <asp:Label CssClass="field-value" runat="server" ID="lblNombre"></asp:Label>
                        </div>
                        <div class="field-row">
                            <span class="field-label">Apellido Paterno:</span>
                            <asp:Label CssClass="field-value" runat="server" ID="lblApellidoP"></asp:Label>
                        </div>
                        <div class="field-row">
                            <span class="field-label">Apellido Materno:</span>
                            <asp:Label CssClass="field-value" ID="lblApellidoM" runat="server" ></asp:Label>
                        </div>
                        <div class="field-row">
                            <span class="field-label">Fecha Cumpleaños:</span>
                            <asp:Label CssClass="field-value" ID="lblFechaCumpleanios" runat="server"></asp:Label>
                        </div>
                        <div class="field-row">
                            <span class="field-label">CURP:</span>
                            <asp:Label CssClass="field-value" ID="lblCurp" runat="server"></asp:Label>
                        </div>
                        <div class="field-row">
                            <span class="field-label">Teléfono:</span>
                            <asp:Label CssClass="field-value" ID="lblTelefono" runat="server"></asp:Label>
                        </div>
                        <div class="field-row">
                            <span Class="field-label">Email:</span>
                            <asp:Label CssClass="field-value" ID="lblEmail" runat="server"></asp:Label>
                        </div>
                        <div class="field-row">
                            <asp class="field-label">Estado:</asp>
                            <asp:Label CssClass="field-value" ID="lblEstado" runat="server"></asp:Label>
                        </div>
                        <div class="field-row">
                            <asp class="field-label">Colonia:</asp>
                            <asp:Label CssClass="field-value" ID="lblColonia" runat="server"></asp:Label>
                        </div>
                        <div class="field-row">
                            <asp class="field-label">Dirección:</asp>
                            <asp:Label CssClass="field-value" ID="lblDireccion" runat="server"></asp:Label>
                        </div>
                        <div class="field-row">
                            <asp class="field-label">Código Postal:</asp>
                            <asp:Label CssClass="field-value" ID="lblCP" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>

                <!-- Datos fiscales -->
                <div class="card card-section shadow">
                    <asp CssClass="card-header">Datos fiscales</asp>
                    <div class="card-body">
                        <div class="field-row">
                            <asp class="field-label">RFC:</asp>
                            <asp:Label CssClass="field-value" ID="lblRFC" runat="server"></asp:Label>
                        </div>
                        <div class="field-row">
                            <asp class="field-label">RFC Facturación:</asp>
                            <asp:Label CssClass="field-value" ID="lblRFCFacturacion" runat="server"></asp:Label>
                        </div>
                        <div class="field-row">
                            <asp class="field-label">Nombre Razon Social:</asp>
                            <asp:Label CssClass="field-value" ID="lblRazonSocial" runat="server"></asp:Label>
                        </div>
                        <div class="field-row">
                            <asp class="field-label">Régimen Fiscal:</asp>
                            <asp:Label CssClass="field-value" ID="lblRegimenFiscal" runat="server"></asp:Label>
                        </div>
                    </div>
                </div>

                <div class="footer-text">
                    Para realizar cambios en su perfil, favor de enviar un correo a:<br />
                    comercial@tecomnet.mx
                </div>

            </div>
        </div>
    </div>
</asp:Content>
