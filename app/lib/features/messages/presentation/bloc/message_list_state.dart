import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

/// Represents the various UI states for message list screen.
abstract class MessageListState extends Equatable {
  const MessageListState();

  @override
  List<Object?> get props => [];
}

/// Initial state when nothing is loaded yet.
class MessageListInitial extends MessageListState {
  const MessageListInitial();
}

/// State while messages are being loaded.
class MessageListLoading extends MessageListState {
  const MessageListLoading();
}

/// State when messages have been successfully fetched.
class MessageListLoaded extends MessageListState {
  final List<Message> messages;

  const MessageListLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// State when an error occurred during loading.
class MessageListError extends MessageListState {
  final String error;

  const MessageListError(this.error);

  @override
  List<Object?> get props => [error];
}
