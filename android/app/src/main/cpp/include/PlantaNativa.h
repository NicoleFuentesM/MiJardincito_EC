#ifndef PLANTANATIVA_H
#define PLANTANATIVA_H

#include <string>

class PlantaNativa {
private:
    std::string nombreComun;
    std::string nombreCientifico;
    std::string region;
    int altitudIdeal;
    std::string tipoClima;
    std::string tipoPlanta;
    std::string color;

public:
    PlantaNativa();
    PlantaNativa(std::string nComun, std::string nCientifico, std::string reg,
                 int alt, std::string clima, std::string tipo, std::string col);

    std::string getNombreComun() const;
    std::string getNombreCientifico() const;
    std::string getRegion() const;
    int getAltitudIdeal() const;
    std::string getTipoClima() const;
    std::string getTipoPlanta() const;
    std::string getColor() const;

    void mostrarFicha() const;
};

#endif // PLANTANATIVA_H
