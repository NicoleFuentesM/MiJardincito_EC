import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentation/providers/coleccion_plantas_provider.dart';
import 'presentation/providers/busqueda_plantas_provider.dart';
import 'presentation/providers/jardin_virtual_provider.dart';
import 'presentation/screens/quiz_screen.dart';
import 'presentation/screens/mi_jardin_virtual_screen.dart';

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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Ubuntu',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4E9F43))
              .copyWith(
                primary: const Color(0xFF4E9F43),
                onPrimary: const Color(0xFF17240B),
                secondary: const Color(0xFF94CEA7),
                onSecondary: const Color(0xFF1D2B20),
                tertiary: const Color(0xFFA7472D),
                onTertiary: Colors.white,
                primaryContainer: const Color(0xFFDEE994),
                onPrimaryContainer: const Color(0xFF17240B),
                surface: const Color(0xFFF1F6E8),
                surfaceContainerLowest: const Color(0xFFEDF4E3),
                surfaceContainerLow: const Color(0xFFE8F1DB),
                surfaceContainer: const Color(0xFFE2EDD4),
                surfaceContainerHigh: const Color(0xFFDCE9CD),
                surfaceContainerHighest: const Color(0xFFD4E4C2),
              ),
          scaffoldBackgroundColor: const Color(0xFFF1F6E8),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4E9F43),
            foregroundColor: Color(0xFF17240B),
            elevation: 0,
          ),
          cardTheme: const CardThemeData(
            color: Color(0xFFE8F1DB),
            elevation: 0,
          ),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Color(0xFFE8F1DB),
            indicatorColor: Color(0xFFDEE994),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFE8F1DB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF94CEA7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF94CEA7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4E9F43), width: 2),
            ),
          ),
        ),
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
  ColeccionPlantasProvider? _coleccionEscuchada;
  bool _inicioResuelto = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final coleccion = context.read<ColeccionPlantasProvider>();
    if (!identical(_coleccionEscuchada, coleccion)) {
      _coleccionEscuchada?.removeListener(_resolverInicio);
      _coleccionEscuchada = coleccion..addListener(_resolverInicio);
    }
    _resolverInicio();
  }

  @override
  void dispose() {
    _coleccionEscuchada?.removeListener(_resolverInicio);
    super.dispose();
  }

  void _resolverInicio() {
    final coleccion = _coleccionEscuchada;
    if (_inicioResuelto || coleccion == null || coleccion.cargando) return;

    void resolver() {
      _inicioResuelto = true;
      _indiceSeleccionado = coleccion.nombresAdoptados.isEmpty ? 0 : 1;
    }

    if (mounted) {
      setState(resolver);
    } else {
      resolver();
    }
  }

  @override
  Widget build(BuildContext context) {
    final esCuestionario = _indiceSeleccionado == 0;

    if (!_inicioResuelto) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _indiceSeleccionado == 0
          ? QuizScreen(
              onGardenTap: () => setState(() => _indiceSeleccionado = 1),
            )
          : const MiJardinVirtualScreen(),
      bottomNavigationBar: esCuestionario
          ? null
          : NavigationBar(
              selectedIndex: _indiceSeleccionado,
              onDestinationSelected: (indice) {
                setState(() => _indiceSeleccionado = indice);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.quiz_outlined),
                  label: 'Buscar',
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
