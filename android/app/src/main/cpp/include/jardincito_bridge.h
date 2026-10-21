#ifndef JARDINCITO_BRIDGE_H
#define JARDINCITO_BRIDGE_H

#ifdef __cplusplus
extern "C" {
#endif

// Exporta la función multicriterio para Dart FFI recibiendo los 4 filtros y la base de datos JSON en memoria
const char* obtenerPlantasCompatiblesAvanzadoJSON(
    int altitud,
    const char* clima,
    const char* tipoPlanta,
    const char* color,
    const char* jsonBaseDatos
);

// Nueva función expuesta para calcular las estadísticas del Jardín Virtual
const char* obtenerProgresoColeccionJSON(
    const char* jsonColeccionadas,
    const char* jsonBaseDatos
);

// Liberación de memoria asignada en el heap de C++
void liberarCadena(char* ptr);

#ifdef __cplusplus
}
#endif

#endif // JARDINCITO_BRIDGE_H
