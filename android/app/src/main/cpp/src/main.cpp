/*#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include "jardincito_bridge.h"
*/
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include "jardincito_bridge.h"

// Función auxiliar para cargar la base de datos local en memoria
std::string leerArchivoJSON(const std::string& ruta) {
    std::ifstream archivo(ruta);
    if (!archivo.is_open()) {
        std::cerr << "Error: No se pudo abrir el archivo " << ruta << std::endl;
        return "";
    }
    std::stringstream buffer;
    buffer << archivo.rdbuf();
    return buffer.str();
}

int main() {
    std::cout << "==================================================" << std::endl;
    std::cout << "  PRUEBA INTERACTIVA DE SIMILARITY SCORING (C++)   " << std::endl;
    std::cout << "==================================================" << std::endl;

    std::string jsonContenido = leerArchivoJSON("data/plantas.json");
    if (jsonContenido.empty()) {
        std::cout << "Asegurate de que data/plantas.json exista en la raiz del proyecto." << std::endl;
        return 1;
    }

    char continuar = 's';
    while (continuar == 's' || continuar == 'S') {
        int altitud;
        std::string clima, tipo, color;

        std::cout << "\n--------------------------------------------------" << std::endl;
        std::cout << "Ingresa la Altitud rango de 2200-4000 (msmn): ";
        std::cin >> altitud;

        std::cout << "Ingresa el Clima (Calido, Templado, Frio, Paramo): ";
        std::cin >> clima;

        std::cout << "Ingresa el Tipo de Planta (Arbol, Arbusto, Hierba): ";
        std::cin >> tipo;

        std::cout << "Ingresa el Color (Blanco, Verde, Naranja, Amarillo, Morado, Rojo, Azul): ";
        std::cin >> color;

        std::cout << "\nProcesando coincidencia con el motor C++..." << std::endl;

        const char* respuestaJSON = obtenerPlantasCompatiblesAvanzadoJSON(
            altitud,
            clima.c_str(),
            tipo.c_str(),
            color.c_str(),
            jsonContenido.c_str()
        );

        if (respuestaJSON != nullptr) {
            std::cout << "\n[Respuesta JSON devuelta a Flutter]:\n" << std::endl;
            std::cout << respuestaJSON << std::endl;
            liberarCadena(const_cast<char*>(respuestaJSON));
        } else {
            std::cout << "No se obtuvieron resultados." << std::endl;
        }

        std::cout << "\n¿Deseas probar otra combinacion? (s/n): ";
        std::cin >> continuar;
    }

    std::cout << "\nPruebas finalizadas. ¡Motor listo para GitHub!" << std::endl;
    return 0;
}

/*
std::string leerArchivoJSON(const std::string& ruta) {
    std::ifstream archivo(ruta);
    if (!archivo.is_open()) return "";
    std::stringstream buffer;
    buffer << archivo.rdbuf();
    return buffer.str();
}

int main() {
    std::cout << "=== PRUEBA DE SIMILARITY SCORING (SIN 'TODOS') ===" << std::endl;

    std::string jsonContenido = leerArchivoJSON("data/plantas.json");
    if (jsonContenido.empty()) {
        std::cout << "Error: No se encontro data/plantas.json" << std::endl;
        return 1;
    }

    // Prueba 1: Coincidencia Exacta (2800 msnm, Templado, Arbol, Blanco) -> Arrayan de Quito (100%)
    std::cout << "\n--- Prueba 1: Coincidencia Exacta (100%) ---" << std::endl;
    const char* res1 = obtenerPlantasCompatiblesAvanzadoJSON(2800, "Templado", "Arbol", "Blanco", jsonContenido.c_str());
    if (res1) {
        std::cout << res1 << std::endl;
        liberarCadena(const_cast<char*>(res1));
    }

    // Prueba 2: Coincidencia Inexacta (2800 msnm, Templado, Arbol, Rojo) -> Debe acercarse al Arrayan (80%)
    std::cout << "\n--- Prueba 2: Coincidencia Inexacta (Busca sugerencia cercana) ---" << std::endl;
    const char* res2 = obtenerPlantasCompatiblesAvanzadoJSON(2800, "Templado", "Arbol", "Rojo", jsonContenido.c_str());
    if (res2) {
        std::cout << res2 << std::endl;
        liberarCadena(const_cast<char*>(res2));
    }

    return 0;
}
 */
