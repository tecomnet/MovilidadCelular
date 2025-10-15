<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminEstatusDeposito.aspx.vb" Inherits="WebAdmin.AdminEstatusDeposito" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
            cursor: pointer;
            font-size: 1.2rem;
            margin-right: 8px;
        }

            .action-icon.edit {
                color: #0d6efd;
            }

            .action-icon.delete {
                color: #dc3545;
            }

        .btn-add {
            font-weight: bold;
            border-radius: 50px;
            padding: 0.5rem 1.2rem;
        }

        .badge-role {
            font-size: 0.85rem;
            padding: 0.4em 0.7em;
            border-radius: 12px;
        }

        .panel-form {
            background-color: #ffffff;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }

        .action-icon {
            text-decoration: none !important;
        }

        a.text-primary, a.text-danger {
            text-decoration: none !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="pnlAdminEstatusDeposito" runat="server" CssClass="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Administración Estatus Depósito</h2>
            <asp:Button ID="BtnAgregarEstatusDeposito" runat="server" CssClass="btn btn-success btn-add"
                Text="+ Agregar Estatus Deposito" OnClick="BtnAgregarEstatusDeposito_Click" />
        </div>
    </asp:Panel>
    <asp:Panel ID="PnlTabla" runat="server" Visible="True">
        <div class="card card-shadow p-4 mb-4">
            <div class="table-responsive">
                <asp:GridView ID="gvEstatusDeposito" runat="server"
                    CssClass="table table-hover align-middle"
                    AutoGenerateColumns="False"
                    HeaderStyle-CssClass="table-dark"
                    ShowHeaderWhenEmpty="True"
                    OnRowCommand="gvEstatusDeposito_RowCommand">

                    <Columns>
                        <asp:BoundField DataField="EstatusDepositoID" HeaderText="ID" />
                        <asp:BoundField DataField="Estatus" HeaderText="Estatus" />
                        <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEditar" runat="server"
                                    CommandName="Editar"
                                    CommandArgument='<%# Eval("EstatusDepositoID") %>'
                                    CssClass="text-primary" ToolTip="Editar">
                                <i class="bi bi-pencil action-icon edit"></i>
                                </asp:LinkButton>

                                <asp:LinkButton ID="lnkBaja" runat="server"
                                    CommandName="DarBaja"
                                    CommandArgument='<%# Eval("EstatusDepositoID") %>'
                                    CssClass="text-danger" OnClientClick="return confirm('¿Seguro que deseas dar de baja este estatus?');">
                                <i class="bi bi-person-x-fill action-icon delete"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>

                </asp:GridView>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="PnlAgregarEstatusDeposito" runat="server" Visible="False">
        <asp:HiddenField ID="hdnEstatusDeposito" runat="server" />
        <asp:Label ID="lblTitulo" runat="server" CssClass="fs-2 text-dark fw-bold"></asp:Label>
        <div class="card card-shadow p-4 mb-4">
            <div class="mb-3">
                <label class="form-label">Estatus</label>
                <asp:TextBox ID="txtEstatus" runat="server" CssClass="form-control" />
            </div>
            <div class="mb-3">
                <label class="form-label">Descripción</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" />
            </div>
        </div>
        <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary ms-2" />
    </asp:Panel>
</asp:Content>
