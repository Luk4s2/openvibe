import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/message.dart';
import 'widgets/index.dart';

/// Screen to display detailed content of a single message.
class MessageDetailScreen extends StatelessWidget {
  final Message message;

  const MessageDetailScreen({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          message.nickname,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.cardPadding),
        child: MessageDetailCard(message: message)
      ),
    );
  }
}
