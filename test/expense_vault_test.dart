import 'package:bipolaris/models/expense_entry.dart';
import 'package:bipolaris/services/expense_vault.dart';
import 'package:flutter_test/flutter_test.dart';
import 'support/memory_string_store.dart';

void main() {
  test(
    'encrypts records at rest and unlocks them with the passphrase',
    () async {
      final storage = MemoryStringStore();
      final vault = ExpenseVault(storage: storage);
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

      final stored = await storage.getString('bipolaris.expense-vault.v1');
      expect(stored, isNot(contains('Exemplo pessoal privado')));
      expect(stored, contains('AES-256-GCM'));

      final contents = await vault.unlock('long-passphrase-123');
      expect(contents.entries.single.motivation, 'comemoração');
      expect(contents.entries.single.selfReportedState, 'feliz');
    },
  );

  test('rejects an incorrect passphrase without exposing entry text', () async {
    final vault = ExpenseVault(storage: MemoryStringStore());
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

    await expectLater(
      vault.unlock('wrong-passphrase'),
      throwsA(isA<VaultUnlockException>()),
    );
  });
}
