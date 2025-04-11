import 'package:app/features/messages/domain/entities/message.dart';
import 'package:app/features/messages/presentation/screens/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MessageListTile displays message data', (WidgetTester tester) async {
    final message = Message(
      id: '1',
      icon: '👋',
      nickname: 'Tester',
      message: 'Hello test world',
      createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MessageListTile(message: message),
        ),
      ),
    );

    expect(find.text('👋'), findsOneWidget);
    expect(find.text('Tester'), findsOneWidget);
    expect(find.text('Hello test world'), findsOneWidget);
    expect(find.textContaining('m'), findsOneWidget);
  });
}
