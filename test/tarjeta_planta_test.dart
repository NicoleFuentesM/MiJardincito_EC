import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mijardincito_ec/models/planta.dart';
import 'package:mijardincito_ec/presentation/providers/coleccion_plantas_provider.dart';
import 'package:mijardincito_ec/presentation/widgets/tarjeta_planta.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('adopta una planta desde su tarjeta y refleja el estado', (
    tester,
  ) async {
    final coleccion = ColeccionPlantasProvider();
    await coleccion.cargar();
    final planta = Planta(
      nombreComun: 'Arrayán',
      nombreCientifico: 'Myrcianthes hallii',
      region: 'Andes',
      altitudIdeal: 2800,
      tipoClima: 'Templado',
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: coleccion,
        child: MaterialApp(
          home: Scaffold(body: TarjetaPlanta(planta: planta)),
        ),
      ),
    );

    await tester.tap(find.text('¡Coleccionar!'));
    await tester.pumpAndSettle();

    expect(coleccion.estaAdoptada('Arrayán'), isTrue);
    expect(find.text('Adoptada'), findsOneWidget);
  });
}
