class PlantaNativa {
  final String nombreComun;
  final String nombreCientifico;
  final String region;
  final int altitudIdeal;
  final String tipoClima;

  PlantaNativa({
    required this.nombreComun,
    required this.nombreCientifico,
    required this.region,
    required this.altitudIdeal,
    required this.tipoClima,
  });
}
//¿Qué pasa con el método sobreviveEnAltitud?
//Notarás que no lo incluí en la clase de Dart. 
//Esto es intencional debido a la Clean Architecture. 
//La lógica de negocio pesada (calcular si sobrevive) se ejecutará en C++ (el backend). 
//Flutter simplemente recibirá los datos procesados y los mostrará.