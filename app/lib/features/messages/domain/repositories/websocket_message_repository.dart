import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../data/models/message_model.dart';
import '../../data/services/message_repository.dart';
import '../../domain/entities/message.dart';

/// Concrete implementation of [MessageRepository] using WebSocket.
class WebSocketMessageRepository implements MessageRepository {
  WebSocketChannel? _channel;
  final List<Message> _cache = [];
  final _controller = StreamController<Message>.broadcast();

  bool _isConnected = false;
  bool _isConnecting = false;

  static const String _url = 'ws://10.0.2.2:8080/';
  static const Duration _reconnectInterval = Duration(seconds: 5);

  String? _lastFeedId;
  int? _lastAmount;

  WebSocketMessageRepository() {
    _initConnection();
  }

  /// Starts and retries the WebSocket connection.
  void _initConnection() {
    if (_isConnecting) return;
    _isConnecting = true;

    Timer.periodic(_reconnectInterval, (timer) {
      if (_isConnected) {
        timer.cancel();
        return;
      }

      try {
        _channel = WebSocketChannel.connect(Uri.parse(_url));
        _channel!.stream.listen(
          _handleData,
          onDone: () {
            _isConnected = false;
            _initConnection();
          },
          onError: (_) {
            _isConnected = false;
          },
          cancelOnError: true,
        );

        _isConnected = true;
        _isConnecting = false;
        timer.cancel();

        // Resend last request if any
        if (_lastFeedId != null && _lastAmount != null) {
          requestMessages(_lastFeedId!, _lastAmount!);
        }
      } catch (_) {
        _isConnected = false;
      }
    });
  }

  /// Processes incoming WebSocket data.
  void _handleData(dynamic data) {
    dynamic decoded;
    try {
      decoded = jsonDecode(data);
      if (decoded is String) decoded = jsonDecode(decoded);
    } catch (_) {
      _controller.addError(Exception('Failed to decode message: $data'));
      return;
    }

    if (decoded is List) {
      final messages = decoded
          .whereType<Map<String, dynamic>>()
          .map(MessageModel.fromJson)
          .toList();
      _cache.addAll(messages);
      _controller.add(messages.last);
    } else if (decoded is Map<String, dynamic>) {
      final message = MessageModel.fromJson(decoded);
      _cache.add(message);
      _controller.add(message);
    } else {
      _controller.addError(Exception('Unexpected message format: $decoded'));
    }
  }

  @override
  Stream<Message> get messages => _controller.stream;

  @override
  void requestMessages(String id, int amount) {
    _lastFeedId = id;
    _lastAmount = amount;

    if (_channel != null && _isConnected) {
      final request = ['get', id, amount];
      _channel!.sink.add(jsonEncode(request));
    }
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
  void dispose() {
    _channel?.sink.close(status.goingAway);
    _controller.close();
  }
}
