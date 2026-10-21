import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

import '../models/planta.dart';

typedef ObtenerPlantasCompatiblesAvanzadoC = Pointer<Utf8> Function(
  Int32 altitud,
  Pointer<Utf8> clima,
  Pointer<Utf8> tipoPlanta,
  Pointer<Utf8> color,
  Pointer<Utf8> jsonBaseDatos,
);
typedef ObtenerProgresoColeccionC = Pointer<Utf8> Function(
  Pointer<Utf8> jsonColeccionadas,
  Pointer<Utf8> jsonBaseDatos,
);
typedef LiberarCadenaC = Void Function(Pointer<Utf8> ptr);

typedef ObtenerPlantasCompatiblesAvanzadoDart = Pointer<Utf8> Function(
  int altitud,
  Pointer<Utf8> clima,
  Pointer<Utf8> tipoPlanta,
  Pointer<Utf8> color,
  Pointer<Utf8> jsonBaseDatos,
);
typedef ObtenerProgresoColeccionDart = Pointer<Utf8> Function(
  Pointer<Utf8> jsonColeccionadas,
  Pointer<Utf8> jsonBaseDatos,
);
typedef LiberarCadenaDart = void Function(Pointer<Utf8> ptr);

abstract interface class MotorJardin {
  Future<List<Planta>> obtenerPlantasCompatiblesAvanzado(
    int altitud,
    String clima,
    String tipoPlanta,
    String color,
  );

  Future<Map<String, dynamic>> obtenerProgresoColeccion(
    List<String> nombresColeccionadas,
  );

  Future<List<Planta>> cargarCatalogo();
}

class NativeBridge implements MotorJardin {
  late final DynamicLibrary _dylib;
  late final ObtenerPlantasCompatiblesAvanzadoDart
  _obtenerPlantasCompatiblesAvanzado;
  late final ObtenerProgresoColeccionDart _obtenerProgresoColeccion;
  late final LiberarCadenaDart _liberarCadena;

  NativeBridge() {
    if (Platform.isMacOS || Platform.isIOS) {
      _dylib = DynamicLibrary.process();
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('libjardincito.so');
    } else if (Platform.isWindows) {
      _dylib = DynamicLibrary.open('jardincito.dll');
    } else {
      _dylib = DynamicLibrary.process();
    }

    _obtenerPlantasCompatiblesAvanzado = _dylib
        .lookup<NativeFunction<ObtenerPlantasCompatiblesAvanzadoC>>(
          'obtenerPlantasCompatiblesAvanzadoJSON',
        )
        .asFunction<ObtenerPlantasCompatiblesAvanzadoDart>();

    _obtenerProgresoColeccion = _dylib
        .lookup<NativeFunction<ObtenerProgresoColeccionC>>(
          'obtenerProgresoColeccionJSON',
        )
        .asFunction<ObtenerProgresoColeccionDart>();

    _liberarCadena = _dylib
        .lookup<NativeFunction<LiberarCadenaC>>('liberarCadena')
        .asFunction<LiberarCadenaDart>();
  }

  @override
  Future<List<Planta>> obtenerPlantasCompatiblesAvanzado(
    int altitud,
    String clima,
    String tipoPlanta,
    String color,
  ) async {
    final jsonBaseDatos = await _cargarBaseDatos();
    final climaPointer = clima.toNativeUtf8();
    final tipoPlantaPointer = tipoPlanta.toNativeUtf8();
    final colorPointer = color.toNativeUtf8();
    final jsonBaseDatosPointer = jsonBaseDatos.toNativeUtf8();

    try {
      final resultadoPointer = _obtenerPlantasCompatiblesAvanzado(
        altitud,
        climaPointer,
        tipoPlantaPointer,
        colorPointer,
        jsonBaseDatosPointer,
      );
      final resultadoJson = _leerYLiberar(resultadoPointer);
      final listaJson = jsonDecode(resultadoJson) as List<dynamic>;
      return listaJson
          .map(
            (item) => Planta.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } finally {
      calloc
        ..free(climaPointer)
        ..free(tipoPlantaPointer)
        ..free(colorPointer)
        ..free(jsonBaseDatosPointer);
    }
  }

  @override
  Future<Map<String, dynamic>> obtenerProgresoColeccion(
    List<String> nombresColeccionadas,
  ) async {
    final jsonBaseDatos = await _cargarBaseDatos();
    final jsonColeccionadasPointer = jsonEncode(nombresColeccionadas)
        .toNativeUtf8();
    final jsonBaseDatosPointer = jsonBaseDatos.toNativeUtf8();

    try {
      final resultadoPointer = _obtenerProgresoColeccion(
        jsonColeccionadasPointer,
        jsonBaseDatosPointer,
      );
      final resultadoJson = _leerYLiberar(resultadoPointer);
      return Map<String, dynamic>.from(jsonDecode(resultadoJson) as Map);
    } finally {
      calloc
        ..free(jsonColeccionadasPointer)
        ..free(jsonBaseDatosPointer);
    }
  }

  Future<List<Planta>> obtenerPlantasCompatibles(int altitud, String clima) {
    return obtenerPlantasCompatiblesAvanzado(altitud, clima, '', '');
  }

  @override
  Future<List<Planta>> cargarCatalogo() async {
    final jsonCatalogo = jsonDecode(await _cargarBaseDatos()) as List<dynamic>;
    return jsonCatalogo
        .map((item) => Planta.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<String> _cargarBaseDatos() {
    return rootBundle.loadString('assets/data/plantas.json');
  }

  String _leerYLiberar(Pointer<Utf8> resultadoPointer) {
    if (resultadoPointer == nullptr) {
      throw StateError('La función nativa no devolvió un resultado.');
    }

    try {
      return resultadoPointer.toDartString();
    } finally {
      _liberarCadena(resultadoPointer);
    }
  }
}
