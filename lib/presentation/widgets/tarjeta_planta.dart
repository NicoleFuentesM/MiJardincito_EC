import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/planta.dart';
import '../providers/coleccion_plantas_provider.dart';

class TarjetaPlanta extends StatelessWidget {
  const TarjetaPlanta({required this.planta, super.key});

  final Planta planta;

  @override
  Widget build(BuildContext context) {
    final coleccion = context.watch<ColeccionPlantasProvider>();
    final adoptada = coleccion.estaAdoptada(planta.nombreComun);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(Icons.local_florist),
            title: Text(
              planta.nombreComun,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${planta.nombreCientifico}\n'
              'Región: ${planta.region} | Clima: ${planta.tipoClima}',
            ),
            isThreeLine: true,
            trailing: Text('${planta.altitudIdeal} msnm'),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 8),
              child: FilledButton.tonalIcon(
                onPressed: adoptada || coleccion.cargando
                    ? null
                    : () => coleccion.adoptar(planta.nombreComun),
                icon: Icon(adoptada ? Icons.check : Icons.yard),
                label: Text(adoptada ? 'Adoptada' : '¡Coleccionar!'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
