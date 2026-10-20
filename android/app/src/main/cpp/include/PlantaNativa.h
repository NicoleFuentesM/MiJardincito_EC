#ifndef PLANTA_NATIVA_H
#define PLANTA_NATIVA_H

#include <string>

//creación de clase
class PlantaNativa{
    
    //parte privada atributos de las plantas
private:
    std::string nombreComun;
    std::string nombreCientifico;
    std::string region;
    int altitudIdeal;
    std::string tipoClima;
    //parte pública-constructores, get
public:
    //constructor
    PlantaNativa(std::string comun, std::string cientifico, std::string reg, int altitud, std::string clima);
    //gets
    std::string getNombreComun() const;
    std::string getRegion() const;
    std::string getTipoClima() const;
    int getAltitudIdeal() const;
    //método de comportamiento
    void mostrarFicha() const;
    //método para altitud-supervivencia de la plantita
    bool sobreviveEnAltitud(int) const;
    bool esCompatible(int, const std::string&) const;
    std::string getNombreCientifico() const;
};

#endif
