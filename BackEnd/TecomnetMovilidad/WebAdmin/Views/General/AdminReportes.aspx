<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminReportes.aspx.vb" Inherits="WebAdmin.AdminReportes" %>

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
<div class="container-fluid">
    <h2 class="mb-4">Reportes</h2>

    <div class="row g-4">
        <!-- SIMs -->
        <div class="col-md-4">
            <div class="card card-shadow text-center p-3 h-100">
                <div class="card-body">
                    <i class="bi bi-sim display-4 mb-2 text-primary"></i>
                    <h5 class="card-title">SIMs</h5>
                    <p class="card-text">Total Activas: 25 <br /> Total Suspendidas: 5</p>
                    <a href="#reporte-sims" class="btn btn-primary w-100" data-bs-toggle="modal">Ver detalle</a>
                </div>
            </div>
        </div>

        <!-- Clientes -->
        <div class="col-md-4">
            <div class="card card-shadow text-center p-3 h-100">
                <div class="card-body">
                    <i class="bi bi-person-vcard display-4 mb-2 text-success"></i>
                    <h5 class="card-title">Clientes</h5>
                    <p class="card-text">Total Activos: 40 <br /> Total Inactivos: 10</p>
                    <a href="#reporte-clientes" class="btn btn-success w-100" data-bs-toggle="modal">Ver detalle</a>
                </div>
            </div>
        </div>

        <!-- Distribuidores -->
        <div class="col-md-4">
            <div class="card card-shadow text-center p-3 h-100">
                <div class="card-body">
                    <i class="bi bi-diagram-3 display-4 mb-2 text-warning"></i>
                    <h5 class="card-title">Distribuidores</h5>
                    <p class="card-text">Total Activos: 15 <br /> Total Inactivos: 2</p>
                    <a href="#reporte-distribuidores" class="btn btn-warning w-100" data-bs-toggle="modal">Ver detalle</a>
                </div>
            </div>
        </div>
    </div>
</div>

</asp:Content>
