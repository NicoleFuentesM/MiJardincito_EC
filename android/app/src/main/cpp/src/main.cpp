#include <iostream>
#include "jardincito_bridge.h"

int main() {
    std::cout << "=== PRUEBA DE PUENTE C-API (DART FFI SIMULATION) ===" << std::endl;

    // Simulación de la petición que enviará Flutter/Dart FFI
    const char* respuestaJson = obtenerPlantasCompatiblesJSON(2800, "Templado");

    if (respuestaJson != nullptr) {
        std::cout << "\nCadena JSON generada por C++ para Flutter:\n" << std::endl;
        std::cout << respuestaJson << std::endl;

        // Liberación de memoria reservada en el heap
        liberarCadena(const_cast<char*>(respuestaJson));
    } else {
        std::cout << "Error al generar la respuesta JSON." << std::endl;
    }

    return 0;
}
