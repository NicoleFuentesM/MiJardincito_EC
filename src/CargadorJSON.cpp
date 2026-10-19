//
//  CargadorJSON.cpp
//  MyTool
//
//  Created by Nicole Rafaela Fuentes Manosalvas on 10/19/26.
//

#include "CargadorJSON.h"
#include "json.hpp"
#include <fstream> //librería que permite que los datos persistan al cerrar el programa. Manejo y getión de archivos.
#include <iostream>

//alias para no escribir nlohmann::json todo el tiempo
using json=nlohmann::json;

void CargadorJSON::cargarPlantas(Jardincito& jardin, const std::string& rutaArchivo)
{
   //1. abrir el archivo
    std::ifstream archivo(rutaArchivo);
    // validar que exista el archivo y se pueda abrir
    if(!archivo.is_open()){
        std::cerr << "Error: No se pudo abrir el archivo de datos: " << rutaArchivo << std::endl;
        return;
    }
    //2. Parsear el Json
    json datosJson;
    archivo >> datosJson; //pasa a formato json automáticamente
    //3. iterar sobre el arreglo de plantas del archivo
    for (const auto& item:datosJson){
        //extraer los valores mapeando las llaves exactas que se puso en plantas
        PlantaNativa nuevaPlanta(
                                 item["nombreComun"],
                                 item["nombreCientifico"],
                                 item["region"],
                                 item["altitudIdeal"],
                                 item["tipoClima"]
                                 );
        //agregar al repositorio
        jardin.agregarPlanta(nuevaPlanta);
    }
    std::cout << "Se cargaron " << datosJson.size() << " plantas desde la base de datos. " << std::endl;
}
