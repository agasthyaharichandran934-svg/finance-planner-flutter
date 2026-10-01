class Goal {
  final String name;
  final double targetAmount;
  final double currentAmount;
  final String deadline;

  Goal({
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
  });

  // Always clamped between 0.0 and 1.0 to prevent Flutter assertion errors
  double get progress {
    if (targetAmount <= 0) {
      return 0.0;
    }
    return (currentAmount / targetAmount).clamp(0.0, 1.0);
  }

  // Percentage value for display (0.0 to 100.0)
  double get progressPercent => progress * 100;

  String toStorageString() {
    return '$name|$targetAmount|$currentAmount|$deadline';
  }

  factory Goal.fromStorageString(String data) {
    try {
      final parts = data.split('|');
      return Goal(
        name: parts.isNotEmpty ? parts[0] : '',
        targetAmount: parts.length > 1 ? double.tryParse(parts[1]) ?? 0.0 : 0.0,
        currentAmount: parts.length > 2 ? double.tryParse(parts[2]) ?? 0.0 : 0.0,
        deadline: parts.length > 3 ? parts[3] : '',
      );
    } catch (_) {
      return Goal(
        name: 'Untitled Goal',
        targetAmount: 0.0,
        currentAmount: 0.0,
        deadline: '',
      );
    }
  }
}