<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ContratarPlan.aspx.vb" Inherits="WebClient.ContratarPlan" Culture="es-MX" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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

                <div class="tab-pane fade show active" id="anual" role="tabpanel">
                    <div class="row justify-content-center g-3">
                        <asp:ListView ID="lvOfferAnual" runat="server" DataKeyNames="OfertaID,PrecioAnual">
                            <ItemTemplate>
                                <div class="col-md-4 col-sm-6 pb-3">
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
                                                <label class="promo-value"><%# String.Format("{0:C2} MXN", Eval("PrecioAnual")) %></label>
                                            </div>
                                            <div class="text-center">
                                                <asp:Button ID="btnLoQuieroA" runat="server" Text="Lo quiero" CssClass="btn btn-primary"
                                                    CommandName="Loquiero" CommandArgument='<%# Eval("OfertaID") %>' OnClick="btnLoQuieroA_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:ListView>
                    </div>
                </div>

                <div class="tab-pane fade" id="mensual" role="tabpanel">
                    <div class="row justify-content-center g-3">
                        <asp:ListView ID="lvOfferMensual" runat="server" DataKeyNames="OfertaID,PrecioMensual">
                            <ItemTemplate>
                                <div class="col-md-4 col-sm-6 pb-3">
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
                                                <label class="promo-value"><%# String.Format("{0:C2} MXN", Eval("PrecioMensual")) %></label>
                                            </div>
                                            <div class="text-center">
                                                <asp:Button ID="btnLoQuieroM" runat="server" Text="Lo quiero" CssClass="btn btn-primary"
                                                    CommandName="Loquiero" CommandArgument='<%# Eval("OfertaID") %>' OnClick="btnLoQuieroM_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:ListView>
                    </div>
                </div>
                <div class="tab-pane fade" id="recarga" role="tabpanel">
                    <div class="row justify-content-center g-3">
                        <asp:ListView ID="lvOfferRecarga" runat="server" DataKeyNames="OfertaID,PrecioRecurrente">
                            <ItemTemplate>
                                <div class="col-md-4 col-sm-6 pb-3">
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
                                                <asp:Button ID="btnLoQuieroR" runat="server" Text="Lo quiero" CssClass="btn btn-primary"
                                                    CommandName="Loquiero" CommandArgument='<%# Eval("OfertaID") %>' OnClick="btnLoQuieroR_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:ListView>
                    </div>
                </div>
            </div>
            </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
