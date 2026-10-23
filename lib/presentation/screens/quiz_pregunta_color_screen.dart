import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/busqueda_plantas_provider.dart';

class QuizPreguntaColorScreen extends StatelessWidget {
  const QuizPreguntaColorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final busqueda = context.watch<BusquedaPlantasProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.palette, size: 64),
          const SizedBox(height: 20),
          Text(
            '¿Qué color buscas?',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: BusquedaPlantasProvider.colores.map((color) {
              return ChoiceChip(
                label: Text(color),
                selected: busqueda.color == color,
                onSelected: (_) => busqueda.cambiarColor(color),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
