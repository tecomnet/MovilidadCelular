<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminTickets.aspx.vb" Inherits="WebAdmin.AdminTickets" %>
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
    <asp:Panel ID="PnlTickets" runat="server" Visible="True" CssClass="container mt-4">
    <div class="card card-shadow p-4 mb-4">
        <h4 class="mb-3">Administración de Tickets</h4>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-dark">
                    <tr>
                        <th># Ticket</th>
                        <th>Cliente</th>
                        <th>Asunto</th>
                        <th>Estado</th>
                        <th>Fecha</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>001</td>
                        <td>Juan Pérez</td>
                        <td>No funciona el sistema</td>
                        <td><span class="badge bg-warning">Abierto</span></td>
                        <td>26/09/2025</td>
                        <td>
                            <i class="bi bi-eye action-icon text-primary" title="Ver detalles"></i>
                            <i class="bi bi-pencil action-icon text-success" title="Editar ticket"></i>
                            <i class="bi bi-x-circle action-icon text-danger" title="Cerrar ticket"></i>
                        </td>
                    </tr>
                    <tr>
                        <td>002</td>
                        <td>María López</td>
                        <td>Solicitud de reporte</td>
                        <td><span class="badge bg-success">Cerrado</span></td>
                        <td>25/09/2025</td>
                        <td>
                            <i class="bi bi-eye action-icon text-primary" title="Ver detalles"></i>
                            <i class="bi bi-pencil action-icon text-success" title="Editar ticket"></i>
                            <i class="bi bi-x-circle action-icon text-danger" title="Cerrar ticket"></i>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</asp:Panel>
    <asp:Panel ID="PnlEditarTicket" runat="server" Visible="False" CssClass="container mt-4">
    <div class="card card-shadow p-4 mb-4">
        <h4 class="mb-3">Editar Ticket</h4>
        <div class="mb-3">
            <label class="form-label">Cliente</label>
            <asp:TextBox ID="txtCliente" runat="server" CssClass="form-control" />
        </div>
        <div class="mb-3">
            <label class="form-label">Asunto</label>
            <asp:TextBox ID="txtAsunto" runat="server" CssClass="form-control" />
        </div>
        <div class="mb-3">
            <label class="form-label">Estado</label>
            <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                <asp:ListItem Text="Abierto" Value="Abierto" />
                <asp:ListItem Text="En proceso" Value="EnProceso" />
                <asp:ListItem Text="Cerrado" Value="Cerrado" />
            </asp:DropDownList>
        </div>
        <div class="mb-3">
            <label class="form-label">Descripción</label>
            <asp:TextBox ID="txtDescripcion" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" />
        </div>
        <div class="d-flex justify-content-end">
            <asp:Button ID="btnGuardarTicket" runat="server" Text="Guardar" CssClass="btn btn-primary me-2" />
            <asp:Button ID="btnCancelarTicket" runat="server" Text="Cancelar" CssClass="btn btn-secondary" />
        </div>
    </div>
</asp:Panel>


</asp:Content>
