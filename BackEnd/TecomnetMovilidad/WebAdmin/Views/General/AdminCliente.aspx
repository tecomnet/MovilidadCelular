<%@ Page Title="" Language="vb" UnobtrusiveValidationMode="None" AutoEventWireup="true" MasterPageFile="~/Default.Master" CodeBehind="AdminCliente.aspx.vb" Inherits="WebAdmin.AdminCliente" Culture="es-MX" %>

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

        .hidden {
            display: none !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="pnlAdminCliente" runat="server" CssClass="container mt-3">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Administración de Clientes</h2>
            <asp:Button ID="btnAgregarCliente" runat="server" CssClass="btn btn-success btn-add"
                Text="+ Agregar Cliente" OnClick="btnAgregarCliente_Click" />
        </div>
        <div class="mb-4">
            <asp:TextBox ID="txtBuscarClientes" runat="server" CssClass="form-control"
                placeholder="🔍 Buscar clientes..." AutoPostBack="true"
                OnTextChanged="txtBuscarClientes_TextChanged"
                onkeyup="iniciarBusqueda();">
            </asp:TextBox>
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

    <div class="mb-4 d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center">
            <asp:Panel ID="PnlBotonDatos" runat="server" Visible="False" CssClass="me-2">
                <asp:Button ID="btnDatosGenerales" runat="server" CssClass="btn btn-primary me-2" Text="Datos Generales" OnClick="btnDatosGenerales_Click" />
                <asp:Button ID="btnDatosFiscales" runat="server" CssClass="btn btn-secondary me-2" Text="Datos Fiscales" OnClick="btnDatosFiscales_Click" />
            </asp:Panel>

            <asp:Panel ID="PnlBotonSIM" runat="server" Visible="False">
                <asp:Button ID="btnAsignarSIM" runat="server" CssClass="btn btn-success" Text="Asignar SIM" OnClick="btnAsignarSIM_Click" />
            </asp:Panel>
        </div>

        <div class="d-flex align-items-center">
            <asp:Panel ID="PnlBotonGuardarCancelar" runat="server" Visible="False">
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar"
                    CssClass="btn btn-primary me-2" OnClick="btnGuardar_Click" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar"
                    CssClass="btn btn-secondary" CausesValidation="false" OnClick="btnCancelar_Click" />
            </asp:Panel>
        </div>
    </div>

    <asp:Panel ID="pnlAgregar" runat="server" Visible="False">
        <asp:Label ID="lblMensajeGlobal" runat="server" Visible="false" CssClass="alert w-100 d-block mb-3"></asp:Label>
        <asp:HiddenField ID="hdnClienteId" runat="server" />
        <asp:Label ID="lblTitulo" runat="server" CssClass="fs-2 text-dark fw-bold"></asp:Label>
        <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="alert" />

        <asp:Panel ID="pnlSeccionGenerales" runat="server" Visible="True">
            <div class="panel-form container-fluid">
                <h4 class="mb-4">Datos Generales</h4>

                <div class="row">
                    <div class="col-lg-6 mb-3">
                        <label class="form-label">Tipo de Persona</label>
                        <asp:DropDownList ID="ddlTipoPersona" runat="server" CssClass="form-select" AutoPostBack="true"
                            OnSelectedIndexChanged="ddlTipoPersona_SelectedIndexChanged">
                            <asp:ListItem Text="Física" Value="F"></asp:ListItem>
                            <asp:ListItem Text="Moral" Value="M"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-lg-6 mb-3">
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
                </div>

                <asp:Panel ID="pnlFisica" runat="server">
                    <div class="row">
                        <div class="col-lg-6 mb-3">
                            <label class="form-label">Nombre</label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-lg-6 mb-3">
                            <label class="form-label">Apellido Paterno</label>
                            <asp:TextBox ID="txtApellidoPaterno" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6 mb-3">
                            <label class="form-label">Apellido Materno</label>
                            <asp:TextBox ID="txtApellidoMaterno" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-lg-6 mb-3">
                            <label class="form-label">CURP</label>
                            <asp:TextBox ID="txtCURP" runat="server" CssClass="form-control" />
                        </div>
                    </div>
                </asp:Panel>
                <div class="row">
                    <asp:Panel ID="pnlFisicaFecha" runat="server" CssClass="col-lg-6 mb-3">
                        <label class="form-label">Fecha de Nacimiento</label>
                        <asp:TextBox ID="txtFechaCumpleanios" runat="server" TextMode="Date" CssClass="form-control" />
                    </asp:Panel>
                    <asp:Panel ID="pnlRFC" runat="server" CssClass="col-lg-6 mb-3">
                        <label class="form-label">RFC</label>
                        <asp:TextBox ID="txtRFC" runat="server" CssClass="form-control" />
                    </asp:Panel>
                    <div class="col-lg-6 mb-3">
                        <label class="form-label">Teléfono</label>
                        <asp:TextBox ID="txtTelefono" runat="server" TextMode="Phone" CssClass="form-control" />
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                            ControlToValidate="txtTelefono"
                            ValidationExpression="^[0-9]{10}$"
                            ErrorMessage="Ingresa 10 dígitos" CssClass="text-danger" Display="Dynamic" />
                    </div>
                        <div class="col-lg-6 mb-3">
                            <label class="form-label">Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" />
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                ControlToValidate="txtEmail" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                ControlToValidate="txtEmail"
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                ErrorMessage="Formato de email no válido" CssClass="text-danger" Display="Dynamic" />
                            <span id="spanEmailExistente" class="text-danger"></span>
                        </div>
                        <asp:Panel ID="pnlPassword" runat="server" class="col-lg-6 mb-3">

                                <label class="form-label">Contraseña</label>
                                <asp:TextBox ID="tbPassword" runat="server" Width="100%" TextMode="Password" CssClass="form-control"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                    ControlToValidate="tbPassword" ErrorMessage="Requerida" CssClass="text-danger" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revPassword" runat="server"
                                    ControlToValidate="tbPassword"
                                    ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$"
                                    ErrorMessage="* Mínimo 6 caracteres (letras y números)" CssClass="text-danger" Display="Dynamic" />

                        </asp:Panel>
                            <div class="col-lg-6 mb-3">
                                <label class="form-label">Fecha de Alta</label>
                                <asp:TextBox ID="txtFechaAlta" runat="server" CssClass="form-control" TextMode="Date" ReadOnly="True" />
                            </div>
                        <div class="col-lg-6 mb-3">
                            <label class="form-label">Estado</label>
                            <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Puebla" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Estado México" Value="2"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    <div class="col-lg-6 mb-3">
                        <label class="form-label">Localidad</label>
                        <asp:DropDownList ID="ddlLocalidad" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Xicotepec" Value="2"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label class="form-label">Colonia</label>
                        <asp:TextBox ID="txtColonia" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label class="form-label">Calle</label>
                        <asp:TextBox ID="txtCalle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label class="form-label">Dirección</label>
                        <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-lg-6 mb-3">
                        <label class="form-label">Código Postal</label>
                        <asp:TextBox ID="txtCP" runat="server" CssClass="form-control" />
                        <asp:RegularExpressionValidator ID="revCP" runat="server"
                            ControlToValidate="txtCP" ValidationExpression="^[0-9]{5}$"
                            ErrorMessage="Ingresa un CP válido" CssClass="text-danger" Display="Dynamic" />
                    </div>
                </div>                
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlSeccionFiscales" runat="server" Visible="False">
            <div class="card shadow-sm mb-4">
                <div class="card-body container-fluid">
                    <h4 class="mb-4">Datos Fiscales</h4>
                    <div class="row">
                        <div class="col-lg-6 mb-3">
                            <label class="form-label">Tipo de Persona</label>
                            <asp:DropDownList ID="ddlTipoPersonaRegimen" runat="server" CssClass="form-select" AutoPostBack="true">
                                <asp:ListItem Text="Física" Value="F"></asp:ListItem>
                                <asp:ListItem Text="Moral" Value="M"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                ControlToValidate="ddlTipoPersonaRegimen" InitialValue="" ErrorMessage="Selecciona un tipo" CssClass="text-danger" Display="Dynamic" />
                        </div>

                        <div class="col-lg-6 mb-3">
                            <label class="form-label">Regimén Fiscal</label>
                            <%--<asp:TextBox ID="txtRegimenFiscal" runat="server" CssClass="form-control" />--%>
                            <asp:DropDownList ID="ddlRegimenFiscal" runat="server" CssClass="form-select">
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-lg-6 mb-3">
                            <label class="form-label">Razón Social</label>
                            <asp:TextBox ID="txtNombreRazonSocial" runat="server" CssClass="form-control" />
                        </div>

                        <div class="col-lg-6 mb-3">
                            <label class="form-label">RFC Facturación</label>
                            <asp:TextBox ID="txtRfcFacturacion" runat="server" CssClass="form-control" />
                        </div>
                    </div>

                    <div class="row">

                        <div class="col-lg-6 mb-3">
                            <label class="form-label">Uso De Contratante</label>
                            <asp:TextBox ID="txtUsoComprobante" runat="server" CssClass="form-control" />
                        </div>

                        <div class="col-lg-6 mb-3">
                            <label class="form-label">CP Facturación</label>
                            <asp:TextBox ID="txtCPFacturacion" runat="server" CssClass="form-control" />
                        </div>

                    </div>
                    <div class="row">
                    </div>
                </div>
            </div>
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
            <h4 class="mb-3">SIM CLIENTE</h4>
            <div class="table-responsive mb-3">
                <asp:GridView ID="gvSIMAsignadas" runat="server"
                    CssClass="table table-hover align-middle"
                    AutoGenerateColumns="False"
                    HeaderStyle-CssClass="table-dark"
                    ShowHeaderWhenEmpty="True"
                    OnRowCommand="gvSIMAsignadas_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="ICCID" HeaderText="ICCID" />
                        <asp:BoundField DataField="MSISDN" HeaderText="MSISDN" />
                        <asp:BoundField DataField="Estado" HeaderText="Estado" />
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkVerDetalle" runat="server"
                                    CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("SIMID") %>'
                                    CssClass="text-primary"
                                    ToolTip="Ver detalles">
                    <i class="bi bi-eye"></i> 
                                </asp:LinkButton>
                                <asp:LinkButton ID="lnkAsignarOferta" runat="server"
                                    CommandName="AsignarOferta"
                                    CommandArgument='<%# Eval("SIMID") %>'
                                    CssClass="text-success ms-2"
                                    ToolTip="Asignar oferta"
                                    Visible='<%# (Eval("OfertaID") Is DBNull.Value) OrElse (Eval("OfertaID") Is Nothing) OrElse (Eval("OfertaID").ToString() = "") %>'>
    <i class="bi bi-plus-circle"></i>
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
                                    CssClass="btn btn-success btn-sm"
                                    OnClientClick="return confirm('¿Seguro que deseas asignar esta SIM al cliente?');">
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
                        <span id="lblModalICCID" runat="server"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>MSISDN:</strong></label>
                        <span id="lblModalMSISDN" runat="server"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Estado:</strong></label>
                        <span id="lblModalEstado" runat="server"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Plan Asignado:</strong></label>
                        <span id="lblModalPlan" runat="server"></span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Seleccionar Oferta -->
    <div class="modal fade" id="modalOfertas" tabindex="-1" aria-labelledby="modalOfertasLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Seleccionar Oferta</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">

                    <asp:HiddenField ID="hdnSIMId" runat="server" />

                    <asp:GridView ID="gvOfertas" runat="server"
                        CssClass="table table-hover align-middle"
                        AutoGenerateColumns="False"
                        HeaderStyle-CssClass="table-dark"
                        ShowHeaderWhenEmpty="True"
                        OnRowCommand="gvOfertas_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="OfferIDAltan" HeaderText="ID" />
                            <asp:BoundField DataField="HomologacionID" HeaderText="Homologación" />
                            <asp:BoundField DataField="Oferta" HeaderText="Nombre Oferta" />
                            <asp:TemplateField HeaderText="Precio">
                                <ItemTemplate>
                                    <asp:Label ID="lblRecarga" runat="server"
                                        Text='<%# String.Format("{0:C}", Eval("PrecioRecurrente")) & " / recarga" %>'
                                        Visible='<%# Convert.ToInt32(Eval("Tipo")) = 1 %>'></asp:Label>
                                    <asp:Label ID="lblAnticipado" runat="server"
                                        Text='<%# String.Format("{0:C}", Eval("PrecioAnual")) & " / anticipado" %>'
                                        Visible='<%# Convert.ToInt32(Eval("Tipo")) = 2 %>'></asp:Label>

                                    <asp:Label ID="lblMensual" runat="server"
                                        Text='<%# String.Format("{0:C}", Eval("PrecioMensual")) & " / mensual" %>'
                                        Visible='<%# Convert.ToInt32(Eval("Tipo")) = 3 %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tipo de Tarifa">
                                <ItemTemplate>
                                    <%# If(Eval("TarifaPrimaria"), "Primaria", "Secundaria") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="FechaAlta" HeaderText="Fecha Alta" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:TemplateField HeaderText="Acción">
                                <ItemTemplate>
                                    <asp:Button ID="btnSelectOferta" runat="server"
                                        CommandName="SeleccionarOferta"
                                        CommandArgument='<%# Eval("OfertaID") %>'
                                        CssClass="btn btn-success btn-sm"
                                        OnClientClick="return confirm('¿Seguro que deseas asignar una oferta a esta SIM?');"
                                        Text="Seleccionar" />
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%= txtEmail.ClientID %>").on('blur', function () {
                var email = $(this).val();
                var clienteId = parseInt($("#<%= hdnClienteId.ClientID %>").val()) || 0;

                if (email.length > 0) {
                    $.ajax({
                        type: "POST",
                        url: "AdminCliente.aspx/VerificarEmailExistente",
                        data: JSON.stringify({ email: email, clienteId: clienteId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d) {
                                $("#spanEmailExistente").text("❌ Este correo ya está registrado. Intenta con otro.");
                                $("#spanEmailExistente").addClass("text-danger").removeClass("text-success");
                            } else {
                                $("#spanEmailExistente").text("✅ Correo disponible.");
                                $("#spanEmailExistente").addClass("text-success").removeClass("text-danger");
                            }
                        },
                        error: function (xhr, status, error) {
                            console.log("Error al validar el email: " + error);
                        }
                    });
                } else {
                    $("#spanEmailExistente").text("");
                }
            });
        });
    </script>
    <script>
        let typingTimer;
        const delay = 700;

        function iniciarBusqueda() {
            clearTimeout(typingTimer);
            typingTimer = setTimeout(function () {
                __doPostBack('<%= txtBuscarClientes.UniqueID %>', '');
            }, delay);
        }
    </script>
</asp:Content>
