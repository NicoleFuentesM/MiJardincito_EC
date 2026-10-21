#include "Jardincito.h"
#include "json.hpp"
#include <cmath>
#include <algorithm>

using json = nlohmann::json;

Jardincito::Jardincito() {}

void Jardincito::agregarPlanta(const PlantaNativa& planta) {
    listaPlantas.push_back(planta);
}

std::vector<PlantaNativa> Jardincito::getListaPlantas() const {
    return listaPlantas;
}

std::vector<PlantaNativa> Jardincito::buscarPlantasCompatibles(int altitudUsuario, const std::string& climaUsuario) const {
    return buscarPlantasCompatiblesAvanzado(altitudUsuario, climaUsuario, "", "");
}

std::vector<PlantaNativa> Jardincito::buscarPlantasCompatiblesAvanzado(
    int altitudUsuario,
    const std::string& climaUsuario,
    const std::string& tipoPlantaUsuario,
    const std::string& colorUsuario
) const {
    std::vector<PlantaNativa> compatibles;

    for (const auto& planta : listaPlantas) {
        // 1. Filtro de Altitud (+- 500 metros)
        bool coincideAltitud = std::abs(planta.getAltitudIdeal() - altitudUsuario) <= 500;

        // 2. Filtro de Clima (coincidencia exacta o comodín "Todos" / "")
        bool coincideClima = climaUsuario.empty() || climaUsuario == "Todos" || planta.getTipoClima() == climaUsuario;

        // 3. Filtro de Tipo de Planta (coincidencia exacta o comodín "Todos" / "")
        bool coincideTipo = tipoPlantaUsuario.empty() || tipoPlantaUsuario == "Todos" || planta.getTipoPlanta() == tipoPlantaUsuario;

        // 4. Filtro de Color (coincidencia exacta o comodín "Todos" / "")
        bool coincideColor = colorUsuario.empty() || colorUsuario == "Todos" || planta.getColor() == colorUsuario;

        if (coincideAltitud && coincideClima && coincideTipo && coincideColor) {
            compatibles.push_back(planta);
        }
    }

    return compatibles;
}

std::string Jardincito::generarReporteColeccion(const std::vector<std::string>& nombresColeccionados) const {
    int totalBaseDatos = static_cast<int>(listaPlantas.size());
    int contadorValidos = 0;

    // Verificar cuántas plantas de la lista ingresada realmente existen en el catálogo
    for (const auto& nombre : nombresColeccionados) {
        bool existe = std::any_of(listaPlantas.begin(), listaPlantas.end(),
            [&nombre](const PlantaNativa& p) { return p.getNombreComun() == nombre; });
        if (existe) {
            contadorValidos++;
        }
    }

    double porcentaje = (totalBaseDatos > 0)
        ? (static_cast<double>(contadorValidos) / totalBaseDatos) * 100.0
        : 0.0;

    // Asignación de nivel según el porcentaje alcanzado
    std::string nivel = "Sembrador Novato";
    if (porcentaje >= 80.0) {
        nivel = "Guardia de la Flora Andina";
    } else if (porcentaje >= 50.0) {
        nivel = "Botánico Ecologista";
    } else if (porcentaje >= 20.0) {
        nivel = "Jardinero de Montaña";
    }

    json reporte;
    reporte["totalColeccionadas"] = contadorValidos;
    reporte["totalEspecies"] = totalBaseDatos;
    reporte["porcentaje"] = porcentaje;
    reporte["nivelJardinero"] = nivel;

    return reporte.dump();
}
