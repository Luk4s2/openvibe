import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/di.dart';
import '../bloc/message_list_bloc.dart';
import '../bloc/message_list_event.dart';
import '../bloc/message_list_state.dart';
import 'widgets/index.dart';

/// Displays a list of recent messages with basic details.
class MessageListScreen extends StatelessWidget {
  const MessageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<MessageListBloc>()
        ..add(const FetchMessages(AppConstants.defaultMessageId, AppConstants.defaultFetchAmount)),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: const Text(
            AppConstants.messagesTitle,
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: BlocBuilder<MessageListBloc, MessageListState>(
          builder: (context, state) {
            if (state is MessageListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MessageListLoaded) {
              final messages = [...state.messages]
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final msg = messages[index];
                  return MessageListTile(message: msg);
                },
              );
            } else if (state is MessageListError) {
              return Center(
                child: Text('${AppConstants.errorPrefix}${state.error}'),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
