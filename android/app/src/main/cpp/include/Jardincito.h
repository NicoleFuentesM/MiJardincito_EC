#ifndef JARDINCITO_H
#define JARDINCITO_H

#include "PlantaNativa.h"
#include <vector>
#include <string>

class Jardincito {
private:
    std::vector<PlantaNativa> listaPlantas;

public:
    Jardincito();

    void agregarPlanta(const PlantaNativa& planta);
    std::vector<PlantaNativa> getListaPlantas() const;

    // Búsqueda básica
    std::vector<PlantaNativa> buscarPlantasCompatibles(int altitudUsuario, const std::string& climaUsuario) const;

    // Búsqueda multicriterio (Día 4)
    std::vector<PlantaNativa> buscarPlantasCompatiblesAvanzado(
        int altitudUsuario,
        const std::string& climaUsuario,
        const std::string& tipoPlantaUsuario,
        const std::string& colorUsuario
    ) const;
    // Nuevo módulo: Lógica de colección e insignias del Jardín Virtual
        std::string generarReporteColeccion(const std::vector<std::string>& nombresColeccionados) const;
};

#endif // JARDINCITO_H
