<%@ Page Title="" Language="vb" UnobtrusiveValidationMode="None" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminOfertas.aspx.vb" Inherits="WebAdmin.AdminOfertas" Culture="es-MX" %>

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

        .action-icon {
            text-decoration: none !important;
        }

        a.text-primary, a.text-danger {
            text-decoration: none !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="pnlAdminOfertas" runat="server" CssClass="container mt-3">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Administración de Ofertas</h2>
            <asp:Button ID="btnAgregarOfertas" runat="server" CssClass="btn btn-success btn-add"
                Text="+ Agregar Ofertas" OnClick="btnAgregarOfertas_Click" />
        </div>

        <div class="mb-4">
            <asp:TextBox ID="txtBuscarOfertas" runat="server" CssClass="form-control"
                placeholder="🔍 Buscar ofertas..." AutoPostBack="true"
                OnTextChanged="txtBuscarOfertas_TextChanged"
                onkeyup="iniciarBusqueda();">
            </asp:TextBox>
        </div>

        <div class="mb-3">
            <label for="ddlFiltroTipoOferta" class="form-label"></label>
            <asp:DropDownList ID="ddlFiltroTipoOferta" runat="server" CssClass="form-select" AutoPostBack="True" OnSelectedIndexChanged="ddlFiltroTipoOferta_SelectedIndexChanged">
                <asp:ListItem Text="-- Todos --" Value="0" />
                <asp:ListItem Text="Prepago" Value="1" />
                <asp:ListItem Text="Pago Anticipado" Value="2" />
                <asp:ListItem Text="Renovación Automática" Value="3" />
            </asp:DropDownList>
        </div>


    </asp:Panel>

    <asp:Panel ID="pnlTabla" runat="server" Visible="True">
        <div style="overflow-x: auto; width: 100%;">
            <div class="card card-shadow p-4 mb-4">
                <div class="table-responsive">
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
                            <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
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
                            <asp:BoundField DataField="DatosMB" HeaderText="Datos (MB)" />
                            <asp:BoundField DataField="Minutos" HeaderText="Minutos" />
                            <asp:BoundField DataField="Sms" HeaderText="SMS" />
                            <asp:TemplateField HeaderText="Tipo de Tarifa">
                                <ItemTemplate>
                                    <%# If(Eval("TarifaPrimaria"), "Primaria", "Secundaria") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="FechaAlta" HeaderText="Fecha Alta" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEditar" runat="server"
                                        CommandName="EditarOferta"
                                        CommandArgument='<%# Eval("OfertaId") %>'
                                        CssClass="text-primary" ToolTip="Editar">
                                        <i class="bi bi-pencil action-icon edit"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnBaja" runat="server"
                                        CommandName="BajaOferta"
                                        CommandArgument='<%# Eval("OfertaId") %>'
                                        CssClass="action-icon delete"
                                        OnClientClick="return confirm('¿Seguro que deseas dar de baja esta Oferta?');">
<i class="bi bi-person-x-fill" title="Dar de baja cliente"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlAgregar" runat="server" Visible="False">
        <asp:HiddenField ID="hdnOfertaId" runat="server" />
        <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="alert" />
        <div class="panel-form">
            <h4 class="mb-4">Agregar Oferta</h4>

            <div class="mb-3">
                <label class="form-label">ID Oferta</label>
                <asp:TextBox ID="txtOfertaIdAltan" runat="server" CssClass="form-control" TextMode="Number" />
                <asp:RequiredFieldValidator ID="rfvOfertaIdAltan" runat="server"
                    ControlToValidate="txtOfertaIdAltan"
                    ErrorMessage="El ID Oferta es obligatorio."
                    ForeColor="Red" Display="Dynamic" />
            </div>
            <div class="mb-3">
                <label class="form-label">ID Homologación</label>
                <asp:TextBox ID="txtHomologacioId" runat="server" CssClass="form-control" TextMode="Number" />
                <asp:RequiredFieldValidator ID="rfvHomologacioId" runat="server"
                    ControlToValidate="txtHomologacioId"
                    ErrorMessage="El ID Homologación es obligatorio."
                    ForeColor="Red" Display="Dynamic" />
            </div>
            <div class="mb-3">
                <label class="form-label">Oferta</label>
                <asp:DropDownList ID="ddlTipoOferta" runat="server" CssClass="form-select"
                    AutoPostBack="True" OnSelectedIndexChanged="ddlTipoOferta_SelectedIndexChanged">
                    <asp:ListItem Text="-- Selecciona un opción --" Value="0" />
                    <asp:ListItem Text="Prepago" Value="1" />
                    <asp:ListItem Text="Pago Anticipado" Value="2" />
                    <asp:ListItem Text="Renovación Automática" Value="3" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvTipoOferta" runat="server"
                    ControlToValidate="ddlTipoOferta" InitialValue="0"
                    ErrorMessage="Debe seleccionar un tipo de oferta."
                    ForeColor="Red" Display="Dynamic" />
            </div>
            <div class="mb-3">
                <asp:Panel ID="divPrecioRecarga" runat="server" Visible="false" CssClass="mb-3">
                    <label class="form-label">Precio Recarga</label>
                    <asp:TextBox ID="txtPrecioRecarga" runat="server" CssClass="form-control" TextMode="Number" />
                    <asp:RequiredFieldValidator ID="rfvPrecioRecarga" runat="server"
                        ControlToValidate="txtPrecioRecarga"
                        ErrorMessage="El precio recarga es obligatorio."
                        ForeColor="Red" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revPrecioRecarga" runat="server"
                        ControlToValidate="txtPrecioRecarga"
                        ValidationExpression="^\d+(\.\d{1,2})?$"
                        ErrorMessage="Precio Recarga debe ser un número válido."
                        ForeColor="Red" Display="Dynamic" />
                </asp:Panel>
            </div>
            <div class="mb-3">
                <asp:Panel ID="divPrecioAnual" runat="server" Visible="false" CssClass="mb-3">
                    <label class="form-label">Precio Anual</label>
                    <asp:TextBox ID="txtPrecioAnual" runat="server" CssClass="form-control" TextMode="Number" />
                    <asp:RequiredFieldValidator ID="rfvPrecioAnual" runat="server"
                        ControlToValidate="txtPrecioAnual"
                        ErrorMessage="El precio anual es obligatorio."
                        ForeColor="Red" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revPrecioAnual" runat="server"
                        ControlToValidate="txtPrecioAnual"
                        ValidationExpression="^\d+(\.\d{1,2})?$"
                        ErrorMessage="Precio Anual debe ser un número válido."
                        ForeColor="Red" Display="Dynamic" />
                </asp:Panel>
            </div>
            <div class="mb-3">
                <asp:Panel ID="divPrecioMensual" runat="server" Visible="false" CssClass="mb-3">
                    <label class="form-label">Precio Mensual</label>
                    <asp:TextBox ID="txtPrecioMensual" runat="server" CssClass="form-control" TextMode="Number" />
                    <asp:RequiredFieldValidator ID="rfvPrecioMensual" runat="server"
                        ControlToValidate="txtPrecioMensual"
                        ErrorMessage="El precio mensual es obligatorio."
                        ForeColor="Red" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revPrecioMensual" runat="server"
                        ControlToValidate="txtPrecioMensual"
                        ValidationExpression="^\d+(\.\d{1,2})?$"
                        ErrorMessage="Precio Mensual debe ser un número válido."
                        ForeColor="Red" Display="Dynamic" />
                </asp:Panel>
            </div>
            <div class="mb-3">
                <label class="form-label">Nombre de la Oferta</label>
                <asp:TextBox ID="txtOferta" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="rfvOferta" runat="server"
                    ControlToValidate="txtOferta"
                    ErrorMessage="El nombre de la oferta es obligatorio."
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Descripción</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
            </div>

            <div class="mb-3">
                <label class="form-label">Datos (MB)</label>
                <asp:TextBox ID="txtDatosMB" runat="server" CssClass="form-control" TextMode="Number" />
                <asp:RequiredFieldValidator ID="rfvDatosMB" runat="server"
                    ControlToValidate="txtDatosMB"
                    ErrorMessage="Los datos son obligatorios."
                    ForeColor="Red" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revDatosMB" runat="server"
                    ControlToValidate="txtDatosMB"
                    ValidationExpression="^\d+$"
                    ErrorMessage="Datos debe ser un número entero válido."
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Minutos</label>
                <asp:TextBox ID="txtMinutos" runat="server" CssClass="form-control" TextMode="Number" />
                <asp:RequiredFieldValidator ID="rfvMinutos" runat="server"
                    ControlToValidate="txtMinutos"
                    ErrorMessage="Los minutos son obligatorios."
                    ForeColor="Red" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revMinutos" runat="server"
                    ControlToValidate="txtMinutos"
                    ValidationExpression="^\d+$"
                    ErrorMessage="Minutos debe ser un número entero válido."
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">SMS</label>
                <asp:TextBox ID="txtSms" runat="server" CssClass="form-control" TextMode="Number" />
                <asp:RequiredFieldValidator ID="rfvSms" runat="server"
                    ControlToValidate="txtSms"
                    ErrorMessage="Los SMS son obligatorios."
                    ForeColor="Red" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revSms" runat="server"
                    ControlToValidate="txtSms"
                    ValidationExpression="^\d+$"
                    ErrorMessage="SMS debe ser un número entero válido."
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Validez (días)</label>
                <asp:TextBox ID="txtValidezDias" runat="server" CssClass="form-control" TextMode="Number" />
                <asp:RequiredFieldValidator ID="rfvValidezDias" runat="server"
                    ControlToValidate="txtValidezDias"
                    ErrorMessage="La validez es obligatoria."
                    ForeColor="Red" Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revValidezDias" runat="server"
                    ControlToValidate="txtValidezDias"
                    ValidationExpression="^\d+$"
                    ErrorMessage="Validez debe ser un número entero válido."
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Aplica Roaming</label>
                <asp:DropDownList ID="ddlAplicaRoaming" runat="server" CssClass="form-select">
                    <asp:ListItem Text="-- Selecciona un opción --" Value="0" />
                    <asp:ListItem Text="Sí" Value="True" />
                    <asp:ListItem Text="No" Value="False" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvAplicaRoaming" runat="server"
                    ControlToValidate="ddlAplicaRoaming" InitialValue="0"
                    ErrorMessage="Debe seleccionar si aplica roaming."
                    ForeColor="Red" Display="Dynamic" />
            </div>


            <div class="mb-3">
                <label class="form-label">Tarifa Primaria</label>
                <asp:DropDownList ID="ddlTarifaPrimaria" runat="server" CssClass="form-select">
                    <asp:ListItem Text="-- Selecciona un opción --" Value="0" />
                    <asp:ListItem Text="Sí" Value="True" />
                    <asp:ListItem Text="No" Value="False" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvTarifaPrimaria" runat="server"
                    ControlToValidate="ddlTarifaPrimaria" InitialValue="0"
                    ErrorMessage="Debe seleccionar tarifa primaria."
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Redes Sociales</label>
                <asp:DropDownList ID="ddlRedesSociales" runat="server" CssClass="form-select">
                    <asp:ListItem Text="-- Selecciona un opción --" Value="0" />
                    <asp:ListItem Text="Sí" Value="True" />
                    <asp:ListItem Text="No" Value="False" />
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvRedesSociales" runat="server"
                    ControlToValidate="ddlRedesSociales" InitialValue="0"
                    ErrorMessage="Debe seleccionar redes sociales."
                    ForeColor="Red" Display="Dynamic" />
            </div>

            <div class="mb-3">
                <label class="form-label">Fecha de Alta</label>
                <asp:TextBox ID="txtFechaAlta" runat="server" CssClass="form-control" TextMode="Date" ReadOnly="True" />
            </div>

            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary ms-2" CausesValidation="False" OnClick="btnCancelar_Click" />
        </div>
    </asp:Panel>
    <script>
        let typingTimer;
        const delay = 700;

        function iniciarBusqueda() {
            clearTimeout(typingTimer);
            typingTimer = setTimeout(function () {
                __doPostBack('<%= txtBuscarOfertas.UniqueID %>', '');
        }, delay);
        }
    </script>
</asp:Content>
