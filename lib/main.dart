import 'package:flutter/material.dart';
import 'services/native_bridge.dart';
import 'models/planta.dart';

void main() {
  runApp(const MiJardincitoApp());
}

class MiJardincitoApp extends StatelessWidget {
  const MiJardincitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CatalogoScreen(),
    );
  }
}

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final NativeBridge _bridge = NativeBridge();
  List<Planta> _plantas = [];

  void _consultarPlantas() {
    // Parámetros de prueba: Quito (2800 msnm, Clima Templado)
    final resultado = _bridge.obtenerPlantasCompatibles(2800, 'Templado');
    setState(() {
      _plantas = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Jardincito EC - FFI')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _consultarPlantas,
              icon: const Icon(Icons.search),
              label: const Text('Consultar Especies (Quito: 2800m, Templado)'),
            ),
          ),
          Expanded(
            child: _plantas.isEmpty
                ? const Center(child: Text('Presiona el botón para consultar'))
                : ListView.builder(
                    itemCount: _plantas.length,
                    itemBuilder: (context, index) {
                      final p = _plantas[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(p.nombreComun, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${p.nombreCientifico}\nRegión: ${p.region} | Clima: ${p.tipoClima}'),
                          trailing: Text('${p.altitudIdeal} msnm'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
