import 'dart:convert';

String generarUrlExito() {
  String tokenString = DateTime.now().toIso8601String();
  String tokenBase64 = base64Encode(utf8.encode(tokenString));
  String urlExito =
      'https://tecomnet.net/movilidad/clientes/Views/Recargas/ValidaRecarga.aspx?token=$tokenBase64';
  return urlExito;
}
