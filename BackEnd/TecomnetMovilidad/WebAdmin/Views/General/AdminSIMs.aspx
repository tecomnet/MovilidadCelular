<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminSIMs.aspx.vb" Inherits="WebAdmin.AdminSIMs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f5f6fa;
        }

        .card {
            border-radius: 12px;
        }

        .card-shadow {
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            transition: 0.3s;
        }

            .card-shadow:hover {
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

        .action-icon {
            text-decoration: none !important;
        }

        a.text-primary, a.text-danger, a.text-warning, a.text-success {
            text-decoration: none !important;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="pnlSIMs" runat="server" CssClass="container mt-4 mb-5" Visible="True">
        <div style="overflow-x: auto; width: 100%;">
            <h2 class="mb-4">Administración de SIMs</h2>
            <div class="mb-4">
                <asp:TextBox ID="txtBuscarSIM" runat="server" CssClass="form-control"
                    placeholder="🔍 Buscar SIM..." AutoPostBack="true"
                    OnTextChanged="txtBuscarSIM_TextChanged"
                    onkeyup="iniciarBusqueda();">
                </asp:TextBox>
            </div>
            <div class="card card-shadow p-4 mb-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <asp:GridView ID="gvSims" runat="server"
                            CssClass="table table-hover align-middle"
                            AutoGenerateColumns="False"
                            HeaderStyle-CssClass="table-dark"
                            ShowHeaderWhenEmpty="True">
                            <Columns>
                                <asp:BoundField DataField="ICCID" HeaderText="ICCID" />
                                <asp:BoundField DataField="MSISDN" HeaderText="MSISDN" />
                                <asp:BoundField DataField="Estado" HeaderText="Estado" />
                                <asp:TemplateField HeaderText="Acciones">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnVerSim" runat="server"
                                            CommandName="VerSim"
                                            CommandArgument='<%# Eval("SIMID") %>'
                                            CssClass="text-primary">
                                         <i class="bi bi-eye-fill"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnToggle" runat="server" CssClass="text-warning"
                                            OnClick="btnToggle_Click" ToolTip="Suspender SIM">
                                            <i id="iconToggle" runat="server" class="bi bi-pause-circle-fill"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnToggleTrafico" runat="server"
                                            CommandName="ToggleTrafico"
                                            CommandArgument='<%# Eval("SIMID") %>'
                                            CssClass="text-danger"
                                            ToolTip="Suspender tráfico (Entrada/Salida)"
                                            OnClick="btnToggleTrafico_Click">
                                            <i id="iconToggleTrafico" runat="server" class="bi bi-slash-circle-fill"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnCancelar" runat="server"
                                            CommandName="Cancelar"
                                            CommandArgument='<%# Eval("SIMID") %>'
                                            CssClass="text-danger"
                                            ToolTip="Cancelar SIM">
                                            <i class="bi bi-x-circle-fill"></i>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </table>
                </div>
            </div>
        </div>
    </asp:Panel>
    <div class="modal fade" id="modalDetalleSIM" tabindex="-1" aria-labelledby="modalDetalleSIMLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalDetalleSIMLabel">Detalle de la SIM</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label"><strong>Cliente:</strong></label>
                        <span id="lblModalCliente" runat="server"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>ICCID:</strong></label>
                        <span id="lblModalICCID" runat="server"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>MSISDN:</strong></label>
                        <span id="lblModalMSISDN" runat="server"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Estado:</strong></label>
                        <span id="lblModalEstado" runat="server"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Plan Asignado:</strong></label>
                        <span id="lblModalPlan" runat="server"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>MB Disponibles:</strong></label>
                        <span id="lblModalMBDisponibles" runat="server"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>MB Usados:</strong></label>
                        <span id="lblModalMBUsados" runat="server"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Fecha Vencimiento:</strong></label>
                        <span id="lblModalVencimiento" runat="server"></span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
    <script>
        let typingTimer;
        const delay = 700;

        function iniciarBusqueda() {
            clearTimeout(typingTimer);
            typingTimer = setTimeout(function () {
                __doPostBack('<%= txtBuscarSIM.UniqueID %>', '');
        }, delay);
        }
    </script>
</asp:Content>
