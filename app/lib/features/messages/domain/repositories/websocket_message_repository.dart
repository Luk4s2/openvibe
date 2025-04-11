import 'dart:async';
import 'dart:convert';
import 'package:app/core/constants/app_constants.dart';
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

  static const String _url = 'ws://${AppConstants.websocketIP}/';
  static const Duration _reconnectInterval = Duration(seconds: AppConstants.reconnectInterval);

  String? _lastFeedId;
  int? _lastAmount;

  WebSocketMessageRepository() {
    _initConnection();
  }

  void _initConnection() {
    if (_isConnecting) return;
    _isConnecting = true;

    Timer.periodic(_reconnectInterval, (timer) {
      if (_isConnected) {
        timer.cancel();
        return;
      }

      try {
        final channel = WebSocketChannel.connect(Uri.parse(_url));

        channel.stream.listen(
          _handleData,
          onDone: () {
            _isConnected = false;
            _isConnecting = false;
            _channel = null;
          },
          onError: (_) {
            _isConnected = false;
            _isConnecting = false;
            _channel = null;
          },
          cancelOnError: true,
        );

        _channel = channel;
        _isConnected = true;
        _isConnecting = false;
        timer.cancel();

        if (_lastFeedId != null && _lastAmount != null) {
          requestMessages(_lastFeedId!, _lastAmount!);
        }
      } catch (e) {
        _isConnected = false;
        _isConnecting = false;
        _channel = null;
      }
    });
  }

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
