# Contratos de la API MovilidadCelular y guía para atacar los contras de la migración

Este documento define los request/response de cada endpoint (para migración a C# y/o OpenAPI) y cómo mitigar los contras de la migración con ayuda del asistente.

---

## 1. Contratos por endpoint

**Base URL:** `https://tecomnet.net/movilidad/WebApi/api/`  
**Autenticación:** JWT en cabecera `Authorization: Bearer <token>`, excepto `POST api/Account`.

---

### 1.1 Account – Login (obtener token)

**Método:** `POST`  
**Ruta:** `api/Account`  
**Auth:** No (AllowAnonymous)

**Request body (JSON):**
```json
{
  "UserName": "string",
  "Password": "string"
}
```

| Campo     | Tipo   | Requerido | Descripción          |
|----------|--------|-----------|----------------------|
| UserName | string | Sí        | Usuario (ej. móvil)  |
| Password | string | Sí        | Contraseña           |

**Response (200):** cuerpo es el **token JWT en texto** (no un objeto JSON).  
**Response (401):** Unauthorized.

**C# DTOs:**
```csharp
public class LoginAccountRequest
{
    [Required]
    public string UserName { get; set; } = "";
    [Required]
    public string Password { get; set; } = "";
}
// Response: Content-Type application/json, body = string (token)
```

---

### 1.2 Cliente – Login (validar usuario y obtener perfil)

**Método:** `POST`  
**Ruta:** `api/Cliente/Login`  
**Auth:** Bearer

**Request body:**
```json
{
  "UserName": "string",
  "Password": "string"
}
```

**Response 200:** objeto `Cliente` (ver modelo abajo).  
**Response 401:** `{ "mensaje": "Usuario o contraseña no valida." }`  
**Response 500:** `{ "error": "...", "detalle": "..." }`

---

### 1.3 Cliente – Tablero

**Método:** `GET`  
**Ruta:** `api/Cliente/Tablero/{ClienteId}`  
**Auth:** Bearer

**Parámetros de ruta:** `ClienteId` (int)

**Response 200:** array de `Tablero`.  
**Response 204:** `{ "mensaje": "No existen ofertas asociados al cliente." }`  
**Response 500:** `{ "error": "...", "detalle": "..." }`

---

### 1.4 Cliente – Cambiar contraseña

**Método:** `POST`  
**Ruta:** `api/Cliente/CambiaPassword`  
**Auth:** Bearer

**Request body:**
```json
{
  "UserName": "string",
  "Password": "string",
  "NewPassword": "string"
}
```

**Response 200:** `{ "mensaje": "La contraseña se cambio correctamente" }`  
**Response 401:** `{ "mensaje": "Usuario o contraseña no valida." }`  
**Response 500:** `{ "mensaje": "Error al cambiar la contraseña..." }` o `{ "error", "detalle" }`

---

### 1.5 Cliente – Solicitud cambio de contraseña (recuperar)

**Método:** `POST`  
**Ruta:** `api/Cliente/SolicitudCambioPassword`  
**Auth:** Bearer

**Request body:**
```json
{
  "email": "string"
}
```

**Response 200:** `{ "mensaje": "La solicitud fue enviada correctamente a su correo electronico..." }`  
**Response 500:** `{ "mensaje": "El correo no existe..." }` o `{ "mensaje": "No se pudo enviar la solicitud..." }` o `{ "error", "detalle" }`

---

### 1.6 Ofertas – Por ID

**Método:** `GET`  
**Ruta:** `api/Ofertas/{OfertaID}`  
**Auth:** Bearer

**Parámetros de ruta:** `OfertaID` (int)

**Response 200:** objeto `Oferta`.  
**Response 204:** `{ "mensaje": "No existe la oferta." }`  
**Response 500:** `{ "error", "detalle" }`

---

### 1.7 Ofertas – Activas por tipo

**Método:** `GET`  
**Ruta:** `api/Ofertas/Activa/Tipo/{Tipo}`  
**Auth:** Bearer

**Parámetros de ruta:** `Tipo` (int, enum `TipoServicio`: 1=Prepago, 2=PagoAnticipado, 3=RenovacionAutomatica)

**Response 200:** array de `Oferta`.  
**Response 204:** `{ "mensaje": "No existen ofertas activas." }`  
**Response 500:** `{ "error", "detalle" }`

---

### 1.8 Recargas – Por cliente

**Método:** `GET`  
**Ruta:** `api/Recargas/Cliente/{ClienteID}`  
**Auth:** Bearer

**Parámetros de ruta:** `ClienteID` (int)

**Response 200:** array de `VisRecarga`.  
**Response 204:** `{ "mensaje": "No existen recargas." }`  
**Response 500:** `{ "error", "detalle" }`

---

### 1.9 Recargas – Compra producto

**Método:** `POST`  
**Ruta:** `api/Recargas/CompraProducto`  
**Auth:** Bearer

**Request body:**
```json
{
  "OfferingId": "string",
  "MSISDN": "string"
}
```

**Response 200:** `{ "mensaje": "La compra se realizo correctamente." }`  
**Response 500:** `{ "mensaje": "El objeto enviado no es valido" }` o `{ "mensaje": "Error al realizar la compra" }` o `{ "error", "detalle" }`

---

### 1.10 Recargas – Cambiar producto (cambio de oferta)

**Método:** `PATCH`  
**Ruta:** `api/Recargas/CambiaProducto`  
**Auth:** Bearer

**Request body:** mismo que Compra producto:
```json
{
  "OfferingId": "string",
  "MSISDN": "string"
}
```

**Response 200:** `{ "mensaje": "La compra se realizo correctamente." }`  
**Response 500:** igual que Compra producto.

---

### 1.11 Compra – SIM

**Método:** `POST`  
**Ruta:** `api/Compra/SIM/{ICCID}/{MSISDN}/{OfertaID}`  
**Auth:** Bearer

**Parámetros de ruta:** `ICCID` (string), `MSISDN` (string), `OfertaID` (int).  
**Request body:** objeto `Cliente` (cualquier subconjunto de campos del modelo Cliente).

**Response 200:** actualmente mock:
```json
{
  "ClienteID": 2222,
  "ICCID": "DSGDFFDGFD",
  "MSISDN": "DSFSDFDSF",
  "QRBASE64": "dsgfhdfggfgdgdfggd"
}
```
**Response 500:** `{ "CodeError", "ErrorMessage", "Description" }`

---

### 1.12 Registrar solicitud de pago

**Método:** `POST`  
**Ruta:** `api/RegistrarSolicitudDePago`  
**Auth:** Bearer

**Request body:** objeto `SolicitudDePago` (solo se envían y validan estos campos):

| Campo            | Tipo    | Requerido | Descripción        |
|------------------|---------|-----------|--------------------|
| ICCID            | string  | Sí        | ICCID de la SIM    |
| MetodoPagoID     | int     | Sí        | ID método de pago  |
| OfertaIDActual   | int     | Sí        | Oferta actual      |
| OfertaIDNueva    | int     | Sí        | Oferta nueva       |
| Monto            | double  | Sí        | Monto a pagar      |
| MSISDN           | string  | No        | Número (opcional)  |

El servidor asigna: `OrderID` (formato `TMV|{Guid}`), `Estatus`, `FechaCreacion`, `EstatusDepositoID`, etc.

**Response 200:**
```json
{
  "OrderID": "string",
  "SolicitudID": 0
}
```
**Response 500:** `{ "CodeError", "ErrorMessage", "Description" }` (CodeError "1" objeto nulo, "2" datos inválidos, "3" excepción, "4" genérico).

---

### 1.13 Obtener solicitud de pago

**Método:** `GET`  
**Ruta:** `api/ObtenerSolicitudDePago/{OrderID}`  
**Auth:** Bearer

**Parámetros de ruta:** `OrderID` (string)

**Response 200:** objeto que contiene `objSolicitudDePago` (objeto `SolicitudDePago` completo).  
**Response 500:** `{ "CodeError", "ErrorMessage", "Description" }`

---

## 2. Modelos compartidos (DTOs)

### 2.1 LoginAccount
```csharp
public class LoginAccount
{
    [Required]
    public string UserName { get; set; } = "";
    [Required]
    public string Password { get; set; } = "";
}
```

### 2.2 ChangePasswordAccount
```csharp
public class ChangePasswordAccount : LoginAccount
{
    [Required]
    public string NewPassword { get; set; } = "";
}
```

### 2.3 EmailRequest
```csharp
public class EmailRequest
{
    [Required]
    public string email { get; set; } = "";  // mantener minúscula por compatibilidad
}
```

### 2.4 CompraProducto
```csharp
public class CompraProducto
{
    [Required]
    public string OfferingId { get; set; } = "";
    [Required]
    public string MSISDN { get; set; } = "";
}
```

### 2.5 Cliente
```csharp
public class Cliente
{
    public int ClienteId { get; set; }
    public string Nombre { get; set; } = "";
    public string ApellidoPaterno { get; set; } = "";
    public string ApellidoMaterno { get; set; } = "";
    public DateTime? FechaCumpleanios { get; set; }
    public string TipoPersona { get; set; } = "";
    public string CURP { get; set; } = "";
    public string Telefono { get; set; } = "";
    public string Email { get; set; } = "";
    public DateTime FechaAlta { get; set; }
    public EstatusCliente Estatus { get; set; }  // 1=Activo, 2=Suspendido, 3=Desactivado
    public string ContrasenaHash { get; set; } = "";
    public string RFC { get; set; } = "";
    public string NombreRazonSocial { get; set; } = "";
    public DateTime? FechaBaja { get; set; }
    public string Colonia { get; set; } = "";
    public string Direccion { get; set; } = "";
    public string Estado { get; set; } = "";
    public string RFCFacturacion { get; set; } = "";
    public string CP { get; set; } = "";
    public string CPFacturacion { get; set; } = "";
    public string RegimenFiscal { get; set; } = "";
    public string SiigoID { get; set; } = "";
}
```

### 2.6 Tablero
```csharp
public class Tablero
{
    public int SIMID { get; set; }
    public string ICCID { get; set; } = "";
    public string MSISDN { get; set; } = "";
    public DateTime? FechaVencimiento { get; set; }
    public int? MBAsignados { get; set; }
    public int? MBUsados { get; set; }
    public int? MBDisponibles { get; set; }
    public int? MBAdicionales { get; set; }
    public int OfertaID { get; set; }
    public string Oferta { get; set; } = "";
    public string Descripcion { get; set; } = "";
    public int Minutos { get; set; }
    public int Sms { get; set; }
    public TipoServicio Tipo { get; set; }  // 1=Prepago, 2=PagoAnticipado, 3=RenovacionAutomatica
    public string Estatus { get; set; } = "";
}
```

### 2.7 Oferta
```csharp
public class Oferta
{
    public int OfertaID { get; set; }
    public string Oferta { get; set; } = "";
    public string Descripcion { get; set; } = "";
    public decimal PrecioMensual { get; set; }
    public decimal PrecioAnual { get; set; }
    public decimal PrecioRecurrente { get; set; }
    public int DatosMB { get; set; }
    public int Minutos { get; set; }
    public int Sms { get; set; }
    public bool EsPrepago { get; set; }
    public TipoServicio Tipo { get; set; }
    public string OfferIDAltan { get; set; } = "";
    public int ValidezDias { get; set; }
    public bool AplicaRoaming { get; set; }
    public bool BolsaCompartirDatos { get; set; }
    public bool RedesSociales { get; set; }
    public bool TarifaPrimaria { get; set; }
    public int HomologacionID { get; set; }
    public DateTime FechaAlta { get; set; }
    public DateTime? FechaBaja { get; set; }
}
```

### 2.8 VisRecarga (hereda de Recarga + campos extra)
```csharp
public class VisRecarga
{
    public int RecargaId { get; set; }
    public DateTime FechaRecarga { get; set; }
    public string ICCID { get; set; } = "";
    public int ClienteID { get; set; }
    public int OfertaID { get; set; }
    public double Total { get; set; }
    public int MetodoPagoID { get; set; }
    public string OrderID { get; set; } = "";
    public int DistribuidorID { get; set; }
    public int EstatusPagoDistribuidorID { get; set; }
    public DateTime? FechaPagoDistribuidor { get; set; }
    public double Comision { get; set; }
    public double Impuesto { get; set; }
    public int? DepositoID { get; set; }
    public bool RequiereFacturaCliente { get; set; }
    public int? FacturaID { get; set; }
    public string NombreMetodo { get; set; } = "";
    public string MSISDN { get; set; } = "";
    public string Oferta { get; set; } = "";
}
```

### 2.9 SolicitudDePago
```csharp
public class SolicitudDePago
{
    public int SolicitudID { get; set; }
    public string OrderID { get; set; } = "";
    public int MetodoPagoID { get; set; }
    public int OfertaIDActual { get; set; }
    public int OfertaIDNueva { get; set; }
    public double Monto { get; set; }
    public string ICCID { get; set; } = "";
    public string MSISDN { get; set; } = "";
    public string Estatus { get; set; } = "";
    public DateTime FechaCreacion { get; set; }
    public int EstatusDepositoID { get; set; }
    public string IdTransaction { get; set; } = "";
    public string AuthNumber { get; set; } = "";
    public string AuthCode { get; set; } = "";
    public string Reason { get; set; } = "";
    public int? PagoDepositoID { get; set; }
    public CanalDeVenta CanalDeVenta { get; set; }   // 1=App, 2=PaginaWeb, 3=PortalCautivo
    public TipoOperacion TipoOperacion { get; set; } // 1=Compra, 2=Recarga, 3=Cambio, 4=Renovacion
    public DateTime UltimaActualizacion { get; set; }
    public int NumeroReintentos { get; set; }
    public int DistribuidorID { get; set; }
}
```

### 2.10 Enumeraciones
```csharp
public enum TipoServicio { Prepago = 1, PagoAnticipado = 2, RenovacionAutomatica = 3 }
public enum EstatusCliente { Activo = 1, Suspendido = 2, Desactivado = 3 }
public enum CanalDeVenta { App = 1, PaginaWeb = 2, PortalCautivo = 3 }
public enum TipoOperacion { Compra = 1, Recarga = 2, Cambio = 3, Renovacion = 4 }
```

---

## 3. Cómo atacar los contras de la migración (con ayuda del asistente)

Sí, los contras de la migración se pueden atacar y yo puedo ayudarte en cada uno. Resumen de contras y qué podemos hacer:

| Contra | Cómo atacarlo con ayuda |
|--------|-------------------------|
| **Esfuerzo y tiempo** | Plan de migración por fases (primero API + contratos, luego WebHooK). Yo puedo generar el esqueleto de la solución en C# (capas, proyectos, DTOs, controladores vacíos) y tú vas rellenando lógica; también puedo proponer tareas concretas por sprint. |
| **Riesgo funcional** | Mantener mismos endpoints y DTOs (este documento). Yo puedo ayudarte a escribir tests de integración contra la API actual (Postman/Newman o xUnit + HttpClient) para capturar el comportamiento y usarlos como regresión en la API nueva. |
| **Doble mantenimiento** | Definir ventana corta de migración y un solo código en producción (API C# reemplaza VB). Yo puedo ayudarte a listar qué cambios en VB hay que “replicar” en C# y a revisar que no quede lógica huérfana. |
| **Conocimiento del dominio** | Documentar flujos (login, pago, webhook, Altan) en pasos; yo puedo redactar esa documentación a partir del código que ya analicé y proponer diagramas de secuencia o listas de pasos. |
| **Cliente Flutter** | Mantener rutas y cuerpos iguales (este documento). Si en algún momento cambias contrato, yo puedo proponer los cambios en el cliente Flutter (api_service.dart y pantallas) para que sigan compatibles. |
| **Tests previos** | No hay tests hoy; hay que crearlos. Yo puedo proponer y escribir tests unitarios (servicios de aplicación, mapeos) y de integración (API C# contra BD de prueba o mocks) usando xUnit/NUnit y HttpClient, y ayudarte a configurar el pipeline. |

**Pasos concretos que puedo hacer contigo:**

1. **Esqueleto de solución C#** con capas (API, Application, Domain, Infrastructure), DTOs de este documento y controladores que devuelvan los mismos códigos y estructuras.
2. **Tests de contrato** (ej. “POST api/Account con credenciales X devuelve 200 y un string”) para la API actual y luego para la nueva.
3. **Documentación de flujos** (login → perfil → tablero; solicitud de pago → webhook → Altan) en texto o diagramas.
4. **Lista de tareas de migración** priorizada (por endpoint o por módulo) para que no se te escape nada.
5. **Revisión de seguridad** en la API nueva (login real, JWT, CORS, connection strings) y sugerencias de cambios en código.

Cuando quieras, podemos empezar por el esqueleto en C# o por los tests de contrato; dime con qué prefieres seguir.
