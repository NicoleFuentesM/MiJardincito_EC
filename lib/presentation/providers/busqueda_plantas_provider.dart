import 'package:flutter/material.dart';

import '../../models/planta.dart';
import '../../services/native_bridge.dart';

class BusquedaPlantasProvider extends ChangeNotifier {
  BusquedaPlantasProvider({this.motor});

  final MotorJardin? motor;
  late final MotorJardin _motor = motor ?? NativeBridge();

  static const Map<String, String> climas = {
    'Cálido': 'Calido',
    'Templado': 'Templado',
    'Frío': 'Frio',
    'Páramo': 'Paramo',
  };

  static const Map<String, String> tipos = {
    'Árbol': 'Arbol',
    'Arbusto': 'Arbusto',
    'Hierba': 'Hierba',
  };

  static const List<String> colores = [
    'Blanco',
    'Verde',
    'Naranja',
    'Amarillo',
    'Morado',
    'Rojo',
    'Azul',
  ];

  int _altitud = 2800;
  String _clima = 'Templado';
  String _tipoPlanta = 'Árbol';
  String _color = 'Blanco';
  List<Planta> _plantas = [];
  bool _cargando = false;
  bool _consultaRealizada = false;
  String? _error;

  int get altitud => _altitud;
  String get clima => _clima;
  String get tipoPlanta => _tipoPlanta;
  String get color => _color;
  List<Planta> get plantas => List.unmodifiable(_plantas);
  bool get cargando => _cargando;
  bool get consultaRealizada => _consultaRealizada;
  String? get error => _error;

  void cambiarAltitud(double valor) {
    _altitud = valor.round();
    notifyListeners();
  }

  void cambiarClima(String valor) {
    _clima = valor;
    notifyListeners();
  }

  void cambiarTipoPlanta(String valor) {
    if (!tipos.containsKey(valor)) {
      throw ArgumentError.value(valor, 'valor', 'Tipo de planta no válido');
    }
    _tipoPlanta = valor;
    notifyListeners();
  }

  void cambiarColor(String valor) {
    if (!colores.contains(valor)) {
      throw ArgumentError.value(valor, 'valor', 'Color no válido');
    }
    _color = valor;
    notifyListeners();
  }

  Future<void> buscarPlantas() async {
    if (_cargando) return;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _plantas = await _motor.obtenerPlantasCompatiblesAvanzado(
        _altitud,
        climas[_clima]!,
        tipos[_tipoPlanta]!,
        _color,
      );
      _consultaRealizada = true;
    } on FlutterError catch (error) {
      _error = 'No se pudo cargar la base de plantas: $error';
    } on ArgumentError catch (error) {
      _error = 'No se pudo conectar con el motor nativo: $error';
    } on StateError catch (error) {
      _error = 'El motor nativo no pudo completar la búsqueda: $error';
    } on UnsupportedError catch (error) {
      _error = 'El motor nativo no está disponible en esta plataforma: $error';
    } on Exception catch (error) {
      _error = 'No se pudo realizar la búsqueda: $error';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
}
