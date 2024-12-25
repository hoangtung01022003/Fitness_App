class Goal {
  final String goalType;
  final double targetValue;
  final String unit;
  final String startDate;
  final String targetDate;

  Goal({
    required this.goalType,
    required this.targetValue,
    required this.unit,
    required this.startDate,
    required this.targetDate,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      goalType: json['goal_type'],
      targetValue: json['target_value'],
      unit: json['unit'],
      startDate: json['start_date'],
      targetDate: json['target_date'],
    );
  }
}
