import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/busqueda_plantas_provider.dart';

class ClimaVisual {
  const ClimaVisual({
    required this.nombre,
    required this.imagen,
    required this.fondo,
    required this.descripcion,
  });

  final String nombre;
  final String imagen;
  final Color fondo;
  final String descripcion;
}

class QuizPreguntaClimaScreen extends StatefulWidget {
  const QuizPreguntaClimaScreen({super.key});

  static const List<ClimaVisual> climasVisuales = [
    ClimaVisual(
      nombre: 'Cálido',
      imagen: 'assets/images/calido.png',
      fondo: Color(0xFFF9C74F),
      descripcion: 'Días soleados y temperaturas agradables.',
    ),
    ClimaVisual(
      nombre: 'Templado',
      imagen: 'assets/images/templado.png',
      fondo: Color(0xFFD9EBC4),
      descripcion: 'Un clima suave, ideal para disfrutar la naturaleza.',
    ),
    ClimaVisual(
      nombre: 'Frío',
      imagen: 'assets/images/frio.png',
      fondo: Color(0xFFD7EDF7),
      descripcion: 'Temperaturas frescas y aire de montaña.',
    ),
    ClimaVisual(
      nombre: 'Páramo',
      imagen: 'assets/images/paramo.png',
      fondo: Color(0xFFDCE4E8),
      descripcion: 'Alturas andinas, neblina y frailejones.',
    ),
  ];

  static int paginaInicial(int indice) {
    const paginaBase = 1000000;
    final desplazamiento =
        (indice - paginaBase % climasVisuales.length) %
        climasVisuales.length;
    return paginaBase + desplazamiento;
  }

  static Color colorFondo(String clima) {
    return climasVisuales
        .firstWhere(
          (opcion) => opcion.nombre == clima,
          orElse: () => climasVisuales[1],
        )
        .fondo;
  }

  @override
  State<QuizPreguntaClimaScreen> createState() =>
      _QuizPreguntaClimaScreenState();
}

class _QuizPreguntaClimaScreenState extends State<QuizPreguntaClimaScreen> {
  late final PageController _controladorClima;
  late int _indiceSeleccionado;

  @override
  void initState() {
    super.initState();
    final climaActual = context.read<BusquedaPlantasProvider>().clima;
    _indiceSeleccionado = QuizPreguntaClimaScreen.climasVisuales.indexWhere(
      (opcion) => opcion.nombre == climaActual,
    );
    if (_indiceSeleccionado < 0) _indiceSeleccionado = 1;
    _controladorClima = PageController(
      initialPage: QuizPreguntaClimaScreen.paginaInicial(_indiceSeleccionado),
    );
  }

  @override
  void dispose() {
    _controladorClima.dispose();
    super.dispose();
  }

  void _seleccionarClima(int indice) {
    final indiceClima = indice % QuizPreguntaClimaScreen.climasVisuales.length;
    if (indiceClima == _indiceSeleccionado) return;
    setState(() => _indiceSeleccionado = indiceClima);
    context
        .read<BusquedaPlantasProvider>()
        .cambiarClima(
          QuizPreguntaClimaScreen.climasVisuales[indiceClima].nombre,
        );
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final clima = QuizPreguntaClimaScreen.climasVisuales[_indiceSeleccionado];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOut,
      color: clima.fondo,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        children: [
          Text(
            'Clima',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF263328),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.12),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              clima.nombre,
              key: ValueKey(clima.nombre),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF37443A),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Desliza para elegir el clima de tu jardín',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF4D584F),
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: PageView.builder(
              controller: _controladorClima,
              scrollDirection: Axis.vertical,
              onPageChanged: _seleccionarClima,
              itemBuilder: (context, indice) {
                final opcion =
                    QuizPreguntaClimaScreen.climasVisuales[
                      indice % QuizPreguntaClimaScreen.climasVisuales.length
                    ];

                return LayoutBuilder(
                  builder: (context, constraints) => Center(
                    child: AnimatedScale(
                      scale:
                          indice %
                                  QuizPreguntaClimaScreen
                                      .climasVisuales
                                      .length ==
                              _indiceSeleccionado
                          ? 1
                          : 0.88,
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutBack,
                      child: Image.asset(
                        opcion.imagen,
                        width: constraints.maxWidth * 0.88,
                        height: constraints.maxHeight * 0.78,
                        fit: BoxFit.contain,
                        semanticLabel: opcion.nombre,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: Text(
              clima.descripcion,
              key: ValueKey('${clima.nombre}-descripcion'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF37443A),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              QuizPreguntaClimaScreen.climasVisuales.length,
              (indice) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: indice == _indiceSeleccionado ? 18 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: indice == _indiceSeleccionado
                      ? colores.primary
                      : const Color(0xFF758078).withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
