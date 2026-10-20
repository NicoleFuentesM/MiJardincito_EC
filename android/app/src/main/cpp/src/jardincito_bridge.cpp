//
//  jardin_bridge.cpp
//  MyTool
//
//  Created by Nicole Rafaela Fuentes Manosalvas on 10/20/26.
//

#include "jardincito_bridge.h"
#include "Jardincito.h"
#include "CargadorJSON.h"
#include "json.hpp" // Importante: debe incluirse antes del alias 'using json'

#include <cstdlib>
#include <cstring>
#include <string>

using json = nlohmann::json;

extern "C" {

const char* obtenerPlantasCompatiblesJSON(int altitud, const char* clima) {
    Jardincito miJardin;
    std::string rutaJson = "data/plantas.json";
    
    // 1. Cargar la base de datos de plantas
    CargadorJSON::cargarPlantas(miJardin, rutaJson);
    
    // 2. Ejecutar el filtro de compatibilidad
    std::string climaStr = (clima != nullptr) ? std::string(clima) : "";
    std::vector<PlantaNativa> filtradas = miJardin.buscarPlantasCompatibles(altitud, climaStr);
    
    // 3. Serializar las plantas encontradas en una estructura JSON
    json arrayResultado = json::array();
    for (const auto& planta : filtradas) {
        json item;
        item["nombreComun"] = planta.getNombreComun();
        item["nombreCientifico"] = planta.getNombreCientifico();
        item["region"] = planta.getRegion();
        item["altitudIdeal"] = planta.getAltitudIdeal();
        item["tipoClima"] = planta.getTipoClima();
        arrayResultado.push_back(item);
    }
    
    // 4. Reservar memoria dinamica (heap) para devolver la cadena C a Dart FFI
    std::string jsonStr = arrayResultado.dump();
    char* buffer = static_cast<char*>(malloc(jsonStr.length() + 1));
    if (buffer != nullptr) {
        std::strcpy(buffer, jsonStr.c_str());
    }
    
    return buffer;
}

void liberarCadena(char* ptr) {
    if (ptr != nullptr) {
        free(ptr);
    }
}

}
