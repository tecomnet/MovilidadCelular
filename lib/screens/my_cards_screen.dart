import 'package:flutter/material.dart';
import 'package:movilidad_celulares/services/api_service.dart';
import 'package:movilidad_celulares/services/tarjeta.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';
import 'package:movilidad_celulares/widgets/base_scaffold.dart';
import 'package:movilidad_celulares/widgets/line_selector.dart';
import 'package:movilidad_celulares/widgets/tecomnet_widgets.dart';

/// Tarjetas guardadas del cliente: verlas, agregar una y quitarla.
class MyCardsScreen extends StatefulWidget {
  const MyCardsScreen({super.key});

  @override
  State<MyCardsScreen> createState() => _MyCardsScreenState();
}

class _MyCardsScreenState extends State<MyCardsScreen> {
  bool _cargando = true;
  List<Tarjeta> _tarjetas = [];

  /// La carga falló, que no es lo mismo que no tener tarjetas.
  bool _falloCarga = false;

  /// La tarjeta que se está quitando, para poner su rueda y bloquear el resto.
  int? _quitando;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /// Con [conRueda] en false la lista sigue a la vista mientras se recarga:
  /// es lo que se usa al deslizar hacia abajo, que ya pone su propia rueda, y
  /// después de agregar o quitar, para que la pantalla no parpadee.
  Future<void> _cargar({bool conRueda = true}) async {
    if (conRueda && mounted) setState(() => _cargando = true);

    final clienteId = await AuthService.clienteIdActual();
    final tarjetas = clienteId == null
        ? null
        : await AuthService.obtenerTarjetas(clienteId);
    if (!mounted) return;

    setState(() {
      _tarjetas = tarjetas ?? [];
      _falloCarga = tarjetas == null;
      _cargando = false;
    });
  }

  Future<void> _agregar() async {
    final agregada = await Navigator.pushNamed(context, '/addCard');
    if (agregada == true && mounted) await _cargar(conRueda: false);
  }

  // ------------------------------------------------------------------- quitar

  Future<void> _quitar(Tarjeta tarjeta) async {
    if (_quitando != null) return;

    final seguro = await _confirmar(
      titulo: '¿Quitar ${tarjeta.nombre}?',
      texto: 'Ya no podrás usarla para tus pagos.',
      accion: 'Quitar',
    );
    if (seguro != true || !mounted) return;

    await _ejecutarQuitar(tarjeta, forzar: false);
  }

  Future<void> _ejecutarQuitar(Tarjeta tarjeta, {required bool forzar}) async {
    final clienteId = await AuthService.clienteIdActual();
    if (!mounted) return;
    if (clienteId == null) {
      showNotice(
        context,
        'No pudimos identificar tu cuenta. Intenta de nuevo.',
      );
      return;
    }

    setState(() => _quitando = tarjeta.clienteTarjetaId);
    final resultado = await AuthService.quitarTarjeta(
      clienteId: clienteId,
      // El ClienteTarjetaID del listado, no el cardId: con el cardId el
      // servidor responde 404.
      clienteTarjetaId: tarjeta.clienteTarjetaId,
      forzar: forzar,
    );
    if (!mounted) return;
    setState(() => _quitando = null);

    if (resultado == null) {
      showNotice(
        context,
        'No se pudo conectar. Revisa tu conexión e intenta de nuevo.',
      );
      return;
    }

    switch (resultado.estado) {
      case EstadoQuitarTarjeta.quitada:
        showNotice(context, 'Tarjeta eliminada', color: TecomnetTheme.verde);
        await _cargar(conRueda: false);

      case EstadoQuitarTarjeta.requiereConfirmacion:
        // No se borró nada. Quitarla dejaría esas líneas sin forma de
        // renovarse y se suspenden al vencer el plan: el cliente tiene que
        // saberlo antes de decidir.
        await _confirmarLineasQueCobra(tarjeta, resultado.lineasQueCobra);

      case EstadoQuitarTarjeta.noEncontrada:
        showNotice(context, 'Esa tarjeta ya no está en tu cuenta.');
        await _cargar(conRueda: false);

      case EstadoQuitarTarjeta.pasarelaNoConfirmo:
        // El servidor no la desactivó porque en la pasarela sigue viva y
        // cobrable: hay que decirlo así, no «se quitó».
        showNotice(
          context,
          'El banco no confirmó el borrado y la tarjeta sigue activa. '
          'Intenta de nuevo en unos minutos.',
        );

      case EstadoQuitarTarjeta.error:
        showNotice(
          context,
          resultado.mensaje ??
              'No se pudo quitar la tarjeta. Intenta de nuevo.',
        );
    }
  }

