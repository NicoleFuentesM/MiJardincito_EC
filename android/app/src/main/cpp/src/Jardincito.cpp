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

// Función auxiliar estática para calcular coincidencia de 0% a 100%
static double calcularPorcentajeCoincidencia(
    int altitudUser, const std::string& climaUser,
    const std::string& tipoUser, const std::string& colorUser,
    const PlantaNativa& planta
) {
    double puntaje = 0.0;

    // 1. Altitud (Peso máximo: 30%) - Proporcional dentro del rango de +-500m
    int diffAlt = std::abs(planta.getAltitudIdeal() - altitudUser);
    if (diffAlt <= 500) {
        puntaje += 30.0 * (1.0 - (static_cast<double>(diffAlt) / 500.0));
    }

    // 2. Clima (Peso máximo: 25%) - Coincidencia exacta
    if (!climaUser.empty() && climaUser == planta.getTipoClima()) {
        puntaje += 25.0;
    }

    // 3. Tipo de Planta (Peso máximo: 25%) - Coincidencia exacta
    if (!tipoUser.empty() && tipoUser == planta.getTipoPlanta()) {
        puntaje += 25.0;
    }

    // 4. Color (Peso máximo: 20%) - Coincidencia exacta
    if (!colorUser.empty() && colorUser == planta.getColor()) {
        puntaje += 20.0;
    }

    return puntaje;
}

std::vector<PlantaNativa> Jardincito::buscarPlantasCompatiblesAvanzado(
    int altitudUsuario,
    const std::string& climaUsuario,
    const std::string& tipoPlantaUsuario,
    const std::string& colorUsuario
) const {
    std::vector<PlantaNativa> resultado;

    double maxPuntaje = -1.0;
    const PlantaNativa* mejorCandidata = nullptr;

    for (const auto& planta : listaPlantas) {
        double score = calcularPorcentajeCoincidencia(
            altitudUsuario, climaUsuario, tipoPlantaUsuario, colorUsuario, planta
        );

        // Si la coincidencia es exacta (100%), se agrega a la lista de éxitos
        if (score >= 99.0) {
            resultado.push_back(planta);
        }

        // Guardar la planta con mayor coincidencia para sugerencia cercana
        if (score > maxPuntaje) {
            maxPuntaje = score;
            mejorCandidata = &planta;
        }
    }

    // Si no hubo coincidencia perfecta de 100%, retornar únicamente la planta más cercana
    if (resultado.empty() && mejorCandidata != nullptr) {
        resultado.push_back(*mejorCandidata);
    }

    return resultado;
}

std::string Jardincito::generarReporteColeccion(const std::vector<std::string>& nombresColeccionados) const {
    int totalBaseDatos = static_cast<int>(listaPlantas.size());
    int contadorValidos = 0;

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
