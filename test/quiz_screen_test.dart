import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mijardincito_ec/models/planta.dart';
import 'package:mijardincito_ec/presentation/providers/coleccion_plantas_provider.dart';
import 'package:mijardincito_ec/presentation/providers/busqueda_plantas_provider.dart';
import 'package:mijardincito_ec/presentation/screens/quiz_screen.dart';
import 'package:mijardincito_ec/services/native_bridge.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('recorre cuatro preguntas y muestra el resultado', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final motor = _MotorBusquedaFalso();
    final busqueda = BusquedaPlantasProvider(motor: motor);
    final coleccion = ColeccionPlantasProvider();
    await coleccion.cargar();
    var jardinPulsado = false;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: busqueda),
          ChangeNotifierProvider.value(value: coleccion),
        ],
        child: MaterialApp(
          home: QuizScreen(onGardenTap: () => jardinPulsado = true),
        ),
      ),
    );

    expect(find.text('¿A qué altitud está tu jardín?'), findsOneWidget);
    await tester.tap(find.byTooltip('Mi jardín'));
    expect(jardinPulsado, isTrue);

    await tester.tap(find.byKey(const ValueKey('quiz-next')));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué clima predomina en tu jardín?'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('quiz-next')));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué tipo de planta quieres?'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('quiz-next')));
    await tester.pumpAndSettle();
    expect(find.text('¿Qué color buscas?'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('quiz-next')));
    await tester.pumpAndSettle();

    expect(find.text('Plantas compatibles'), findsOneWidget);
    expect(find.text('Arrayán'), findsOneWidget);
    expect(motor.busquedaRealizada, isTrue);

    await tester.tap(find.text('¡Coleccionar!'));
    await tester.pumpAndSettle();
    expect(coleccion.nombresAdoptados, ['Arrayán']);
  });
}

class _MotorBusquedaFalso implements MotorJardin {
  bool busquedaRealizada = false;

  @override
  Future<List<Planta>> obtenerPlantasCompatiblesAvanzado(
    int altitud,
    String clima,
    String tipoPlanta,
    String color,
  ) async {
    busquedaRealizada = true;
    return [
      Planta(
        nombreComun: 'Arrayán',
        nombreCientifico: 'Myrcianthes hallii',
        region: 'Andes',
        altitudIdeal: altitud,
        tipoClima: clima,
      ),
    ];
  }

  @override
  Future<Map<String, dynamic>> obtenerProgresoColeccion(
    List<String> nombresColeccionadas,
  ) async => {};

  @override
  Future<List<Planta>> cargarCatalogo() async => [];
}
