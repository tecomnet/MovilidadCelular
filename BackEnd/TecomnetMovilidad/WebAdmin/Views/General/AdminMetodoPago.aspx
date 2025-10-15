<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminMetodoPago.aspx.vb" Inherits="WebAdmin.AdminMetodoPago" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="PnlAdminMetodoPago" runat="server" CssClass="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Administración Método De Pago</h2>
        </div>
    </asp:Panel>
    <asp:Panel ID="PnlTabla" runat="server" Visible="true">
        <div class="card card-shadow p-4 mb-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Nombre de Método</th>
                            <th>Descripción</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Pago con tarjeta</td>
                            <td>Pago con tarjeta</td>
                            <td>
                                <asp:LinkButton ID="lnkEditarPagoTarjeta" runat="server" CssClass="action-icon edit" OnClick="lnkEditarPagoTarjeta_Click" ToolTip="Editar método de pago">
            <i class="bi bi-pencil"></i>
                                </asp:LinkButton>
                                <i class="bi bi-person-x-fill action-icon delete" title="Dar de baja usuario"></i>
                            </td>
                        </tr>
                </table>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="PnlEditarMetodoPago" runat="server" Visible="False">
        <div class="card card-shadow p-4 mb-4">
        <h4 class="mb-3">Editar Método de Pago</h4>
        <div class="mb-3">
            <label class="form-label">Método de Pago</label>
            <asp:TextBox ID="txtEditarMetodoPago" runat="server" CssClass="form-control" />
        </div>
        <div class="mb-3">
            <label class="form-label">Descripción</label>
            <asp:TextBox ID="txtEditarDescripcion" runat="server" CssClass="form-control" />
        </div>
    </div>
        <div class="d-flex justify-content-end">
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary me-2" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary" />
        </div>
    </asp:Panel>
</asp:Content>
