import 'dart:async';
import 'dart:convert';

import 'package:app/core/constants/app_constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../../core/storage/message_cache.dart';
import '../../data/models/message_model.dart';
import '../../data/services/message_repository.dart';
import '../../domain/entities/message.dart';

/// WebSocket implementation of [MessageRepository].
class WebSocketMessageRepository implements MessageRepository {
  static const String _url = 'ws://${AppConstants.websocketIP}/';
  static const Duration _reconnectInterval = Duration(seconds: AppConstants.reconnectInterval);

  final MessageCache _cache = MessageCache();
  final StreamController<List<Message>> _messageListController = StreamController<List<Message>>.broadcast();

  WebSocketChannel? _channel;
  bool _isConnected = false;
  bool _isConnecting = false;

  String? _lastFeedId;
  int? _lastAmount;

  WebSocketMessageRepository() {
    _initConnection();
  }

  void _initConnection() {
    if (_isConnecting || _isConnected) return;
    _isConnecting = true;
    _attemptConnection();
  }

  Future<void> _attemptConnection() async {
    try {
      final channel = WebSocketChannel.connect(Uri.parse(_url));
      _channel = channel;

      channel.stream.listen(
        _handleIncomingData,
        onDone: _handleConnectionClosed,
        onError: (_) => _handleConnectionClosed(),
        cancelOnError: true,
      );

      _isConnected = true;
      _isConnecting = false;

      _replayLastRequest();
    } catch (_) {
      _handleConnectionClosed();
      await Future.delayed(_reconnectInterval);
      _attemptConnection();
    }
  }

  void _handleConnectionClosed() => _resetConnectionState();

  void _resetConnectionState() {
    _isConnected = false;
    _isConnecting = false;
    _channel = null;
  }

  void _replayLastRequest() {
    if (_lastFeedId != null && _lastAmount != null) {
      requestMessages(_lastFeedId!, _lastAmount!);
    }
  }

  void _handleIncomingData(dynamic rawData) {
    try {
      final decoded = _decodeData(rawData);

      if (decoded is List) {
        _handleMessageList(decoded);
      } else if (decoded is Map<String, dynamic>) {
        _handleSingleMessage(decoded);
      } else {
        _messageListController.addError(Exception('Unexpected message format'));
      }
    } catch (_) {
      _messageListController.addError(Exception('Failed to decode message: $rawData'));
    }
  }

  dynamic _decodeData(dynamic rawData) {
    final decoded = jsonDecode(rawData);
    return decoded is String ? jsonDecode(decoded) : decoded;
  }

  void _handleMessageList(List<dynamic> decodedList) {
    final messages = decodedList
        .whereType<Map<String, dynamic>>()
        .map(MessageModel.fromJson)
        .toList();

    _cache.addAll(messages);
    _messageListController.add(_cache.all);
  }

  void _handleSingleMessage(Map<String, dynamic> data) {
    final message = MessageModel.fromJson(data);
    _cache.add(message);
    _messageListController.add(_cache.all);
  }

  @override
  Stream<List<Message>> get messages => _messageListController.stream;

  @override
  List<Message> get cachedMessages => _cache.all;

  @override
  void requestMessages(String id, int amount) {
    _lastFeedId = id;
    _lastAmount = amount;

    if (_isConnected && _channel != null) {
      final request = ['get', id, amount];
      _channel!.sink.add(jsonEncode(request));
    }
  }

  @override
  Message? getMessageById(String id) => _cache.getById(id);

  @override
  void dispose() {
    _channel?.sink.close(status.goingAway);
    _messageListController.close();
  }
}
