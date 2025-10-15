<%@ Page Title="" Language="vb" UnobtrusiveValidationMode="None" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminCliente.aspx.vb" Inherits="WebAdmin.AdminCliente" %>

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
    <asp:Panel ID="pnlAdminCliente" runat="server" CssClass="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Administración de Clientes</h2>
            <asp:Button ID="btnAgregarCliente" runat="server" CssClass="btn btn-success btn-add"
                Text="+ Agregar Cliente" OnClick="btnAgregarCliente_Click" />
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlTabla" runat="server" Visible="True">
        <div style="overflow-x: auto; width: 100%;">
            <div class="card card-shadow p-4 mb-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <asp:GridView ID="gvClientes" runat="server"
                            CssClass="table table-hover align-middle"
                            AutoGenerateColumns="False"
                            HeaderStyle-CssClass="table-dark"
                            ShowHeaderWhenEmpty="True">

                            <Columns>
                                <asp:BoundField DataField="ClienteId" HeaderText="ID" />
                                <asp:TemplateField HeaderText="Nombre Completo">
                                    <ItemTemplate>
                                        <%# Eval("Nombre") & " " & Eval("ApellidoPaterno") & " " & Eval("ApellidoMaterno") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Telefono" HeaderText="Teléfono" />
                                <asp:BoundField DataField="Email" HeaderText="Correo" />
                                <asp:BoundField DataField="FechaAlta" HeaderText="Fecha Alta"
                                    DataFormatString="{0:dd/MM/yyyy}" />
                                <asp:BoundField DataField="Estatus" HeaderText="Estatus" />
                                <asp:TemplateField HeaderText="Acciones">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkEditar" runat="server"
                                            CommandName="EditarCliente"
                                            CommandArgument='<%# Eval("ClienteId") %>'
                                            CssClass="text-primary" ToolTip="Editar">
                                            <i class="bi bi-pencil action-icon edit"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnBaja" runat="server"
                                            CommandName="BajaCliente"
                                            CommandArgument='<%# Eval("ClienteId") %>'
                                            CssClass="action-icon delete"
                                            OnClientClick="return confirm('¿Seguro que deseas dar de baja este cliente?');">
    <i class="bi bi-person-x-fill" title="Dar de baja cliente"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>

    <div class="mb-4 d-flex justify-content-center">
        <asp:Panel ID="PnlBotonDatos" runat="server" Visible="False">
            <asp:Button ID="btnDatosGenerales" runat="server" CssClass="btn btn-primary me-2" Text="Datos Generales" OnClick="btnDatosGenerales_Click" />
            <asp:Button ID="btnDatosFiscales" runat="server" CssClass="btn btn-secondary me-2" Text="Datos Fiscales" OnClick="btnDatosFiscales_Click" />
        </asp:Panel>
        <asp:Panel ID="PnlBotonSIM" runat="server" Visible="False">
            <asp:Button ID="btnAsignarSIM" runat="server" CssClass="btn btn-success" Text="Asignar SIM" OnClick="btnAsignarSIM_Click" />
        </asp:Panel>
    </div>
