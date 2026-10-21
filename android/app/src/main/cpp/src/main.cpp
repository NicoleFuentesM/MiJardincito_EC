#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include "jardincito_bridge.h"

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
    std::cout << "===========================================" << std::endl;
    std::cout << "  MI JARDINCITO EC - DIA 4 BACKEND FINAL   " << std::endl;
    std::cout << "===========================================" << std::endl;

    std::string jsonContenido = leerArchivoJSON("data/plantas.json");
    if (jsonContenido.empty()) {
        std::cout << "Asegurate de que data/plantas.json exista en la raiz." << std::endl;
        return 1;
    }

    // --- TEST 1: REPORTE DE JARDÍN VIRTUAL ---
    std::cout << "\n--- TEST 1: Progreso de Coleccion (Simulando 3 plantas coleccionadas) ---" << std::endl;
    const char* coleccionSimulada = R"(["Arrayan de Quito", "Chuquiragua", "Mortiño"])";
    
    const char* reporteJSON = obtenerProgresoColeccionJSON(coleccionSimulada, jsonContenido.c_str());
    if (reporteJSON != nullptr) {
        std::cout << "Reporte devuelto por C++:\n" << reporteJSON << std::endl;
        liberarCadena(const_cast<char*>(reporteJSON));
    }

    // --- TEST 2: BÚSQUEDA MULTICRITERIO ---
    std::cout << "\n--- TEST 2: Busqueda Multicriterio ---" << std::endl;
    const char* resultadoBusqueda = obtenerPlantasCompatiblesAvanzadoJSON(
        2800, "Templado", "Arbol", "Blanco", jsonContenido.c_str()
    );
    if (resultadoBusqueda != nullptr) {
        std::cout << "Resultado del filtro:\n" << resultadoBusqueda << std::endl;
        liberarCadena(const_cast<char*>(resultadoBusqueda));
    }

    return 0;
}
