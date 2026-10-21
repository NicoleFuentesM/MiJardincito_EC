import 'package:flutter/material.dart';
import '../../models/planta_model.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  double _altitudSeleccionada = 2800; // Valor inicial por defecto (Quito)
  String _climaSeleccionado = 'Templado';

  final List<String> _opcionesClima = [
    'Paramo',
    'Templado',
    'Seco Tropical',
    'Bosque Nublado',
    'Humedo Tropical',
  ];

  // Lista temporal para mostrar las plantas filtradas
  final List<PlantaModel> _plantasCompatibles = [];

  void _consultarCompatibilidad() {
    // Nota: En el Día 3 aquí llamaremos a la función nativa C++ mediante FFI.
    // Por ahora, validamos la regla localmente en Dart para probar la UI:
    // Tolerancia: |altitudIdeal - altitud| <= 500 y mismo clima.
    setState(() {
      // Feedback visual temporal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Consultando para ${_altitudSeleccionada.toInt()} msnm y clima $_climaSeleccionado...',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Jardincito EC - Selector'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Altitud: ${_altitudSeleccionada.toInt()} msnm',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _altitudSeleccionada,
              min: 0,
              max: 4500,
              divisions: 90,
              label: '${_altitudSeleccionada.toInt()} m',
              activeColor: Colors.green.shade700,
              onChanged: (value) {
                setState(() {
                  _altitudSeleccionada = value;
                });
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'Tipo de Clima:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _climaSeleccionado,
              isExpanded: true,
              items: _opcionesClima.map((String clima) {
                return DropdownMenuItem<String>(
                  value: clima,
                  child: Text(clima),
                );
              }).toList(),
              onChanged: (nuevoClima) {
                if (nuevoClima != null) {
                  setState(() {
                    _climaSeleccionado = nuevoClima;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _consultarCompatibilidad,
              icon: const Icon(Icons.search),
              label: const Text('Buscar Plantas Compatibles'),
            ),
            const Divider(height: 32),
            Expanded(
              child: _plantasCompatibles.isEmpty
                  ? const Center(
                      child: Text(
                        'Ajusta tu altitud y clima para ver qué especies sobreviven en tu jardín.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _plantasCompatibles.length,
                      itemBuilder: (context, index) {
                        final planta = _plantasCompatibles[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.lightGreen,
                              child: Icon(Icons.eco, color: Colors.white),
                            ),
                            title: Text(planta.nombreComun),
                            subtitle: Text(
                              '${planta.nombreCientifico}\nRegión: ${planta.region} | Altitud: ${planta.altitudIdeal} msnm',
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
