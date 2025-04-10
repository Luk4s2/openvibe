/// Provides utility methods for formatting date and time into readable formats.
library;

/// Returns a relative time string like '3m', '2h', '1d' based on [time].
String formatTimeAgo(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  return '${diff.inDays}d';
}

/// Returns a full formatted date string from [time].
String formatFullDate(DateTime time) {
  return '${time.toLocal()}';
}
