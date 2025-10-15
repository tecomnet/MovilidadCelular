<%@ Page Title="" Language="vb" UnobtrusiveValidationMode="None" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminUsuarios.aspx.vb" Inherits="WebAdmin.AdminUsuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
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

    <asp:Panel ID="pnlAdminUsuarios" runat="server" CssClass="container mt-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Administración de Usuarios</h2>
            <asp:Button ID="btnAgregarUsuario" runat="server" CssClass="btn btn-success btn-add"
                Text="+ Agregar Usuario" OnClick="btnAgregarUsuario_Click" />
        </div>

    </asp:Panel>

    <asp:Panel ID="pnlTabla" runat="server" Visible="True">
        <div style="overflow-x: auto; width: 100%;">
            <asp:GridView ID="gvUsuarios" runat="server" CssClass="table table-hover align-middle"
                AutoGenerateColumns="False" DataKeyNames="UsuarioID">
                <Columns>
                    <asp:BoundField DataField="UsuarioID" HeaderText="ID" />
                    <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                    <asp:BoundField DataField="Email" HeaderText="Correo" />
                    <asp:BoundField DataField="NumeroTelefono" HeaderText="Número de Teléfono" />
                    <asp:BoundField DataField="TipoUsuario" HeaderText="Tipo Usuario" />
                    <asp:BoundField DataField="FechaAlta" HeaderText="Fecha Alta" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="UltimoLogin" HeaderText="Último inicio de sesión" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="FechaUltimaActualizacion" HeaderText="Fecha última actualización" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="fechaBaja" HeaderText="Fecha Baja" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEditarUsuario" runat="server"
                                CssClass="bi bi-pencil action-icon edit"
                                CommandName="EditarUsuario"
                                CommandArgument='<%# Eval("UsuarioID") %>'
                                ToolTip="Editar Usuario" />
                            <asp:LinkButton ID="btnBajaUsuario" runat="server"
                                CssClass="bi bi-person-x-fill action-icon delete"
                                CommandName="BajaUsuario"
                                CommandArgument='<%# Eval("UsuarioID") %>'
                                OnClientClick="return confirm('¿Seguro que deseas dar de baja este cliente?');"
                                ToolTip="Dar de baja usuario" />

                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlAgregar" runat="server" Visible="False">
        <asp:Label ID="lblTitulo" runat="server" CssClass="fs-2 text-dark fw-bold"></asp:Label>
        <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="alert" />
        <asp:HiddenField ID="hdnUsuarioID" runat="server" />
        <div class="panel-form">
            <div class="mb-3">
                <label class="form-label">Usuario</label>
                <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvNombreUsuario" runat="server"
                    ControlToValidate="txtNombreUsuario"
                    ErrorMessage="El Nombre de Usuario es obligatorio."
                    ForeColor="Red" Display="Dynamic" />
            </div>
            <div class="mb-3">
                <label class="form-label">Nombre</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvNombre" runat="server"
                    ControlToValidate="txtNombre"
                    ErrorMessage="El Nombre es obligatorio."
                    ForeColor="Red" Display="Dynamic" />
            </div>
            <div class="mb-3">
                <label class="form-label">Correo</label>
                <asp:TextBox ID="txtCorreo" runat="server" TextMode="Email" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvCorreo" runat="server"
                    ControlToValidate="txtCorreo"
                    ErrorMessage="El Correo es obligatorio."
                    ForeColor="Red" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revCorreo" runat="server"
                    ControlToValidate="txtCorreo"
                    ErrorMessage="Ingrese un correo válido."
                    ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
                    ForeColor="Red" Display="Dynamic" />
           <div class="row mb-3">
                </div>
            <div class="col-md-2">
                Contraseña:

            </div>
            <div class="col-md-">
                <asp:TextBox ID="tbPassword" runat="server" TextMode="Password" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvContrasena" runat="server"
                    ControlToValidate="tbPassword"
                    ErrorMessage="La contraseña es obligatoria."
                    ForeColor="Red" Display="Dynamic" />
            </div>
            </div>
            <div class="mb-3">
                <label class="form-label">Número de Télefono</label>
                <asp:TextBox ID="txtTelefono" runat="server" TextMode="Phone" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvTelefono" runat="server"
                    ControlToValidate="txtTelefono"
                    ErrorMessage="El número de teléfono es obligatorio."
                    ForeColor="Red" Display="Dynamic" />
            </div>
            <div class="mb-3">
                <label class="form-label">Tipo de Usuario</label>
                <asp:DropDownList ID="ddlTipoPersona" runat="server" CssClass="form-select">
                    <asp:ListItem Text="-- Selecciona un opción --" Value="0" />
                    <asp:ListItem Text="Administrator" Value="Administrator"></asp:ListItem>
                    <asp:ListItem Text="Soporte" Value="Soporte"></asp:ListItem>
                    <asp:ListItem Text="Distribuidor" Value="Distribuidor"></asp:ListItem>
                    <asp:ListItem Text="Recargas" Value="Recargas"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvTipoUsuario" runat="server"
                    ControlToValidate="ddlTipoPersona" InitialValue="0"
                    ErrorMessage="Debe seleccionar una opción."
                    ForeColor="Red" Display="Dynamic" />
            </div>
            <div class="mb-3">
                <label class="form-label">Fecha de Alta</label>
                <asp:TextBox ID="txtFechaAlta" runat="server" TextMode="Date" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvFecchaAlta" runat="server"
                    ControlToValidate="txtFechaAlta"
                    ErrorMessage="La fecha es obligatoria."
                    ForeColor="Red" Display="Dynamic" />
            </div>
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary ms-2" />
        </div>
    </asp:Panel>

</asp:Content>
