import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/busqueda_plantas_provider.dart';
import 'quiz_pregunta_altitud_screen.dart';
import 'quiz_pregunta_clima_screen.dart';
import 'quiz_pregunta_color_screen.dart';
import 'quiz_pregunta_tipo_screen.dart';
import 'quiz_resultado_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({required this.onGardenTap, super.key});

  final VoidCallback onGardenTap;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const int _cantidadPreguntas = 4;
  final PageController _controladorPaginas = PageController();
  int _paginaActual = 0;

  bool get _esResultado => _paginaActual == _cantidadPreguntas;

  void _avanzar() {
    if (_esResultado) {
      setState(() => _paginaActual = 0);
      _controladorPaginas.jumpToPage(0);
      return;
    }

    if (_paginaActual == _cantidadPreguntas - 1) {
      setState(() => _paginaActual++);
      _controladorPaginas.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
      unawaited(context.read<BusquedaPlantasProvider>().buscarPlantas());
      return;
    }

    setState(() => _paginaActual++);
    _controladorPaginas.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controladorPaginas.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _esResultado
                        ? 'Tu jardín ideal'
                        : 'Pregunta ${_paginaActual + 1} de $_cantidadPreguntas',
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_paginaActual + 1) / (_cantidadPreguntas + 1),
                    color: colores.primary,
                    backgroundColor: colores.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controladorPaginas,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  QuizPreguntaAltitudScreen(),
                  QuizPreguntaClimaScreen(),
                  QuizPreguntaTipoScreen(),
                  QuizPreguntaColorScreen(),
                  QuizResultadoScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                tooltip: 'Mi jardín',
                onPressed: widget.onGardenTap,
                icon: const Icon(Icons.yard),
              ),
              FilledButton.icon(
                key: const ValueKey('quiz-next'),
                onPressed: _avanzar,
                icon: Icon(_esResultado ? Icons.replay : Icons.arrow_forward),
                label: Text(_esResultado ? 'Empezar de nuevo' : 'Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
