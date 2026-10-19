//archivo para traducir la base de datos instalada en un archivo json a c++

#ifndef CARGADORJSON_H
#define CARGADORJSON_H

#include "Jardincito.h"
#include <string>

class CargadorJSON{
  
public:
    //método estático: no se necesita crear un método cargador para usarlo
    static void cargarPlantas(Jardincito&, const std::string&);
};

#endif
