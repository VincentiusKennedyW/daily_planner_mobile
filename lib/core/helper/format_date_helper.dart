String formatDate(DateTime date) {
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final targetDate = DateTime(date.year, date.month, date.day);

  final difference = targetDate.difference(today);
  final dayDifference = difference.inDays;

  if (dayDifference == 0) {
    return 'Hari ini';
  } else if (dayDifference == 1) {
    return 'Besok';
  } else if (dayDifference == -1) {
    return 'Kemarin';
  } else if (dayDifference < 0) {
    return '${-dayDifference} hari lalu';
  } else {
    return '$dayDifference hari lagi';
  }
}

String formatDateWithTime(DateTime date) {
  final witaDate = date.add(const Duration(hours: 8));
  final now = DateTime.now().add(const Duration(hours: 8));

  final today = DateTime(now.year, now.month, now.day);
  final targetDate = DateTime(witaDate.year, witaDate.month, witaDate.day);
  final difference = targetDate.difference(today);
  final dayDifference = difference.inDays;

  final hour = witaDate.hour.toString().padLeft(2, '0');
  final minute = witaDate.minute.toString().padLeft(2, '0');

  if (dayDifference == 0) {
    return 'Hari ini, $hour:$minute';
  } else if (dayDifference == 1) {
    return 'Besok, $hour:$minute';
  } else if (dayDifference == -1) {
    return 'Kemarin, $hour:$minute';
  } else if (dayDifference < -1) {
    final day = witaDate.day.toString().padLeft(2, '0');
    final month = witaDate.month.toString().padLeft(2, '0');
    final year = witaDate.year.toString();
    return '$day-$month-$year $hour:$minute';
  } else {
    return '$dayDifference hari lagi, $hour:$minute';
  }
}
