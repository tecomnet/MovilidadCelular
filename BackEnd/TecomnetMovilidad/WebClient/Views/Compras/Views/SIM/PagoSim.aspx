<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="PagoSim.aspx.vb" Inherits="WebClient.PagoSim" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Pago de SIM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .centered {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            font-family: Arial, sans-serif;
            padding: 40px;
        }

        .card-payment {
            max-width: 500px;
            width: 100%;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

            .card-payment h4 {
                margin-bottom: 20px;
                text-align: center;
                color: #3f7dc0;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="centered">
            <div class="card-payment">
                <h4>Formulario de Pago</h4>

                <div class="mb-3">
                    <label for="txtNombreTarjeta" class="form-label">Nombre en la Tarjeta</label>
                    <asp:TextBox ID="txtNombreTarjeta" runat="server" CssClass="form-control" />
                </div>

                <div class="mb-3">
                    <label for="txtNumeroTarjeta" class="form-label">Número de Tarjeta</label>
                    <asp:TextBox ID="txtNumeroTarjeta" runat="server" CssClass="form-control" MaxLength="16" />
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="txtExpiracion" class="form-label">Fecha Expiración (MM/AA)</label>
                        <asp:TextBox ID="txtExpiracion" runat="server" CssClass="form-control" Placeholder="MM/AA" MaxLength="5" />
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="txtCVV" class="form-label">CVV</label>
                        <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control" MaxLength="3" />
                    </div>
                </div>

                <div class="d-grid gap-2 mt-3">
                    <asp:Button ID="btnPagar" runat="server" Text="Pagar" CssClass="btn btn-primary" OnClick="btnPagar_Click" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
