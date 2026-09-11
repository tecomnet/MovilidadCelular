// URL a la que la pasarela devuelve al usuario tras pagar.
//
// La app nunca llega a cargar esta página: el WebView intercepta la navegación
// antes y la usa solo como señal de que el pago terminó. Lleva el OrderID para
// poder consultar el estado al regresar.
//
// AJUSTAR con la ruta real del backend.
const String urlBaseRetorno =
    'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io/api/pago/retorno';

String generarUrlRetorno(String orderId) {
  return '$urlBaseRetorno?order=${Uri.encodeQueryComponent(orderId)}';
}

// Prefijo sin parámetros, para comparar la navegación del WebView.
// Se compara por prefijo y no por igualdad exacta porque la pasarela suele
// añadir sus propios parámetros al devolver al usuario.
String get prefijoUrlRetorno => urlBaseRetorno;
