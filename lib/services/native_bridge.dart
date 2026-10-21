import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import '../models/planta.dart';

// Definición de firmas C
typedef ObtenerPlantasC = Pointer<Utf8> Function(Int32 altitud, Pointer<Utf8> clima);
typedef LiberarCadenaC = Void Function(Pointer<Utf8> ptr);

// Definición de firmas Dart
typedef ObtenerPlantasDart = Pointer<Utf8> Function(int altitud, Pointer<Utf8> clima);
typedef LiberarCadenaDart = void Function(Pointer<Utf8> ptr);

class NativeBridge {
  late final DynamicLibrary _dylib;
  late final ObtenerPlantasDart _obtenerPlantas;
  late final LiberarCadenaDart _liberarCadena;

  NativeBridge() {
    // Carga de la biblioteca compilada según plataforma
    if (Platform.isMacOS || Platform.isIOS) {
      _dylib = DynamicLibrary.process();
    } else if (Platform.isAndroid) {
      _dylib = DynamicLibrary.open('libjardincito.so');
    } else if (Platform.isWindows) {
      _dylib = DynamicLibrary.open('jardincito.dll');
    } else {
      _dylib = DynamicLibrary.process();
    }

    _obtenerPlantas = _dylib
        .lookup<NativeFunction<ObtenerPlantasC>>('obtenerPlantasCompatiblesJSON')
        .asFunction<ObtenerPlantasDart>();

    _liberarCadena = _dylib
        .lookup<NativeFunction<LiberarCadenaC>>('liberarCadena')
        .asFunction<LiberarCadenaDart>();
  }

  List<Planta> obtenerPlantasCompatibles(int altitud, String clima) {
    final climaPointer = clima.toNativeUtf8();

    try {
      // 1. Invocar función nativa de C++
      final resultadoPointer = _obtenerPlantas(altitud, climaPointer);

      if (resultadoPointer == nullptr) {
        return [];
      }

      // 2. Leer la cadena UTF-8 en Dart
      final jsonString = resultadoPointer.toDartString();

      // 3. Liberar la memoria asignada en C++ para evitar memory leaks
      _liberarCadena(resultadoPointer);

      // 4. Deserializar el JSON
      final List<dynamic> listaJson = jsonDecode(jsonString);
      return listaJson.map((item) => Planta.fromJson(item)).toList();
    } finally {
      // Liberar la cadena enviada como parámetro
      calloc.free(climaPointer);
    }
  }
}
