<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ValidaRecarga.aspx.vb" Inherits="WebClient.ValidaRecarga" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Éxito</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body {
            background-color: #f8f9fa;
        }

        .success-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            text-align: center;
        }

        .success-icon {
            font-size: 80px;
            color: #28a745;
            margin-bottom: 20px;
        }

        .success-title {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #343a40;
        }

        .success-message {
            font-size: 18px;
            color: #6c757d;
            margin-bottom: 30px;
        }

        .btn-home {
            background-color: #28a745;
            color: #fff;
            font-size: 16px;
            padding: 10px 25px;
            border-radius: 8px;
            text-decoration: none;
        }

        .btn-home:hover {
                background-color: #218838;
                color: #fff;
            }

        #countdown {
            font-weight: bold;
            color: #dc3545;
        }

        .success-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }

            .success-icon.success {
                color: #28a745;
            }

            .success-icon.error {
                color: #dc3545;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Panel ID="pnlSuccess" runat="server" CssClass="success-container" Visible="False">
            <div class="success-icon success">&#10004;</div>
            <div class="success-title">¡Transacción Exitosa!</div>
            <div class="success-message">
                Tu pago se ha procesado correctamente.<br />
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlExpired" runat="server" CssClass="success-container" Visible="False">
            <div class="success-icon error">&#10006;</div>
            <div class="success-title">Error al procesar la recarga</div>
        </asp:Panel>

       <%-- <script>
            var countdownEl = document.getElementById('countdown');
            if (countdownEl) {
                var time = 60;
                var interval = setInterval(function () {
                    time--;
                    countdownEl.innerText = time;
                    if (time <= 0) clearInterval(interval);
                }, 1000);
            }
        </script>
        <script>
            setTimeout(function () {
                location.reload();
            }, 65000);
        </script>--%>
    </form>
</body>
</html>
