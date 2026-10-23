import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/busqueda_plantas_provider.dart';

class QuizPreguntaClimaScreen extends StatelessWidget {
  const QuizPreguntaClimaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final busqueda = context.watch<BusquedaPlantasProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.cloud, size: 64),
          const SizedBox(height: 20),
          Text(
            '¿Qué clima predomina en tu jardín?',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            initialValue: busqueda.clima,
            decoration: const InputDecoration(
              labelText: 'Selecciona un clima',
              border: OutlineInputBorder(),
            ),
            items: BusquedaPlantasProvider.climas.keys
                .map(
                  (clima) =>
                      DropdownMenuItem(value: clima, child: Text(clima)),
                )
                .toList(),
            onChanged: (clima) {
              if (clima != null) busqueda.cambiarClima(clima);
            },
          ),
        ],
      ),
    );
  }
}
