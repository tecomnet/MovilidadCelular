/// Tipo de oferta, tal como lo devuelve el campo `Tipo` de la API.
///
/// Es el campo que distingue una recarga de un plan. **No usar `EsPrepago`**
/// para esto: de las 35 ofertas de tipo 1 en producción, 26 tienen
/// `EsPrepago = false`, así que ese campo no identifica el tipo de línea.
enum TipoOferta {
  /// 1 — `Prepago`. Recarga puntual: no se renueva, se vuelve a comprar.
  recarga,

  /// 2 — `PagoAnticipado`. Plan anual pagado por adelantado.
  anual,

  /// 3 — `RenovacionAutomatica`. Plan mensual que el backend renueva solo.
  mensual,
}

/// Traduce el `Tipo` de la API. Devuelve `null` si viene vacío o desconocido,
/// para que quien lo consuma decida el caso seguro en vez de suponer.
TipoOferta? tipoOfertaDesde(dynamic valor) {
  final numero = valor is int ? valor : int.tryParse('${valor ?? ''}');
  switch (numero) {
    case 1:
      return TipoOferta.recarga;
    case 2:
      return TipoOferta.anual;
    case 3:
      return TipoOferta.mensual;
    default:
      return null;
  }
}

/// Número que espera la API para cada tipo.
int tipoOfertaValor(TipoOferta tipo) {
  switch (tipo) {
    case TipoOferta.recarga:
      return 1;
    case TipoOferta.anual:
      return 2;
    case TipoOferta.mensual:
      return 3;
  }
}

enum CanalDeVenta { App, PaginaWeb, PortalCautivo }

enum TipoOperacion { Compra, Recarga, Cambio, Renovacion }

int canalDeVentaValue(CanalDeVenta canal) {
  switch (canal) {
    case CanalDeVenta.App:
      return 1;
    case CanalDeVenta.PaginaWeb:
      return 2;
    case CanalDeVenta.PortalCautivo:
      return 3;
  }
}

int tipoOperacionValue(TipoOperacion tipo) {
  switch (tipo) {
    case TipoOperacion.Compra:
      return 1;
    case TipoOperacion.Recarga:
      return 2;
    case TipoOperacion.Cambio:
      return 3;
    case TipoOperacion.Renovacion:
      return 4;
  }
}
