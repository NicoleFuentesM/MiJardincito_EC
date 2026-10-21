import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mijardincito_ec/main.dart';

void main() {
  testWidgets('La vista muestra los filtros multicriterio', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiJardincitoApp());

    expect(find.text('Altitud: 2800 msnm'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.byType(DropdownButtonFormField<String>), findsNWidgets(3));
    expect(find.text('Clima'), findsOneWidget);
    expect(find.text('Tipo de planta'), findsOneWidget);
    expect(find.text('Color'), findsOneWidget);
    expect(find.text('Buscar especies compatibles'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>).first);
    await tester.pumpAndSettle();
    expect(find.text('Cálido'), findsOneWidget);
    expect(find.text('Frío'), findsOneWidget);
    expect(find.text('Páramo'), findsOneWidget);

    await tester.tap(find.text('Frío'));
    await tester.pumpAndSettle();
    expect(find.text('Frío'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(1));
    await tester.pumpAndSettle();
    expect(find.text('Árbol'), findsOneWidget);
    expect(find.text('Arbusto'), findsOneWidget);
    expect(find.text('Hierba'), findsOneWidget);
    await tester.tap(find.text('Árbol'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButtonFormField<String>).at(2));
    await tester.pumpAndSettle();
    for (final color in [
      'Blanco',
      'Verde',
      'Naranja',
      'Amarillo',
      'Morado',
      'Rojo',
      'Azul',
    ]) {
      expect(find.text(color), findsOneWidget);
    }
  });
}
