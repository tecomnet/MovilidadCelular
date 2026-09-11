import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String _correoSoporte = 'comercial@tecomnet.mx';

  Map<String, dynamic>? _perfil;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    if (mounted) setState(() => _cargando = true);
    final datos = await AuthService.obtenerPerfil();
    if (!mounted) return;
    setState(() {
      _perfil = datos;
      _cargando = false;
    });
  }

  /// Lee un campo del perfil. Devuelve cadena vacía si falta o viene nulo, para
  /// que la vista muestre «—» de forma uniforme.
  String _campo(String clave) {
    final valor = _perfil?[clave];
    if (valor == null) return '';
    return valor.toString().trim();
  }

  /// El web muestra el nombre completo en un solo dato.
  String get _nombreCompleto {
    final partes = [
      _campo('Nombre'),
      _campo('ApellidoPaterno'),
      _campo('ApellidoMaterno'),
    ].where((p) => p.isNotEmpty);
    return partes.join(' ');
  }

  /// De «1997-09-22T00:00:00» a «22/09/1997».
  String _fecha(String clave) {
    final crudo = _campo(clave);
    if (crudo.isEmpty) return '';
    final f = DateTime.tryParse(crudo);
    if (f == null) return crudo;
    return '${f.day.toString().padLeft(2, '0')}/'
        '${f.month.toString().padLeft(2, '0')}/'
        '${f.year}';
  }

  /// El API devuelve la letra del catálogo; al cliente hay que decírselo en
  /// palabras. Si llega algo que no reconocemos se muestra tal cual, que es
  /// menos malo que ocultarlo.
  String get _tipoDePersona {
    final codigo = _campo('TipoPersona').toUpperCase();
    return switch (codigo) {
      'F' => 'Persona física',
      'M' => 'Persona moral',
      _ => _campo('TipoPersona'),
    };
  }

  bool get _tieneDatosFiscales =>
      _campo('RFC').isNotEmpty ||
      _campo('RFCFacturacion').isNotEmpty ||
      _campo('NombreRazonSocial').isNotEmpty ||
      _campo('RegimenFiscal').isNotEmpty;

  Future<void> _escribirSoporte() async {
    final uri = Uri(scheme: 'mailto', path: _correoSoporte);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Mi perfil',
      rutaActual: '/profile',
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargar,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [
                  if (_perfil == null)
                    _seccion(
                      icono: Icons.badge_outlined,
                      titulo: 'Mis datos personales',
                      hijo: const _Mensaje(
                        'No se pudieron cargar tus datos personales.',
                      ),
                    )
                  else
                    _datosPersonales(),
                  const SizedBox(height: 16),
                  _datosFiscales(),
                  const SizedBox(height: 22),
                  _pieContacto(),
                  const SizedBox(height: 14),
                  const Center(
                    child: Text(
                      '© 2026 TECOMNET · Movilidad',
                      style: TextStyle(
                        color: TecomnetTheme.tintaSuave,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _datosPersonales() {
    return _seccion(
      icono: Icons.badge_outlined,
      titulo: 'Mis datos personales',
      hijo: Column(
        children: [
          _Dato('Nombre', _nombreCompleto),
          _Dato('CURP', _campo('CURP')),
          _Dato('Teléfono', _campo('Telefono')),
          _Dato('Correo', _campo('Email')),
          _Dato('Tipo de persona', _tipoDePersona),
          _Dato('Fecha de nacimiento', _fecha('FechaCumpleanios')),
          _Dato('Estado', _campo('Estado')),
          _Dato('Colonia', _campo('Colonia')),
          _Dato('Dirección', _campo('Direccion')),
          _Dato('C.P.', _campo('CP'), ultimo: true),
        ],
      ),
    );
  }

  Widget _datosFiscales() {
    return _seccion(
      icono: Icons.receipt_long_outlined,
      titulo: 'Datos fiscales',
      hijo: _tieneDatosFiscales
          ? Column(
              children: [
                _Dato('RFC', _campo('RFC')),
                _Dato('RFC de facturación', _campo('RFCFacturacion')),
                _Dato('Razón social', _campo('NombreRazonSocial')),
                _Dato('Régimen fiscal', _campo('RegimenFiscal'), ultimo: true),
              ],
            )
          // El perfil sí cargó: si no hay RFC ni razón social es que el
          // cliente no los tiene dados de alta, no que la consulta fallara.
          // Antes las dos situaciones decían «no se pudieron cargar».
          : const _Mensaje('No tienes datos fiscales registrados.'),
    );
  }

  Widget _seccion({
    required IconData icono,
    required String titulo,
    required Widget hijo,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TecomnetTheme.panelTarjeta,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TecomnetTheme.panelBorde),
        boxShadow: [
          BoxShadow(
            color: TecomnetTheme.tintaFuerte.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, size: 21, color: TecomnetTheme.azulMarca),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: TecomnetTheme.tintaFuerte,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          hijo,
        ],
      ),
    );
  }

  Widget _pieContacto() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Para realizar cambios en tus datos, escríbenos a ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: TecomnetTheme.tintaMedia,
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          GestureDetector(
            onTap: _escribirSoporte,
            child: const Text(
              _correoSoporte,
              style: TextStyle(
                color: TecomnetTheme.azulMarca,
                fontSize: 13.5,
                height: 1.5,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: TecomnetTheme.azulMarca,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Un dato del perfil: etiqueta arriba, valor debajo.
///
/// El web los coloca en rejilla de tres columnas. En móvil no hay ancho para
/// eso —CURP y correo ya ocupan casi la pantalla—, así que van apilados y
/// separados por filetes, que es lo que mantiene el barrido vertical legible.
class _Dato extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final bool ultimo;

  const _Dato(this.etiqueta, this.valor, {this.ultimo = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: const TextStyle(
                  color: TecomnetTheme.tintaSuave,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 3),
              SelectableText(
                valor.isEmpty ? '—' : valor,
                style: TextStyle(
                  color: valor.isEmpty
                      ? TecomnetTheme.tintaSuave
                      : TecomnetTheme.tintaFuerte,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        if (!ultimo) const Divider(height: 1, color: TecomnetTheme.panelBorde),
      ],
    );
  }
}

class _Mensaje extends StatelessWidget {
  final String texto;
  const _Mensaje(this.texto);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        texto,
        style: const TextStyle(
          color: TecomnetTheme.tintaMedia,
          fontSize: 14.5,
          height: 1.4,
        ),
      ),
    );
  }
}
