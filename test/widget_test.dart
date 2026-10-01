import 'package:bipolaris/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'shows synthetic-data and non-clinical scope notices',
    (
      tester,
    ) async {
      await tester.pumpWidget(const BipolarisApp());

      expect(
        find.textContaining('todos os exemplos são fictícios'),
        findsOneWidget,
      );
      expect(find.textContaining('não oferece diagnóstico'), findsOneWidget);
      expect(
        find.textContaining('Nenhum agente de IA está conectado.'),
        findsOneWidget,
      );
    },
  );
}
