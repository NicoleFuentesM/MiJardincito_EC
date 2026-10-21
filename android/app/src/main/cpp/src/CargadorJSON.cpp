#include "CargadorJSON.h"
#include "json.hpp"
#include <fstream>
#include <iostream>

using json = nlohmann::json;

void CargadorJSON::cargarPlantas(Jardincito& jardin, const std::string& rutaArchivo) {
    std::ifstream archivo(rutaArchivo);
    if (!archivo.is_open()) {
        std::cerr << "Error al abrir el archivo JSON: " << rutaArchivo << std::endl;
        return;
    }

    json datos;
    archivo >> datos;

    for (const auto& item : datos) {
        std::string nComun = item.value("nombreComun", "");
        std::string nCientifico = item.value("nombreCientifico", "");
        std::string region = item.value("region", "");
        int altitud = item.value("altitudIdeal", 0);
        std::string clima = item.value("tipoClima", "");
        std::string tipo = item.value("tipoPlanta", "");
        std::string color = item.value("color", "");

        PlantaNativa planta(nComun, nCientifico, region, altitud, clima, tipo, color);
        jardin.agregarPlanta(planta);
    }
}

void CargadorJSON::cargarPlantasDesdeString(Jardincito& jardin, const std::string& jsonContenido) {
    if (jsonContenido.empty()) return;

    try {
        json datos = json::parse(jsonContenido);
        for (const auto& item : datos) {
            std::string nComun = item.value("nombreComun", "");
            std::string nCientifico = item.value("nombreCientifico", "");
            std::string region = item.value("region", "");
            int altitud = item.value("altitudIdeal", 0);
            std::string clima = item.value("tipoClima", "");
            std::string tipo = item.value("tipoPlanta", "");
            std::string color = item.value("color", "");

            PlantaNativa planta(nComun, nCientifico, region, altitud, clima, tipo, color);
            jardin.agregarPlanta(planta);
        }
    } catch (const json::parse_error& e) {
        std::cerr << "Error al parsear la cadena JSON: " << e.what() << std::endl;
    }
}
