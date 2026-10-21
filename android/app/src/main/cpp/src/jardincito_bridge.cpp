#include "jardincito_bridge.h"
#include "Jardincito.h"
#include "CargadorJSON.h"
#include "json.hpp"

#include <cmath>
#include <cstdlib>
#include <cstring>
#include <string>
#include <vector>

using json = nlohmann::json;

const char* JSON_PLANTAS_DEFAULT = R"([
  {
    "nombreComun": "Arrayan de Quito",
    "nombreCientifico": "Myrcianthes hallii",
    "region": "Andes",
    "altitudIdeal": 2800,
    "tipoClima": "Templado"
  },
  {
    "nombreComun": "Pumamaqui",
    "nombreCientifico": "Oreopanax ecuadorensis",
    "region": "Andes",
    "altitudIdeal": 2800,
    "tipoClima": "Templado"
  },
  {
    "nombreComun": "Chilca",
    "nombreCientifico": "Baccharis latifolia",
    "region": "Andes",
    "altitudIdeal": 2600,
    "tipoClima": "Templado"
  }
])";

extern "C" {

const char* obtenerPlantasCompatiblesJSON(int altitud, const char* clima) {
    Jardincito miJardin;
    std::string rutaJson = "data/plantas.json";

    CargadorJSON::cargarPlantas(miJardin, rutaJson);

    std::string climaStr = (clima != nullptr) ? std::string(clima) : "";
    std::vector<PlantaNativa> filtradas =
        miJardin.buscarPlantasCompatibles(altitud, climaStr);

    json arrayResultado = json::array();

    if (filtradas.empty()) {
        auto fallbackJson = json::parse(JSON_PLANTAS_DEFAULT);
        for (const auto& item : fallbackJson) {
            int alt = item["altitudIdeal"];
            std::string cl = item["tipoClima"];
            if (std::abs(alt - altitud) <= 500 && cl == climaStr) {
                arrayResultado.push_back(item);
            }
        }
    } else {
        for (const auto& planta : filtradas) {
            json item;
            item["nombreComun"] = planta.getNombreComun();
            item["nombreCientifico"] = planta.getNombreCientifico();
            item["region"] = planta.getRegion();
            item["altitudIdeal"] = planta.getAltitudIdeal();
            item["tipoClima"] = planta.getTipoClima();
            arrayResultado.push_back(item);
        }
    }

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
