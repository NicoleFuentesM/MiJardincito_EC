import 'package:flutter/material.dart';

void main() {
  runApp(const JardincitoApp());
}

class JardincitoApp extends StatelessWidget {
  const JardincitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jardincito EC',
      home: Scaffold(
        appBar: AppBar(title: const Text('Jardincito EC - Base Lista')),
        body: const Center(
          child: Text('¡Estructura de Flutter funcionando!'),
        ),
      ),
    );
  }
}