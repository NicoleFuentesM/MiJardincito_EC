import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/busqueda_plantas_provider.dart';

class ColorVisual {
  const ColorVisual({required this.nombre, required this.fondo});

  final String nombre;
  final Color fondo;
}

class QuizPreguntaColorScreen extends StatefulWidget {
  const QuizPreguntaColorScreen({super.key});

  static const List<ColorVisual> coloresVisuales = [
    ColorVisual(nombre: 'Blanco', fondo: Color(0xFFF5F5F0)),
    ColorVisual(nombre: 'Verde', fondo: Color(0xFF7EA172)),
    ColorVisual(nombre: 'Naranja', fondo: Color(0xFFE76F51)),
    ColorVisual(nombre: 'Amarillo', fondo: Color(0xFFE9C46A)),
    ColorVisual(nombre: 'Morado', fondo: Color(0xFF7B2CBF)),
    ColorVisual(nombre: 'Rojo', fondo: Color(0xFFC85A5A)),
    ColorVisual(nombre: 'Azul', fondo: Color(0xFF315F9B)),
  ];

  static int paginaInicial(int indice) {
    const paginaBase = 1000000;
    final desplazamiento =
        (indice - paginaBase % coloresVisuales.length) % coloresVisuales.length;
    return paginaBase + desplazamiento;
  }

  static Color fondoParaColor(String color) {
    return coloresVisuales
        .firstWhere(
          (opcion) => opcion.nombre == color,
          orElse: () => coloresVisuales.first,
        )
        .fondo;
  }

  @override
  State<QuizPreguntaColorScreen> createState() =>
      _QuizPreguntaColorScreenState();
}

class _QuizPreguntaColorScreenState extends State<QuizPreguntaColorScreen> {
  late final PageController _controladorColores;
  late int _indiceSeleccionado;

  @override
  void initState() {
    super.initState();
    final colorActual = context.read<BusquedaPlantasProvider>().color;
    _indiceSeleccionado = QuizPreguntaColorScreen.coloresVisuales.indexWhere(
      (opcion) => opcion.nombre == colorActual,
    );
    if (_indiceSeleccionado < 0) _indiceSeleccionado = 0;
    _controladorColores = PageController(
      initialPage: QuizPreguntaColorScreen.paginaInicial(_indiceSeleccionado),
    );
  }

  @override
  void dispose() {
    _controladorColores.dispose();
    super.dispose();
  }

  void _seleccionarColor(int indice) {
    final indiceColor = indice % QuizPreguntaColorScreen.coloresVisuales.length;
    if (indiceColor == _indiceSeleccionado) return;
    setState(() => _indiceSeleccionado = indiceColor);
    context.read<BusquedaPlantasProvider>().cambiarColor(
      QuizPreguntaColorScreen.coloresVisuales[indiceColor].nombre,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorSeleccionado =
        QuizPreguntaColorScreen.coloresVisuales[_indiceSeleccionado];
    final colorTexto =
        ThemeData.estimateBrightnessForColor(colorSeleccionado.fondo) ==
            Brightness.dark
        ? Colors.white
        : const Color(0xFF24302A);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      color: colorSeleccionado.fondo,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        children: [
          Text(
            'Color',
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(color: colorTexto, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: PageView.builder(
                    key: const ValueKey('color-page-view'),
                    controller: _controladorColores,
                    scrollDirection: Axis.vertical,
                    onPageChanged: _seleccionarColor,
                    itemBuilder: (context, indice) {
                      final opcion =
                          QuizPreguntaColorScreen.coloresVisuales[indice %
                              QuizPreguntaColorScreen.coloresVisuales.length];

                      return Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            opcion.nombre,
                            style: TextStyle(
                              color:
                                  ThemeData.estimateBrightnessForColor(
                                        opcion.fondo,
                                      ) ==
                                      Brightness.dark
                                  ? Colors.white
                                  : const Color(0xFF24302A),
                              fontSize: 46,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    QuizPreguntaColorScreen.coloresVisuales.length,
                    (indice) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      width: 7,
                      height: indice == _indiceSeleccionado ? 18 : 7,
                      decoration: BoxDecoration(
                        color: colorTexto.withValues(
                          alpha: indice == _indiceSeleccionado ? 0.9 : 0.35,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Desliza hacia abajo para elegir un color',
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colorTexto.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
