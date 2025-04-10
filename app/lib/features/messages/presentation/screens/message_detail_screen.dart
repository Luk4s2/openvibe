import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../domain/entities/message.dart';

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
        child: Container(
          padding: const EdgeInsets.all(AppConstants.cardPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text(message.icon,
                      style: const TextStyle(
                          fontSize: AppConstants.emojiSize * 2))),
              const SizedBox(height: AppConstants.spacing),
              Text(
                formatFullDate(message.createdAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(height: 32, thickness: 1.2),
              Text(
                message.message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
