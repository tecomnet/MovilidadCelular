<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminSIMs.aspx.vb" Inherits="WebAdmin.AdminSIMs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="pnlSIMs" runat="server" Visible="True">
        <div style="overflow-x:auto; width:100%;">
        <div class="card card-shadow p-4 mb-4">
            <h4>SIMs disponibles</h4>
            <br />
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <asp:GridView ID="gvSims" runat="server"
                        CssClass="table table-hover align-middle"
                        AutoGenerateColumns="False"
                        HeaderStyle-CssClass="table-dark"
                        ShowHeaderWhenEmpty="True">
                        <Columns>
                            <asp:BoundField DataField="SIMID" HeaderText="ID" />
                            <asp:BoundField DataField="ICCID" HeaderText="ICCID" />
                            <asp:BoundField DataField="MSISDN" HeaderText="MSISDN" />
                            <asp:BoundField DataField="Estado" HeaderText="Estado" />
                            <asp:TemplateField HeaderText="Acciones">
                                <ItemTemplate>
                                    <a href="#" class="text-info"
                                        title="Ver"
                                        onclick='<%# "verSim(" & Eval("SIMID") & ")" %>'>
                                        <i class="bi bi-eye-fill"></i>
                                    </a>
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
                        <label class="form-label"><strong>ICCID:</strong></label>
                        <span>894400000000000001</span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>MSISDN:</strong></label>
                        <span>5512345678</span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Estado:</strong></label>
                        <span>Disponible</span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Fecha Activación:</strong></label>
                        <span>01/09/2025</span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Plan Asignado:</strong></label>
                        <span>Plan Mensual 5GB</span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><strong>Observaciones:</strong></label>
                        <span>SIM nueva, lista para asignación.</span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
    <script>
        function verSim(id) {
            console.log("SIM seleccionada:", id);

            const modal = new bootstrap.Modal(document.getElementById("modalDetalleSIM"));
            modal.show();
        }
    </script>

</asp:Content>
