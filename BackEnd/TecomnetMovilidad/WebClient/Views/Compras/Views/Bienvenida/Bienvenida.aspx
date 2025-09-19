<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Bienvenida.aspx.vb" Inherits="WebClient.Bienvenida" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Bienvenida</title>
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

        .carousel {
            max-width: 600px;
            width: 90%;
        }

        .terms-container {
            margin-bottom: 1px;
        }
         .custom-checkbox input[type="checkbox"] {
        margin-right: 6px; 
    }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="centered" style="height: auto; padding-top: 40px;">
            <div class="welcome-text">
                BIENVENIDO
            </div>
            <div class="subtitle-text" style="margin-bottom: 20px;">
                Gracias por formar parte de TECOMNET. Antes de comenzar, revisemos algunos puntos importantes para aprovechar al máximo tu experiencia.
            </div>
        </div>
        <div class="d-flex justify-content-center my-4">
            <div id="carouselExampleIndicators" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-indicators">
                    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active"></button>
                    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1"></button>
                    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2"></button>
                    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="3"></button>
                </div>
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="https://images.unsplash.com/photo-1521295121783-8a321d551ad2?auto=format&fit=crop&w=600&h=300" class="d-block w-100" alt="Slide 3" />
                    </div>
                    <div class="carousel-item">
                        <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=600&h=300" class="d-block w-100" alt="Slide 2" />
                    </div>
                    <div class="carousel-item">
                        <img src="https://images.unsplash.com/photo-1521295121783-8a321d551ad2?auto=format&fit=crop&w=600&h=300" class="d-block w-100" alt="Slide 3" />
                    </div>
                    <div class="carousel-item">
                        <img src="https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=600&h=300" class="d-block w-100" alt="Slide 2" />
                    </div>
                </div>
                <%--<div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="Resources/Imagenes/slide1.jpg" class="d-block w-100" alt="Slide 1">
                    </div>
                    <div class="carousel-item">
                        <img src="Resources/Imagenes/slide2.jpg" class="d-block w-100" alt="Slide 2">
                    </div>
                    <div class="carousel-item">
                        <img src="Resources/Imagenes/slide3.jpg" class="d-block w-100" alt="Slide 3">
                    </div>
                </div>--%>
                <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon"></span>
                    <span class="visually-hidden">Anterior</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
                    <span class="carousel-control-next-icon"></span>
                    <span class="visually-hidden">Siguiente</span>
                </button>
            </div>
        </div>
        <div class="terms-section text-center mt-4">
            <div class="mb-2">
                <asp:CheckBox ID="chkAcceptTerms" runat="server" />
                <label for="<%= chkAcceptTerms.ClientID %>">
                    Acepto los 
        <a href="#" data-bs-toggle="modal" data-bs-target="#modalTerminos">términos y condiciones</a>.
                </label>
            </div>

            <div class="modal fade" id="modalTerminos" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Términos y Condiciones</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                        </div>
                        <div class="modal-body">
                            Aquí van los términos y condiciones...
                        </div>
                    </div>
                </div>
            </div>


            <div class="mb-3 custom-checkbox">
                <asp:CheckBox ID="chkRequerimientos" runat="server" Text="Cumplo con los requerimientos solicitados." />
            </div>

            <div class="mb-2">
                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar y Continuar" CssClass="btn btn-primary" OnClick="btnAceptar_Click" Enabled="false" />
            </div>

            <div>
                <asp:Label ID="lblError" runat="server" CssClass="text-danger" />
            </div>
        </div>
        <script type="text/javascript">
            window.onload = function () {
                var chkTerms = document.getElementById('<%= chkAcceptTerms.ClientID %>');
                var chkReqs = document.getElementById('<%= chkRequerimientos.ClientID %>');
                var btn = document.getElementById('<%= btnAceptar.ClientID %>');

                chkTerms.checked = false;
                chkReqs.checked = false;
                btn.disabled = true;

                function toggleButton() {
                    btn.disabled = !(chkTerms.checked && chkReqs.checked);
                }

                chkTerms.addEventListener('change', toggleButton);
                chkReqs.addEventListener('change', toggleButton);
            }
        </script>

    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
