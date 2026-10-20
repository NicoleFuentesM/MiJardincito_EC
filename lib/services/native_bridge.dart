import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import '../models/planta_model.dart';

// Definición de firmas C para la función nativa que creará tu compañera:
// const char* filtrarPlantasCompatiblesJSON(int altitud, const char* clima);

typedef FiltrarCompatiblesC = ffi.Pointer<Utf8> Function(
  ffi.Int32 altitud,
  ffi.Pointer<Utf8> clima,
);

typedef FiltrarCompatiblesDart = ffi.Pointer<Utf8> Function(
  int altitud,
  ffi.Pointer<Utf8> clima,
);

class NativeBridge {
  static late final ffi.DynamicLibrary _bibliotecaNativa;
  static late final FiltrarCompatiblesDart _filtrarCompatibles;

  static void inicializar() {
    // Carga de la biblioteca dinámica compilada según la plataforma
    if (Platform.isAndroid) {
      _bibliotecaNativa = ffi.DynamicLibrary.open('libjardincito.so');
    } else if (Platform.isIOS || Platform.isMacOS) {
      _bibliotecaNativa = ffi.DynamicLibrary.process();
    } else {
      _bibliotecaNativa = ffi.DynamicLibrary.open('libjardincito.dylib');
    }

    _filtrarCompatibles = _bibliotecaNativa
        .lookupFunction<FiltrarCompatiblesC, FiltrarCompatiblesDart>(
          'filtrarPlantasCompatiblesJSON',
        );
  }

  // Método de alto nivel para consumir directamente desde la UI de Flutter
  static List<PlantaModel> obtenerPlantasCompatibles(int altitud, String clima) {
    final climaPtr = clima.toNativeUtf8();

    try {
      // 1. Llamada a C++ a través de FFI
      final ffi.Pointer<Utf8> resultadoPtr = _filtrarCompatibles(altitud, climaPtr);
      final jsonString = resultadoPtr.toDartString();

      // 2. Deserialización usando el modelo que creaste
      final List<dynamic> listaDecodificada = jsonDecode(jsonString) as List<dynamic>;
      return listaDecodificada
          .map((item) => PlantaModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } finally {
      // Liberar la memoria asignada para evitar fugas (memory leaks)
      calloc.free(climaPtr);
    }
  }
}