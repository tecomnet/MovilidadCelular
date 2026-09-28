/// Ambiente al que apunta la app: pruebas o producción.
///
/// Este es el único archivo que hay que tocar para pasar de uno a otro. Cada
/// ambiente tiene su URL y sus credenciales de la cuenta de servicio, porque en
/// producción no son las mismas que en pruebas.
///
/// No se usa un JSON ni parámetros de compilación a propósito: un JSON viajaría
/// igual dentro del APK, habría que leerlo antes de la primera llamada y un
/// error de dedo ahí solo se vería al abrir la app. Escrito así, si algo no
/// cuadra, no compila.
class Ambiente {
  const Ambiente._();

  /// false = pruebas (dev) · true = producción.
  ///
  /// Cambiar esto es lo último que se hace antes de compilar el AAB que se sube
  /// a Play, y hay que confirmar que los tres datos de producción de abajo
  /// estén puestos.
  static const bool produccion = true;

  // ── Pruebas ────────────────────────────────────────────────────────────────

  static const String _apiPruebas =
      'https://ca-movilidad-dev-api.wonderfulground-31c63143.centralus.azurecontainerapps.io';

  static const String _usuarioPruebas = 'Mobile.TECOMNET.USER_Admin';

  static const String _clavePruebas =
      'zE8D4nlrLpgpeG3qjiFwlFkUBNfun1LSwMqvZBLhnzXVyCy7VsFaVFDUiwpMHrlO';

  // ── Producción ─────────────────────────────────────────────────────────────
  //
  // PENDIENTE: pegar aquí lo que entregó backend. La URL va sin «/api» al
  // final y sin barra final.

  static const String _apiProduccion = 'https://ca-movilidad-prod-api.wonderfulground-31c63143.centralus.azurecontainerapps.io';

  static const String _usuarioProduccion = 'Mobile.TECOMNET.USER_Admin';

  static const String _claveProduccion = 'lkCvLlEEh3yrZE9qXJB_0HUspd8JoOdAlU7hQ1hj3JWcUE2R5C4FxzpX5QHwoisu';

  // ── Lo que usa el resto de la app ─────────────────────────────────────────

  /// Raíz del API. Cada llamada le agrega su propia ruta: '$api/api/Account'.
  static String get api => produccion ? _apiProduccion : _apiPruebas;

  /// Usuario de la cuenta de servicio con la que la app pide su token.
  static String get usuarioServicio =>
      produccion ? _usuarioProduccion : _usuarioPruebas;

  /// Contraseña de esa cuenta.
  static String get claveServicio =>
      produccion ? _claveProduccion : _clavePruebas;

  /// ¿Falta algo por llenar para poder compilar contra producción?
  ///
  /// Con [produccion] en true y cualquiera de los tres datos vacío, la app no
  /// podría ni iniciar sesión, y desde la pantalla se vería como un problema de
  /// red. Lo comprueba main.dart al arrancar, en depuración, para que el error
  /// salte antes de generar el AAB y no cuando ya está publicado.
  static bool get configuracionIncompleta =>
      produccion &&
      (_apiProduccion.isEmpty ||
          _usuarioProduccion.isEmpty ||
          _claveProduccion.isEmpty);
}
