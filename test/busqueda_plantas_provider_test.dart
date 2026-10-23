import 'package:flutter_test/flutter_test.dart';
import 'package:mijardincito_ec/models/planta.dart';
import 'package:mijardincito_ec/presentation/providers/busqueda_plantas_provider.dart';
import 'package:mijardincito_ec/services/native_bridge.dart';

void main() {
  test('recibe y publica las especies que devuelve el motor', () async {
    final motor = _MotorBusquedaFalso();
    final busqueda = BusquedaPlantasProvider(motor: motor);
    busqueda.cambiarColor('Naranja');
    busqueda.cambiarTipoPlanta('Hierba');

    await busqueda.buscarPlantas();

    expect(motor.filtrosRecibidos, (2800, 'Templado', 'Hierba', 'Naranja'));
    expect(busqueda.plantas, hasLength(1));
    expect(busqueda.plantas.single.nombreComun, 'Arrayán');
    expect(busqueda.consultaRealizada, isTrue);
    expect(busqueda.error, isNull);
  });

  test('rechaza colores fuera de la lista permitida', () {
    final busqueda = BusquedaPlantasProvider(motor: _MotorBusquedaFalso());

    expect(BusquedaPlantasProvider.colores, [
      'Blanco',
      'Verde',
      'Naranja',
      'Amarillo',
      'Morado',
      'Rojo',
      'Azul',
    ]);
    expect(() => busqueda.cambiarColor('Todos'), throwsArgumentError);
  });

  test('solo permite los tres tipos de planta definidos', () {
    final busqueda = BusquedaPlantasProvider(motor: _MotorBusquedaFalso());

    expect(BusquedaPlantasProvider.tipos.keys, [
      'Árbol',
      'Arbusto',
      'Hierba',
    ]);
    expect(busqueda.tipoPlanta, 'Árbol');
    expect(() => busqueda.cambiarTipoPlanta('Todos'), throwsArgumentError);
  });
}

class _MotorBusquedaFalso implements MotorJardin {
  (int, String, String, String)? filtrosRecibidos;

  @override
  Future<List<Planta>> obtenerPlantasCompatiblesAvanzado(
    int altitud,
    String clima,
    String tipoPlanta,
    String color,
  ) async {
    filtrosRecibidos = (altitud, clima, tipoPlanta, color);
    return [
      Planta(
        nombreComun: 'Arrayán',
        nombreCientifico: 'Myrcianthes hallii',
        region: 'Andes',
        altitudIdeal: 2800,
        tipoClima: 'Templado',
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