<asp:Panel ID="pnlAgregar" runat="server" Visible="False">
    <asp:Label ID="lblMensajeGlobal" runat="server" Visible="false" CssClass="alert w-100 d-block mb-3"></asp:Label>
    <asp:HiddenField ID="hdnClienteId" runat="server" />
    <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="alert" />
    <asp:Label ID="lblTitulo" runat="server" CssClass="fs-2 text-dark fw-bold"></asp:Label>

    <asp:Panel ID="pnlSeccionGenerales" runat="server" Visible="True">
        <div class="panel-form">
            <div class="mb-3">
                <label class="form-label">Nombre</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvNombre" runat="server"
                    ControlToValidate="txtNombre" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Apellido Paterno</label>
                <asp:TextBox ID="txtApellidoPaterno" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvApellidoPaterno" runat="server"
                    ControlToValidate="txtApellidoPaterno" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Apellido Materno</label>
                <asp:TextBox ID="txtApellidoMaterno" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Fecha de Nacimiento</label>
                <asp:TextBox ID="txtFechaCumpleanios" runat="server" TextMode="Date" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvFechaNac" runat="server"
                    ControlToValidate="txtFechaCumpleanios" ErrorMessage="Selecciona una fecha" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Tipo de Persona</label>
                <asp:DropDownList ID="ddlTipoPersona" runat="server" CssClass="form-select">
                    <asp:ListItem Text="-- Selecciona --" Value=""></asp:ListItem>
                    <asp:ListItem Text="Física" Value="F"></asp:ListItem>
                    <asp:ListItem Text="Moral" Value="M"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvTipoPersona" runat="server"
                    ControlToValidate="ddlTipoPersona" InitialValue="" ErrorMessage="Selecciona un tipo" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">CURP</label>
                <asp:TextBox ID="txtCURP" runat="server" CssClass="form-control" />
                <asp:RegularExpressionValidator ID="revCURP" runat="server"
                    ControlToValidate="txtCURP"
                    ValidationExpression="^[A-Z]{4}\d{6}[A-Z]{6}\d{2}$"
                    ErrorMessage="CURP no válida" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Teléfono</label>
                <asp:TextBox ID="txtTelefono" runat="server" TextMode="Phone" CssClass="form-control" />
                <asp:RegularExpressionValidator ID="revTelefono" runat="server"
                    ControlToValidate="txtTelefono"
                    ValidationExpression="^[0-9]{10}$"
                    ErrorMessage="Ingresa 10 dígitos" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                    ErrorMessage="Formato de email no válido" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Fecha de Alta</label>
                <asp:TextBox ID="txtFechaAlta" runat="server" TextMode="Date" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvFechaAlta" runat="server"
                    ControlToValidate="txtFechaAlta" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Estatus</label>
                <asp:DropDownList ID="ddlEstatus" runat="server" CssClass="form-select">
                    <asp:ListItem Text="-- Selecciona --" Value=""></asp:ListItem>
                    <asp:ListItem Text="Activo" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Suspendido" Value="2"></asp:ListItem>
                    <asp:ListItem Text="Desactivado" Value="3"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvEstatus" runat="server"
                    ControlToValidate="ddlEstatus" InitialValue="" ErrorMessage="Selecciona un estatus" CssClass="text-danger" Display="Dynamic" />
            </div>
            <asp:Panel ID="pnlPassword" runat="server">
            <div class="mb-3">
                <label class="form-label">Contraseña</label>
                <asp:TextBox ID="tbPassword" runat="server" Width="100%" TextMode="Password" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                    ControlToValidate="tbPassword" ErrorMessage="Requerida" CssClass="text-danger" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revPassword" runat="server"
                    ControlToValidate="tbPassword"
                    ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$"
                    ErrorMessage="* Mínimo 6 caracteres (letras y números)" CssClass="text-danger" Display="Dynamic" />
            </div>
                </asp:Panel>

            <div class="mb-3">
                <label class="form-label">Estado</label>
                <asp:TextBox ID="txtEstado" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Colonia</label>
                <asp:TextBox ID="txtColonia" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Dirección</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Código Postal</label>
                <asp:TextBox ID="txtCP" runat="server" CssClass="form-control" />
                <asp:RegularExpressionValidator ID="revCP" runat="server"
                    ControlToValidate="txtCP" ValidationExpression="^[0-9]{5}$"
                    ErrorMessage="Ingresa un CP válido" CssClass="text-danger" Display="Dynamic" />
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlSeccionFiscales" runat="server" Visible="False">
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h4 class="mb-4">Datos Fiscales</h4>

                <div class="mb-3">
                    <label class="form-label">RFC</label>
                    <asp:TextBox ID="txtRFC" runat="server" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label class="form-label">RFC Facturación</label>
                    <asp:TextBox ID="txtRfcFacturacion" runat="server" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Nombre Razón Social</label>
                    <asp:TextBox ID="txtNombreRazonSocial" runat="server" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label class="form-label">CP Facturación</label>
                    <asp:TextBox ID="txtCPFacturacion" runat="server" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Regimén Fiscal</label>
                    <asp:TextBox ID="txtRegimenFiscal" runat="server" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Uso De Contratante</label>
                    <asp:TextBox ID="txtUsoComprobante" runat="server" CssClass="form-control" />
                </div>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="PnlBotonGuardarCancelar" runat="server" Visible="False">
        <asp:Button ID="btnGuardar" runat="server" Text="Guardar"
            CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary ms-2" />
    </asp:Panel>   
