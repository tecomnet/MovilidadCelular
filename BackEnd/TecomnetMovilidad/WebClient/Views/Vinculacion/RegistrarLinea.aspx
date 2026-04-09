<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RegistrarLinea.aspx.vb" Inherits="WebClient.RegistrarLinea" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <title>Registrar línea móvil |  TECOMNET</title>
    <style>
        body {
            background-color: #f4f6f9;
        }

        .card-custom {
            max-width: 400px;
            width: 100%;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
            overflow: auto;
        }

        .card-custom2 {
            max-width: 95%;
            width: 100%;
            padding: 40px 30px;
            overflow: auto;
        }


        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255,255,255,0.85);
            display: none;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            z-index: 9999;
        }

        .otp-container {
            justify-content: center;
        }

        .otp-input {
            width: 45px;
            height: 55px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            border-radius: 8px;
            border: 1px solid #ced4da;
        }

        .select-box {
            display: flex;
            align-items: center;
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
            cursor: pointer;
            box-sizing: border-box;
            transition: 0.2s all;
        }

            .select-box input[type="radio"] {
                margin-right: 12px;
                flex-shrink: 0;
            }

            .select-box:hover {
                border-color: #2563eb;
                background-color: #e0f0ff;
            }

            .select-box input[type="radio"]:checked + span {
                font-weight: bold;
                color: #2563eb;
            }

        .aviso-privacidad {
            padding: 10px 12px;
            display: flex;
            align-items: flex-start;
            font-family: Arial, sans-serif;
            font-size: 13px;
            color: #333;
            max-width: 100%;
        }

            .aviso-privacidad input[type="checkbox"] {
                margin-top: 2px;
            }

            .aviso-privacidad label {
                margin-left: 8px;
                line-height: 1.4;
                text-align: justify;
            }

        .aviso-link {
            font-weight: bold;
            color: #1e73be;
        }

        .logo img {
            max-width: 400px;
            height: auto;
        }

        .logo2 img {
            max-width: 100px;
            height: auto;
        }

        .camara-simulada {
            width: 320px;
            height: 220px;
            border: 3px dashed #4B81C1;
            position: relative;
            background: rgba(0,0,0,0.05);
        }

        .scan-line {
            position: absolute;
            width: 100%;
            height: 3px;
            background: #4B81C1;
            animation: scan 2s infinite;
        }

        @keyframes scan {
            0% {
                top: 0;
            }

            50% {
                top: 95%;
            }

            100% {
                top: 0;
            }
        }

        .img-center {
            display: block;
            margin-left: auto;
            margin-right: auto;
        }

        .camara-rostro {
            width: 260px;
            height: 260px;
            border: 3px dashed #4B81C1;
            border-radius: 50%;
            position: relative;
            background-color: #f8f9fa;
            overflow: hidden;
        }

        .scan-circle {
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            box-shadow: inset 0 0 0 3px rgba(75, 129, 193, 0.3);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% {
                transform: scale(0.95);
                opacity: 0.6;
            }

            50% {
                transform: scale(1);
                opacity: 1;
            }

            100% {
                transform: scale(0.95);
                opacity: 0.6;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Panel ID="pnlRegistro" runat="server" Visible="true">
            <div class="d-flex justify-content-center align-items-center vh-100">
                <div class="card card-custom text-center">
                    <h2 class="mb-3">Registrar línea</h2>
                    <p class="mb-4">Ingresa tu número de teléfono para continuar con el registro.</p>

                    <asp:TextBox ID="txtNumeroTelefono" runat="server" CssClass="form-control mb-3" Placeholder="Ingresa tu número"></asp:TextBox>

                    <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="btn btn-primary w-100" OnClientClick="mostrarLoading('Enviando código de verificación...');" OnClick="btnRegistrar_Click" />

                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlCodigoVerificacion" runat="server" Visible="false">
            <div class="d-flex justify-content-center align-items-center vh-100">
                <div class="card card-custom text-center">
                    <h2 class="mb-3">Verificación</h2>
                    <p>Ingresa el código de 6 dígitos que enviamos a tu télefono</p>
                    <div class="d-flex justify-content-between gap-2 mb-3 otp-container">
                        <asp:TextBox ID="txtOtp1" runat="server" CssClass="otp-input" MaxLength="1" />
                        <asp:TextBox ID="txtOtp2" runat="server" CssClass="otp-input" MaxLength="1" />
                        <asp:TextBox ID="txtOtp3" runat="server" CssClass="otp-input" MaxLength="1" />
                        <asp:TextBox ID="txtOtp4" runat="server" CssClass="otp-input" MaxLength="1" />
                        <asp:TextBox ID="txtOtp5" runat="server" CssClass="otp-input" MaxLength="1" />
                        <asp:TextBox ID="txtOtp6" runat="server" CssClass="otp-input" MaxLength="1" />
                    </div>
                    <div class="text-center mb-3">
                        <span id="lblTiempo" class="text-muted">Reenviar código en <strong>00:30</strong></span>
                    </div>
                    <div class="text-center mb-3">
                        <asp:Button ID="btnReenviar" runat="server" Text="Reenviar SMS" CssClass="btn btn-link p-0" Enabled="false" />
                    </div>
                    <asp:Button ID="btnVerificar" runat="server" Text="Verificar Código" CssClass="btn btn-primary w-100" OnClientClick="mostrarLoading('Validando código...');" OnClick="btnVerificar_Click" />
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlNumeroRegistrar" runat="server" Visible="false">
            <div class="d-flex justify-content-center vh-100 overflow-auto pt-4">
                <div class="card card-custom text-justify">
                    <h6 class="mb-3">Número de TECOMNET a registrar</h6>
                    <asp:TextBox ID="txtNumeroTelefonoTecomnet" runat="server" CssClass="form-control mb-3" Text="5525304222" ReadOnly="true"></asp:TextBox>
                    <p><strong>Selecciona la identificación con la que deseas registrarte</strong></p>
                    <div class="mb-3">
                        <label class="select-box">
                            <input type="radio" name="lineas" />
                            <span>INE</span>
                        </label>
                    </div>
                    <div class="mb-3">
                        <label class="select-box">
                            <input type="radio" name="lineas" />
                            <span>Pasaporte mexicano</span>
                        </label>
                    </div>
                    <div class="mb-3">
                        <label class="select-box">
                            <input type="radio" name="lineas" />
                            <span>Pasaporte extranjero</span>
                        </label>
                    </div>
                    <div class="aviso-privacidad mt-3">
                        <asp:CheckBox ID="chkAviso" runat="server" />
                        <label for="chkAviso">
                            Reconozco que he tenido a mi disposición el
        <span class="aviso-link">Aviso de Privacidad</span>
                            y otorgo mi consentimiento para que mis datos personales
        sean tratados para las finalidades previstas.
                        </label>
                    </div>
                    <asp:Button ID="btnContinuar" runat="server" Text="Continuar" CssClass="btn btn-primary w-100 mt-3" OnClientClick="mostrarLoading('Cargando...');" OnClick="btnContinuar_Click" />
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlVerificarDocumento" runat="server" Visible="false">
            <div class="d-flex justify-content-center align-items-center vh-100">
                <div class="card card-custom2 text-left p-4">
                    <div class="logo2 d-flex align-items-end gap-5">
                        <asp:Image class="mb-4" ID="imgLogoTecomnet" runat="server" ImageUrl="~/Resources/Imagenes/LogoTecomnetColor.png" CssClass="mb-0" />
                        <h2 class="mb-2" style="color: #4B81C1;">Verifica tu documento</h2>
                    </div>
                    <p class="mb-3 text-muted" style="margin-left: calc(135px + 1rem);">Encuadra bien tu documento en el rectangulo y la captura se realizara de forma automatica</p>
                    <asp:Image class="mb-4" ID="imgVerificarDocumento" runat="server" ImageUrl="~/Resources/Imagenes/verificaDocumento.png" CssClass="mb-0" Width="300px" Height="250px" Style="margin-left: calc(135px + 1rem);" />
                    <div class="d-flex justify-content-end gap-2 mt-3">
                        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary btn-sm" Style="width: 90px;" />
                        <asp:Button ID="btnContinuarDocumento" runat="server" Text="Continuar" CssClass="btn btn-primary btn-sm" Style="width: 90px;" OnClick="btnContinuarDocumento_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlCamaraFrente" runat="server" Visible="false">
            <div class="d-flex justify-content-center align-items-center vh-100">
                <div class="card card-custom2 text-left p-4" style="width: 450px;">
                    <h4 class="mb-2" style="color: #4B81C1;">
                        <asp:Label ID="lblTituloCamara" runat="server" Text="Escanea el frente de tu credencial" />
                    </h4>
                    <p class="text-muted mb-3">
                        <asp:Label ID="lblDescripcionCamara" runat="server" Text="Coloca la credencial dentro del rectángulo" />
                    </p>
                    <div class="camara-simulada mx-auto">
                        <div class="scan-line"></div>
                    </div>
                    <div class="text-end mt-3">
                        <asp:Button ID="btnSimularCaptura" runat="server" Text="Capturar" CssClass="btn btn-primary btn-sm" OnClick="btnSimularCaptura_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlCamaraReverso" runat="server" Visible="false">
            <div class="d-flex justify-content-center align-items-center vh-100">
                <div class="card card-custom2 text-left p-4" style="width: 450px;">
                    <h4 class="mb-2" style="color: #4B81C1;">
                        <asp:Label ID="lblTituloCamaraReverso" runat="server" Text="Escanea el reverso de tu credencial" />
                    </h4>
                    <p class="text-muted mb-3">
                        <asp:Label ID="lblDescripcionCamaraReverso" runat="server" Text="Coloca la credencial dentro del rectángulo" />
                    </p>
                    <div class="camara-simulada mx-auto">
                        <div class="scan-line"></div>
                    </div>
                    <div class="text-end mt-3">
                        <asp:Button ID="btnSimularCapturaReverso" runat="server" Text="Capturar" CssClass="btn btn-primary btn-sm" OnClick="btnSimularCapturaReverso_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlConfirmarCaptura" runat="server" Visible="false">
            <div class="d-flex justify-content-center align-items-center vh-100">
                <div class="card card-custom2 text-left p-4" style="width: 450px;">
                    <h4 class="mb-2 text-success">📸 Captura realizada
                    </h4>

                    <p class="text-muted mb-3">
                        ¿Deseas continuar con este resultado o repetir la captura?
                    </p>

                    <div class="camara-simulada mx-auto mb-3" style="opacity: 0.5;">
                        <span class="position-absolute top-50 start-50 translate-middle text-muted">Imagen capturada
                        </span>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-3">
                        <asp:Button ID="btnRepetirCaptura" runat="server" Text="Repetir" CssClass="btn btn-outline-secondary btn-sm" />
                        <asp:Button ID="btnContinuarCaptura" runat="server" Text="Continuar" CssClass="btn btn-primary btn-sm" OnClick="btnContinuarCaptura_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlPruebaVida" runat="server" Visible="false">
            <div class="d-flex justify-content-center vh-100 overflow-auto pt-4">
                <div class="card card-custom text-justify">
                    <asp:Image class="mb-4" ID="imgIdentidad" runat="server" ImageUrl="~/Resources/Imagenes/identidad.png" CssClass="mb-0 img-center" Width="120px" />
                    <h2 class="mb-3 text-center">Verificación identidad</h2>
                    <p>Para continuar con el registro, necesitamos una fotografía de tu rostro para validar tu identidad.</p>
                    <p>✅ Colocate en un lugar con <strong>buena iluminación.</strong></p>
                    <p>✅ Asegurate de que tu <strong>rostro esté completamente visible.</strong></p>
                    <p><strong>✅ No uses lentes, </strong>gorras o accesorios.</p>
                    <p>✅ Mantén una <strong>expresión natural.</strong></p>
                    <asp:Button ID="btnContinuarVerificacionIdentidad" runat="server" Text="Continuar" CssClass="btn btn-primary w-100" OnClientClick="mostrarLoading('Cargando...');" OnClick="btnContinuarVerificacionIdentidad_Click" />
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlCapturarRostro" runat="server" Visible="false">
            <div class="d-flex justify-content-center align-items-center vh-100">
                <div class="card card-custom2 text-left p-4" style="width: 450px;">
                    <h4 class="mb-2" style="color: #4B81C1;">
                        <asp:Label ID="lblTituloRostro" runat="server" Text="Centra tu rostro"></asp:Label>
                    </h4>
                    <p class="text-muted mb-3">
                        <asp:Label ID="lblDescripcionRostro" runat="server" Text="Mantén una expresión natural y no sonrías."></asp:Label>
                    </p>
                    <div class="camara-rostro mx-auto">
                        <div class="scan-circle"></div>
                    </div>
                    <div class="text-end mt-3">
                        <asp:Button ID="btnSimularRostro" runat="server" Text="Capturar Rostro" CssClass="btn btn-primary btn-sm" OnClientClick="mostrarLoading('Cargando...');" OnClick="btnSimularRostro_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlConfirmarDatos" runat="server" Visible="false">
            <div class="d-flex justify-content-center vh-100 overflow-auto pt-4">
                <div class="card card-custom2 text-left p-4" style="width: 450px;">
                    <h3 class="mb-3 text-center">Revisa que tus datos sean correctos</h3>
                    <label class="mb-2">Nombre(s)</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control mb-3" Text="Valentina" ReadOnly="true"></asp:TextBox>
                    <label class="mb-2">Apellido Paterno</label>
                    <asp:TextBox ID="txtApellidoP" runat="server" CssClass="form-control mb-3" Text="Zaragoza" ReadOnly="true"></asp:TextBox>
                    <label class="mb-2">Apellido Materno</label>
                    <asp:TextBox ID="txtApellidoM" runat="server" CssClass="form-control mb-3" Text="Pérez" ReadOnly="true"></asp:TextBox>
                    <label class="mb-2">Fecha de Nacimiento</label>
                    <asp:TextBox ID="txtFechaNacimiento" runat="server" CssClass="form-control mb-3" Text="01 de julio del 2003" ReadOnly="true"></asp:TextBox>
                    <label class="mb-2">Género</label>
                    <asp:TextBox ID="txtGenero" runat="server" CssClass="form-control mb-3" Text="Femenino" ReadOnly="true"></asp:TextBox>
                    <label class="mb-2">Entidad de nacimiento</label>
                    <asp:TextBox ID="txtEntidadNacimiento" runat="server" CssClass="form-control mb-3" Text="Puebla" ReadOnly="true"></asp:TextBox>
                    <label class="mb-2">CURP</label>
                    <asp:TextBox ID="txtCurp" runat="server" CssClass="form-control mb-3" Text="ZAPE030701MPLRRMA1" ReadOnly="true"></asp:TextBox>
                    <label class="mb-2">INE (IDMEX 10 dígitos)</label>
                    <asp:TextBox ID="txtIne" runat="server" CssClass="form-control mb-3" Text="1243567845" ReadOnly="true"></asp:TextBox>
                    <div class="aviso-privacidad mb-1">
                        <asp:CheckBox ID="chkConfirmoDatos" runat="server" />
                        <label for="chkConfirmoDatos">
                            He revisado mis datos y confirmo que son correctos.                           
                        </label>
                    </div>
                    <asp:Button ID="btnConfirmarDatos" runat="server" Text="Continuar" CssClass="btn btn-primary w-100" OnClientClick="mostrarLoading('Cargando...');" OnClick="btnConfirmarDatos_Click" />
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlRegistroExitoso" runat="server" Visible="false">
            <div class="d-flex justify-content-center align-items-center vh-100">
                <div class="card card-custom text-center">
                    <asp:Image class="mb-4" ID="imgExito" runat="server" ImageUrl="~/Resources/Imagenes/exito.png" CssClass="mb-0 img-center" Width="120px" />
                    <h3 class="mb-3 text-center">Registro y vinculación exitoso</h3>
                    <p>Tus datos han sido verificados y vinculados correctamente. Ya puedes continuar y disfrutar de todas las funcionalidades del sistema.</p>
                    <asp:Button ID="btnFinal" runat="server" Text="Continuar" CssClass="btn btn-primary w-100" OnClientClick="mostrarLoading('Cargando...');" />
                </div>
            </div>
        </asp:Panel>
        <div id="loadingOverlay" class="loading-overlay">
            <div class="spinner-border text-primary" role="status"></div>
            <p class="mt-3" id="loadingText">Cargando...</p>
        </div>
    </form>
    <script>
        function mostrarLoading(mensaje) {
            document.getElementById('loadingText').innerText = mensaje;
            document.getElementById('loadingOverlay').style.display = 'flex';
        }

        function ocultarLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
        }
    </script>
    <script>
        document.querySelectorAll('.otp-input').forEach((input, index, inputs) => {
            input.addEventListener('input', () => {
                if (input.value.length === 1 && inputs[index + 1]) {
                    inputs[index + 1].focus();
                }
            });

            input.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace' && !input.value && inputs[index - 1]) {
                    inputs[index - 1].focus();
                }
            });
        });
    </script>
    <script>
        let tiempo = 30;
        const lbl = document.getElementById('lblTiempo');
        const btn = document.getElementById('<%= btnReenviar.ClientID %>');

        const interval = setInterval(() => {
            tiempo--;

            const segundos = tiempo < 10 ? '0' + tiempo : tiempo;
            lbl.innerHTML = `Reenviar código en <strong>00:${segundos}</strong>`;

            if (tiempo <= 0) {
                clearInterval(interval);
                lbl.innerHTML = '¿No recibiste el código?';
                btn.disabled = false;
            }
        }, 1000);
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
