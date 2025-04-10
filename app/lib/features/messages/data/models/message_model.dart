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

  /// Creates a [MessageModel] from a JSON map.
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString() ?? 'unknown',
      icon: json['icon']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['createdAt'] is int
            ? json['createdAt']
            : int.tryParse(json['createdAt']?.toString() ?? '') ?? 0,
      ),
    );
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'nickname': nickname,
      'message': message,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
