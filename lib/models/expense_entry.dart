import 'dart:math';

class ExpenseEntry {
  const ExpenseEntry({
    required this.id,
    required this.amountCents,
    required this.purchasedAt,
    required this.category,
    required this.planned,
    this.description,
    this.selfReportedState,
    this.motivation,
    this.reflection,
  });

  final String id;
  final int amountCents;
  final DateTime purchasedAt;
  final String category;
  final bool planned;
  final String? description;
  final String? selfReportedState;
  final String? motivation;
  final String? reflection;

  Map<String, Object?> toJson() => {
    'id': id,
    'amountCents': amountCents,
    'purchasedAt': purchasedAt.toIso8601String(),
    'category': category,
    'planned': planned,
    'description': description,
    'selfReportedState': selfReportedState,
    'motivation': motivation,
    'reflection': reflection,
  };

  factory ExpenseEntry.fromJson(Map<String, Object?> json) {
    final amount = json['amountCents'];
    final planned = json['planned'];
    if (amount is! int || amount <= 0 || planned is! bool) {
      throw const FormatException('Invalid expense record.');
    }
    return ExpenseEntry(
      id: json['id'] as String,
      amountCents: amount,
      purchasedAt: DateTime.parse(json['purchasedAt'] as String),
      category: json['category'] as String,
      planned: planned,
      description: _optionalText(json['description']),
      selfReportedState: _optionalText(json['selfReportedState']),
      motivation: _optionalText(json['motivation']),
      reflection: _optionalText(json['reflection']),
    );
  }

  static String? _optionalText(Object? value) {
    if (value == null) return null;
    final text = value as String;
    return text.isEmpty ? null : text;
  }

  static String newId() => DateTime.now().microsecondsSinceEpoch.toString();

  static int? parseMoneyToCents(String value) {
    var normalized = value.trim().replaceAll(RegExp(r'[^0-9,.-]'), '');
    if (normalized.isEmpty || normalized.startsWith('-')) return null;
    if (normalized.contains(',')) {
      if (normalized.indexOf(',') != normalized.lastIndexOf(',')) return null;
      normalized = normalized.replaceAll('.', '').replaceFirst(',', '.');
    } else if (normalized.indexOf('.') != normalized.lastIndexOf('.')) {
      return null;
    }
    final amount = double.tryParse(normalized);
    if (amount == null || !amount.isFinite || amount <= 0) return null;
    final cents = (amount * 100).round();
    return cents > 0 ? cents : null;
  }

  static String formatMoney(int cents) {
    final whole = (cents ~/ 100).toString();
    final grouped = whole.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => '.',
    );
    final fraction = (cents % 100).toString().padLeft(2, '0');
    return 'R\$ $grouped,$fraction';
  }
}
