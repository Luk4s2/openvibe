import '../../domain/entities/message.dart';

/// A model class that represents a [Message] and handles JSON conversion.
class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.icon,
    required super.nickname,
    required super.message,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String? ?? 'unknown',
      icon: json['icon'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      message: json['message'] as String? ?? '',
      createdAt: _parseTimestamp(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'nickname': nickname,
      'message': message,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  static DateTime _parseTimestamp(dynamic input) {
    if (input is int) return DateTime.fromMillisecondsSinceEpoch(input);
    final parsed = int.tryParse(input?.toString() ?? '');
    return DateTime.fromMillisecondsSinceEpoch(parsed ?? 0);
  }
}
