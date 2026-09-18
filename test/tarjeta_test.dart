import 'package:flutter_test/flutter_test.dart';
import 'package:movilidad_celulares/services/tarjeta.dart';

void main() {
  group('Tarjeta.desde', () {
    test('lee el listado tal como lo documenta el backend', () {
      final t = Tarjeta.desde({
        'ClienteTarjetaID': 17,
        'CardId': 'tok_abc',
        'Marca': 'VISA',
        'Ultimos4': '2701',
        'ExpMonth': 3,
        'ExpYear': 2029,
        'Vencida': false,
        'FechaAlta': '2026-09-10T12:30:00',
        'LineasQueCobra': ['5512345678'],
      })!;

      expect(t.clienteTarjetaId, 17);
      expect(t.cardId, 'tok_abc');
      expect(t.nombre, 'Visa •••• 2701');
      expect(t.numeroEnmascarado, '•••• •••• •••• 2701');
      expect(t.vencimiento, '03/29');
      expect(t.esHeredada, isFalse);
      expect(t.lineasQueCobra, ['5512345678']);
      expect(t.fechaAlta, DateTime(2026, 9, 10, 12, 30));
    });

    test('acepta los mismos campos en camelCase', () {
      final t = Tarjeta.desde({
        'clienteTarjetaId': '9',
        'cardId': 'tok_x',
        'marca': 'mastercard',
        'ultimos4': '4444',
        'expMonth': 12,
        'expYear': 2030,
        'vencida': true,
        'lineasQueCobra': [],
      })!;

      expect(t.clienteTarjetaId, 9);
      expect(t.nombre, 'Mastercard •••• 4444');
      expect(t.vencimiento, '12/30');
      expect(t.vencida, isTrue);
      expect(t.lineasQueCobra, isEmpty);
    });

    test('una tarjeta heredada, sin marca ni últimos 4', () {
      final t = Tarjeta.desde({
        'ClienteTarjetaID': 3,
        'CardId': 'tok_viejo',
        'Marca': null,
        'Ultimos4': null,
        'FechaAlta': '2025-01-05T00:00:00',
      })!;

      expect(t.esHeredada, isTrue);
      expect(t.nombre, 'Tarjeta registrada');
      expect(t.numeroEnmascarado, isNull);
      expect(t.vencimiento, isNull);
    });

    test('sin ClienteTarjetaID se descarta: no se podría quitar', () {
      expect(Tarjeta.desde({'CardId': 'tok_sin_id'}), isNull);
    });
  });

  test('lineasDe ignora vacíos y lo que no es lista', () {
    expect(lineasDe(['5511', '', ' 5522 ']), ['5511', '5522']);
    expect(lineasDe(null), isEmpty);
    expect(lineasDe('5511'), isEmpty);
  });
}
