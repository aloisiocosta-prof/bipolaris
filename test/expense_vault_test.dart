import 'dart:convert';

import 'package:bipolaris/models/expense_entry.dart';
import 'package:bipolaris/services/expense_vault.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('encrypts records at rest and unlocks them with the passphrase', () async {
    final preferences = SharedPreferencesAsync();
    final vault = ExpenseVault(preferences: preferences);
    final session = await vault.create('long-passphrase-123');
    await session.save([
      ExpenseEntry(
        id: 'entry-1',
        amountCents: 1500,
        purchasedAt: DateTime.utc(2026, 10, 1),
        category: 'Lazer',
        planned: false,
        selfReportedState: 'feliz',
        motivation: 'comemoração',
        reflection: 'Exemplo pessoal privado',
      ),
    ]);

    final stored = await preferences.getString('bipolaris.expense-vault.v1');
    expect(stored, isNot(contains('Exemplo pessoal privado')));
    expect(stored, contains('AES-256-GCM'));

    final contents = await vault.unlock('long-passphrase-123');
    expect(contents.entries.single.motivation, 'comemoração');
    expect(contents.entries.single.selfReportedState, 'feliz');
  });

  test('rejects an incorrect passphrase without exposing entry text', () async {
    final vault = ExpenseVault(preferences: SharedPreferencesAsync());
    final session = await vault.create('long-passphrase-123');
    await session.save([
      ExpenseEntry(
        id: 'entry-1',
        amountCents: 1500,
        purchasedAt: DateTime.utc(2026, 10, 1),
        category: 'Lazer',
        planned: false,
        description: 'Fato fictício',
      ),
    ]);

    expect(
      () => vault.unlock('wrong-passphrase'),
      throwsA(isA<VaultUnlockException>()),
    );
  });
}
