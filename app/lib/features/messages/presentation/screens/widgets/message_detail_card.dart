import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/utils/time_formatter.dart';
import '../../../domain/entities/message.dart';

/// Reusable widget for displaying a detailed message view.
class MessageDetailCard extends StatelessWidget {
  final Message message;

  const MessageDetailCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(message.icon,
              style: const TextStyle(fontSize: AppConstants.emojiSize * 2)),
          const SizedBox(height: AppConstants.spacing),
          Text(
            formatFullDateTime(message.createdAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Divider(height: 32, thickness: 1.2),
          Text(
            message.message,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
