<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="recargas.aspx.vb" Inherits="WebClient.recargasLogin" Culture="es-MX" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>TECOMNET - Recarga</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }

        .recarga-box {
            border: 2px solid #198754;
            border-radius: 10px;
            background-color: #fff;
        }

        .recarga-header {
            font-size: 28px;
            font-weight: bold;
        }

        .promo-title {
            font-weight: 600;
            font-size: 14px;
            color: #6c757d;
        }

        .promo-value {
            font-size: 20px;
            font-weight: bold;
            color: #212529;
        }

        footer {
            background-color: #003575ff;
            color: white;
            padding: 15px 0;
            margin-top: 40px;
        }

        .containerTittle {
            background: #3f7dc0;
            font-size: 20px;
            color: white;
            padding-top: 20px;
            padding-bottom: 20px;
        }

        .containerWizzard {
            background-color: white;
            padding-bottom: 20px;
        }

        .btn-custom {
            background-color: #3f7dc0;
            border-color: #3f7dc0;
            font-weight: bold;
            color: white;
        }

            .btn-custom:hover {
                background-color: #233251;
                border-color: #233251;
                color: white;
            }

        .containerPay {
            text-align: center;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            margin-top: 3em;
            margin-left: auto;
            margin-right: auto;
        }

        .h1Successfull {
            color: #3f7dc0;
        }

        .pSuccessfull {
            color: #555;
        }

        .buttonSuccessfull {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            background-color: #3f7dc0;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
        }

        .buttonSusscess:hover {
            background-color: #233251;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="d-flex justify-content-between align-items-center m-2">
            <div class="d-flex align-items-center gap-2">
                <img height="40" src='<%= ResolveUrl("~/Resources/Imagenes/Logo.png") %>' />
                <img height="40" src='<%= ResolveUrl("~/Resources/Imagenes/BYD-Logo.png") %>' />
                <img height="40" src='<%= ResolveUrl("~/Resources/Imagenes/Logo-Altan.jpeg") %>' />
            </div>
            <asp:Panel ID="pnlSalir" runat="server" Visible="False">
                <a href='<%= ResolveUrl("~/Views/Recargas/Inicio/recargas.aspx") %>' class="text-dark" title="Salir">
                    <i class="bi bi-box-arrow-right fs-3"></i>
                </a>
            </asp:Panel>
        </div>
        <hr />

        <contenttemplate>
            <asp:HiddenField ID="hfMSISDN" runat="server" />
            <asp:HiddenField ID="hfICCID" runat="server" />
            <div class="container mt-4 text-center">
                <div>
                    <h2 class="pb-4">En <strong>TECOMNET</strong> siempre tenemos los mejores precios.</h2>
                </div>
                <div id="ErrorMessageDiv" runat="server" class="alert alert-danger alert-dismissible fade show text-center" visible="false">
                    <asp:Literal runat="server" ID="FailureText" />
                </div>
                <asp:Panel runat="server" ID="pnlNumero" DefaultButton="btnValidaPhoneNumber" CssClass="containerWizzard">
                    <div class="containerTittle fw-bold">
                        Ingresa tú número
                       
                    </div>
                    <div class="mb-3 pt-3">
                        <label for="txtPhonenumber" class="form-label fw-bold">Número de teléfono</label>
                        <asp:TextBox ID="txtPhonenumber" runat="server" placeholder="Introduce tu número a 10 dígitos" TextMode="Number"
                            CssClass="form-control m-auto" MaxLength="10" Width="300px"></asp:TextBox>
                        <label for="txtConfirmPhonenumber" class="form-label fw-bold">Confirma número de teléfono</label>
                        <asp:TextBox ID="txtConfirmPhonenumber" runat="server" placeholder="Introduce tu número a 10 dígitos" TextMode="Number"
                            CssClass="form-control m-auto" MaxLength="10" Width="300px"></asp:TextBox>
                    </div>
                    <asp:Button ID="btnValidaPhoneNumber" runat="server" CssClass="btn btn-custom" Text="Continuar" ValidationGroup="ValidationPhonenumber" OnClick="btnValidaPhoneNumber_Click" />
                    <div class="mt-2">
                        <asp:ValidationSummary ID="Validation" runat="server" CssClass="alert alert-danger alert-dismissible fade show" ValidationGroup="ValidationPhonenumber" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhonenumber" ValidationGroup="ValidationPhonenumber" ErrorMessage="La número es obligatorio." Display="None"></asp:RequiredFieldValidator>
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtConfirmPhonenumber" ValidationGroup="ValidationPhonenumber" ErrorMessage="La confirmación del número es obligatoria." Display="None"></asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="CompareValidator1" runat="server"
                            ControlToValidate="txtPhonenumber" ControlToCompare="txtConfirmPhonenumber" ErrorMessage="El número  ingresado no existe"
                            Operator="Equal" Type="Integer" Display="None" ValidationGroup="ValidationPhonenumber">
                            </asp:CompareValidator>

                        <asp:RegularExpressionValidator ID="revPhonenumber" runat="server"
                            ControlToValidate="txtPhonenumber"
                            ValidationExpression="^\d{10}$"
                            ErrorMessage="Debe ingresar exactamente 10 dígitos numéricos"
                            Display="None" ValidationGroup="ValidationPhonenumber">
                            </asp:RegularExpressionValidator>
                        <asp:RegularExpressionValidator ID="revConfirmPhonenumber" runat="server"
                            ControlToValidate="txtConfirmPhonenumber"
                            ValidationExpression="^\d{10}$"
                            ErrorMessage="Debe ingresar exactamente 10 dígitos numéricos"
                            Display="None" ValidationGroup="ValidationPhonenumber">
                            </asp:RegularExpressionValidator>
                    </div>
                </asp:Panel>
                <asp:Panel runat="server" ID="pnlRecarga" CssClass="containerWizzard" Visible="false">
                    <div class="row">
                        <h5 class="pb-2 text-center" style="background-color: #f8f9fa; color: #3f7dc0">Costo de plataforma: 3.5%
                        </h5>
                        <asp:ListView ID="lvOffer" runat="server" DataKeyNames="OfertaID,PrecioRecurrente">
                            <ItemTemplate>
                                <div class="col-sm-6 pb-3">
                                    <div class="card shadow-sm recarga-box">
                                        <div class="card-header text-center text-light" style="background-color: #34857c">
                                            <label class="recarga-header"><%# Eval("Oferta") %></label>
                                        </div>
                                        <div class="card-body text-center">
                                            <div class="col-md-12">
                                                <label class="promo-title">Incluye</label>
                                                <label class="promo-value"><%# String.Format("{0} MB", Eval("Descripcion")) %></label>
                                            </div>
                                            <div class="col-md-12">
                                                <label class="promo-title">Costo</label>
                                                <label class="promo-value"><%# String.Format("{0:C2} MXN", Eval("PrecioRecurrente")) %></label>
                                            </div>
                                            <div class="text-center">
                                                <asp:Button ID="btnPay" runat="server" Text="Lo quiero" CssClass="btn btn-primary" CommandName="Pay" CommandArgument='<%# Eval("OfertaID") %>' OnClick="btnPay_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:ListView>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlValidate" runat="server" Visible="false" CssClass="containerPay">
                    <h1 runat="server" id="h1Tittle"></h1>
                    <p runat="server" id="pMessage"></p>
                    <asp:HyperLink NavigateUrl="~/Views/Recargas/recargas.aspx" ID="hlButton" runat="server" Text="Volver a la página principal"></asp:HyperLink>
                </asp:Panel>
                <p class="mt-3 text-muted" style="font-size: 13px;">1 Gigabyte (GB) equivale a 1,024 Megabytes (MB)</p>
                <div class="mt-4">
                    <p>Tarjetas participantes</p>
                    <img src="https://img.icons8.com/color/48/visa.png" alt="Visa" />
                    <img src="https://img.icons8.com/color/48/mastercard.png" alt="MasterCard" />
                    <img src="https://img.icons8.com/color/48/amex.png" alt="Amex" />
                </div>
            </div>
        </contenttemplate>
        <footer class="text-center">
            <div class="container">
                <p><small>(c) <%: Now.Year %> por  TECOMNET.</small></p>

                <br />
                <a href="https://www.tecomnet.mx/avisodeprivacidad/" class="text-white me-3">Términos y condiciones</a>
                <a href="https://www.tecomnet.mx/tecomnet-s-a-p-i-de-c-v-aviso-de-privacidad/" class="text-white">Aviso de privacidad</a>
            </div>
        </footer>
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
