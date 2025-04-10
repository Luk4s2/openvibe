import 'package:equatable/equatable.dart';

/// Entity class representing a user message.
class Message extends Equatable {
  final String id;
  final String icon;
  final String nickname;
  final String message;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.icon,
    required this.nickname,
    required this.message,
    required this.createdAt,
  });

  /// Returns a new instance with updated fields if provided.
  Message copyWith({
    String? id,
    String? icon,
    String? nickname,
    String? message,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      nickname: nickname ?? this.nickname,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, icon, nickname, message, createdAt];
}