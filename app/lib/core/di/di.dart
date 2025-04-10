import 'package:get_it/get_it.dart';

import '../../features/messages/data/services/message_repository.dart';
import '../../features/messages/domain/repositories/websocket_message_repository.dart';
import '../../features/messages/domain/usecases/fetch_messages_usecase.dart';
import '../../features/messages/presentation/bloc/message_list_bloc.dart';

final locator = GetIt.instance;

/// Initializes all dependencies used throughout the app.
void initDependencies() {
  // Register repositories
  locator.registerLazySingleton<MessageRepository>(
      () => WebSocketMessageRepository());

  // Register use cases
  locator.registerLazySingleton(() => FetchMessagesUseCase(locator()));

  // Register BLoCs
  locator.registerFactory(() => MessageListBloc(locator()));
}
