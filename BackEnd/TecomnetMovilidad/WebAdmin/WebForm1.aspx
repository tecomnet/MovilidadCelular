<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="WebForm1.aspx.vb" Inherits="WebAdmin.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="margin:20px;">
            <h2>Descifrar contraseña AES de flutter</h2>
            
            <asp:Label ID="Label1" runat="server" Text="Cadena Encriptada (Base64):"></asp:Label><br />
            <asp:TextBox ID="txtEncrypted" runat="server" Width="400px"></asp:TextBox><br /><br />

            <asp:Button ID="btnDecrypt" runat="server" Text="Descifrar" OnClick="btnDecrypt_Click" /><br /><br />

            <asp:Label ID="lblResult" runat="server" ForeColor="Green"></asp:Label>
        </div>
    </form>
</body>
</html>
