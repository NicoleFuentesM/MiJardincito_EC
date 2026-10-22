#include "jardincito_bridge.h"
#include "Jardincito.h"
#include "CargadorJSON.h"
#include "json.hpp"

#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>
#include <cmath>

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

    if (jsonBaseDatos != nullptr && std::strlen(jsonBaseDatos) > 0) {
        CargadorJSON::cargarPlantasDesdeString(miJardin, std::string(jsonBaseDatos));
    } else {
        CargadorJSON::cargarPlantas(miJardin, "data/plantas.json");
    }

    std::string climaStr = (clima != nullptr) ? std::string(clima) : "";
    std::string tipoStr = (tipoPlanta != nullptr) ? std::string(tipoPlanta) : "";
    std::string colorStr = (color != nullptr) ? std::string(color) : "";

    std::vector<PlantaNativa> recomendadas = miJardin.buscarPlantasCompatiblesAvanzado(
        altitud, climaStr, tipoStr, colorStr
    );

    json arrayResultado = json::array();
    for (const auto& planta : recomendadas) {
        json item;
        item["nombreComun"] = planta.getNombreComun();
        item["nombreCientifico"] = planta.getNombreCientifico();
        item["region"] = planta.getRegion();
        item["altitudIdeal"] = planta.getAltitudIdeal();
        item["tipoClima"] = planta.getTipoClima();
        item["tipoPlanta"] = planta.getTipoPlanta();
        item["color"] = planta.getColor();

        // Recalcular puntaje específico de esta planta para la UI de Flutter
        double score = 0.0;
        int diffAlt = std::abs(planta.getAltitudIdeal() - altitud);
        if (diffAlt <= 500) score += 30.0 * (1.0 - (static_cast<double>(diffAlt) / 500.0));
        if (!climaStr.empty() && climaStr == planta.getTipoClima()) score += 25.0;
        if (!tipoStr.empty() && tipoStr == planta.getTipoPlanta()) score += 25.0;
        if (!colorStr.empty() && colorStr == planta.getColor()) score += 20.0;

        item["porcentajeCoincidencia"] = static_cast<int>(score);
        arrayResultado.push_back(item);
    }

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

    if (jsonBaseDatos != nullptr && std::strlen(jsonBaseDatos) > 0) {
        CargadorJSON::cargarPlantasDesdeString(miJardin, std::string(jsonBaseDatos));
    } else {
        CargadorJSON::cargarPlantas(miJardin, "data/plantas.json");
    }

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
        } catch (...) {}
    }

    std::string reporteStr = miJardin.generarReporteColeccion(listaColeccionadas);

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
