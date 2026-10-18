//
//  PlantaNativa.cpp
//  MyTool
//
//  Created by Nicole Rafaela Fuentes Manosalvas on 10/17/26.
//
#include "PlantaNativa.h"
#include <iostream>


PlantaNativa::PlantaNativa(std::string comun, std::string cientifico, std::string reg, int altitud, std::string clima)
//lista inicializadora
: nombreComun(comun),nombreCientifico(cientifico),region(reg),altitudIdeal(altitud),tipoClima(clima)
{}
//gets
std::string PlantaNativa::getNombreComun() const
{
    return nombreComun;
}
std::string PlantaNativa::getRegion() const
{
    return region;
}
std::string PlantaNativa::getTipoClima() const
{
    return tipoClima;
}
int PlantaNativa::getAltitudIdeal() const
{
    return altitudIdeal;
}
//método de comportamiento
void PlantaNativa::mostrarFicha() const
{
    std::cout << "=== Ficha Botánica ===" << std::endl;
    std::cout << "Nombre: " << nombreComun << std::endl;
    std::cout << "Region: " << region << std:: endl;
    std::cout << "Clima ideal: " << tipoClima << std::endl;
    std::cout << "Altitud optima: " << altitudIdeal << " msnm" << std::endl;
    std::cout << std::string(15,'=') << std::endl;
}
//altitud para que plantita sobreviva
bool PlantaNativa::sobreviveEnAltitud(int altitud_usuario) const
{
    int limiteInferior=altitudIdeal-500;
    int limiteSuperior=altitudIdeal+500;
    
    /*
    if(altitud_usuario>=limiteInferior && altitud_usuario<=limiteSuperior)
    {
        return true; //sobrevive
    }
    else
    {
        return false;
    }*/
    
    return(altitud_usuario>=limiteInferior && altitud_usuario<=limiteSuperior);
}

