import 'package:flutter/material.dart';

import '../../models/planta.dart';
import '../../services/native_bridge.dart';

class JardinVirtualProvider extends ChangeNotifier {
  JardinVirtualProvider({MotorJardin? motor})
    : _motor = motor ?? NativeBridge();

  final MotorJardin _motor;
  List<Planta> _plantas = [];
  int _totalColeccionadas = 0;
  int _totalEspecies = 0;
  double _porcentaje = 0;
  String _rango = 'Sembrador Novato';
  bool _cargando = false;
  String? _error;

  List<Planta> get plantas => List.unmodifiable(_plantas);
  int get totalColeccionadas => _totalColeccionadas;
  int get totalEspecies => _totalEspecies;
  double get porcentaje => _porcentaje;
  String get rango => _rango;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargar(List<String> nombresAdoptados) async {
    if (_cargando) return;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final resultados = await Future.wait([
        _motor.cargarCatalogo(),
        _motor.obtenerProgresoColeccion(nombresAdoptados),
      ]);
      final catalogo = resultados[0] as List<Planta>;
      final reporte = resultados[1] as Map<String, dynamic>;

      _plantas = catalogo;
      _totalColeccionadas = (reporte['totalColeccionadas'] as num).toInt();
      _totalEspecies = (reporte['totalEspecies'] as num).toInt();
      _porcentaje = (reporte['porcentaje'] as num).toDouble();
      _rango = reporte['nivelJardinero'] as String;
    } on FlutterError catch (error) {
      _error = 'No se pudo cargar la base de plantas: $error';
    } on ArgumentError catch (error) {
      _error = 'No se pudo conectar con el motor nativo: $error';
    } on StateError catch (error) {
      _error = 'El motor nativo devolvió un resultado inválido: $error';
    } on Exception catch (error) {
      _error = 'No se pudo cargar el jardín virtual: $error';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
