import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mijardincito_ec/models/planta.dart';
import 'package:mijardincito_ec/presentation/providers/coleccion_plantas_provider.dart';
import 'package:mijardincito_ec/presentation/providers/jardin_virtual_provider.dart';
import 'package:mijardincito_ec/presentation/screens/mi_jardin_virtual_screen.dart';
import 'package:mijardincito_ec/services/native_bridge.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'nombres_plantas_adoptadas': ['Arrayán'],
    });
  });

  test('envía la colección al motor y conserva reporte y catálogo', () async {
    final motor = _MotorFalso();
    final jardin = JardinVirtualProvider(motor: motor);

    await jardin.cargar(['Arrayán', 'Chuquiragua']);

    expect(motor.nombresEnviados, ['Arrayán', 'Chuquiragua']);
    expect(jardin.porcentaje, 20.0);
    expect(jardin.rango, 'Jardinero de Montaña');
    expect(jardin.plantas, hasLength(2));
    expect(jardin.error, isNull);
  });

  testWidgets('muestra el progreso y distingue plantas descubiertas', (
    tester,
  ) async {
    final coleccion = ColeccionPlantasProvider();
    await coleccion.cargar();
    final jardin = JardinVirtualProvider(motor: _MotorFalso());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: coleccion),
          ChangeNotifierProvider.value(value: jardin),
        ],
        child: const MaterialApp(home: MiJardinVirtualScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(jardin.error, isNull);
    expect(jardin.cargando, isFalse);
    expect(find.text('Progreso de flora: 20.0%'), findsOneWidget);
    expect(find.text('Rango: Jardinero de Montaña'), findsOneWidget);
    expect(find.text('Arrayán'), findsOneWidget);
    expect(find.text('Especie por descubrir'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    final imagenPlanta = tester.widget<Image>(find.byType(Image).first);
    expect(
      (imagenPlanta.image as AssetImage).assetName,
      'assets/images/Arrayán.png',
    );
    expect(find.byType(GridView), findsOneWidget);
  });
}

class _MotorFalso implements MotorJardin {
  List<String>? nombresEnviados;

  @override
  Future<List<Planta>> cargarCatalogo() async => [
    Planta.fromJson({
      'nombreComun': 'Arrayán',
      'nombreCientifico': 'Myrcianthes hallii',
      'region': 'Andes',
      'altitudIdeal': 2800,
      'tipoClima': 'Templado',
      'tipoPlanta': 'Árbol',
      'color': 'Blanco',
      'imagenAsset': 'assets/images/Arrayán.png',
    }),
    Planta.fromJson({
      'nombreComun': 'Chuquiragua',
      'nombreCientifico': 'Chuquiraga jussieui',
      'region': 'Andes',
      'altitudIdeal': 3500,
      'tipoClima': 'Frío',
      'tipoPlanta': 'Arbusto',
      'color': 'Naranja',
    }),
  ];

  @override
  Future<Map<String, dynamic>> obtenerProgresoColeccion(
    List<String> nombresColeccionadas,
  ) async {
    nombresEnviados = nombresColeccionadas;
    return {
      'totalColeccionadas': 2,
      'totalEspecies': 10,
      'porcentaje': 20.0,
      'nivelJardinero': 'Jardinero de Montaña',
    };
  }

  @override
  Future<List<Planta>> obtenerPlantasCompatiblesAvanzado(
    int altitud,
    String clima,
    String tipoPlanta,
    String color,
  ) async => [];
}
