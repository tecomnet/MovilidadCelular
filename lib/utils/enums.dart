enum CanalDeVenta {
  App,         
  PaginaWeb,   
  PortalCautivo 
}

enum TipoOperacion {
  Compra,      
  Recarga,     
  Cambio,      
  Renovacion   
}

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
