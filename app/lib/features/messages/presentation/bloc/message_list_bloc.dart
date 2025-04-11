import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/fetch_messages_usecase.dart';
import '../bloc/message_list_event.dart';
import '../bloc/message_list_state.dart';

/// BLoC that manages the state of the message list screen.
class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
  final FetchMessagesUseCase fetchMessagesUseCase;

  /// Creates a [MessageListBloc] with a required [fetchMessagesUseCase].
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

    // Listen only once and store the subscription
    await for (final _ in fetchMessagesUseCase.repository.messages) {
      final messages = fetchMessagesUseCase.repository.cachedMessages;
      emit(MessageListLoaded(messages));
    }
  } catch (e) {
    emit(MessageListError(e.toString()));
  }
}
}
