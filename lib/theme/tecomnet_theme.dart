import 'package:flutter/material.dart';

/// Paleta e identidad visual del Portal del Cliente TECOMNET.
///
/// Vive aparte para que el resto de pantallas se puedan migrar al mismo tema
/// sin repetir literales de color por todos lados.
class TecomnetTheme {
  TecomnetTheme._();

  // Fondos
  static const Color fondoAlto = Color(0xFF070A14);
  static const Color fondoBajo = Color(0xFF0B0E1C);

  // Superficies
  static const Color tarjeta = Color(0xFF14161F);
  static const Color bordeTarjeta = Color(0xFF232634);
  static const Color campo = Color(0xFF1B1E29);
  static const Color bordeCampo = Color(0xFF2A2E3D);
  static const Color chipIcono = Color(0xFF232735);

  // Acentos
  static const Color cian = Color(0xFF5FD8F0);
  static const Color azul = Color(0xFF2563EB);
  static const Color azulClaro = Color(0xFF22A7E8);

  // Texto
  static const Color textoPrincipal = Color(0xFFF1F4F9);
  static const Color textoSecundario = Color(0xFF9AA3B2);
  static const Color textoTenue = Color(0xFF6B7386);

  // Estados
  static const Color error = Color(0xFFF0637A);
  static const Color aviso = Color(0xFFE0A040);

  // --- Panel claro -------------------------------------------------------
  // Las pantallas de acceso son oscuras e inmersivas; el panel, una vez
  // dentro, es claro y legible. Son dos ambientes distintos a propósito.

  static const Color panelFondo = Color(0xFFF1F4F9);
  static const Color panelTarjeta = Color(0xFFFFFFFF);
  static const Color panelBorde = Color(0xFFE3E8F0);
  static const Color panelBarra = Color(0xFFFFFFFF);

  static const Color tintaFuerte = Color(0xFF16243D);
  static const Color tintaMedia = Color(0xFF5A6A82);
  static const Color tintaSuave = Color(0xFF8C99AC);

  static const Color azulMarca = Color(0xFF1B6FC4);
  static const Color azulProfundo = Color(0xFF0F4C8A);
  static const Color verde = Color(0xFF2E9E7B);
  static const Color verdeSuave = Color(0xFFE3F4EE);
  static const Color azulSuave = Color(0xFFE4F0FB);
  static const Color whatsapp = Color(0xFF25D366);

  /// Degradado del banner de bienvenida del panel.
  static const LinearGradient degradadoBanner = LinearGradient(
    colors: [Color(0xFF17304F), Color(0xFF1273C8)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Fondo del cajón lateral, tomado del sidebar web.
  static const Color cajonFondo = Color(0xFF11233E);
  static const Color cajonActivo = Color(0xFF1B3A63);
  static const Color cajonTexto = Color(0xFFD6DFEC);
  static const Color cajonTextoTenue = Color(0xFF7E90AB);

  /// Degradado del botón principal.
  static const LinearGradient degradadoAccion = LinearGradient(
    colors: [azul, azulClaro],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Degradado de fondo de la app.
  static const LinearGradient degradadoFondo = LinearGradient(
    colors: [fondoAlto, fondoBajo],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Estilo de las etiquetas sobre los campos (CORREO, CONTRASEÑA…).
  static const TextStyle etiquetaCampo = TextStyle(
    color: textoSecundario,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.6,
  );
}
