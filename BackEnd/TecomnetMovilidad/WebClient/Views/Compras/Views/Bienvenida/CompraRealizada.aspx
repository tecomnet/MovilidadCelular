<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="CompraRealizada.aspx.vb" Inherits="WebClient.CompraRealizada" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Compra Realizada</title>
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

    .subtitle-text {
        font-size: 18px;
        color: #333333;
        text-align: center;
        max-width: 500px;
    }

    .store-buttons img {
        width: 150px;
        margin: 0 10px;
    }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="centered" style="height: auto; padding-top: 40px;">
            <div class="welcome-text">
                GRACIAS POR TU  COMPRA 😊 
            </div>
            <div class="subtitle-text" style="margin-bottom: 20px;">
               Descarga nuestra app escaneando el código QR. Asegúrate de estar conectado a la red.
            </div>

            <div class="mt-3">
                <img src='<%= ResolveUrl("~/Resources/Imagenes/codigo-qr.png") %>' alt="QR de pago" class="img-fluid" style="width:200px; height:auto;" />
            </div>

            <div class="mb-4">
                <a href='<%= ResolveUrl("~/Resources/Imagenes/codigo-qr.png") %>' download="codigo-qr.png" class="btn btn-success">
                    Descargar QR
                </a>
            </div>

          <div class="store-buttons d-flex justify-content-center gap-2">
    <a href="https://play.google.com/store/apps/details?id=com.tuapp" target="_blank">
        <img src="https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png" 
             alt="Google Play" style="height:60px;" />
    </a>

    <a href="https://apps.apple.com/app/idTU_APP_ID" target="_blank">
        <img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" 
             alt="App Store" style="height:60px;" />
    </a>
</div>

        </div>
    </form>
</body>
</html>
