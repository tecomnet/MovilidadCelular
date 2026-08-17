<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="VinculacionCurp.aspx.vb" Inherits="WebClient.VinculacionCurp" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <title>Registro de líneas móviles | TECOMNET</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, Arial, Helvetica, sans-serif;
            background-color: #f4f6f9;
        }

        .container {
            background: linear-gradient(135deg, #1f4fb2, #2563eb);
            color: white;
            padding: 60px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            min-height: 350px;
        }

        .content {
            max-width: 55%;
        }

        h1 {
            font-size: 34px;
            margin-bottom: 15px;
        }

        p {
            font-size: 16px;
            line-height: 1.6;
        }

        .fecha {
            margin-top: 10px;
            font-weight: bold;
        }

        .buttons {
            margin-top: 30px;
        }

        .btn {
            padding: 12px 22px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 15px;
            margin-right: 10px;
        }

        .btn-primary {
            background-color: white;
            color: #1f4fb2;
            font-weight: bold;
        }

        .btn-secondary {
            background-color: transparent;
            color: white;
            border: 1px solid white;
        }

        .logo img {
            max-width: 400px;
            height: auto;
        }

        .cards-container {
            display: flex;
            gap: 20px;
            margin-top: 30px;
            box-sizing: border-box;
        }

        .card {
            background-color: #ffffff;
            border-radius: 10px;
            padding: 25px;
            flex: 1;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .card-h3 {
            margin-top: 0;
            color: #1f4fb2;
        }

        .card p {
            color: #333;
            line-height: 1.5;
        }

        @media (max-width: 768px) {
            .cards-container {
                flex-direction: column;
            }
        }

        .badge {
            display: inline-block;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
            margin-bottom: 10px;
            text-transform: capitalize;
            font-family: Arial, sans-serif;
        }

        .presencial-linea {
            background-color: #d9f2e6;
            color: #2a8a4f;
        }

        .main-content {
            max-width: 1200px;
            margin: 30px auto 60px auto;
            padding: 0 20px;
            box-sizing: border-box;
        }

        .accordion-container {
            display: flex;
            flex-direction: column;
            gap: 15px;
            max-width: 1200px;
            box-sizing: border-box;
        }

        .accordion-item {
            width: 100%;
            border: 1px solid #d0d7de;
            border-radius: 8px;
            background-color: #f8fafc;
        }

        .accordion-button {
            background: transparent;
            border: none;
            width: 100%;
            text-align: left;
            padding: 12px 16px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #24292f;
            border-radius: 8px;
        }

        .accordion-content {
            padding: 0 16px 16px 16px;
            display: none;
            font-size: 14px;
            color: #57606a;
        }

        .accordion-button.active + .accordion-content {
            display: block;
        }

        .arrow {
            transition: transform 0.3s ease;
        }

        .accordion-button.active .arrow {
            transform: rotate(180deg);
        }

        .footer {
            bottom: 0;
            left: 0;
            width: 100%;
            background-color: #e0e0e0;
            color: #333;
            text-align: center;
            padding: 12px 0;
            font-size: 14px;
            box-shadow: rgba(0,0,0,0.1);
            z-index: 1000;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="content">
                <h1>Registro de líneas móviles
                    <br />
                    TECOMNET</h1>
                <p>
                    Por disposición oficial, todas las líneas de telefonía móvil deberán registrarse 
                    con identificación oficial con fotografía y CURP.
                </p>
                <div class="fecha">
                    Fecha límite: 30 de Junio de 2026
                </div>
                <div class="buttons">
                    <asp:Button ID="btnRegistrar" runat="server" Text="Registrar mi línea" CssClass="btn btn-primary"  OnClick="btnRegistrar_Click"/>
                    <asp:Button ID="btnConsultar" runat="server" Text="Consultar Líneas Registradas" CssClass="btn btn-secondary" />
                </div>
            </div>
            <div class="logo">
                <asp:Image class="mb-4" ID="imgLogoTecomnet" runat="server" ImageUrl="~/Resources/Imagenes/LogoTecomnet.png" />
            </div>
        </div>
        <div class="main-content">
            <h2>¿Por que es necesario el registro?</h2>
            <p>
                Apartir del 09 de enero de 2026, todos los usuarios deberán vincular su línea celular a su identidad oficial
            como parte de una disposición obligatoria a nivel nacional.
            </p>
            <div class="cards-container">
                <div class="card">
                    <h3>📅 Fechas clave</h3>
                    <p>
                        <strong>Inicio:</strong> 09 de enero de 2026
                    <br />
                        <strong>Límite:</strong> 30 de junio  de 2026
                    </p>
                </div>
                <div class="card">
                    <h3>🚫 Suspención</h3>
                    <p>Apartir del 01 de julio de 2026, las líneas no registradas serán suspendidas hasta completar el trámite.</p>
                </div>
                <div class="card">
                    <h3>⚠️ Servicio limitado</h3>
                    <p>Durante la suspención solo se podrán realizar llamadas a número de emergencia y atención ciudadana.</p>
                </div>
            </div>
            <h2>¿Cómo puedo realizar el registro?</h2>
            <div class="cards-container">
                <div class="card">
                    <span class="badge presencial-linea">Presencial</span>
                    <h3>Centro de atención</h3>
                    <p>Acude a cualquier centro de atención a clientes a nivel nacional con tu identificación oficial vigente.</p>
                </div>
                <div class="card">
                    <span class="badge presencial-linea">En línea</span>
                    <h3>Modalidad Remota</h3>
                    <p>Realiza el trámite en línea con hasta3 intentos. Se solicitará una prueba de vida (selfie).</p>
                </div>
            </div>
            <h2>Preguntas frecuentes</h2>
            <div class="accordion-container">
                <div class="accordion-item">
                    <button class="accordion-button" type="button">
                        ¿Qué documentos necesito? <span class="arrow">&#9660;</span>
                    </button>
                    <div class="accordion-content">
                        INE, Pasaporte o CURP Biométrica vigentes. Extranjeros: Pasaporte o CURP temporal.
                    </div>
                </div>

                <div class="accordion-item">
                    <button class="accordion-button" type="button">
                        ¿Qué pasa si no reconozco una línea? <span class="arrow">&#9660;</span>
                    </button>
                    <div class="accordion-content">
                        Puedes acudir a cualquier centro de atención a clientes para realizar la aclaración o desvinculación.
                    </div>
                </div>

                <div class="accordion-item">
                    <button class="accordion-button" type="button">
                        ¿La desvinculación cancela mi contrato? <span class="arrow">&#9660;</span>
                    </button>
                    <div class="accordion-content">
                        No, solo se desvinculan los datos. El contrato continua vigente.
                    </div>
                </div>
            </div>
        </div>
        <footer class="footer">
            <p>TECOMNET © 2026 . Derechos reservados.</p>
        </footer>
    </form>
    <script>
        document.querySelectorAll('.accordion-button').forEach(button => {
            button.addEventListener('click', () => {
                button.classList.toggle('active');
            });
        });
    </script>

</body>
</html>
