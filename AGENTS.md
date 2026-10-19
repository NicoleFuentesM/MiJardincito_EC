# Reglas de SDLC Agentic - Proyecto Jardincito EC

**Contexto del Proyecto:**
Aplicación móvil para identificar flora autóctona del Ecuador.
Frontend: Flutter/Dart. Backend (Lógica): C++ nativo vía Dart FFI.
Arquitectura: Clean Architecture (Presentation, Domain, Data).
Gestor de Estado: Provider.

**Reglas para Asistentes de IA (Context Engineering):**
1. **Clean Architecture:** Ningún widget de interfaz (`screens`) debe contener lógica de negocio. Toda la lógica reside en `use_cases`.
2. **C++ y FFI:** Al generar código C++, respetar POO. Las funciones exportadas para FFI deben usar `extern "C"`.
3. **Manejo de Estado:** Usar exclusivamente `Provider`. Prohibido usar `setState` excepto para animaciones efímeras locales.
4. **Metodología TDD:** Validar pruebas (Rojo -> Verde -> Refactor) antes de implementar lógica final.
5. **Idioma:** Código, variables (ej. `PlantaNativa`) y comentarios en español.
