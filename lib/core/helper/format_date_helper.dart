String formatDate(DateTime date) {
  final now = DateTime.now();
  final difference = date.difference(now);

  if (difference.inDays == 0) {
    return 'Hari ini';
  } else if (difference.inDays == 1) {
    return 'Besok';
  } else if (difference.inDays == -1) {
    return 'Kemarin';
  } else if (difference.inDays < 0) {
    return '${-difference.inDays} hari lalu';
  } else {
    return '${difference.inDays} hari lagi';
  }
}

String formatDateWithTime(DateTime date) {
  final witaDate = date.add(const Duration(hours: 8));
  final now = DateTime.now().add(const Duration(hours: 8));
  final difference = witaDate.difference(now);

  if (difference.inDays == 0) {
    final hour = witaDate.hour.toString().padLeft(2, '0');
    final minute = witaDate.minute.toString().padLeft(2, '0');
    return 'Hari ini, $hour:$minute';
  } else if (difference.inDays == 1) {
    final hour = witaDate.hour.toString().padLeft(2, '0');
    final minute = witaDate.minute.toString().padLeft(2, '0');
    return 'Besok, $hour:$minute';
  } else if (difference.inDays == -1) {
    final hour = witaDate.hour.toString().padLeft(2, '0');
    final minute = witaDate.minute.toString().padLeft(2, '0');
    return 'Kemarin, $hour:$minute';
  } else if (difference.inDays < -1) {
    final day = witaDate.day.toString().padLeft(2, '0');
    final month = witaDate.month.toString().padLeft(2, '0');
    final year = witaDate.year.toString();
    final hour = witaDate.hour.toString().padLeft(2, '0');
    final minute = witaDate.minute.toString().padLeft(2, '0');
    return '$day-$month-$year $hour:$minute';
  } else {
    final hour = witaDate.hour.toString().padLeft(2, '0');
    final minute = witaDate.minute.toString().padLeft(2, '0');
    return '${difference.inDays} hari lagi, $hour:$minute';
  }
}
