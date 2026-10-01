class Income {
  final double amount;
  final String source;
  final String description;

  Income({
    required this.amount,
    required this.source,
    required this.description,
  });

  String toStorageString() {
    return '$amount|$source|$description';
  }

  factory Income.fromStorageString(String data) {
    final parts = data.split('|');

    return Income(
      amount: double.parse(parts[0]),
      source: parts[1],
      description: parts[2],
    );
  }
}