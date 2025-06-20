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
