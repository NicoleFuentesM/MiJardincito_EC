import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mijardincito_ec/main.dart';
import 'package:mijardincito_ec/models/planta.dart';
import 'package:mijardincito_ec/presentation/providers/busqueda_plantas_provider.dart';
import 'package:mijardincito_ec/presentation/providers/coleccion_plantas_provider.dart';
import 'package:mijardincito_ec/presentation/providers/jardin_virtual_provider.dart';
import 'package:mijardincito_ec/services/native_bridge.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('el primer inicio abre el cuestionario sin barra superior', (
    tester,
  ) async {
    await tester.pumpWidget(const MiJardincitoApp());
    await tester.pumpAndSettle();

    expect(find.text('Altitud'), findsOneWidget);
    expect(find.text('Mi Jardincito EC'), findsNothing);
    expect(find.byType(AppBar), findsNothing);
    expect(find.text('Buscar'), findsNothing);
  });

  testWidgets('abre Mi Jardín si ya hay una planta en la colección', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'nombres_plantas_adoptadas': ['Arrayán'],
    });
    final coleccion = ColeccionPlantasProvider();
    await coleccion.cargar();
    final motor = _MotorFalso();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => BusquedaPlantasProvider(motor: motor),
          ),
          ChangeNotifierProvider.value(value: coleccion),
          ChangeNotifierProvider(
            create: (_) => JardinVirtualProvider(motor: motor),
          ),
        ],
        child: const MaterialApp(home: NavegacionPrincipal()),
      ),
    );
    await tester.pumpAndSettle();

    final navegacion = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(navegacion.selectedIndex, 1);
    expect(find.text('Buscar'), findsOneWidget);
    expect(find.text('Mi Jardín'), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
  });
}

class _MotorFalso implements MotorJardin {
  @override
  Future<List<Planta>> cargarCatalogo() async => [];

  @override
  Future<Map<String, dynamic>> obtenerProgresoColeccion(
    List<String> nombresColeccionadas,
  ) async => {
    'totalColeccionadas': nombresColeccionadas.length,
    'totalEspecies': 0,
    'porcentaje': 0.0,
    'nivelJardinero': 'Sembrador Novato',
  };

  @override
  Future<List<Planta>> obtenerPlantasCompatiblesAvanzado(
    int altitud,
    String clima,
    String tipoPlanta,
    String color,
  ) async => [];
}