  Future<void> _confirmarLineasQueCobra(
    Tarjeta tarjeta,
    List<String> lineas,
  ) async {
    final cuales = lineas.isEmpty
        ? 'una o más de tus líneas'
        : lineas.length == 1
        ? 'la línea ${lineas.first}'
        : 'las líneas ${lineas.join(', ')}';

    final seguro = await _confirmar(
      titulo: 'Esta tarjeta paga tu plan mensual',
      texto:
          'Con ${tarjeta.nombre} se renueva el plan de $cuales. Si la quitas, '
          'no se podrá renovar y la línea se suspenderá cuando venza su plan.',
      accion: 'Quitar de todos modos',
      peligrosa: true,
    );
    if (seguro != true || !mounted) return;

    await _ejecutarQuitar(tarjeta, forzar: true);
  }

  Future<bool?> _confirmar({
    required String titulo,
    required String texto,
    required String accion,
    bool peligrosa = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: TecomnetTheme.panelTarjeta,
        surfaceTintColor: TecomnetTheme.panelTarjeta,
        title: Text(
          titulo,
          style: const TextStyle(
            color: TecomnetTheme.tintaFuerte,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          texto,
          style: const TextStyle(
            color: TecomnetTheme.tintaMedia,
            fontSize: 14.5,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Conservar',
              style: TextStyle(color: TecomnetTheme.tintaMedia),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              accion,
              style: TextStyle(
                color: peligrosa
                    ? TecomnetTheme.error
                    : TecomnetTheme.azulMarca,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------- vista
  //
  // Sigue el diseño de «Mis tarjetas» de la app web: cada tarjeta dibujada como
  // una tarjeta física y «Agregar tarjeta» como una tarjeta punteada al final.
  // Se conserva el orden en que las manda el servidor, el mismo que usa la web,
  // para que las dos no muestren lo mismo en órdenes distintos.

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Mis tarjetas',
      rutaActual: '/cards',
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _cargar(conRueda: false),
              child: AbsorbPointer(
                absorbing: _quitando != null,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  children: [
                    if (_falloCarga)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: EmptyPanel(
                          mensaje:
                              'No pudimos cargar tus tarjetas. Revisa tu '
                              'conexión y desliza hacia abajo para reintentar.',
                          icono: Icons.cloud_off_rounded,
                        ),
                      )
                    else
                      ..._tarjetas.map(_conPie),
                    _Ancho(child: _AgregarTarjeta(alTocar: _agregar)),
                    const SizedBox(height: 18),
                    const _NotaSeguridad(),
                  ],
                ),
              ),
            ),
    );
  }

  /// La tarjeta dibujada y, debajo, la fecha de alta y el botón de quitar.
  Widget _conPie(Tarjeta tarjeta) {
    final quitandoEsta = _quitando == tarjeta.clienteTarjetaId;
    final alta = tarjeta.fechaAlta;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: _Ancho(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TarjetaDibujada(tarjeta: tarjeta),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      alta == null ? '' : 'Registrada el ${_fecha(alta)}',
                      style: const TextStyle(
                        color: TecomnetTheme.tintaSuave,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                  if (quitandoEsta)
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else
                    TextButton.icon(
                      onPressed: () => _quitar(tarjeta),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text('Quitar'),
                      style: TextButton.styleFrom(
                        foregroundColor: TecomnetTheme.tintaMedia,
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _fecha(DateTime f) =>
      '${f.day.toString().padLeft(2, '0')}/'
      '${f.month.toString().padLeft(2, '0')}/${f.year}';
}

/// Limita el ancho en pantallas grandes: una tarjeta estirada a lo ancho de
/// una tableta ya no parece tarjeta.
class _Ancho extends StatelessWidget {
  final Widget child;
  const _Ancho({required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: child,
      ),
    );
  }
}

/// Proporción de una tarjeta bancaria real (ISO/IEC 7810 ID-1).
const double _proporcionTarjeta = 1.586;

class _TarjetaDibujada extends StatelessWidget {
  final Tarjeta tarjeta;
  const _TarjetaDibujada({required this.tarjeta});

  @override
  Widget build(BuildContext context) {
    final lineas = tarjeta.lineasQueCobra;
    // En la web cabe un número; si cobra varias líneas se muestra la primera
    // y cuántas más, para no desbordar la esquina.
    final cobra = lineas.isEmpty
        ? '—'
        : lineas.length == 1
        ? lineas.first
        : '${lineas.first} +${lineas.length - 1}';

    return AspectRatio(
      aspectRatio: _proporcionTarjeta,
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A2552), Color(0xFF14468F), Color(0xFF0B2F66)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0A2552).withValues(alpha: 0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _Chip(),
                const Spacer(),
                if (tarjeta.vencida) ...[
                  const _Vencida(),
                  const SizedBox(width: 10),
                ],
                _Marca(marca: tarjeta.marca),
              ],
            ),
            const Spacer(),
            Text(
              tarjeta.numeroEnmascarado ?? 'Tarjeta registrada',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: tarjeta.esHeredada ? 19 : 18,
                fontWeight: FontWeight.w600,
                letterSpacing: tarjeta.esHeredada ? 1.2 : 2.2,
              ),
            ),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _Dato(titulo: 'VENCE', valor: tarjeta.vencimiento ?? '—'),
                const Spacer(),
                _Dato(titulo: 'COBRA', valor: cobra, alFinal: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8CD7E), Color(0xFFC9A04A), Color(0xFFE2C271)],
        ),
      ),
    );
  }
}

