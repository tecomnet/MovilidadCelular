import 'dart:math';
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:movilidad_celulares/theme/tecomnet_theme.dart';

/// Fondo de red de nodos del Portal del Cliente, dibujado por código.
///
/// Equivalente móvil del fondo interactivo de la web:
///  * **Deriva ambiental** — los nodos flotan lentamente por su cuenta, así el
///    fondo está vivo aunque nadie lo toque (en web eso lo daba el cursor).
///  * **Reacción al dedo** — al tocar o arrastrar, los nodos cercanos se
///    apartan y se tejen líneas cian hacia el punto de contacto. En web y
///    escritorio funciona igual con el puntero del mouse, sin tocar nada.
///
/// El patrón inicial usa una semilla fija, de modo que la app siempre arranca
/// con la misma composición. Al ser vectorial se ve nítido en cualquier
/// densidad y no añade peso al APK.
class ConstellationBackground extends StatefulWidget {
  final Widget child;

  /// Número de nodos. Menos nodos = fondo más limpio y menos trabajo por
  /// fotograma; el coste de los enlaces crece al cuadrado.
  final int nodos;

  const ConstellationBackground({super.key, required this.child, this.nodos = 40});

  @override
  State<ConstellationBackground> createState() => _ConstellationBackgroundState();
}

