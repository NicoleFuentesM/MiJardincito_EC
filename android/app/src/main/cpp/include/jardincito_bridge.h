//
//  jardincito_bridge.h
//  MyTool
//
//  Created by Nicole Rafaela Fuentes Manosalvas on 10/20/26.
//

#ifndef JARDIN_BRIDGE_H
#define JARDIN_BRIDGE_H

#ifdef __cplusplus
extern "C" {
#endif

// Exporta la función para que Flutter/Dart consulte las plantas compatibles en JSON
const char* obtenerPlantasCompatiblesJSON(int altitud, const char* clima);

// Función para liberar la memoria dinámica asignada por la cadena devuelta
void liberarCadena(char* ptr);

#ifdef __cplusplus
}
#endif

#endif // JARDIN_BRIDGE_H
