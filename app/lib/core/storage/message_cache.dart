import '../../../features/messages/domain/entities/message.dart';

class MessageCache {
  static const int _maxSize = 1500;

  final Map<String, Message> _messages = {};

  /// Get all messages without any particular order.
  List<Message> get all => _messages.values.toList();

  /// Get a message by its ID.
  Message? getById(String id) => _messages[id];

  /// Add or update a message in the cache.
  void add(Message message) {
    _messages[message.id] = message;
    _trim();
  }

  /// Add or update a list of messages in the cache.
  void addAll(List<Message> messages) {
    for (var message in messages) {
      _messages[message.id] = message;
    }
    _trim();
  }

  /// Clear the entire cache.
  void clear() => _messages.clear();

  /// Trim messages in case of exceed message limit
  void _trim() {
    if (_messages.length <= _maxSize) return;

    final keysToRemove =
        _messages.keys.take(_messages.length - _maxSize).toList();
    for (final key in keysToRemove) {
      _messages.remove(key);
    }
  }
}
