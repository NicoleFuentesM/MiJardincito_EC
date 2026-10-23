import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/planta.dart';
import '../providers/coleccion_plantas_provider.dart';

class TarjetaPlanta extends StatelessWidget {
  const TarjetaPlanta({required this.planta, super.key});

  final Planta planta;
  static const String _imagenPlaceholder = 'assets/images/placeholder.png';

  @override
  Widget build(BuildContext context) {
    final coleccion = context.watch<ColeccionPlantasProvider>();
    final adoptada = coleccion.estaAdoptada(planta.nombreComun);
    final colores = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      color: const Color(0xFFEAEFE6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              planta.nombreComun,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF263B25),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final lado = (constraints.maxWidth).clamp(0.0, 240.0);
                return Center(
                  child: Container(
                    width: lado,
                    height: lado,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.asset(
                        planta.imagenAsset?.trim().isNotEmpty == true
                            ? planta.imagenAsset!
                            : _imagenPlaceholder,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              _imagenPlaceholder,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  ColoredBox(
                                    color: const Color(0xFFDCE9CD),
                                    child: Icon(
                                      Icons.local_florist,
                                      size: 72,
                                      color: colores.primary,
                                    ),
                                  ),
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6EF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.local_florist, color: colores.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          planta.nombreComun,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: const Color(0xFF263B25),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${planta.altitudIdeal} msnm',
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF485A43),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    planta.nombreCientifico,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5B6756),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Región: ${planta.region} | Clima: ${planta.tipoClima}',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: const Color(0xFF394735)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: FilledButton.tonalIcon(
                onPressed: adoptada || coleccion.cargando
                    ? null
                    : () => coleccion.adoptar(planta.nombreComun),
                icon: Icon(adoptada ? Icons.check : Icons.yard),
                label: Text(adoptada ? 'Adoptada' : '¡Coleccionar!'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  backgroundColor: const Color(0xFFD4E4C2),
                  foregroundColor: const Color(0xFF263B25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
