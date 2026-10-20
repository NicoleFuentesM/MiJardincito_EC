import 'package:flutter_test/flutter_test.dart';
import 'package:mijardincito_ec/main.dart';

void main() {
  testWidgets('La aplicación muestra el selector de plantas', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MiJardincitoApp());

    expect(find.text('Mi Jardincito EC - Selector'), findsOneWidget);
    expect(find.text('Altitud: 2800 msnm'), findsOneWidget);
    expect(find.text('Buscar Plantas Compatibles'), findsOneWidget);

    await tester.tap(find.text('Buscar Plantas Compatibles'));
    await tester.pump();

    expect(
      find.text('Consultando para 2800 msnm y clima Templado...'),
      findsOneWidget,
    );
  });
}
