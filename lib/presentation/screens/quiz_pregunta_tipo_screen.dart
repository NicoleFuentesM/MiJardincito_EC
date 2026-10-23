import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/busqueda_plantas_provider.dart';

class QuizPreguntaTipoScreen extends StatelessWidget {
  const QuizPreguntaTipoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final busqueda = context.watch<BusquedaPlantasProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.eco, size: 64),
          const SizedBox(height: 20),
          Text(
            '¿Qué tipo de planta quieres?',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: BusquedaPlantasProvider.tipos.keys.map((tipo) {
              return ChoiceChip(
                label: Text(tipo),
                selected: busqueda.tipoPlanta == tipo,
                onSelected: (_) => busqueda.cambiarTipoPlanta(tipo),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
