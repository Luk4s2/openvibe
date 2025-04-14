import 'package:flutter/material.dart';

import '../../features/messages/domain/entities/message.dart';
import '../../features/messages/presentation/screens/message_detail_screen.dart';
import '../../features/messages/presentation/screens/message_list_screen.dart';
import '../constants/app_constants.dart';
import '../constants/app_routes.dart';

/// Centralized router for handling application navigation.
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const MessageListWrapper(),
        );

      case AppRoutes.detail:
        final message = settings.arguments as Message;
        return MaterialPageRoute(
          builder: (_) => MessageDetailScreen(message: message),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text(AppConstants.pageNotFound)),
          ),
        );
    }
  }
}
