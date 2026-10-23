import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/busqueda_plantas_provider.dart';

class QuizPreguntaAltitudScreen extends StatelessWidget {
  const QuizPreguntaAltitudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final busqueda = context.watch<BusquedaPlantasProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.terrain, size: 64),
          const SizedBox(height: 20),
          Text(
            '¿A qué altitud está tu jardín?',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '${busqueda.altitud} msnm',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Slider(
            min: 0,
            max: 5000,
            divisions: 100,
            label: '${busqueda.altitud} msnm',
            value: busqueda.altitud.toDouble(),
            onChanged: busqueda.cambiarAltitud,
          ),
          const Text(
            'Puedes encontrar la altitud de tu ubicación en el mapa o en la '
            'configuración de tu dispositivo.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
