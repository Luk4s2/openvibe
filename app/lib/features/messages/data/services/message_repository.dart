

import '../../domain/entities/message.dart';

/// Abstract class defining the contract for any message repository implementation.
abstract class MessageRepository {
  /// Stream of messages received from the server.
  Stream<Message> get messages;

  /// Requests a number of messages from the server using the feed ID.
  void requestMessages(String id, int amount);

  /// Returns a message from the local cache by its [id].
  Message? getMessageById(String id);

  /// List of all messages currently cached.
  List<Message> get cachedMessages;

  /// Closes the WebSocket or other active connections.
  void dispose();
}