</asp:Panel>
    <asp:Panel ID="PnlAsignarSIM" runat="server" Visible="False">
        <asp:Label ID="lblICCID" runat="server" Visible="false" />
        <asp:Label ID="lblMSISDN" runat="server" Visible="false" />
        <asp:Label ID="lblEstadoSIM" runat="server" Visible="false" />
        <div class="card card-shadow p-4 mb-4">
            <div class="d-flex justify-content-end mb-2">
                <asp:Button ID="BtnNuevaSIM" runat="server" CssClass="btn btn-success btn-sm" Text="+ Asignar Nueva SIM" OnClick="BtnNuevaSIM_Click" />
            </div>
            <h4>SIM CLIENTE</h4>
            <div class="table-responsive mb-3">
                <asp:GridView ID="gvSIMAsignadas" runat="server"
                    CssClass="table table-hover align-middle"
                    AutoGenerateColumns="False"
                    HeaderStyle-CssClass="table-dark"
                    ShowHeaderWhenEmpty="True">
                    <Columns>
                        <asp:BoundField DataField="ICCID" HeaderText="ICCID" />
                        <asp:BoundField DataField="MSISDN" HeaderText="MSISDN" />
                        <asp:BoundField DataField="Estado" HeaderText="Estado" />
                        <asp:BoundField DataField="FechaAsignacion" HeaderText="Fecha Asignacion" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:TemplateField HeaderText="Ver">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkVerDetalle" runat="server"
                                    CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("SIMID") %>'
                                    CssClass="text-primary"
                                    ToolTip="Ver detalles">
                    <i class="bi bi-eye"></i> 
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </asp:Panel>
    <asp:Panel ID="pnlSIMDisponibles" runat="server" Visible="False">
        <div class="card card-shadow p-4 mb-4">
            <h4>SIMs Disponibles</h4>
            <div class="table-responsive">
                <asp:GridView ID="gvSIMDisponibles" runat="server"
                    CssClass="table table-hover align-middle"
                    AutoGenerateColumns="False"
                    HeaderStyle-CssClass="table-dark"
                    ShowHeaderWhenEmpty="True"
                    OnRowCommand="gvSIMDisponibles_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="ICCID" HeaderText="ICCID" />
                        <asp:BoundField DataField="MSISDN" HeaderText="MSISDN" />
                        <asp:BoundField DataField="Estado" HeaderText="Estado" />
                        <asp:TemplateField HeaderText="Ver">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkVerDetalle" runat="server"
                                    CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("SIMID") %>'
                                    CssClass="text-primary"
                                    ToolTip="Ver detalles">
                    <i class="bi bi-eye"></i> 
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkAsignar" runat="server"
                                    CommandName="AsignarSIM"
                                    CommandArgument='<%# Eval("SIMID") %>'
                                    CssClass="btn btn-success btn-sm">
                                Asignar
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </asp:Panel>
    <!-- Modal Detalle SIM -->
    <div class="modal fade" id="modalDetalleSIM" tabindex="-1" aria-labelledby="modalDetalleSIMLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalDetalleSIMLabel">Detalle de la SIM</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label"><strong>ICCID:</strong></label>
                        <span>894400000000000001</span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>MSISDN:</strong></label>
                        <span>5512345678</span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Estado:</strong></label>
                        <span>Disponible</span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Fecha Asignacion:</strong></label>
                        <span>01/09/2025</span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Plan Asignado:</strong></label>
                        <span>Plan Mensual 5GB</span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Observaciones:</strong></label>
                        <span>SIM nueva, lista para asignación.</span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
