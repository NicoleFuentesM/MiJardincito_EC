//
//  Jadincito.h
//  MyTool
//
//  Created by Nicole Rafaela Fuentes Manosalvas on 10/18/26.
//

#ifndef JARDINCITO_H
#define JARDINCITO_H

#include "PlantaNativa.h"
#include <vector> //librería de c++ para arreglos dinámicos, arreglo crecerá y maneja la memoria por nosotros

class Jardincito{
private:
    std::vector<PlantaNativa> coleccionPlantas;
public:
    //constructor por defecto
    Jardincito()=default;
    //métodos para interactuar con la colleción
    void agregarPlanta(const PlantaNativa&);
    void verJardincito() const;
    const std::vector<PlantaNativa>& obtenerTodasLasPlantas() const;
};

#endif

