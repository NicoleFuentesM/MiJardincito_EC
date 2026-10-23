import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/busqueda_plantas_provider.dart';

class TipoPlantaVisual {
  const TipoPlantaVisual({required this.nombre, required this.asset});

  final String nombre;
  final String asset;
}

class QuizPreguntaTipoScreen extends StatelessWidget {
  const QuizPreguntaTipoScreen({super.key});

  static const String _assetPlaceholder = 'assets/images/placeholder.png';

  static const List<TipoPlantaVisual> opciones = [
    TipoPlantaVisual(nombre: 'Árbol', asset: 'assets/images/arbol.png'),
    TipoPlantaVisual(nombre: 'Arbusto', asset: 'assets/images/arbusto.png'),
    TipoPlantaVisual(nombre: 'Hierba', asset: 'assets/images/hierba.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final busqueda = context.watch<BusquedaPlantasProvider>();
    final colores = Theme.of(context).colorScheme;

    return Container(
      color: const Color(0xFFF9F8F6),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        children: [
          Text(
            'Tipo',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF263328),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Elige el tipo de planta que buscas',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF697267),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          for (var indice = 0; indice < 2; indice++) ...[
                            if (indice > 0) const SizedBox(width: 12),
                            Expanded(
                              child: _TarjetaTipoPlanta(
                                opcion: opciones[indice],
                                seleccionada:
                                    busqueda.tipoPlanta ==
                                    opciones[indice].nombre,
                                assetPlaceholder: _assetPlaceholder,
                                colorSeleccion: colores.primary,
                                onTap: () => busqueda.cambiarTipoPlanta(
                                  opciones[indice].nombre,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          width: (constraints.maxWidth - 12) / 2,
                          child: _TarjetaTipoPlanta(
                            opcion: opciones[2],
                            seleccionada:
                                busqueda.tipoPlanta == opciones[2].nombre,
                            assetPlaceholder: _assetPlaceholder,
                            colorSeleccion: colores.primary,
                            onTap: () => busqueda.cambiarTipoPlanta(
                              opciones[2].nombre,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaTipoPlanta extends StatelessWidget {
  const _TarjetaTipoPlanta({
    required this.opcion,
    required this.seleccionada,
    required this.assetPlaceholder,
    required this.colorSeleccion,
    required this.onTap,
  });

  final TipoPlantaVisual opcion;
  final bool seleccionada;
  final String assetPlaceholder;
  final Color colorSeleccion;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final borde = seleccionada ? colorSeleccion : const Color(0xFFD8DED2);

    return Material(
      color: seleccionada ? colorSeleccion.withValues(alpha: 0.08) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        key: ValueKey('tipo-${opcion.nombre}'),
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borde, width: seleccionada ? 3 : 1.5),
            boxShadow: [
              if (seleccionada)
                BoxShadow(
                  color: colorSeleccion.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  opcion.asset,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    assetPlaceholder,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.eco_outlined,
                      size: 48,
                      color: colores.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      opcion.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF263328),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (seleccionada) ...[
                    const SizedBox(width: 6),
                    Icon(Icons.check_circle, size: 18, color: colorSeleccion),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
