import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColeccionPlantasProvider extends ChangeNotifier {
  static const String _claveNombres = 'nombres_plantas_adoptadas';

  List<String> _nombresAdoptados = [];
  bool _cargando = false;
  String? _error;

  List<String> get nombresAdoptados => List.unmodifiable(_nombresAdoptados);
  bool get cargando => _cargando;
  String? get error => _error;

  bool estaAdoptada(String nombreComun) =>
      _nombresAdoptados.contains(nombreComun);

  Future<void> cargar() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final preferencias = await SharedPreferences.getInstance();
      _nombresAdoptados =
          preferencias.getStringList(_claveNombres) ?? <String>[];
    } on Exception catch (error) {
      _error = 'No se pudo recuperar la colección: $error';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> adoptar(String nombreComun) async {
    if (_cargando || nombreComun.isEmpty || estaAdoptada(nombreComun)) return;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final nuevosNombres = [..._nombresAdoptados, nombreComun];
      final preferencias = await SharedPreferences.getInstance();
      final guardado = await preferencias.setStringList(
        _claveNombres,
        nuevosNombres,
      );
      if (!guardado) {
        throw StateError('El almacenamiento local rechazó la colección.');
      }
      _nombresAdoptados = nuevosNombres;
    } on Exception catch (error) {
      _error = 'No se pudo guardar la especie adoptada: $error';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
