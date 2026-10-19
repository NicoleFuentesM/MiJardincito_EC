//
//  Jardincito.cpp
//  MyTool
//
//  Created by Nicole Rafaela Fuentes Manosalvas on 10/18/26.
//

#include "Jardincito.h"
#include <iostream>


//métodos para interactuar con la colleción
void Jardincito::agregarPlanta(const PlantaNativa& nuevaPlanta)
{
    //colección de plantas en el vector
    coleccionPlantas.push_back(nuevaPlanta);
}
//imprimir catálogo en terminal
void Jardincito::verJardincito() const
{
    if (coleccionPlantas.empty())
    {
        std::cout << "El jardin esta vacio. ¡Agrega plantitas nativas!" << std::endl;
        return;
    }
    std::cout << "\n=== CATALOGO DEL JARDINCITO EC ===" << std::endl;
    std::cout << "Total de especies: " << coleccionPlantas.size() << "\n" << std::endl;
    //Bucle for moderno (rangebased for loop)
    //con const auto& para no copiar los objetos y deducir el tipo automáticamente
    for (const auto& planta:coleccionPlantas)
    {
        planta.mostrarFicha();
        std::cout << std::string(15,'-') << std::endl;
    }
}
//exponer los datos de solo lectura para el algoritmo de coincidencias
const std::vector<PlantaNativa>& Jardincito:: obtenerTodasLasPlantas() const
{
    return coleccionPlantas;
}
std::vector<PlantaNativa> Jardincito:: buscarPlantasCompatibles(int altitud, const std::string& clima) const
{
    std::vector<PlantaNativa> compatibles;
    for (const auto& planta:coleccionPlantas)
    {
        if (planta.esCompatible(altitud,clima))
        {
            compatibles.push_back(planta);
        }
    }
    return compatibles;
}