class _ConstellationBackgroundState extends State<ConstellationBackground>
    with SingleTickerProviderStateMixin {
  late final List<_Nodo> _puntos;
  late final Ticker _ticker;

  /// Se incrementa en cada fotograma para disparar el repintado sin
  /// reconstruir el árbol de widgets.
  final ValueNotifier<int> _fotograma = ValueNotifier<int>(0);

  /// Posición del dedo o del cursor, en píxeles locales. `null` = sin contacto.
  final ValueNotifier<Offset?> _puntero = ValueNotifier<Offset?>(null);

  Duration _ultimoTick = Duration.zero;
  bool _animando = false;

  @override
  void initState() {
    super.initState();
    final random = Random(20250825); // semilla fija: composición estable
    _puntos = List.generate(widget.nodos, (_) {
      return _Nodo(
        posicion: Offset(random.nextDouble(), random.nextDouble()),
        // Velocidad en unidades normalizadas por segundo: muy lenta, un nodo
        // tarda cerca de un minuto en cruzar media pantalla.
        velocidad: Offset(
          (random.nextDouble() - 0.5) * 0.016,
          (random.nextDouble() - 0.5) * 0.016,
        ),
        radio: 1.1 + random.nextDouble() * 1.6,
        destacado: random.nextDouble() < 0.18,
      );
    });

    _ticker = createTicker(_alFotograma);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respeta «reducir movimiento» del sistema: si está activo, el fondo se
    // queda quieto y solo reacciona al contacto.
    final reducirMovimiento = MediaQuery.disableAnimationsOf(context);
    if (reducirMovimiento && _animando) {
      _ticker.stop();
      _animando = false;
    } else if (!reducirMovimiento && !_animando) {
      _ultimoTick = Duration.zero;
      _ticker.start();
      _animando = true;
    }
  }

  void _alFotograma(Duration elapsed) {
    final dt = (elapsed - _ultimoTick).inMicroseconds / 1e6;
    _ultimoTick = elapsed;
    // Ignora el primer fotograma y los saltos grandes (app en segundo plano).
    if (dt <= 0 || dt > 0.1) return;

    for (final nodo in _puntos) {
      var x = nodo.posicion.dx + nodo.velocidad.dx * dt;
      var y = nodo.posicion.dy + nodo.velocidad.dy * dt;

      // Reaparecen por el lado opuesto en vez de rebotar: el movimiento se
      // percibe continuo y no hay acumulación en los bordes.
      if (x < -0.06) {
        x = 1.06;
      } else if (x > 1.06) {
        x = -0.06;
      }
      if (y < -0.06) {
        y = 1.06;
      } else if (y > 1.06) {
        y = -0.06;
      }

      nodo.posicion = Offset(x, y);
    }

    _fotograma.value++;
  }

  @override
  void dispose() {
    _ticker.dispose();
    _fotograma.dispose();
    _puntero.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: TecomnetTheme.degradadoFondo),
      child: MouseRegion(
        // Escritorio y web: reacciona al pasar el cursor, como el diseño original.
        onHover: (e) => _puntero.value = e.localPosition,
        onExit: (_) => _puntero.value = null,
        child: Listener(
          // Móvil: reacciona al tocar y arrastrar. `HitTestBehavior.translucent`
          // deja que los toques sigan llegando al formulario que va encima.
          behavior: HitTestBehavior.translucent,
          onPointerDown: (e) => _puntero.value = e.localPosition,
          onPointerMove: (e) => _puntero.value = e.localPosition,
          onPointerUp: (_) => _puntero.value = null,
          onPointerCancel: (_) => _puntero.value = null,
          child: Stack(
            children: [
              // Aislado en su propia capa: el fondo se repinta cada fotograma
              // sin obligar al formulario a repintarse con él.
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _ConstelacionPainter(
                      nodos: _puntos,
                      puntero: _puntero,
                      repaint: Listenable.merge([_fotograma, _puntero]),
                    ),
                  ),
                ),
              ),
              // El fondo es decorativo: no debe describirse en accesibilidad.
              Positioned.fill(
                child: Semantics(container: false, child: widget.child),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Nodo {
  Offset posicion;
  final Offset velocidad;
  final double radio;
  final bool destacado;

  _Nodo({
    required this.posicion,
    required this.velocidad,
    required this.radio,
    required this.destacado,
  });
}

class _ConstelacionPainter extends CustomPainter {
  final List<_Nodo> nodos;
  final ValueListenable<Offset?> puntero;

  /// Distancia máxima (relativa al ancho) para unir dos nodos.
  static const double _umbralEnlace = 0.26;

  /// Radio de influencia del dedo o cursor, en píxeles.
  static const double _radioPuntero = 120.0;

  /// Cuánto se aparta un nodo en el centro de esa influencia, en píxeles.
  static const double _empuje = 26.0;

  _ConstelacionPainter({
    required this.nodos,
    required this.puntero,
    required Listenable repaint,
  }) : super(repaint: repaint);

  /// Aparta el punto del puntero. Se aplica solo al dibujar, no al estado:
  /// al levantar el dedo todo vuelve a su sitio sin nada que deshacer.
  Offset _desplazar(Offset p, Offset? foco) {
    if (foco == null) return p;
    final delta = p - foco;
    final distancia = delta.distance;
    if (distancia >= _radioPuntero || distancia == 0) return p;
    final fuerza = (1 - distancia / _radioPuntero) * _empuje;
    return p + (delta / distancia) * fuerza;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final foco = puntero.value;

    final puntos = <Offset>[
      for (final n in nodos)
        _desplazar(
          Offset(n.posicion.dx * size.width, n.posicion.dy * size.height),
          foco,
        ),
    ];

    final umbral = _umbralEnlace * size.width;
    final lapizLinea = Paint()
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    // Enlaces entre nodos: cuanto más cerca, más visible la línea.
    for (var i = 0; i < puntos.length; i++) {
      for (var j = i + 1; j < puntos.length; j++) {
        final distancia = (puntos[i] - puntos[j]).distance;
        if (distancia > umbral) continue;

        final cercania = 1 - (distancia / umbral);
        lapizLinea.color = const Color(
          0xFF4A3D8F,
        ).withValues(alpha: 0.10 + cercania * 0.22);
        canvas.drawLine(puntos[i], puntos[j], lapizLinea);
      }
    }

    // Hilos cian hacia el punto de contacto: es lo que da la sensación de que
    // la red responde a la mano.
    if (foco != null) {
      final lapizFoco = Paint()
        ..strokeWidth = 0.9
        ..style = PaintingStyle.stroke;
      for (final p in puntos) {
        final distancia = (p - foco).distance;
        if (distancia > _radioPuntero) continue;
        final cercania = 1 - (distancia / _radioPuntero);
        lapizFoco.color = TecomnetTheme.cian.withValues(alpha: cercania * 0.45);
        canvas.drawLine(foco, p, lapizFoco);
      }
    }

    // Nodos por encima de los enlaces.
    final lapizNodo = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < puntos.length; i++) {
      final nodo = nodos[i];
      // Los nodos bajo el dedo brillan un poco más.
      var alpha = nodo.destacado ? 0.55 : 0.45;
      if (foco != null) {
        final distancia = (puntos[i] - foco).distance;
        if (distancia < _radioPuntero) {
          alpha += (1 - distancia / _radioPuntero) * 0.35;
        }
      }
      lapizNodo.color = nodo.destacado
          ? TecomnetTheme.cian.withValues(alpha: alpha.clamp(0.0, 1.0))
          : const Color(0xFF6B5FA8).withValues(alpha: alpha.clamp(0.0, 1.0));
      canvas.drawCircle(puntos[i], nodo.radio, lapizNodo);
    }
  }

  // El repintado lo gobierna el `repaint` del constructor (fotograma + puntero).
  @override
  bool shouldRepaint(_ConstelacionPainter oldDelegate) =>
      !identical(oldDelegate.nodos, nodos);
}
