<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Registros.aspx.vb" Inherits="WebClient.Registros" UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Registros</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .centered {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: Arial, sans-serif;
        }

        .welcome-text {
            font-size: 32px;
            font-weight: bold;
            color: #3f7dc0;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="centered" style="height: auto; padding-top: 40px;">
            <div class="welcome-text">
                INGRESA TUS DATOS
            </div>
            <asp:Label ID="LblMensajeN" runat="server" CssClass="show" Visible="false"></asp:Label>
            <div class="container mt-4">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtNombre" class="form-label">Nombre</label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtApellidoPaterno" class="form-label">Apellido Paterno</label>
                        <asp:TextBox ID="txtApellidoPaterno" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvApellidoP" runat="server" ControlToValidate="txtApellidoPaterno" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtApellidoMaterno" class="form-label">Apellido Materno</label>
                        <asp:TextBox ID="txtApellidoMaterno" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvApellidoM" runat="server" ControlToValidate="txtApellidoMaterno" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtFechaNacimiento" class="form-label">Fecha Nacimiento</label>
                        <asp:TextBox ID="txtFechaNacimiento" runat="server" TextMode="Date" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvFechaCumpleanios" runat="server" ControlToValidate="txtFechaNacimiento" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="ddlTipoPersona" class="form-label">Tipo de Persona</label>
                        <asp:DropDownList ID="ddlTipoPersona" runat="server" CssClass="form-select">
                            <asp:ListItem Text="-- Selecciona una opción --" Value="" />
                            <asp:ListItem Text="Física" Value="Física" />
                            <asp:ListItem Text="Moral" Value="Moral" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvTipoPersona" runat="server" ControlToValidate="ddlTipoPersona" InitialValue="" ErrorMessage="Selecciona un tipo de persona" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtCurp" class="form-label">CURP</label>
                        <asp:TextBox ID="txtCurp" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvCurp" runat="server" ControlToValidate="txtCurp" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtTelefono" class="form-label">Télefono</label>
                        <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvTelefono" runat="server" ControlToValidate="txtTelefono" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtEmail" class="form-label">Correo</label>
                        <asp:TextBox ID="txtEmail" TextMode="Email" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvCorreo" runat="server" ControlToValidate="txtEmail" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtFechaAlta" class="form-label">Fecha de Alta</label>
                        <asp:TextBox ID="txtFechaAlta" TextMode="Date" runat="server" CssClass="form-control" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtContrasena" class="form-label">Contraseña</label>
                        <asp:TextBox ID="txtContrasena" TextMode="Password" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvContrasena" runat="server" ControlToValidate="txtContrasena" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtColonia" class="form-label">Colonia</label>
                        <asp:TextBox ID="txtColonia" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvColonia" runat="server" ControlToValidate="txtColonia" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtDireccion" class="form-label">Dirección</label>
                        <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvDireccion" runat="server" ControlToValidate="txtDireccion" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtCP" class="form-label">Código Postal</label>
                        <asp:TextBox ID="txtCP" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfCP" runat="server" ControlToValidate="txtCP" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                </div>
                <h5 class="mt-4">Facturación</h5>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtRFC" class="form-label">RFC</label>
                        <asp:TextBox ID="txtRFC" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvRFC" runat="server" ControlToValidate="txtRFC" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtRFCFacturacion" class="form-label">RFC Facturación</label>
                        <asp:TextBox ID="txtRFCFacturacion" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvRFCFacturacion" runat="server" ControlToValidate="txtRFCFacturacion" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtNombreRazonSocial" class="form-label">Nombre / Razón Social</label>
                        <asp:TextBox ID="txtNombreRazonSocial" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvNombreRazonSocial" runat="server" ControlToValidate="txtNombreRazonSocial" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtCPFacturacion" class="form-label">CP Facturación</label>
                        <asp:TextBox ID="txtCPFacturacion" runat="server" CssClass="form-control" />
                        <asp:RequiredFieldValidator ID="rfvCPFacturacion" runat="server" ControlToValidate="txtCPFacturacion" InitialValue="" ErrorMessage="Este campo es obligatorio" CssClass="text-danger" />
                    </div>
                    <div class="row g-3 align-items-end">
                        <div class="col-md-6 mb-3">
                            <label for="ddlRegimenFiscal" class="form-label">Régimen Fiscal</label>
                            <asp:DropDownList ID="ddlRegimenFiscal" runat="server" CssClass="form-select">
                                <asp:ListItem Text="-- Selecciona una opción --" Value="" />
                                <asp:ListItem Text="General de Ley Personas Morales" Value="601" />
                                <asp:ListItem Text="Personas Físicas con Actividades Empresariales" Value="612" />
                                <asp:ListItem Text="Régimen Simplificado de Confianza" Value="626" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvRegimenFiscal" runat="server" ControlToValidate="ddlRegimenFiscal" InitialValue="" ErrorMessage="Selecciona una opción" CssClass="text-danger" />
                        </div>
                        <div class="col-md-3 mb-3">
                            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary w-100" OnClick="btnGuardar_Click" />
                        </div>
                        <div class="col-md-3 mb-3">
                            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-danger w-100" OnClick="btnCancelar_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
