//archivo para traducir la base de datos instalada en un archivo json a c++

#ifndef CARGADORJSON_H
#define CARGADORJSON_H

#include "Jardincito.h"
#include <string>

class CargadorJSON {
public:
    // Carga desde archivo local (útil para pruebas en Xcode/Desktop)
    static void cargarPlantas(Jardincito& jardin, const std::string& rutaArchivo);

    // Carga desde una cadena en memoria (usado por Flutter/Android)
    static void cargarPlantasDesdeString(Jardincito& jardin, const std::string& jsonContenido);
};

#endif // CARGADORJSON_H
