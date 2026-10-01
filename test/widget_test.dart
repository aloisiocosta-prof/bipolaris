import 'package:bipolaris/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'services/expense_vault.dart';
import 'support/memory_string_store.dart';

void main() {
  testWidgets('offers to create a private expense reflection journal', (
    tester,
  ) async {
    await tester.pumpWidget(
      BipolarisApp(vault: ExpenseVault(storage: MemoryStringStore())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bipolaris'), findsOneWidget);
    expect(find.text('Criar diário protegido'), findsOneWidget);
    expect(find.textContaining('não são enviados'), findsOneWidget);
    expect(find.textContaining('não faz diagnóstico'), findsOneWidget);
  });
}
