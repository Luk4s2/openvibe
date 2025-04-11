import 'package:app/features/messages/data/models/message_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MessageModel', () {
    test('fromJson should return valid model', () {
      final json = {
        'id': '123',
        'icon': '😎',
        'nickname': 'John',
        'message': 'Hello world',
        'createdAt': DateTime(2024, 1, 1).millisecondsSinceEpoch,
      };

      final model = MessageModel.fromJson(json);

      expect(model.id, '123');
      expect(model.icon, '😎');
      expect(model.nickname, 'John');
      expect(model.message, 'Hello world');
      expect(model.createdAt.year, 2024);
    });

    test('toJson should convert to proper map', () {
      final model = MessageModel(
        id: '123',
        icon: '🔥',
        nickname: 'Alice',
        message: 'Testing...',
        createdAt: DateTime(2025, 12, 24, 10, 15),
      );

      final map = model.toJson();

      expect(map['id'], '123');
      expect(map['icon'], '🔥');
      expect(map['nickname'], 'Alice');
      expect(map['message'], 'Testing...');
      expect(map['createdAt'], model.createdAt.millisecondsSinceEpoch);
    });
  });
}
