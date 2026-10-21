class Planta {
  final String nombreComun;
  final String nombreCientifico;
  final String region;
  final int altitudIdeal;
  final String tipoClima;

  Planta({
    required this.nombreComun,
    required this.nombreCientifico,
    required this.region,
    required this.altitudIdeal,
    required this.tipoClima,
  });

  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      nombreComun: json['nombreComun'] ?? '',
      nombreCientifico: json['nombreCientifico'] ?? '',
      region: json['region'] ?? '',
      altitudIdeal: json['altitudIdeal'] ?? 0,
      tipoClima: json['tipoClima'] ?? '',
    );
  }
}
