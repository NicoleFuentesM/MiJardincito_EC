import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mijardincito_ec/presentation/providers/coleccion_plantas_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('recupera nombres guardados de la colección', () async {
    SharedPreferences.setMockInitialValues({
      'nombres_plantas_adoptadas': ['Arrayán', 'Chuquiragua'],
    });
    final coleccion = ColeccionPlantasProvider();

    await coleccion.cargar();

    expect(coleccion.nombresAdoptados, ['Arrayán', 'Chuquiragua']);
  });

  test('guarda especies adoptadas sin duplicar nombres', () async {
    final coleccion = ColeccionPlantasProvider();
    await coleccion.cargar();

    await coleccion.adoptar('Arrayán');
    await coleccion.adoptar('Arrayán');

    final preferencias = await SharedPreferences.getInstance();
    expect(coleccion.nombresAdoptados, ['Arrayán']);
    expect(preferencias.getStringList('nombres_plantas_adoptadas'), [
      'Arrayán',
    ]);

    final coleccionRecuperada = ColeccionPlantasProvider();
    await coleccionRecuperada.cargar();
    expect(coleccionRecuperada.nombresAdoptados, ['Arrayán']);
  });
}
