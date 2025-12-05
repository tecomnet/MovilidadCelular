<%@ Page Title="" Language="vb" UnobtrusiveValidationMode="None" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminPortabilidad.aspx.vb" Inherits="WebAdmin.AdminPortabilidad" %>

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
            padding: 1rem 1.5rem;
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

        .table td .action-icon,
        .table td a.text-primary,
        .table td a.text-danger,
        .table td a.text-success {
            display: inline-block;
            white-space: nowrap;
            vertical-align: middle;
        }

        .table td {
            white-space: nowrap;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="PnlAdminPortabilidad" runat="server" CssClass="container mt-3">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Administración de Portabilidad</h2>
        </div>
    </asp:Panel>
    <asp:Panel ID="PnlBotones" runat="server" CssClass="container mt-5">
        <asp:Label ID="lblMensajeBatch" runat="server" CssClass="text-info mt-2 d-block"></asp:Label>
        <asp:Label ID="lblMensaje" runat="server" CssClass="text-info mt-2 d-block"></asp:Label>
        <div class="d-flex justify-content-end align-items-center gap-2 mb-4">
            <asp:Button ID="btnAgregarBatch" runat="server" CssClass="btn btn-success btn-add"
                Text="+ Agregar Batch" OnClick="btnCargarBatch_Click" />
            <asp:FileUpload ID="fileUploadBatch" runat="server" accept=".csv" Style="display: none" />
            <asp:Button ID="btnAgregarManual" runat="server" CssClass="btn btn-success btn-add"
                Text="+ Agregar Manual" OnClick="btnAgregarManual_Click" />
            <asp:Button ID="btnGenerarCsv" runat="server" CssClass="btn btn-success btn-add"
                Text="Generar .csv" OnClick="btnGenerarCsv_Click" />
        </div>

        <div class="mb-4">
            <asp:TextBox ID="txtBuscarPortabilidad" runat="server" CssClass="form-control"
                placeholder="🔍 Buscar portabilidad..." AutoPostBack="true"
                OnTextChanged="txtBuscarPortabilidad_TextChanged"
                onkeyup="iniciarBusqueda();">
            </asp:TextBox>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlDatosGenerales" runat="server" Visible="True">
        <asp:HiddenField ID="hdnPortabilidadId" runat="server" />
        <div class="panel-form">
            <div class="mb-3">
                <label class="form-label">MSISDN Transitorio</label>
                <asp:TextBox ID="txtMSISDN_Transitorio" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvMSISDN_Transitorio" runat="server"
                    ControlToValidate="txtMSISDN_Transitorio" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">MSISDN</label>
                <asp:TextBox ID="txtMSISDN" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvMSISDN" runat="server"
                    ControlToValidate="txtMSISDN" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Compañia</label>
                <asp:TextBox ID="txtCompaniaOrigen" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Fecha de Registro</label>
                <asp:TextBox ID="TxtFechaRegistro" runat="server" CssClass="form-control" TextMode="Date" ReadOnly="True" />
            </div>

            <div class="mb-3">
                <label class="form-label">Tipo Portabilidad</label>
                <asp:DropDownList ID="ddlTipoPortabilidad" runat="server" CssClass="form-select" Enabled="False">
                    <asp:ListItem Text="-- Selecciona --" Value=""></asp:ListItem>
                    <asp:ListItem Text="Api" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Manual" Value="2"></asp:ListItem>
                    <asp:ListItem Text="Batch" Value="3"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar"
                CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary ms-2" CausesValidation="false" />
        </div>
    </asp:Panel>
    <asp:Panel ID="PnlTabla" runat="server" Visible="true">
        <div style="overflow-x: auto; width: 100%;">
            <asp:GridView ID="gvDatosPortabilidad" runat="server" CssClass="table table-hover align-middle"
                AutoGenerateColumns="False" ShowHeader="True" HeaderStyle-CssClass="table-dark">
                <Columns>
                    <asp:BoundField DataField="MSISDN_Transitorio" HeaderText="MSISDN Transitorio" />
                    <asp:BoundField DataField="MSISDN" HeaderText="MSISDN" />
                    <asp:BoundField DataField="CompaniaOrigen" HeaderText="Compañía Origen" />
                    <asp:BoundField DataField="Estatus" HeaderText="Estatus" />
                    <asp:BoundField DataField="FechaRegistro" HeaderText="Fecha Registro" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="FechaTermino" HeaderText="Fecha Término" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="FechaCancelacion" HeaderText="Fecha Cancelación" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="FechaRechazo" HeaderText="Fecha Rechazo" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="TipoPortabilidad" HeaderText="Tipo Portabilidad" />
                    <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>
                            <div class="d-flex align-items-center">
                                <asp:LinkButton ID="btnAceptar" runat="server"
                                    class="bi bi-check-lg text-success me-2 action-icon"
                                    CommandName="AceptarSolicitud"
                                    CommandArgument='<%# Eval("PortabilidadID") %>'
                                    ToolTip="Aceptar"
                                    OnClientClick="return confirm('¿Seguro que deseas aceptar esta solicitud?');" />
                                <a href="#" class="text-danger me-2 action-icon" title="Rechazar">
                                    <i class="bi bi-x-lg"></i>
                                </a>
                                <a href="#" class="text-danger me-2 action-icon" title="Cancelado">
                                    <i class="bi bi-slash-circle"></i>
                                </a>
                                <a href="#" class="text-primary action-icon" title="Descargar">
                                    <i class="bi bi-download"></i>
                                </a>
                            </div>
                            <asp:Panel ID="pnlOrderId" runat="server" Visible="false" CssClass="mt-2">

                                <asp:TextBox ID="txtOrderId" runat="server"
                                    CssClass="form-control"
                                    Placeholder="Ingrese"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvOrderId" runat="server"
                                    ControlToValidate="txtOrderId"
                                    ErrorMessage="El OrderId es obligatorio."
                                    Display="Dynamic"
                                    CssClass="text-danger"
                                    SetFocusOnError="True" />

                                <asp:Button ID="btnGuardarOrderId" runat="server"
                                    Text="Guardar"
                                    CommandName="GuardarOrderId"
                                    CommandArgument='<%# Eval("PortabilidadID") %>'
                                    CssClass="btn btn-primary btn-sm mt-1"
                                    CausesValidation="True" />
                                <asp:Button ID="btnCancelar" runat="server"
                                    Text="Cancelar"
                                    CssClass="btn btn-danger btn-sm mt-1"
                                    OnClick="btnCancelar_Click"  CausesValidation="false" />
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const btnAgregarBatch = document.getElementById("<%= btnAgregarBatch.ClientID %>");
            const fileUploadBatch = document.getElementById("<%= fileUploadBatch.ClientID %>");

            btnAgregarBatch.addEventListener("click", function (e) {
                e.preventDefault();
                fileUploadBatch.click();
            });

            fileUploadBatch.addEventListener("change", function () {
                if (fileUploadBatch.value) {
                    __doPostBack('<%= btnAgregarBatch.UniqueID %>', '');
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
                __doPostBack('<%= txtBuscarPortabilidad.UniqueID %>', '');
            }, delay);
        }
    </script>
</asp:Content>
