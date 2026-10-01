class Budget {
  final double monthlyLimit;

  Budget({
    required this.monthlyLimit,
  });

  String toStorageString() {
    return monthlyLimit.toString();
  }

  factory Budget.fromStorageString(String data) {
    return Budget(
      monthlyLimit: double.parse(data),
    );
  }
}