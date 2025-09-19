<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ContratarPlan.aspx.vb" Inherits="WebClient.ContratarPlan" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Contratar Plan</title>
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
        .welcome-text {
            font-size: 32px;
            font-weight: bold;
            color: #3f7dc0;
            margin-bottom: 20px;
            text-align: center;
        }
        .subtitle-text {
            font-size: 18px;
            color: #333;
            text-align: center;
            max-width: 600px;
            margin-bottom: 30px;
        }
        .card-recommended {
            border: 2px solid #ffc107;
        }
        .badge-recommended {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #ffc107;
            color: #000;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="centered">
            <div class="welcome-text">BIENVENIDO</div>
            <div class="subtitle-text">Selecciona tu plan a contratar.</div>

            <ul class="nav nav-tabs justify-content-center" id="planTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="anual-tab" data-bs-toggle="tab" data-bs-target="#anual" type="button" role="tab">Anual</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="mensual-tab" data-bs-toggle="tab" data-bs-target="#mensual" type="button" role="tab">Mensual</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="recarga-tab" data-bs-toggle="tab" data-bs-target="#recarga" type="button" role="tab">Recarga</button>
                </li>
            </ul>

            <div class="tab-content mt-4 w-100">

                <!-- Plan Anual -->
                <div class="tab-pane fade show active" id="anual" role="tabpanel">
                    <div class="row justify-content-center g-3">
                        <div class="col-md-4 col-sm-6 position-relative">
                            <div class="card h-100 text-center border-primary">
                                <div class="card-header bg-primary text-white">Plan Anual Básico</div>
                                <div class="card-body">
                                    <h5 class="card-title">12 Meses</h5>
                                    <p class="card-text">50GB de datos<br/>1000 minutos<br/>SMS ilimitados</p>
                                    <asp:Button ID="btnAnual1" runat="server" CssClass="btn btn-primary" Text="Contratar" OnClick="btnAnual1_Click" />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 col-sm-6">
                            <div class="card h-100 text-center border-primary">
                                <div class="card-header bg-primary text-white">Plan Anual Plus</div>
                                <div class="card-body">
                                    <h5 class="card-title">12 Meses</h5>
                                    <p class="card-text">100GB de datos<br/>Minutos ilimitados<br/>Roaming incluido</p>
                                    <asp:Button ID="btnAnual2" runat="server" CssClass="btn btn-primary" Text="Contratar" OnClick="btnAnual2_Click" />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 col-sm-6">
                            <div class="card h-100 text-center border-primary">
                                <div class="card-header bg-primary text-white">Plan Anual Premium</div>
                                <div class="card-body">
                                    <h5 class="card-title">12 Meses</h5>
                                    <p class="card-text">Datos ilimitados<br/>Minutos ilimitados<br/>Soporte VIP</p>
                                    <asp:Button ID="btnAnual3" runat="server" CssClass="btn btn-primary" Text="Contratar" OnClick="btnAnual3_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Plan Mensual -->
                <div class="tab-pane fade" id="mensual" role="tabpanel">
                    <div class="row justify-content-center g-3">
                        <div class="col-md-4 col-sm-6">
                            <div class="card h-100 text-center border-primary">
                                <div class="card-header bg-primary text-white">Plan Mensual Básico</div>
                                <div class="card-body">
                                    <h5 class="card-title">30 Días</h5>
                                    <p class="card-text">5GB de datos<br/>200 minutos<br/>SMS ilimitados</p>
                                    <asp:Button ID="btnMensual1" runat="server" CssClass="btn btn-primary" Text="Contratar" OnClick="btnMensual1_Click" />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 col-sm-6">
                            <div class="card h-100 text-center border-primary">
                                <div class="card-header bg-primary text-white">Plan Mensual Plus</div>
                                <div class="card-body">
                                    <h5 class="card-title">30 Días</h5>
                                    <p class="card-text">15GB de datos<br/>500 minutos<br/>Roaming incluido</p>
                                    <asp:Button ID="btnMensual2" runat="server" CssClass="btn btn-primary" Text="Contratar" OnClick="btnMensual2_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Plan Recarga -->
                <div class="tab-pane fade" id="recarga" role="tabpanel">
                    <div class="row justify-content-center g-3">
                        <div class="col-md-4 col-sm-6">
                            <div class="card h-100 text-center border-primary">
                                <div class="card-header bg-primary text-white">Recarga 50</div>
                                <div class="card-body">
                                    <h5 class="card-title">7 días ilimitados</h5>
                                    <p class="card-text">2GB de datos<br/>100 minutos</p>
                                    <asp:Button ID="btnRecarga1" runat="server" CssClass="btn btn-primary" Text="Contratar" OnClick="btnRecarga1_Click" />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 col-sm-6">
                            <div class="card h-100 text-center border-primary">
                                <div class="card-header bg-primary text-white">Recarga 100</div>
                                <div class="card-body">
                                    <h5 class="card-title">15 días ilimitados</h5>
                                    <p class="card-text">5GB de datos<br/>300 minutos</p>
                                    <asp:Button ID="btnRecarga2" runat="server" CssClass="btn btn-primary" Text="Contratar" OnClick="btnRecarga2_Click1" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div> 
        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
