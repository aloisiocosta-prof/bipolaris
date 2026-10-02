import 'package:bipolaris/main.dart';
import 'package:bipolaris/models/expense_entry.dart';
import 'package:bipolaris/privacy_and_use_page.dart';
import 'package:bipolaris/services/expense_vault.dart';
import 'package:bipolaris/theme/bipolaris_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/memory_string_store.dart';

void main() {
  test('route parser accepts hash and path deep links', () async {
    const parser = BipolarisRouteInformationParser();

    final hashRoute = await parser.parseRouteInformation(
      RouteInformation(uri: Uri.parse('https://bipolaris.test/#/privacy')),
    );
    final pathRoute = await parser.parseRouteInformation(
      RouteInformation(uri: Uri.parse('https://bipolaris.test/privacy')),
    );
    final rootRoute = await parser.parseRouteInformation(
      RouteInformation(uri: Uri.parse('https://bipolaris.test/')),
    );

    expect(hashRoute.showPrivacy, isTrue);
    expect(pathRoute.showPrivacy, isTrue);
    expect(rootRoute.showPrivacy, isFalse);
    expect(parser.restoreRouteInformation(hashRoute).uri.path, '/privacy');
  });

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
    final session = _FakeSession();
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
          onOpenPrivacy: () {},
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

    expect(find.text('R\$ 10,00'), findsAtLeastNWidgets(1));
    expect(find.text('1'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.text('Tranquilo(a)'), findsOneWidget);
    expect(find.text('Preocupado(a)'), findsNothing);
  });

  testWidgets('reflection form offers optional self-report choices', (
    tester,
  ) async {
    final session = _FakeSession();
    await tester.pumpWidget(
      MaterialApp(
        theme: BipolarisTheme.light(),
        home: JournalPage(
          session: session,
          initialEntries: const [],
          onLock: () {},
          onOpenPrivacy: () {},
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

  testWidgets('privacy and use guide is available before creating the vault', (
    tester,
  ) async {
    await tester.pumpWidget(
      BipolarisApp(vault: ExpenseVault(storage: MemoryStringStore())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Privacidade e uso'));
    await tester.pumpAndSettle();

    expect(find.byType(PrivacyAndUsePage), findsOneWidget);
    expect(find.text('Que dados ficam salvos e onde?'), findsOneWidget);

    expect(
      find.text('Informações claras, quando você precisar'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('privacy and use guide can be reopened from journal options', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: BipolarisTheme.light(),
        home: Builder(
          builder: (context) => JournalPage(
            session: _FakeSession(),
            initialEntries: const [],
            onLock: () {},
            onOpenPrivacy: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const PrivacyAndUsePage(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Opções do diário'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Privacidade e uso'));
    await tester.pumpAndSettle();

    expect(find.byType(PrivacyAndUsePage), findsOneWidget);
    expect(find.text('Como usar o diário'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('privacy guide remains readable on a narrow mobile viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: BipolarisTheme.light(),
        home: const PrivacyAndUsePage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Privacidade e uso'), findsOneWidget);
    expect(find.text('Como usar o diário'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('summary cards stack on narrow screens and fit large totals', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final session = _FakeSession();
    await tester.pumpWidget(
      MaterialApp(
        theme: BipolarisTheme.light(),
        home: JournalPage(
          session: session,
          initialEntries: [
            ExpenseEntry(
              id: 'large-total',
              amountCents: 123456789,
              purchasedAt: DateTime.now(),
              category: 'Outro',
              planned: true,
            ),
          ],
          onLock: () {},
          onOpenPrivacy: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final totalCard = find
        .ancestor(
          of: find.text('Total • todo o período'),
          matching: find.byType(Card),
        )
        .first;
    final countCard = find
        .ancestor(
          of: find.text('Registros exibidos'),
          matching: find.byType(Card),
        )
        .first;

    expect(
      tester.getTopLeft(countCard).dy,
      greaterThan(tester.getBottomLeft(totalCard).dy),
    );
    expect(find.text('R\$ 1.234.567,89'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeSession implements ExpenseVaultSession {
  @override
  Future<void> destroy() async {}

  @override
  Future<void> save(List<ExpenseEntry> entries) async {}
}
