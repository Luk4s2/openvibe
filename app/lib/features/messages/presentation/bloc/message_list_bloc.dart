import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/fetch_messages_usecase.dart';
import '../bloc/message_list_event.dart';
import '../bloc/message_list_state.dart';

/// BLoC that manages the state of the message list screen.
class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
  final FetchMessagesUseCase fetchMessagesUseCase;

  MessageListBloc(this.fetchMessagesUseCase) : super(const MessageListInitial()) {
    on<FetchMessages>(_onFetchMessages);
  }

  Future<void> _onFetchMessages(
    FetchMessages event,
    Emitter<MessageListState> emit,
  ) async {
    emit(const MessageListLoading());

    try {
      fetchMessagesUseCase(event.feedId, event.amount);

      await emit.forEach(
        fetchMessagesUseCase.repository.messages,
        onData: (messages) {
          final sortedMessages = [...messages]
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return MessageListLoaded(sortedMessages);
        },
        onError: (error, stackTrace) => MessageListError(error.toString()),
      );
    } on FormatException catch (e) {
      emit(MessageListError('Invalid data format: ${e.message}'));
    } on Exception catch (e) {
      emit(MessageListError('An error occurred: ${e.toString()}'));
    }
  }
}
