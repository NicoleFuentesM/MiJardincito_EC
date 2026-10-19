//
//  main.cpp
//  MyTool
//
//  Created by Nicole Rafaela Fuentes Manosalvas on 10/17/26.
//

#include "PlantaNativa.h"
#include "Jardincito.h"
#include "CargadorJSON.h"
#include <iostream>
//nueva librería llamada cassert para la aserciones (TDD): buena práctica para el paso siguiente que es conectar con Flutter y Dart ya que cruzamos una frontera tecnológica. Así estaremos seguras de donde está el fallo en caso de que algo crashee.
#include <cassert>

void testEntidadPlantaNativa();

int main(){
    /*
    //pruebassss
    std::cout << "Iniciando prueba de Mijardincito con TDD..." << std::endl << std::endl;
    
    //Prueba solo de main sin TDD
    //instanciación de plantitas nativas
    PlantaNativa polylepis("Polylepis/Arbol de Papel", "Polylepis Incana", "Sierra", 4000, "Frio");
    PlantaNativa chuquiragua("Chuquiragua","Chuquiraga jussieui","Paramo",3500,"Frio y Seco");
    //llamar al método de comportamiento
    polylepis.mostrarFicha();
    std::cout<<std::endl;
    chuquiragua.mostrarFicha();
    std::cout<<std::endl;
    //probar un getter individual
    std::cout << "El " << polylepis.getNombreComun() << " soporta altitudes de hasta " << polylepis.getAltitudIdeal() << " msnm." << std::endl;
     
    testEntidadPlantaNativa();
    // Si una prueba falla (assert da falso), el programa hace "crash" aquí y no llega a la siguiente línea.
    // Si llega a esta línea, significa que todo está perfecto (Luz Verde en TDD).
        std::cout << "TDD Fase 1: ¡Todas las pruebas de PlantaNativa pasaron exitosamente!" << std::endl;
    std::cout << std::endl;
    
    //prueba de Jardincito
    std::cout << "Pruebas de Jardincito" << std::endl;
    Jardincito jardin1;
    jardin1.agregarPlanta(polylepis);
    jardin1.agregarPlanta(chuquiragua);
    jardin1.verJardincito();
    */
    
    //instanciación de jardin
    Jardincito miJardin;
    
    //ruta relativa al archivo plantas.json desde la raiz del proyecto
    std::string rutaJson="data/plantas.json";
    std::cout << "PROBANDO CAPA DE DATOS (JSON -> JARDIN)" << std::endl;
    //1. Invocar el cargador para parsear e inyectar las plantas
    CargadorJSON::cargarPlantas(miJardin, rutaJson);
    //mostrar la lista de plantas recuperada de vector
    miJardin.verJardincito();
    
    return 0;
}

/*
//función para probar la entidad
void testEntidadPlantaNativa(){
    //instanciación de objeto de prueba
    PlantaNativa pruebaPlanta("Chuquiragua", "Chuquiragua jussieui", "Paramo", 3500, "Frio y Seco");
    //Actuar y afirmar - verificar que los getters devuelven lo correcto
    assert(pruebaPlanta.getNombreComun()=="Chuquiragua");
    assert(pruebaPlanta.getRegion()=="Paramo");
    assert(pruebaPlanta.getAltitudIdeal()==3500);
    assert(pruebaPlanta.getTipoClima()=="Frio y Seco");
    //Prueba nueva de funcionalidad - TDD fase roja
    //La planta sobrevive si la altitud dada por el usuario está dentro de +/- 500m de su altitud ideal
    //Chuqiragua tiene altitud de 3500m, debe sobrevivir a 3200m(T) pero no a 2000m(F)
    assert(pruebaPlanta.sobreviveEnAltitud(3200)==true);
    assert(pruebaPlanta.sobreviveEnAltitud(2000)==false);
}
*/
