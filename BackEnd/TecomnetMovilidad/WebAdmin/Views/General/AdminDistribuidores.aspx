<%@ Page Title="" Language="vb" UnobtrusiveValidationMode="None" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminDistribuidores.aspx.vb" Inherits="WebAdmin.AdminDistribuidores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

        .gvPager a {
            padding: .375rem .75rem;
            margin: 0 2px;
            border: 1px solid #dee2e6;
            border-radius: .25rem;
            text-decoration: none;
            color: #0d6efd;
        }

            .gvPager a:hover {
                background-color: #e9ecef;
            }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Label ID="lblError" runat="server" ForeColor="Red" Visible="False"></asp:Label>
    <asp:Panel ID="pnlAdminDistribuidores" runat="server" CssClass="container mt-3">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Administración de Distribuidores</h2>
            <asp:Button ID="btnAgregarDistribuidor" runat="server" CssClass="btn btn-success btn-add"
                Text="+ Agregar Distribuidor" OnClick="btnAgregarDistribuidor_Click" />
        </div>
        <div class="mb-4">
            <asp:TextBox ID="txtBuscarDistribuidores" runat="server" CssClass="form-control"
                placeholder="🔍 Buscar distribuidores..." AutoPostBack="true"
                OnTextChanged="txtBuscarDistribuidores_TextChanged"
                onkeyup="iniciarBusqueda();">
            </asp:TextBox>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlTabla" runat="server" Visible="True">
        <div class="card card-shadow p-4 mb-4">
            <div style="overflow-x: auto; width: 100%;">
                <asp:GridView ID="gvDistribuidores" runat="server"
                    CssClass="table table-hover align-middle"
                    AutoGenerateColumns="False"
                    HeaderStyle-CssClass="table-dark"
                    ShowHeaderWhenEmpty="True" DataKeyNames="DistribuidorID"
                    AllowPaging="True"
                    PageSize="1"
                    OnPageIndexChanging="gvDistribuidores_PageIndexChanging">
                    <PagerStyle CssClass="gvPager" HorizontalAlign="Center" />
                    <Columns>
                        <asp:BoundField DataField="Region" HeaderText="Región" />
                        <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                        <asp:BoundField DataField="Direccion" HeaderText="Dirección" />
                        <asp:BoundField DataField="RFC" HeaderText="RFC" />
                        <asp:BoundField DataField="TipoPersona" HeaderText="Tipo Persona" />
                        <asp:BoundField DataField="NombreContacto" HeaderText="Nombre Contacto" />
                        <asp:BoundField DataField="TelefonoContacto" HeaderText="Teléfono" />
                        <asp:BoundField DataField="EmailContacto" HeaderText="Correo" />
                        <asp:BoundField DataField="Beneficiario" HeaderText="Beneficiario" />
                        <asp:BoundField DataField="FechaAlta" HeaderText="Fecha Alta" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="FechaUltimaActualizacion" HeaderText="Última actualización" DataFormatString="{0:dd/MM/yyyy}" />

                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEditar" runat="server"
                                    CommandName="EditarDistribuidor"
                                    CommandArgument='<%# Eval("DistribuidorID") %>'
                                    CssClass="text-primary" ToolTip="Editar">
    <i class="bi bi-pencil action-icon edit"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="lnkBaja" runat="server"
                                    CommandName="BajaDistribuidor"
                                    CommandArgument='<%# Eval("DistribuidorID") %>'
                                    CssClass="action-icon delete"
                                    OnClientClick="return confirm('¿Seguro que deseas dar de baja este distribuidor?');">
    <i class="bi bi-person-x-fill"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlAgregar" runat="server" Visible="False">
        <asp:Label ID="lblMensajeGlobal" runat="server" Visible="false" CssClass="alert w-100 d-block mb-3"></asp:Label>
        <asp:HiddenField ID="hdnDistribuidorID" runat="server" />
        <asp:Label ID="lblTitulo" runat="server" CssClass="fs-2 text-dark fw-bold"></asp:Label>
        <asp:Label ID="lblMensaje" runat="server" Visible="false" CssClass="alert" />
        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h4 class="mb-4">Datos Generales</h4>

                <div class="mb-3">
                    <label class="form-label">Región</label>
                    <asp:TextBox ID="txtRegion" runat="server" TextMode="Number" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvRegion" runat="server"
                        ControlToValidate="txtRegion" ErrorMessage="Campo Requerido" CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Nombre</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvNombre" runat="server"
                        ControlToValidate="txtNombre" ErrorMessage="Campo Requerido" CssClass="text-danger" Display="Dynamic" />
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
                    <asp:RequiredFieldValidator ID="rfvTelefonoContacto" runat="server"
                        ControlToValidate="txtTelefonoContacto" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Correo</label>
                    <asp:TextBox ID="txtEmailContacto" runat="server" TextMode="Email" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                        ControlToValidate="txtEmailContacto" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                        ControlToValidate="txtEmailContacto"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                        ErrorMessage="Formato de email no válido" CssClass="text-danger" Display="Dynamic" />
                    <span id="spanCorreoExistente" class="text-danger"></span>
                </div>

                <div class="mb-3">
                    <label class="form-label">Fecha de Alta</label>
                    <asp:TextBox ID="txtFechaAlta" runat="server" CssClass="form-control" ReadOnly="True" />
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
                        <asp:ListItem Text="-- Selecciona --" Value=""></asp:ListItem>
                        <asp:ListItem Text="Física" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Moral" Value="2"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvTipoPersona" runat="server"
                        ControlToValidate="ddlTipoPersona" InitialValue="" ErrorMessage="Selecciona un estatus" CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Dirección Fiscal</label>
                    <asp:TextBox ID="txtDireccionFiscal" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvDireccionFiscal" runat="server"
                        ControlToValidate="txtDireccionFiscal" InitialValue="" ErrorMessage="Campo Requerido" CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Porcentaje Comisión</label>
                    <asp:TextBox ID="txtPorcentajeComision" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvPorcentaje" runat="server"
                        ControlToValidate="txtPorcentajeComision" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Banco</label>
                    <asp:TextBox ID="txtBanco" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvBanco" runat="server"
                        ControlToValidate="txtBanco" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Cuenta</label>
                    <asp:TextBox ID="txtCuenta" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvCuenta" runat="server"
                        ControlToValidate="txtCuenta" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Beneficiario</label>
                    <asp:TextBox ID="txtBeneficiario" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator ID="rfvBeneficiario" runat="server"
                        ControlToValidate="txtBeneficiario" ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Tipo Distribuidor</label>
                    <asp:DropDownList ID="ddlTipoDistribuidor" runat="server" CssClass="form-select">
                        <asp:ListItem Text="-- Selecciona --" Value=""></asp:ListItem>
                        <asp:ListItem Text="Consumidor Final" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Mayorista" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Minorista" Value="3"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvTipoDistribuidor" runat="server"
                        ControlToValidate="ddlTipoDistribuidor" InitialValue="" ErrorMessage="Selecciona un estatus" CssClass="text-danger" Display="Dynamic" />
                </div>
            </div>
        </div>

        <div class="mt-3">
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary ms-2" OnClick="btnCancelar_Click" CausesValidation="False" />
        </div>

    </asp:Panel>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%= txtEmailContacto.ClientID %>").on('keyup blur', function () {

                var correo = $(this).val();
                var distribuidorId = parseInt($("#<%= hdnDistribuidorID.ClientID %>").val()) || 0;

                if (correo.length > 0) {
                    $.ajax({
                        type: "POST",
                        url: "AdminDistribuidores.aspx/VerificarCorreoExistente",
                        data: JSON.stringify({ correo: correo, distribuidorId: distribuidorId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d) {
                                $("#spanCorreoExistente").text("❌ Este correo ya está registrado. Intenta con otro.")
                                    .removeClass("text-success")
                                    .addClass("text-danger");
                                $("#<%= btnGuardar.ClientID %>").prop("disabled", true);
                            } else {
                                $("#spanCorreoExistente").text("✅ Correo disponible.")
                                    .removeClass("text-danger")
                                    .addClass("text-success");
                                $("#<%= btnGuardar.ClientID %>").prop("disabled", false);
                            }
                        },
                        error: function (xhr, status, error) {
                            console.log("Error al validar el correo: " + error);
                        }
                    });
                } else {
                    $("#spanCorreoExistente").text("");
                    $("#<%= btnGuardar.ClientID %>").prop("disabled", false);
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
                __doPostBack('<%= txtBuscarDistribuidores.UniqueID %>', '');
            }, delay);
        }
    </script>
</asp:Content>
