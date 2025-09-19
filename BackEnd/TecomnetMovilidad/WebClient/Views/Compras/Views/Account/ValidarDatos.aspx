<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ValidarDatos.aspx.vb" Inherits="WebClient.ValidarDatos" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Confirmar Datos</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
    <div class="container mt-5">
    <form id="form1" runat="server" class="container mt-5">
        <h3>Confirma tus datos</h3>
        <table class="table table-bordered mt-3">
            <tr><th>Nombre</th><td><asp:Label ID="lblNombre" runat="server" /></td></tr>
            <tr><th>Apellido Paterno</th><td><asp:Label ID="lblApellidoPaterno" runat="server" /></td></tr>
            <tr><th>Apellido Materno</th><td><asp:Label ID="lblApellidoMaterno" runat="server" /></td></tr>
            <tr><th>Fecha Nacimiento</th><td><asp:Label ID="lblFechaNacimiento" runat="server" /></td></tr>
            <tr><th>Tipo Persona</th><td><asp:Label ID="lblTipoPersona" runat="server" /></td></tr>
            <tr><th>CURP</th><td><asp:Label ID="lblCURP" runat="server" /></td></tr>
            <tr><th>Teléfono</th><td><asp:Label ID="lblTelefono" runat="server" /></td></tr>
            <tr><th>Email</th><td><asp:Label ID="lblEmail" runat="server" /></td></tr>
            <tr><th>Dirección</th><td><asp:Label ID="lblDireccion" runat="server" /></td></tr>
            <tr><th>Colonia</th><td><asp:Label ID="lblColonia" runat="server" /></td></tr>
            <tr><th>CP</th><td><asp:Label ID="lblCP" runat="server" /></td></tr>
            <tr><th>RFC</th><td><asp:Label ID="lblRFC" runat="server" /></td></tr>
            <tr><th>Régimen Fiscal</th><td><asp:Label ID="lblRegimenFiscal" runat="server" /></td></tr>
        </table>

         <div class="row g-2 justify-content-start mt-3">
        <div class="col-auto">
            <asp:Button ID="btnRegresar" runat="server" Text="Regresar" CssClass="btn btn-secondary w-100" OnClick="btnRegresar_Click" />
        </div>
    <div class="col-auto">
            <asp:Button ID="btnConfirmar" runat="server" Text="Confirmar" CssClass="btn btn-primary w-100" OnClick="btnConfirmar_Click" />
             </div>
             </div>
    </form>
        </div>
</body>
</html>
