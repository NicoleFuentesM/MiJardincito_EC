import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/busqueda_plantas_provider.dart';

class QuizPreguntaAltitudScreen extends StatelessWidget {
  const QuizPreguntaAltitudScreen({super.key});

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
            'Altitud',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF263328),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              '${busqueda.altitud} msnm',
              key: ValueKey(busqueda.altitud),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF526A43),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final alturaSlider = constraints.maxHeight * 0.9;

                return Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/images/montaña.png',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 48,
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: SizedBox(
                            width: alturaSlider,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                activeTrackColor: const Color(0xFF81936A),
                                inactiveTrackColor: const Color(0xFFD9DED1),
                                thumbColor: colores.primary,
                                overlayColor: colores.primary.withValues(
                                  alpha: 0.14,
                                ),
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 9,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 18,
                                ),
                              ),
                              child: Slider(
                                min: 0,
                                max: 5000,
                                divisions: 100,
                                label: '${busqueda.altitud} msnm',
                                value: busqueda.altitud.toDouble(),
                                onChanged: busqueda.cambiarAltitud,
                              ),
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
          const SizedBox(height: 12),
          Text(
            'Puedes encontrar la altitud de tu ubicación en el mapa o en la '
            'configuración de tu dispositivo.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF697267),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
