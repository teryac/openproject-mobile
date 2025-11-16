class WeekDay {
  final int position;
  final String name;
  final bool working;

  const WeekDay({
    required this.position,
    required this.name,
    required this.working,
  });

  factory WeekDay.fromJson(Map<String, dynamic> json) {
    return WeekDay(
      position: json['day'] as int,
      name: json['name'] as String,
      working: json['working'] as bool,
    );
  }
}
