import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/planta.dart';
import 'presentation/providers/coleccion_plantas_provider.dart';
import 'presentation/providers/busqueda_plantas_provider.dart';
import 'presentation/providers/jardin_virtual_provider.dart';
import 'presentation/screens/mi_jardin_virtual_screen.dart';
import 'presentation/widgets/tarjeta_planta.dart';

void main() {
  runApp(const MiJardincitoApp());
}

class MiJardincitoApp extends StatelessWidget {
  const MiJardincitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BusquedaPlantasProvider()),
        ChangeNotifierProvider(
          create: (_) => ColeccionPlantasProvider()..cargar(),
        ),
        ChangeNotifierProvider(create: (_) => JardinVirtualProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NavegacionPrincipal(),
      ),
    );
  }
}

class NavegacionPrincipal extends StatefulWidget {
  const NavegacionPrincipal({super.key});

  @override
  State<NavegacionPrincipal> createState() => _NavegacionPrincipalState();
}

class _NavegacionPrincipalState extends State<NavegacionPrincipal> {
  int _indiceSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _indiceSeleccionado == 0
              ? 'Mi Jardincito EC'
              : 'Mi Jardín Virtual',
        ),
      ),
      body: _indiceSeleccionado == 0
          ? const CatalogoScreen()
          : const MiJardinVirtualScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceSeleccionado,
        onDestinationSelected: (indice) {
          setState(() => _indiceSeleccionado = indice);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Buscar plantas',
          ),
          NavigationDestination(
            icon: Icon(Icons.yard),
            label: 'Mi Jardín',
          ),
        ],
      ),
    );
  }
}

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final busqueda = context.watch<BusquedaPlantasProvider>();
    final coleccion = context.watch<ColeccionPlantasProvider>();

    return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _construirControlAltitud(busqueda),
              const SizedBox(height: 12),
              _construirSelector(
                titulo: 'Clima',
                valor: busqueda.clima,
                opciones: BusquedaPlantasProvider.climas.keys.toList(),
                alCambiar: busqueda.cambiarClima,
              ),
              const SizedBox(height: 12),
              _construirSelector(
                titulo: 'Tipo de planta',
                valor: busqueda.tipoPlanta,
                opciones: BusquedaPlantasProvider.tipos.keys.toList(),
                alCambiar: busqueda.cambiarTipoPlanta,
              ),
              const SizedBox(height: 12),
              _construirSelector(
                titulo: 'Color',
                valor: busqueda.color,
                opciones: BusquedaPlantasProvider.colores,
                alCambiar: busqueda.cambiarColor,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: busqueda.cargando ? null : busqueda.buscarPlantas,
                icon: const Icon(Icons.search),
                label: const Text('Buscar especies compatibles'),
              ),
              if (coleccion.error case final error?) ...[
                const SizedBox(height: 8),
                Text(
                  error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 12),
              if (busqueda.cargando)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (busqueda.error case final error?)
                Text(
                  error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                )
              else if (busqueda.plantas.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                        busqueda.consultaRealizada
                            ? 'No se encontraron especies compatibles. '
                                  'Prueba cambiar los filtros o la altitud.'
                            : 'Selecciona los filtros y busca especies.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else ...[
                Text(
                  '${busqueda.plantas.length} especies compatibles',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                _construirListaPlantas(busqueda.plantas),
              ],
            ],
          ),
        ),
    );
  }

  Widget _construirControlAltitud(BusquedaPlantasProvider busqueda) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Altitud: ${busqueda.altitud} msnm',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Slider(
              min: 0,
              max: 5000,
              divisions: 100,
              label: '${busqueda.altitud} msnm',
              value: busqueda.altitud.toDouble(),
              onChanged: busqueda.cambiarAltitud,
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirSelector({
    required String titulo,
    required String valor,
    required List<String> opciones,
    required ValueChanged<String> alCambiar,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: valor,
      decoration: InputDecoration(
        labelText: titulo,
        border: const OutlineInputBorder(),
      ),
      items: opciones
          .map((opcion) => DropdownMenuItem(value: opcion, child: Text(opcion)))
          .toList(),
      onChanged: (nuevoValor) {
        if (nuevoValor != null) alCambiar(nuevoValor);
      },
    );
  }

  Widget _construirListaPlantas(List<Planta> plantas) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: plantas.length,
      itemBuilder: (context, index) {
        final planta = plantas[index];
        return TarjetaPlanta(planta: planta);
      },
    );
  }
}
