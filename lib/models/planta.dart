class Planta {
  final String nombreComun;
  final String nombreCientifico;
  final String region;
  final int altitudIdeal;
  final String tipoClima;
  final String tipoPlanta;
  final String color;
  final String? imagenAsset;

  Planta({
    required this.nombreComun,
    required this.nombreCientifico,
    required this.region,
    required this.altitudIdeal,
    required this.tipoClima,
    this.tipoPlanta = '',
    this.color = '',
    this.imagenAsset,
  });

  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      nombreComun: json['nombreComun'] as String? ?? '',
      nombreCientifico: json['nombreCientifico'] as String? ?? '',
      region: json['region'] as String? ?? '',
      altitudIdeal: (json['altitudIdeal'] as num?)?.toInt() ?? 0,
      tipoClima: json['tipoClima'] as String? ?? '',
      tipoPlanta: json['tipoPlanta'] as String? ?? '',
      color: json['color'] as String? ?? '',
      imagenAsset: json['imagenAsset'] as String?,
    );
  }
}
