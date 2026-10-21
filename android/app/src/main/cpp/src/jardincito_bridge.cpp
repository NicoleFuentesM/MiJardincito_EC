#include "jardincito_bridge.h"
#include "Jardincito.h"
#include "CargadorJSON.h"
#include "json.hpp"

#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>

using json = nlohmann::json;

extern "C" {

const char* obtenerPlantasCompatiblesAvanzadoJSON(
    int altitud,
    const char* clima,
    const char* tipoPlanta,
    const char* color,
    const char* jsonBaseDatos
) {
    Jardincito miJardin;

    // 1. Cargar plantas desde la cadena JSON en memoria (enviada desde Flutter)
    if (jsonBaseDatos != nullptr && std::strlen(jsonBaseDatos) > 0) {
        CargadorJSON::cargarPlantasDesdeString(miJardin, std::string(jsonBaseDatos));
    } else {
        // Fallback para ejecuciones locales en Xcode
        CargadorJSON::cargarPlantas(miJardin, "data/plantas.json");
    }

    // 2. Convertir parámetros C a std::string de C++
    std::string climaStr = (clima != nullptr) ? std::string(clima) : "";
    std::string tipoStr = (tipoPlanta != nullptr) ? std::string(tipoPlanta) : "";
    std::string colorStr = (color != nullptr) ? std::string(color) : "";

    // 3. Filtrar especies compatibles con el algoritmo multicriterio
    std::vector<PlantaNativa> filtradas = miJardin.buscarPlantasCompatiblesAvanzado(
        altitud, climaStr, tipoStr, colorStr
    );

    // 4. Serializar el resultado a un Array JSON
    json arrayResultado = json::array();
    for (const auto& planta : filtradas) {
        json item;
        item["nombreComun"] = planta.getNombreComun();
        item["nombreCientifico"] = planta.getNombreCientifico();
        item["region"] = planta.getRegion();
        item["altitudIdeal"] = planta.getAltitudIdeal();
        item["tipoClima"] = planta.getTipoClima();
        item["tipoPlanta"] = planta.getTipoPlanta();
        item["color"] = planta.getColor();
        arrayResultado.push_back(item);
    }

    // 5. Reservar memoria en el heap para entregar la cadena a Dart FFI
    std::string jsonStr = arrayResultado.dump();
    char* buffer = static_cast<char*>(malloc(jsonStr.length() + 1));
    if (buffer != nullptr) {
        std::strcpy(buffer, jsonStr.c_str());
    }

    return buffer;
}

const char* obtenerProgresoColeccionJSON(
    const char* jsonColeccionadas,
    const char* jsonBaseDatos
) {
    Jardincito miJardin;

    // 1. Cargar la base de datos completa de plantas
    if (jsonBaseDatos != nullptr && std::strlen(jsonBaseDatos) > 0) {
        CargadorJSON::cargarPlantasDesdeString(miJardin, std::string(jsonBaseDatos));
    } else {
        CargadorJSON::cargarPlantas(miJardin, "data/plantas.json");
    }

    // 2. Parsear la lista de plantas coleccionadas enviada desde Flutter
    std::vector<std::string> listaColeccionadas;
    if (jsonColeccionadas != nullptr && std::strlen(jsonColeccionadas) > 0) {
        try {
            json arrayColeccion = json::parse(jsonColeccionadas);
            if (arrayColeccion.is_array()) {
                for (const auto& elemento : arrayColeccion) {
                    if (elemento.is_string()) {
                        listaColeccionadas.push_back(elemento.get<std::string>());
                    }
                }
            }
        } catch (...) {
            // Manejo de error si la cadena enviada no es un JSON válido
        }
    }

    // 3. Generar las estadísticas en C++
    std::string reporteStr = miJardin.generarReporteColeccion(listaColeccionadas);

    // 4. Retornar memoria reservada para FFI
    char* buffer = static_cast<char*>(malloc(reporteStr.length() + 1));
    if (buffer != nullptr) {
        std::strcpy(buffer, reporteStr.c_str());
    }

    return buffer;
}

void liberarCadena(char* ptr) {
    if (ptr != nullptr) {
        free(ptr);
    }
}

}
