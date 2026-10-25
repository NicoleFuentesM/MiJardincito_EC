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

    expect(find.text('Altitud'), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz-back')), findsOneWidget);
    expect(find.text('2800 msnm'), findsOneWidget);
    expect(find.byType(RotatedBox), findsOneWidget);
    final imagenMontana = find.byWidgetPredicate(
      (widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == 'assets/images/montaña.png',
    );
    expect(
      imagenMontana,
      findsOneWidget,
    );
    expect(
      tester.getSize(imagenMontana).height,
      tester.getSize(find.byType(RotatedBox).first).height,
    );
    await tester.tap(find.byTooltip('Mi jardín'));
    expect(jardinPulsado, isTrue);

    await tester.tap(find.byKey(const ValueKey('quiz-next')));
    await tester.pumpAndSettle();
    expect(find.text('Clima'), findsOneWidget);
    expect(find.text('Templado'), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz-back')), findsOneWidget);
    await tester.drag(find.byType(PageView).last, const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Frío'), findsOneWidget);
    expect(busqueda.clima, 'Frío');
    await tester.drag(find.byType(PageView).last, const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(busqueda.clima, 'Páramo');
    await tester.drag(find.byType(PageView).last, const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(busqueda.clima, 'Cálido');

    await tester.tap(find.byKey(const ValueKey('quiz-next')));
    await tester.pumpAndSettle();
    expect(find.text('Tipo'), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz-back')), findsOneWidget);
    expect(find.text('Árbol'), findsOneWidget);
    expect(find.text('Arbusto'), findsOneWidget);
    expect(find.text('Hierba'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('tipo-Arbusto')));
    expect(busqueda.tipoPlanta, 'Arbusto');
    await tester.tap(find.byKey(const ValueKey('quiz-back')));
    await tester.pumpAndSettle();
    expect(find.text('Clima'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('quiz-next')));
    await tester.pumpAndSettle();
    expect(find.text('Tipo'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('quiz-next')));
    await tester.pumpAndSettle();
    expect(find.text('Color'), findsOneWidget);
    expect(find.byKey(const ValueKey('quiz-back')), findsOneWidget);
    expect(find.text('Blanco'), findsWidgets);
    await tester.drag(
      find.byKey(const ValueKey('color-page-view')),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    expect(busqueda.color, 'Verde');
    for (var indice = 1; indice < 7; indice++) {
      await tester.drag(
        find.byKey(const ValueKey('color-page-view')),
        const Offset(0, -400),
      );
      await tester.pumpAndSettle();
    }
    expect(busqueda.color, 'Blanco');

    await tester.tap(find.byKey(const ValueKey('quiz-next')));
    await tester.pumpAndSettle();

    expect(find.text('Plantas compatibles'), findsOneWidget);
    expect(find.text('Arrayán'), findsNWidgets(2));
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                'assets/images/Arrayán.png',
      ),
      findsOneWidget,
    );
    expect(motor.busquedaRealizada, isTrue);

    await tester.ensureVisible(find.text('¡Coleccionar!'));
    await tester.pumpAndSettle();
    jardinPulsado = false;
    await tester.tap(find.text('¡Coleccionar!'));
    await tester.pumpAndSettle();
    expect(coleccion.nombresAdoptados, ['Arrayán']);
    expect(jardinPulsado, isTrue);
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
        imagenAsset: 'assets/images/Arrayán.png',
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
