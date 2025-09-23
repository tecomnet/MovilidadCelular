<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminUsuarios.aspx.vb" Inherits="WebAdmin.AdminUsuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <style>
        body { background-color: #f5f6fa; }
        .card { border-radius: 12px; }
        .card-shadow { box-shadow: 0 4px 20px rgba(0,0,0,0.08); transition: 0.3s; }
        .card-shadow:hover { box-shadow: 0 8px 25px rgba(0,0,0,0.15); }
        .action-icon { cursor: pointer; font-size: 1.2rem; margin-right: 8px; }
        .action-icon.edit { color: #0d6efd; }
        .action-icon.delete { color: #dc3545; }
        .btn-add { font-weight: bold; border-radius: 50px; padding: 0.5rem 1.2rem; }
        .badge-role { font-size: 0.85rem; padding: 0.4em 0.7em; border-radius: 12px; }
        .panel-form { background-color: #ffffff; border-radius: 12px; padding: 2rem; box-shadow: 0 6px 20px rgba(0,0,0,0.1); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:Panel ID="pnlAdminUsuarios" runat="server" CssClass="container mt-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Administración de Usuarios</h2>
            <asp:Button ID="btnAgregarUsuario" runat="server" CssClass="btn btn-success btn-add" 
                        Text="+ Agregar Usuario" OnClick="btnAgregarUsuario_Click" />
        </div>

    </asp:Panel>

    <asp:Panel ID="pnlTabla" runat="server" Visible="True">
        <div class="card card-shadow p-4 mb-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>Usuario</th><th>Nombre</th><th>Correo</th><th>Número de Télefono</th>
                            <th>Tipo Usuario</th><th>Fecha Alta</th><th>Último inicio de sesión</th><th>Fecha última actualización</th><th>Fecha Baja</th><th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>JuanPG</td><td>Juan Pérez</td><td>juan@mail.com</td><td>7641041987</td>
                            <td>Administrador</td><td>22/09/2025</td><td>22/09/2025</td><td>22/09/2025</td><td>-----</td>
                            <td>
                                <i class="bi bi-pencil action-icon edit" title="Editar usuario"></i>
                                <i class="bi bi-person-x-fill action-icon delete" title="Dar de baja usuario"></i>
                            </td>
                        </tr>
                        <tr>
                            <td>MariaGC</td><td>María Gómez</td><td>maria@mail.com</td><td>7641041987</td>
                            <td>Soporte</td><td>22/09/2025</td><td>22/09/2025</td><td>22/09/2025</td><td>-----</td>
                            <td>
                                <i class="bi bi-pencil action-icon edit" title="Editar usuario"></i>
                                <i class="bi bi-person-x-fill action-icon delete" title="Dar de baja usuario"></i>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlAgregar" runat="server" Visible="False">
        <div class="panel-form">
            <h4 class="mb-4">Agregar Usuario</h4>
            <div class="mb-3">
                <label class="form-label">Usuario</label>
                <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control" />
            </div>
            <div class="mb-3">
                <label class="form-label">Nombre</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
            </div>
            <div class="mb-3">
                <label class="form-label">Correo</label>
                <asp:TextBox ID="txtCorreo" runat="server" TextMode="Email" CssClass="form-control" />
            </div>           
            <div class="mb-3">
                <label class="form-label">Número de Télefono</label>
                <asp:TextBox ID="txtTélefono" runat="server" TextMode="Phone" CssClass="form-control" />
            </div>
             <div class="mb-3">
                 <label class="form-label">Tipo de Usario</label>
                 <asp:DropDownList ID="ddlTipoPersona" runat="server" CssClass="form-select">
                     <asp:ListItem Text="Administrator" Value="Administrator"></asp:ListItem>
                     <asp:ListItem Text="Soporte" Value="Soporte"></asp:ListItem>
                     <asp:ListItem Text="Distribuidor" Value="Distribuidor"></asp:ListItem>
                     <asp:ListItem Text="Recargas" Value="Recargas"></asp:ListItem>
                 </asp:DropDownList>
             </div>
            <div class="mb-3">
                <label class="form-label">Fecha de Alta</label>
                <asp:TextBox ID="txtFechaAlta" runat="server" TextMode="Date" CssClass="form-control" />
            </div>
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary ms-2" />
        </div>
    </asp:Panel>

</asp:Content>
