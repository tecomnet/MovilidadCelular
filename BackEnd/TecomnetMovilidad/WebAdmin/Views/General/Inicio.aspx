<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="Inicio.aspx.vb" Inherits="WebAdmin.Inicio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f5f6fa;
        }

        .card {
            border-radius: 12px;
        }

        .card-shadow {
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: 0.3s;
        }

            .card-shadow:hover {
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

        .action-icon {
            cursor: pointer;
            font-size: 1.2rem;
            margin-right: 8px;
        }

            .action-icon.edit {
                color: #0d6efd;
            }

            .action-icon.delete {
                color: #dc3545;
            }

        .btn-add {
            font-weight: bold;
            border-radius: 50px;
            padding: 0.5rem 1.2rem;
        }

        .badge-role {
            font-size: 0.85rem;
            padding: 0.4em 0.7em;
            border-radius: 12px;
        }

        .panel-form {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }

        .card, .panel-form {
            margin-bottom: 2rem;
        }

        .action-icon {
            text-decoration: none !important;
        }

        a.text-primary, a.text-danger {
            text-decoration: none !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="row mb-4">
            <div class="col">
                <h1 class="display-4"><strong>Bienvenido a <span class="text-success">TECOMNET</span></strong></h1>
                <p class="lead"><strong>Tu plataforma para gestionar usuarios, clientes, distribuidores, ofertas y más.</strong></p>
            </div>
        </div>

        <div class="row">
            <!-- Tarjeta de Usuarios -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-people"></i>Usuarios</h5>
                        <p class="card-text">Administra los usuarios del sistema.</p>
                        <a href="<%= ResolveUrl("~/Views/General/AdminUsuarios.aspx") %>" class="btn btn-success">Ir a Usuarios</a>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de Clientes -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-person-vcard"></i>Clientes</h5>
                        <p class="card-text">Gestiona la información de tus clientes.</p>
                        <a href="<%= ResolveUrl("~/Views/General/AdminCliente.aspx") %>" class="btn btn-success">Ir a Clientes</a>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de Distribuidores -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-diagram-3"></i>Distribuidores</h5>
                        <p class="card-text">Controla los distribuidores y sus comisiones.</p>

                        <a href="<%= ResolveUrl("~/Views/General/AdminDistribuidores.aspx") %>" class="btn btn-success">Ir a Distribuidores</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Segunda fila de tarjetas -->
        <div class="row">
            <!-- Tarjeta de Ofertas -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-gift"></i>Ofertas</h5>
                        <p class="card-text">Crea y administra promociones y ofertas.</p>
                        <a href="<%= ResolveUrl("~/Views/General/AdminOfertas.aspx") %>" class="btn btn-success">Ir a Ofertas</a>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de SIMs -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-sim"></i>SIMs</h5>
                        <p class="card-text">Gestiona las tarjetas SIM disponibles.</p>
                        <a href="<%= ResolveUrl("~/Views/General/AdminSIMs.aspx") %>" class="btn btn-success">Ir a SIMs</a>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de Reportes -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-bar-chart-line"></i>Reportes</h5>
                        <p class="card-text">Visualiza reportes y estadísticas.</p>
                        <a href="<%= ResolveUrl("~/Views/General/AdminReportes.aspx") %>" class="btn btn-success">Ir a Reportes</a>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de Portabilidad -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm h-100">
                    <div class="card-body">
                        <h5 class="card-title"><i class="bi bi-arrow-left-right me-2"></i>Portabilidad</h5>
                        <p class="card-text">Controla las portabilidades y estadísticas.</p>
                        <a href="<%= ResolveUrl("~/Views/General/AdminPortabilidad.aspx") %>" class="btn btn-success">Ir a Portabilidad</a>
                    </div>
                </div>
            </div>
        </div>
</asp:Content>
