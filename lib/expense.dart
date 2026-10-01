class Expense {
  final double amount;
  final String category;
  final String description;

  Expense({
    required this.amount,
    required this.category,
    required this.description,
  });

  Expense copyWith({
    double? amount,
    String? category,
    String? description,
  }) {
    return Expense(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  String toStorageString() {
    return '$amount|$category|$description';
  }

  factory Expense.fromStorageString(String data) {
    final parts = data.split('|');

    return Expense(
      amount: double.parse(parts[0]),
      category: parts[1],
      description: parts[2],
    );
  }
}