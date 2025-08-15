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
                            <div class="field-label">Nombre:</div>
                            <div class="field-value">Juan</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Apellido Paterno:</div>
                            <div class="field-value">Pérez</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Apellido Materno:</div>
                            <div class="field-value">Garrido</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Fecha Cumpleaños:</div>
                            <div class="field-value">01/01/1990</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">CURP:</div>
                            <div class="field-value">PEGA900101HDFRRN01</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Teléfono:</div>
                            <div class="field-value">55-1234-5678</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Email:</div>
                            <div class="field-value">juan.perez@correo.com</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Estado:</div>
                            <div class="field-value">CDMX</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Colonia:</div>
                            <div class="field-value">Centro</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Dirección:</div>
                            <div class="field-value">Av. Reforma 123</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Código Postal:</div>
                            <div class="field-value">06000</div>
                        </div>
                    </div>
                </div>

                <!-- Datos fiscales -->
                <div class="card card-section shadow">
                    <div class="card-header">Datos fiscales</div>
                    <div class="card-body">
                        <div class="field-row">
                            <div class="field-label">RFC:</div>
                            <div class="field-value">PEGA900101XXX</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">RFC Facturación:</div>
                            <div class="field-value">PEGA900101XXX</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Nombre Razon Social:</div>
                            <div class="field-value">Juan Pérez S.A.</div>
                        </div>
                        <div class="field-row">
                            <div class="field-label">Régimen Fiscal:</div>
                            <div class="field-value">Persona Física</div>
                        </div>
                    </div>
                </div>

                <div class="footer-text">
                    Para realizar cambios en su perfil, favor de enviar un correo a:<br/>
                    comercial@tecomnet.mx
                </div>

            </div>
        </div>
    </div>
</asp:Content>
