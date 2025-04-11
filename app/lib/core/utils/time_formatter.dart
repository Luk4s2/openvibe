import 'package:intl/intl.dart';
/// Provides utility methods for formatting date and time into readable formats.


/// Returns a relative time string like '3m', '2h', '1d' based on [time].
String formatTimeAgo(DateTime time) {
  final diff = DateTime.now().difference(time);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  return '${diff.inDays}d';
}

/// Returns a full formatted date string from [time].
String formatFullDateTime(DateTime time) {
  return DateFormat('dd/MM/yyyy h:mm a').format(time.toLocal());
}
