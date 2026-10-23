import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/busqueda_plantas_provider.dart';
import '../widgets/tarjeta_planta.dart';

class QuizResultadoScreen extends StatelessWidget {
  const QuizResultadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final busqueda = context.watch<BusquedaPlantasProvider>();
    final colores = Theme.of(context).colorScheme;

    if (busqueda.cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (busqueda.error case final error?) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                error,
                textAlign: TextAlign.center,
                style: TextStyle(color: colores.error),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: busqueda.buscarPlantas,
                icon: const Icon(Icons.refresh),
                label: const Text('Intentar de nuevo'),
              ),
            ],
          ),
        ),
      );
    }

    if (busqueda.plantas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No encontramos plantas compatibles con tus respuestas. '
            'Puedes volver a empezar y probar otros filtros.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            'Plantas compatibles',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: busqueda.plantas.length,
            itemBuilder: (context, index) {
              final planta = busqueda.plantas[index];
              return TarjetaPlanta(planta: planta);
            },
          ),
        ),
      ],
    );
  }
}
