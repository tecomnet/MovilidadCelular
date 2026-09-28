/// Cómo terminó un cobro en la pasarela.
enum ResultadoPago { exitoso, error }

// Páginas a las que la pasarela devuelve al cliente al terminar de pagar.
//
// La app no se las manda a nadie: RegistrarSolicitudDePago no las lleva en el
// cuerpo, las configura el backend en la pasarela. Aquí solo sirven para
// reconocer, dentro del WebView, que el pago terminó y con qué resultado.
//
// Se aceptan las de pruebas y las de producción a la vez. La app no tiene un
// interruptor de ambiente, y quien decide a cuál redirigir es la pasarela: si
// solo se reconociera una, un pago en el otro ambiente dejaría el WebView
// abierto sin que la app se enterara de que ya terminó.
const Set<String> _hostsRetorno = {
  'dev.d3ugekic3bvc7e.amplifyapp.com', // pruebas
  'main.d3n0bfziy6j29b.amplifyapp.com', // producción
};

/// Resultado del pago si [url] es una página de retorno, o `null` si no lo es.
///
/// Se compara host y ruta y se ignoran los parámetros de consulta, porque la
/// pasarela suele añadir los suyos al redirigir.
ResultadoPago? resultadoDeRetorno(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || !_hostsRetorno.contains(uri.host)) return null;

  // Una barra final no debe hacer que el retorno pase desapercibido.
  var ruta = uri.path;
  if (ruta.length > 1 && ruta.endsWith('/')) {
    ruta = ruta.substring(0, ruta.length - 1);
  }

  switch (ruta) {
    case '/pago-exitoso':
      return ResultadoPago.exitoso;
    case '/pago-error':
      return ResultadoPago.error;
    default:
      return null;
  }
}