/// La marca escrita cuando el servidor la manda; si no, el icono genérico que
/// usa la web.
class _Marca extends StatelessWidget {
  final String? marca;
  const _Marca({required this.marca});

  @override
  Widget build(BuildContext context) {
    final m = marca;
    if (m == null) {
      return const Icon(
        Icons.credit_card_rounded,
        color: Colors.white70,
        size: 24,
      );
    }
    return Text(
      m.toUpperCase(),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.italic,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _Vencida extends StatelessWidget {
  const _Vencida();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: TecomnetTheme.error,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'VENCIDA',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _Dato extends StatelessWidget {
  final String titulo;
  final String valor;
  final bool alFinal;

  const _Dato({
    required this.titulo,
    required this.valor,
    this.alFinal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alFinal
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

/// «Agregar tarjeta» con el mismo tamaño que una tarjeta y borde punteado,
/// como en la web.
class _AgregarTarjeta extends StatelessWidget {
  final VoidCallback alTocar;
  const _AgregarTarjeta({required this.alTocar});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _proporcionTarjeta,
      child: CustomPaint(
        painter: _BordePunteado(),
        child: Material(
          color: TecomnetTheme.panelTarjeta,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: alTocar,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 34,
                  color: TecomnetTheme.azulMarca,
                ),
                SizedBox(height: 6),
                Text(
                  'Agregar tarjeta',
                  style: TextStyle(
                    color: TecomnetTheme.azulMarca,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Flutter no trae bordes punteados: se dibuja el contorno redondeado por
/// tramos.
class _BordePunteado extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pincel = Paint()
      ..color = TecomnetTheme.tintaSuave
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final contorno = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(16)),
      );

    const trazo = 7.0, hueco = 5.0;
    for (final tramo in contorno.computeMetrics()) {
      var d = 0.0;
      while (d < tramo.length) {
        canvas.drawPath(tramo.extractPath(d, d + trazo), pincel);
        d += trazo + hueco;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NotaSeguridad extends StatelessWidget {
  const _NotaSeguridad();

  @override
  Widget build(BuildContext context) {
    return const _Ancho(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.shield_outlined,
              size: 15,
              color: TecomnetTheme.tintaSuave,
            ),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'Nunca guardamos el número completo ni el código de seguridad '
              'de tu tarjeta: solo los últimos 4 dígitos. Los datos viven en '
              'la pasarela de pago.',
              style: TextStyle(
                color: TecomnetTheme.tintaSuave,
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
