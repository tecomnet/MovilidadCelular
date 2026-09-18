/// Ambiente al que apunta la app.
///
/// Este es el único archivo que hay que tocar para pasar de pruebas a
/// producción: pegar la URL que dé backend en [_apiProduccion] y poner
/// [produccion] en true. Las URLs van escritas tal cual las entrega backend.
///
/// No se usa un JSON ni parámetros de compilación a propósito: un JSON viajaría
/// igual dentro del APK, habría que leerlo antes de la primera llamada y un
/// error de dedo ahí solo se vería al abrir la app. Escrito así, si algo no
/// cuadra, no compila.
class Ambiente {
  const Ambiente._();

  /// false = pruebas (dev) · true = producción.
  static const bool produccion = false;

  static const String _apiPruebas =
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io';

  /// PENDIENTE: la URL de producción la da backend. Sin «/api» al final.
  static const String _apiProduccion = '';

  /// Raíz del API. Cada llamada le agrega su propia ruta: '$api/api/Account'.
  static String get api => produccion ? _apiProduccion : _apiPruebas;
}
