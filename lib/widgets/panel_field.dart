import 'package:flutter/material.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';

/// Campo de formulario del panel claro.
///
/// Es el equivalente de [TecomnetField] para las pantallas de dentro: etiqueta
/// en tinta fuerte, caja blanca con filete y, opcionalmente, texto de ayuda o
/// de error debajo.
class PanelField extends StatelessWidget {
  final String etiqueta;
  final TextEditingController controller;

  /// Texto gris bajo el campo. Se sustituye por [errorText] cuando hay error.
  final String? ayuda;
  final String errorText;

  final bool obscure;
  final VoidCallback? onAlternarVisibilidad;
  final bool visible;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const PanelField({
    super.key,
    required this.etiqueta,
    required this.controller,
    this.ayuda,
    this.errorText = '',
    this.obscure = false,
    this.onAlternarVisibilidad,
    this.visible = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final tieneError = errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          etiqueta,
          style: const TextStyle(
            color: TecomnetTheme.tintaFuerte,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: TecomnetTheme.panelTarjeta,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: tieneError
                  ? TecomnetTheme.error
                  : TecomnetTheme.panelBorde,
              width: tieneError ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: const TextStyle(
                    color: TecomnetTheme.tintaFuerte,
                    fontSize: 15.5,
                  ),
                  cursorColor: TecomnetTheme.azulMarca,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
              // En móvil se escribe la contraseña en un teclado pequeño: poder
              // verla evita reintentos a ciegas.
              if (onAlternarVisibilidad != null)
                IconButton(
                  icon: Icon(
                    visible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: TecomnetTheme.tintaSuave,
                    size: 20,
                  ),
                  tooltip: visible ? 'Ocultar' : 'Mostrar',
                  onPressed: onAlternarVisibilidad,
                ),
            ],
          ),
        ),
        if (tieneError || (ayuda != null && ayuda!.isNotEmpty))
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 2),
            child: Text(
              tieneError ? errorText : ayuda!,
              style: TextStyle(
                color: tieneError
                    ? TecomnetTheme.error
                    : TecomnetTheme.tintaSuave,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
      ],
    );
  }
}
