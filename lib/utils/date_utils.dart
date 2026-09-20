bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Monday-start of the week containing [d].
DateTime startOfWeek(DateTime d) {
  final day = dateOnly(d);
  final diff = day.weekday - DateTime.monday; // Monday = 1
  return day.subtract(Duration(days: diff));
}

DateTime startOfMonth(DateTime d) => DateTime(d.year, d.month, 1);

List<DateTime> lastNDays(int n, {DateTime? end}) {
  final today = dateOnly(end ?? DateTime.now());
  return List.generate(
      n, (i) => today.subtract(Duration(days: n - 1 - i)));
}

String weekdayShort(DateTime d) {
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return names[d.weekday - 1];
}

String greetingForNow() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning!';
  if (hour < 17) return 'Good Afternoon!';
  return 'Good Evening!';
}
