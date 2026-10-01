import 'package:bipolaris/models/expense_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ExpenseEntry money handling', () {
    test('parses Brazilian currency with thousands and cents', () {
      expect(ExpenseEntry.parseMoneyToCents('R\$ 1.234,56'), 123456);
    });

    test('parses decimal point and formats cents as BRL', () {
      expect(ExpenseEntry.parseMoneyToCents('12.34'), 1234);
      expect(ExpenseEntry.formatMoney(123456), 'R\$ 1.234,56');
    });

    test('rejects invalid, negative, zero, and ambiguous values', () {
      expect(ExpenseEntry.parseMoneyToCents('abc'), isNull);
      expect(ExpenseEntry.parseMoneyToCents('-4,00'), isNull);
      expect(ExpenseEntry.parseMoneyToCents('0,00'), isNull);
      expect(ExpenseEntry.parseMoneyToCents('1,2,3'), isNull);
    });
  });

  test('serializes and restores a self-reported reflection', () {
    final entry = ExpenseEntry(
      id: 'test-1',
      amountCents: 7890,
      purchasedAt: DateTime.utc(2026, 10, 1),
      category: 'Alimentação',
      planned: false,
      selfReportedState: 'ansiedade',
      motivation: 'praticidade',
      reflection: 'Eu precisava mesmo deste item?',
    );

    final restored = ExpenseEntry.fromJson(entry.toJson());

    expect(restored.amountCents, 7890);
    expect(restored.selfReportedState, 'ansiedade');
    expect(restored.motivation, 'praticidade');
    expect(restored.reflection, 'Eu precisava mesmo deste item?');
    expect(restored.planned, isFalse);
  });
}
