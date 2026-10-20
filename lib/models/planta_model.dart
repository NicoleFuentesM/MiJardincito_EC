class PlantaModel {
  final String nombreComun;
  final String nombreCientifico;
  final String region;
  final int altitudIdeal;
  final String tipoClima;

  PlantaModel({
    required this.nombreComun,
    required this.nombreCientifico,
    required this.region,
    required this.altitudIdeal,
    required this.tipoClima,
  });

  // Fábrica para deserializar el JSON que vendrá desde C++ / archivo
  factory PlantaModel.fromJson(Map<String, dynamic> json) {
    return PlantaModel(
      nombreComun: json['nombreComun'] as String,
      nombreCientifico: json['nombreCientifico'] as String,
      region: json['region'] as String,
      altitudIdeal: json['altitudIdeal'] as int,
      tipoClima: json['tipoClima'] as String,
    );
  }

  // Método para convertir a Map si necesitamos depurar o guardar
  Map<String, dynamic> toJson() {
    return {
      'nombreComun': nombreComun,
      'nombreCientifico': nombreCientifico,
      'region': region,
      'altitudIdeal': altitudIdeal,
      'tipoClima': tipoClima,
    };
  }
}
