import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/planta.dart';
import '../providers/coleccion_plantas_provider.dart';
import '../providers/jardin_virtual_provider.dart';

class MiJardinVirtualScreen extends StatefulWidget {
  const MiJardinVirtualScreen({super.key});

  @override
  State<MiJardinVirtualScreen> createState() => _MiJardinVirtualScreenState();
}

class _MiJardinVirtualScreenState extends State<MiJardinVirtualScreen> {
  ColeccionPlantasProvider? _coleccionEscuchada;
  String? _ultimaColeccion;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final coleccion = context.read<ColeccionPlantasProvider>();
    if (!identical(_coleccionEscuchada, coleccion)) {
      _coleccionEscuchada?.removeListener(_actualizarJardin);
      _coleccionEscuchada = coleccion..addListener(_actualizarJardin);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _actualizarJardin());
  }

  @override
  void dispose() {
    _coleccionEscuchada?.removeListener(_actualizarJardin);
    super.dispose();
  }

  void _actualizarJardin() {
    if (!mounted) return;
    final proveedorColeccion = _coleccionEscuchada;
    if (proveedorColeccion == null || proveedorColeccion.cargando) return;
    final nombres = proveedorColeccion.nombresAdoptados;
    final firma = nombres.join('\u0000');
    if (_ultimaColeccion == firma) return;
    _ultimaColeccion = firma;
    context.read<JardinVirtualProvider>().cargar(nombres);
  }

  @override
  Widget build(BuildContext context) {
    final jardin = context.watch<JardinVirtualProvider>();
    final coleccion = context.watch<ColeccionPlantasProvider>();

    if (coleccion.cargando || jardin.cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (jardin.error case final error?) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => jardin.cargar(coleccion.nombresAdoptados),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    return ColoredBox(
      color: const Color(0xFFE8F1DB),
      child: Column(
        children: [
          _construirProgreso(jardin),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: jardin.plantas.length,
              itemBuilder: (context, index) {
                final planta = jardin.plantas[index];
                final adoptada = coleccion.estaAdoptada(planta.nombreComun);
                return _TarjetaJardin(planta: planta, adoptada: adoptada);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirProgreso(JardinVirtualProvider jardin) {
    final progreso = (jardin.porcentaje / 100).clamp(0.0, 1.0);
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(16, 40, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Progreso de flora: ${jardin.porcentaje.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progreso),
            const SizedBox(height: 8),
            Text(
              '${jardin.totalColeccionadas} de ${jardin.totalEspecies} especies',
            ),
            Text(
              'Rango: ${jardin.rango}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaJardin extends StatelessWidget {
  const _TarjetaJardin({required this.planta, required this.adoptada});

  static const String _imagenPlaceholder = 'assets/images/placeholder.png';

  final Planta planta;
  final bool adoptada;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (adoptada)
              SizedBox(
                width: 64,
                height: 64,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    planta.imagenAsset?.trim().isNotEmpty == true
                        ? planta.imagenAsset!.trim()
                        : _imagenPlaceholder,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      _imagenPlaceholder,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => ColoredBox(
                        color: const Color(0xFFDCE9CD),
                        child: Icon(
                          Icons.local_florist,
                          color: colores.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              Icon(
                Icons.lock_outline,
                size: 48,
                color: colores.onSurfaceVariant,
              ),
            const SizedBox(height: 8),
            Text(
              adoptada ? planta.nombreComun : 'Especie por descubrir',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: adoptada ? FontWeight.w600 : FontWeight.bold,
              ),
            ),
            if (adoptada) ...[
              const SizedBox(height: 4),
              Text(
                planta.nombreCientifico,
                textAlign: TextAlign.center,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 6),
              Text(
                '${planta.region} · ${planta.altitudIdeal} msnm',
                textAlign: TextAlign.center,
              ),
              Text(
                '${planta.tipoClima} · ${planta.tipoPlanta} · ${planta.color}',
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
