import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../data/models/message_model.dart';
import '../../data/services/message_repository.dart';
import '../../domain/entities/message.dart';

/// Concrete implementation of [MessageRepository] using WebSocket.
class WebSocketMessageRepository implements MessageRepository {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://10.0.2.2:8080/'),
  );

  final List<Message> _cache = [];

  @override
  Stream<Message> get messages => _channel.stream.map((data) {
        dynamic decoded;

        try {
          decoded = jsonDecode(data);
          if (decoded is String) {
            decoded = jsonDecode(decoded); // double encoded JSON
          }
        } catch (_) {
          throw Exception('Failed to decode message: $data');
        }

        if (decoded is List) {
          final messages = decoded
              .whereType<Map<String, dynamic>>()
              .map(MessageModel.fromJson)
              .toList();
          _cache.addAll(messages);
          return messages.last;
        }

        if (decoded is Map<String, dynamic>) {
          final message = MessageModel.fromJson(decoded);
          _cache.add(message);
          return message;
        }

        throw Exception('Unexpected message format: $decoded');
      });

  @override
  void requestMessages(String id, int amount) {
    final request = ['get', id, amount];
    _channel.sink.add(jsonEncode(request));
  }

  @override
  Message? getMessageById(String id) {
    try {
      return _cache.firstWhere((msg) => msg.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Message> get cachedMessages => List.unmodifiable(_cache);

  @override
  void dispose() => _channel.sink.close();
}
