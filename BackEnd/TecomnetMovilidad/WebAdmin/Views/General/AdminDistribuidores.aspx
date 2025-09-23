<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminDistribuidores.aspx.vb" Inherits="WebAdmin.AdminDistribuidores" %>
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
     <asp:Panel ID="pnlAdminDistribuidores" runat="server" CssClass="container mt-5">

     <div class="d-flex justify-content-between align-items-center mb-4">
         <h2>Administración de Distribuidores</h2>
         <asp:Button ID="btnAgregarDistribuidor" runat="server" CssClass="btn btn-success btn-add" 
                     Text="+ Agregar Distribuidor" OnClick="btnAgregarDistribuidor_Click" />
     </div>

 </asp:Panel>

 <asp:Panel ID="pnlTabla" runat="server" Visible="True">
     <div class="card card-shadow p-4 mb-4">
         <div class="table-responsive">
             <table class="table table-hover align-middle">
                 <thead class="table-dark">
                     <tr>
                         <th>Región</th><th>Nombre</th><th>Dirección</th><th>RFC</th><th>Tipo De Persona</th>
                         <th>Nombre</th><th>Número Télefono</th><th>Correo</th><th>Beneficiario</th><th>Acciones</th>
                     </tr>
                 </thead>
                 <tbody>
                     <tr>
                          <td>1</td><td>TECOMNET</td><td>Las Palmas</td> <td>ECGERTQ23H1</td> <td>Fisica</td> <td>Juan Pérez</td> <td>7641041987</td><td>juan@mail.com</td><td>TECOMNET</td>                   
                         <td>
                             <i class="bi bi-pencil action-icon edit" title="Editar distribuidor"></i>
                             <i class="bi bi-person-x-fill action-icon delete" title="Dar de baja distribuidor"></i>
                         </td>
                     </tr>
                     <tr>
                     <td>2</td><td>TECOMNET</td><td>Las Palmas</td> <td>ECGERTQ23H1</td> <td>Fisica</td> <td>Maria Pérez</td> <td>7641041987</td><td>maria@mail.com</td><td>TECOMNET</td>                    
                         <td>
                             <i class="bi bi-pencil action-icon edit" title="Editar distribuidor"></i>
                             <i class="bi bi-person-x-fill action-icon delete" title="Dar de baja distribuidor"></i>
                         </td>
                     </tr>
                 </tbody>
             </table>
         </div>
     </div>
 </asp:Panel>

<asp:Panel ID="pnlAgregar" runat="server" Visible="False">

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <h4 class="mb-4">Datos Generales</h4>

            <div class="mb-3">
                <label class="form-label">Región</label>
                <asp:TextBox ID="txtRegion" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Nombre</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Dirección</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Nombre Contacto</label>
                <asp:TextBox ID="txtNombreContacto" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Teléfono Contacto</label>
                <asp:TextBox ID="txtTelefonoContacto" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Correo</label>
                <asp:TextBox ID="txtEmailContacto" runat="server" TextMode="Email" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Fecha de Alta</label>
                <asp:TextBox ID="txtFechaAlta" runat="server" TextMode="Date" CssClass="form-control" />
            </div>
        </div>
    </div>

    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <h4 class="mb-4">Datos Fiscales</h4>

            <div class="mb-3">
                <label class="form-label">RFC</label>
                <asp:TextBox ID="txtRFC" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Tipo de Persona</label>
                <asp:DropDownList ID="ddlTipoPersona" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Física" Value="Fisica"></asp:ListItem>
                    <asp:ListItem Text="Moral" Value="Moral"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="mb-3">
                <label class="form-label">Dirección Fiscal</label>
                <asp:TextBox ID="txtDireccionFiscal" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Porcentaje Comisión</label>
                <asp:TextBox ID="txtPorcentajeComision" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Banco</label>
                <asp:TextBox ID="txtBanco" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Cuenta</label>
                <asp:TextBox ID="txtCuenta" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Beneficiario</label>
                <asp:TextBox ID="txtBeneficiario" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Tipo Distribuidor</label>
                <asp:DropDownList ID="ddlTipoDistribuidor" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Consumidor Final" Value="ConsumidorFinal"></asp:ListItem>
                    <asp:ListItem Text="Mayorista" Value="Mayorista"></asp:ListItem>
                    <asp:ListItem Text="Minorista" Value="Minorista"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>
    </div>

    <div class="mt-3">
        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" />
        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary ms-2" />
    </div>

</asp:Panel>
</asp:Content>
