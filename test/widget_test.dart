import 'package:bipolaris/main.dart';
import 'package:bipolaris/models/expense_entry.dart';
import 'package:bipolaris/services/expense_vault.dart';
import 'package:bipolaris/theme/bipolaris_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
    expect(find.text('Crie seu diário protegido'), findsOneWidget);
    expect(find.textContaining('não são enviados'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('Criar diário protegido'), findsOneWidget);
    expect(find.textContaining('não faz diagnóstico'), findsOneWidget);
  });

  testWidgets('period and category filters update the same summary', (
    tester,
  ) async {
    final now = DateTime.now();
    final store = MemoryStringStore();
    final session = await ExpenseVault(storage: store).create('senha de teste');
    final entries = [
      ExpenseEntry(
        id: 'today-food',
        amountCents: 1000,
        purchasedAt: now,
        category: 'Alimentação',
        planned: true,
        selfReportedState: 'Tranquilo(a)',
      ),
      ExpenseEntry(
        id: 'today-transit',
        amountCents: 2500,
        purchasedAt: now,
        category: 'Transporte',
        planned: false,
        selfReportedState: 'Preocupado(a)',
      ),
      ExpenseEntry(
        id: 'older-food',
        amountCents: 500,
        purchasedAt: now.subtract(const Duration(days: 40)),
        category: 'Alimentação',
        planned: true,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: BipolarisTheme.light(),
        home: JournalPage(
          session: session,
          initialEntries: entries,
          onLock: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('R\$ 40,00'), findsOneWidget);

    await tester.tap(find.text('30 dias'));
    await tester.pumpAndSettle();
    expect(find.text('R\$ 35,00'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('Todas as categorias'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alimentação').last);
    await tester.pumpAndSettle();

    expect(find.text('R\$ 10,00'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Tranquilo(a)'), findsOneWidget);
    expect(find.text('Preocupado(a)'), findsNothing);
  });

  testWidgets('reflection form offers optional self-report choices', (
    tester,
  ) async {
    final session = await ExpenseVault(
      storage: MemoryStringStore(),
    ).create('senha de teste');
    await tester.pumpWidget(
      MaterialApp(
        theme: BipolarisTheme.light(),
        home: JournalPage(
          session: session,
          initialEntries: const [],
          onLock: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Registrar gasto'));
    await tester.pumpAndSettle();

    expect(find.text('Como você se sentia? (opcional)'), findsOneWidget);
    expect(find.text('O que motivou a compra? (opcional)'), findsOneWidget);
    expect(find.text('Animado(a)'), findsOneWidget);
    expect(find.text('Outro / escrever'), findsNWidgets(2));

    final choice = find.ancestor(
      of: find.text('Animado(a)'),
      matching: find.byType(ChoiceChip),
    );
    await tester.tap(choice);
    await tester.pumpAndSettle();
    expect(tester.widget<ChoiceChip>(choice).selected, isTrue);
  });
}
