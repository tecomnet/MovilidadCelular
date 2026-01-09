<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VinculacionCurp.aspx.vb" Inherits="WebClient.VinculacionCurp" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Vinculación CURP</title>

    <style>
        body {
            margin: 0;
            background: #eef2f7;
            font-family: 'Segoe UI', sans-serif;
        }

        .contenedor {
            max-width: 900px;
            margin: 30px auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,.1);
        }

        h2 {
            margin-top: 0;
            color: #1f2937;
        }

        .info-web {
            background: #f1f5f9;
            border-left: 5px solid #2563eb;
            padding: 15px;
            margin-bottom: 25px;
            font-size: 14px;
            color: #1e293b;
        }

        .pasos {
            display: flex;
            gap: 20px;
        }

        .paso {
            flex: 1;
            background: #e8f0fe;
            padding: 20px;
            border-radius: 8px;
            font-weight: 600;
            color: #1e3a8a;
            text-align: center;
        }

        .opcion-movil {
            margin-top: 30px;
            padding: 20px;
            background: #f8fafc;
            border-radius: 8px;
            border: 1px dashed #c7d2fe;
        }

            .opcion-movil h3 {
                margin-top: 0;
                color: #374151;
            }

        .qr-box {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-top: 15px;
        }

        .qr {
            width: 140px;
            height: 140px;
            background: repeating-linear-gradient( 45deg, #000, #000 10px, #fff 10px, #fff 20px );
        }

        .paso-click {
            cursor: pointer;
            transition: all 0.2s ease;
        }

            .paso-click:hover {
                background: #dbeafe;
                transform: translateY(-2px);
            }

            .paso-click:active {
                transform: scale(0.98);
            }

        .camara-container {
            position: relative;
            width: 420px;
            height: 315px;
            margin: 25px auto;
            border-radius: 10px;
            overflow: hidden;
            background: black;
        }

            .camara-container video {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

        .overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            border: 3px solid #22c55e;
            pointer-events: none;
        }

        .ovalo {
            width: 200px;
            height: 260px;
            border-radius: 50%;
            display: none;
        }

        .cuadrado {
            width: 260px;
            height: 170px;
            border-radius: 8px;
            display: none;
        }

        .mensaje-camara {
            position: absolute;
            bottom: 10px;
            width: 100%;
            text-align: center;
            color: white;
            font-weight: bold;
            background: rgba(0,0,0,.5);
            padding: 6px;
            font-size: 14px;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">

        <div class="contenedor">

            <h2>Verificación de identidad</h2>

            <div class="info-web">
                Está realizando este proceso desde una <strong>computadora</strong>.
            Para continuar con la vinculación de su CURP es necesario completar
            la verificación de identidad.
            </div>

            <div class="pasos">
                <div id="pasoRostro" class="paso paso-click" onclick="abrirCamara('rostro')">
                    📷 Paso 1<br />
                    Tome una fotografía de su rostro
                </div>

                <div id="pasoCredencial" class="paso paso-click" onclick="abrirCamara('credencial')">
                    🪪 Paso 2<br />
                    Tome una fotografía con su credencial
                </div>
            </div>



            <div class="camara-container" id="camaraContainer" style="display: none;">
                <video id="video" autoplay playsinline></video>

                <div id="overlayRostro" class="overlay ovalo"></div>
                <div id="overlayCredencial" class="overlay cuadrado"></div>

                <div class="mensaje-camara" id="mensajeCamara"></div>
            </div>

            <div class="opcion-movil">
                <h3>¿Su computadora no tiene cámara?</h3>
                <p>
                    Puede continuar el proceso desde su teléfono móvil
                escaneando el siguiente código QR.
                </p>

                <div class="qr-box">
                    <div class="qr"></div>
                    <div>
                        <strong>Escanee el código con su celular</strong><br />
                        La verificación continuará en su dispositivo móvil.
                    </div>
                </div>
            </div>

        </div>

    </form>
    <script>
        let streamActual = null;
        let rostroCompleto = false;
        let credencialCompleta = false;

        function abrirCamara(tipo) {

            if (tipo === 'credencial' && !rostroCompleto) {
                alert("Primero debe completar la fotografía del rostro.");
                return;
            }

            document.getElementById("camaraContainer").style.display = "block";
            document.getElementById("overlayRostro").style.display = "none";
            document.getElementById("overlayCredencial").style.display = "none";

            if (tipo === 'rostro') {
                document.getElementById("overlayRostro").style.display = "block";
                document.getElementById("mensajeCamara").innerText =
                    "Alinee su rostro dentro del óvalo";
            } else {
                document.getElementById("overlayCredencial").style.display = "block";
                document.getElementById("mensajeCamara").innerText =
                    "Coloque su credencial dentro del recuadro";
            }

            if (!streamActual) {
                navigator.mediaDevices.getUserMedia({ video: true })
                    .then(stream => {
                        streamActual = stream;
                        document.getElementById("video").srcObject = stream;
                    })
                    .catch(() => alert("No se pudo acceder a la cámara."));
            }

            // Simulación de captura
            setTimeout(function () {

                if (tipo === 'rostro') {
                    rostroCompleto = true;
                    marcarPasoCompleto("pasoRostro");
                } else {
                    credencialCompleta = true;
                    marcarPasoCompleto("pasoCredencial");
                }

                cerrarCamara();

            }, 3000);
        }

        function cerrarCamara() {
            if (streamActual) {
                streamActual.getTracks().forEach(track => track.stop());
                streamActual = null;
            }

            document.getElementById("video").srcObject = null;
            document.getElementById("camaraContainer").style.display = "none";
        }

        function marcarPasoCompleto(idPaso) {
            let paso = document.getElementById(idPaso);
            paso.style.background = "#dcfce7";
            paso.style.color = "#166534";
            paso.innerHTML += "<br />✔ Completado";
        }
    </script>
</body>
</html>
