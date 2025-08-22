class TimeSlot {
  final DateTime date;
  final int startHour; // 24-hour format
  final int endHour;
  final bool isAvailable;
  final double? discount; // Optional discount percentage

  TimeSlot({
    required this.date,
    required this.startHour,
    required this.endHour,
    this.isAvailable = true,
    this.discount,
  });

  String get timeRange {
    final startAmPm = startHour < 12 ? 'AM' : 'PM';
    final endAmPm = endHour < 12 ? 'AM' : 'PM';
    final startHour12 = startHour > 12
        ? startHour - 12
        : (startHour == 0 ? 12 : startHour);
    final endHour12 = endHour > 12
        ? endHour - 12
        : (endHour == 0 ? 12 : endHour);

    return '$startHour12 $startAmPm - $endHour12 $endAmPm';
  }

  String get shortTimeRange {
    final startAmPm = startHour < 12 ? 'AM' : 'PM';
    final endAmPm = endHour < 12 ? 'AM' : 'PM';
    final startHour12 = startHour > 12
        ? startHour - 12
        : (startHour == 0 ? 12 : startHour);
    final endHour12 = endHour > 12
        ? endHour - 12
        : (endHour == 0 ? 12 : endHour);

    // Show end AM/PM only if different from start
    if (startAmPm == endAmPm) {
      return '$startHour12 – $endHour12 $endAmPm';
    }
    return '$startHour12 $startAmPm – $endHour12 $endAmPm';
  }

  DateTime get startDateTime {
    return DateTime(date.year, date.month, date.day, startHour);
  }

  DateTime get endDateTime {
    return DateTime(date.year, date.month, date.day, endHour);
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  String get dayLabel {
    if (isToday) return 'Today';
    if (isTomorrow) return 'Tomorrow';

    final weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return weekdays[date.weekday - 1];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          startHour == other.startHour &&
          endHour == other.endHour;

  @override
  int get hashCode => date.hashCode ^ startHour.hashCode ^ endHour.hashCode;

  /// Convert TimeSlot to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'startHour': startHour,
      'endHour': endHour,
      'isAvailable': isAvailable,
      'discount': discount,
    };
  }

  /// Create TimeSlot from Map
  static TimeSlot fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      date: DateTime.parse(map['date'] as String),
      startHour: map['startHour'] as int,
      endHour: map['endHour'] as int,
      isAvailable: map['isAvailable'] as bool? ?? true,
      discount: map['discount'] as double?,
    );
  }
}
