#include "PlantaNativa.h"
#include <iostream>

PlantaNativa::PlantaNativa()
    : nombreComun(""), nombreCientifico(""), region(""), altitudIdeal(0),
      tipoClima(""), tipoPlanta(""), color("") {}

PlantaNativa::PlantaNativa(std::string nComun, std::string nCientifico, std::string reg,
                           int alt, std::string clima, std::string tipo, std::string col)
    : nombreComun(nComun), nombreCientifico(nCientifico), region(reg),
      altitudIdeal(alt), tipoClima(clima), tipoPlanta(tipo), color(col) {}

std::string PlantaNativa::getNombreComun() const { return nombreComun; }
std::string PlantaNativa::getNombreCientifico() const { return nombreCientifico; }
std::string PlantaNativa::getRegion() const { return region; }
int PlantaNativa::getAltitudIdeal() const { return altitudIdeal; }
std::string PlantaNativa::getTipoClima() const { return tipoClima; }
std::string PlantaNativa::getTipoPlanta() const { return tipoPlanta; }
std::string PlantaNativa::getColor() const { return color; }

void PlantaNativa::mostrarFicha() const {
    std::cout << "Nombre Comun: " << nombreComun << "\n"
              << "Nombre Cientifico: " << nombreCientifico << "\n"
              << "Region: " << region << "\n"
              << "Altitud Ideal: " << altitudIdeal << " msnm\n"
              << "Clima: " << tipoClima << "\n"
              << "Tipo de Planta: " << tipoPlanta << "\n"
              << "Color: " << color << std::endl;
}
