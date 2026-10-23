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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Plantas compatibles',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colores.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            for (var indice = 0; indice < busqueda.plantas.length; indice++) ...[
              TarjetaPlanta(
                planta: busqueda.plantas[indice],
                key: ValueKey(busqueda.plantas[indice].nombreComun),
              ),
              if (indice < busqueda.plantas.length - 1)
                const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
