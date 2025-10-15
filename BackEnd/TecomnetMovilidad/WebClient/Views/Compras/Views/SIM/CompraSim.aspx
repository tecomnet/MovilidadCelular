<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CompraSim.aspx.vb" Inherits="WebClient.CompraSim" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Comprar SIM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

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
        .subtitle-text {
            font-size: 18px;
            color: #333333;
            text-align: center;
            max-width: 500px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="centered" style="height: auto; padding-top: 40px;">
            <div class="welcome-text">CONFIRMA TU COMPRA</div>
            <div class="card p-4 mb-3" style="width: 400px;">
                <h5>Datos del Cliente</h5>
                <p><strong>Nombre:</strong> <asp:Label ID="lblNombre" runat="server" /></p>
                <p><strong>Email:</strong> <asp:Label ID="lblEmail" runat="server" /></p>
                <p><strong>Télefono:</strong> <asp:Label ID="lblTelefono" runat="server" /></p>

                <h5 class="mt-3">Plan Seleccionado</h5>
                <p><strong>Nombre del Plan:</strong> <asp:Label ID="lblPlanNombre" runat="server" /></p>
                <p><strong>Descripción:</strong> <asp:Label ID="lblPlanDescripcion" runat="server" /></p>
                <p><strong>Datos:</strong> <asp:Label ID="lblPlanDatos" runat="server" /></p>
                <p><strong>Minutos:</strong> <asp:Label ID="lblPlanMinutos" runat="server" /></p>
                <p><strong>SMS:</strong> <asp:Label ID="lblPlanSMS" runat="server" /></p>
                <p><strong>Precio:</strong> <asp:Label ID="lblPlanPrecio" runat="server" /></p>
            </div>         

            <div class="d-flex gap-2 justify-content-center mt-3">
                <asp:Button ID="btnPagar" runat="server" Text="Pagar" CssClass="btn btn-primary" OnClick="btnPagar_Click" />
            </div>
        </div>

        <asp:Panel ID="pnlPago" runat="server" Style="display: none;">
            <div class="modal fade" id="modalPago" tabindex="-1" aria-labelledby="modalPagoLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modalPagoLabel">Pago Seguro</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                        </div>
                        <div class="modal-body">
                            <iframe id="iframePago" runat="server" style="width: 100%; height: 400px; border: none;"></iframe>
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <script type="text/javascript">
            function abrirModal() {
                var myModal = new bootstrap.Modal(document.getElementById('modalPago'));
                myModal.show();
            }
        </script>
    </form>
</body>
</html>
