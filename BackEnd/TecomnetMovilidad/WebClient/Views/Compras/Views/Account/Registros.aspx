<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Registros.aspx.vb" Inherits="WebClient.Registros" UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Registros</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <style>
        .card {
            margin-top: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hdnClienteId" runat="server" />

        <div class="container mt-4">
            <div class="card p-4">
                <div class="row mt-4">
        <asp:Label ID="LblMensajeN" runat="server" CssClass="show" style="display:block; text-align:center;"  Visible="false"></asp:Label>
                    <div class="col-md-2 offset-md-8 d-grid">
                        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                    </div>
                    <div class="col-md-2 d-grid">
                        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-danger" OnClick="btnCancelar_Click" />
                    </div>
                </div>
                <h5 class="card-title border-bottom pb-2">Datos Generales</h5>
                <div class="row g-3 mt-2">
                    <div class="col-12">
                        <label class="form-label">Tipo de Persona</label>
                        <asp:DropDownList ID="ddlTipoPersona" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlTipoPersona_SelectedIndexChanged">
                            <asp:ListItem Text="Física" Value="F" />
                            <asp:ListItem Text="Moral" Value="M" />
                        </asp:DropDownList>
                    </div>
                    <asp:Panel ID="pnlDatosFisica" runat="server" Visible="false">
                        <div class="row g-3 mt-2">
                            <div class="col-md-4">
                                <label class="form-label">Nombre</label>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Apellido Paterno</label>
                                <asp:TextBox ID="txtApellidoPaterno" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Apellido Materno</label>
                                <asp:TextBox ID="txtApellidoMaterno" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Nombre Completo</label>
                                <asp:TextBox ID="txtNombreCompleto" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">CURP</label>
                                <asp:TextBox ID="txtCurp" runat="server" CssClass="form-control" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Fecha de Nacimiento</label>
                                <asp:TextBox ID="txtFechaNacimiento" runat="server" TextMode="Date" CssClass="form-control" />
                            </div>
                        </div>
                    </asp:Panel>
                    <div class="col-md-4">
                        <label class="form-label">RFC</label>
                        <asp:TextBox ID="txtRFC" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Teléfono</label>
                        <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Correo</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" />
                        <span id="spanEmailExistente" class="text-danger"></span>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Contraseña</label>
                        <asp:TextBox ID="txtContrasena" runat="server" TextMode="Password"
                            CssClass="form-control" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Fecha de Alta</label>
                        <asp:TextBox ID="txtFechaAlta" runat="server" TextMode="Date" CssClass="form-control" ReadOnly="true" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Colonia</label>
                        <asp:TextBox ID="txtColonia" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Dirección</label>
                        <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Código Postal</label>
                        <asp:TextBox ID="txtCP" runat="server" CssClass="form-control" />
                    </div>
                </div>
                <div class="row mt-3">
                    <h5 class="card-title border-bottom pb-2">Datos Fiscales</h5>
                    <div class="row g-3 mt-2">
                        <div class="col-md-4">
                            <label class="form-label">Tipo de Persona</label>
                            <asp:DropDownList ID="ddlTipoPersonaRegimen" runat="server" CssClass="form-select" AutoPostBack="true">
                                <asp:ListItem Text="Física" Value="F"></asp:ListItem>
                                <asp:ListItem Text="Moral" Value="M"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Regimén Fiscal</label>
                            <asp:DropDownList ID="ddlRegimenFiscal" runat="server" CssClass="form-select">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Nombre</label>
                            <asp:TextBox ID="txtNombreFiscal" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Apellido Paterno</label>
                            <asp:TextBox ID="txtApellidoPaternoFiscal" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Apellido Materno</label>
                            <asp:TextBox ID="txtApellidoMaternoFiscal" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Razón Social</label>
                            <asp:TextBox ID="txtRazonSocialFiscal" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">RFC</label>
                            <asp:TextBox ID="txtRFCFiscal" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">RFC Facturación</label>
                            <asp:TextBox ID="txtRFCFacturacion" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">CP Facturación</label>
                            <asp:TextBox ID="txtCPFacturacion" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Uso De Comprobante</label>
                            <asp:TextBox ID="txtUsoComprobante" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Pais</label>
                            <asp:DropDownList ID="ddlPaisFiscal" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlPaisFiscal_SelectedIndexChanged" ></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Estado</label>
                            <asp:DropDownList ID="ddlEstadoFiscal" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlEstadoFiscal_SelectedIndexChanged" ></asp:DropDownList>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Ciudad</label>
                            <asp:DropDownList ID="ddlCiudadFiscal" runat="server" CssClass="form-select" AutoPostBack="true"></asp:DropDownList>                         
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Calle</label>
                            <asp:TextBox ID="txtCalleFiscal" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Colonia</label>
                            <asp:TextBox ID="txtColoniaFiscal" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Número Interior</label>
                            <asp:TextBox ID="txtNumeroInterior" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Número Exterior</label>
                            <asp:TextBox ID="txtNumeroExterior" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Localidad</label>
                            <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-control" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Codigo Postal</label>
                            <asp:TextBox ID="txtCodigoPostalFiscal" runat="server" CssClass="form-control" />
                        </div>
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
                            url: "Registros.aspx/VerificarEmailExistente",
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
    </form>
</body>
</html>
