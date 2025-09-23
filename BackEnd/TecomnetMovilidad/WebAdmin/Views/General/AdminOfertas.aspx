<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Default.Master" CodeBehind="AdminOfertas.aspx.vb" Inherits="WebAdmin.AdminOfertas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" />
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
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="pnlAdminOfertas" runat="server" CssClass="container mt-5">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Administración de Ofertas</h2>
            <asp:Button ID="btnAgregarOfertas" runat="server" CssClass="btn btn-success btn-add"
                Text="+ Agregar Ofertas" OnClick="btnAgregarOfertas_Click" />
        </div>

    </asp:Panel>

    <asp:Panel ID="pnlTabla" runat="server" Visible="True">
       <div class="card card-shadow p-4 mb-4">
    <div class="table-responsive">
        <table class="table table-hover align-middle">
            <thead class="table-dark">
                <tr>
                    <th>Nombre Oferta</th>
                    <th>Descripción</th>
                    <th>Precio</th>
                    <th>Datos (MB)</th>
                    <th>Minutos</th>
                    <th>SMS</th>
                    <th>Tipo</th>
                    <th>Validez (días)</th>
                    <th>Aplica Roaming</th>
                    <th>Fecha Alta</th>
                    <th>Fecha Baja</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Plan Mensual</td>
                    <td>Incluye redes sociales ilimitadas</td>
                    <td>$150 / mensual</td>
                    <td>5000</td>
                    <td>200</td>
                    <td>50</td>
                    <td>Mensual</td>
                    <td>30</td>
                    <td>Sí</td>
                    <td>22/09/2025</td>
                    <td>-----</td>
                    <td>
                        <i class="bi bi-pencil action-icon edit" title="Editar oferta"></i>
                        <i class="bi bi-trash action-icon delete" title="Eliminar oferta"></i>
                    </td>
                </tr>
                <tr>
                    <td>Recarga $50</td>
                    <td>Solo datos</td>
                    <td>$50 / recarga</td>
                    <td>1000</td>
                    <td>0</td>
                    <td>0</td>
                    <td>Recarga</td>
                    <td>7</td>
                    <td>No</td>
                    <td>22/09/2025</td>
                    <td>-----</td>
                    <td>
                        <i class="bi bi-pencil action-icon edit" title="Editar oferta"></i>
                        <i class="bi bi-trash action-icon delete" title="Eliminar oferta"></i>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>

    </asp:Panel>

    <asp:Panel ID="pnlAgregar" runat="server" Visible="False">
        <div class="panel-form">
            <h4 class="mb-4">Agregar Oferta</h4>

            <div class="mb-3">
                <label class="form-label">Nombre de la Oferta</label>
                <asp:TextBox ID="txtOferta" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Descripción</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
            </div>

            <div class="mb-3">
                <label class="form-label">Precio Mensual</label>
                <asp:TextBox ID="txtPrecioMensual" runat="server" CssClass="form-control" TextMode="Number" />
            </div>

            <div class="mb-3">
                <label class="form-label">Precio Anual</label>
                <asp:TextBox ID="txtPrecioAnual" runat="server" CssClass="form-control" TextMode="Number" />
            </div>

            <div class="mb-3">
                <label class="form-label">Precio Recurrente</label>
                <asp:TextBox ID="txtPrecioRecurrente" runat="server" CssClass="form-control" TextMode="Number" />
            </div>

            <div class="mb-3">
                <label class="form-label">Datos (MB)</label>
                <asp:TextBox ID="txtDatosMB" runat="server" CssClass="form-control" TextMode="Number" />
            </div>

            <div class="mb-3">
                <label class="form-label">Minutos</label>
                <asp:TextBox ID="txtMinutos" runat="server" CssClass="form-control" TextMode="Number" />
            </div>

            <div class="mb-3">
                <label class="form-label">SMS</label>
                <asp:TextBox ID="txtSms" runat="server" CssClass="form-control" TextMode="Number" />
            </div>

            <div class="mb-3">
                <label class="form-label">Tipo de Oferta</label>
                <asp:DropDownList ID="ddlTipoOferta" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Recarga" Value="Recarga"></asp:ListItem>
                    <asp:ListItem Text="Plan Mensual" Value="Mensual"></asp:ListItem>
                    <asp:ListItem Text="Plan Anual" Value="Anual"></asp:ListItem>
                </asp:DropDownList>
            </div>


            <div class="mb-3">
                <label class="form-label">Validez (días)</label>
                <asp:TextBox ID="txtValidezDias" runat="server" CssClass="form-control" TextMode="Number" />
            </div>

            <div class="mb-3">
                <label class="form-label">Aplica Roaming</label>
                <asp:DropDownList ID="ddlAplicaRoaming" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Sí" Value="True"></asp:ListItem>
                    <asp:ListItem Text="No" Value="False"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="mb-3">
                <label class="form-label">Redes Sociales Incluidas</label>
                <asp:TextBox ID="txtRedesSociales" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label class="form-label">Fecha de Alta</label>
                <asp:TextBox ID="txtFechaAlta" runat="server" CssClass="form-control" TextMode="Date" />
            </div>
            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" />
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary ms-2" />
        </div>
    </asp:Panel>
</asp:Content>
