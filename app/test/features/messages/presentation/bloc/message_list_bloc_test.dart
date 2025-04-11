import 'package:app/features/messages/data/services/message_repository.dart';
import 'package:app/features/messages/domain/entities/message.dart';
import 'package:app/features/messages/domain/usecases/fetch_messages_usecase.dart';
import 'package:app/features/messages/presentation/bloc/message_list_bloc.dart';
import 'package:app/features/messages/presentation/bloc/message_list_event.dart';
import 'package:app/features/messages/presentation/bloc/message_list_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockMessageRepository extends Mock implements MessageRepository {}

void main() {
  late MockMessageRepository mockRepository;
  late FetchMessagesUseCase useCase;

  setUp(() {
    mockRepository = MockMessageRepository();
    useCase = FetchMessagesUseCase(mockRepository);
  });

  final mockMessage = Message(
    id: '1',
    icon: '👋',
    nickname: 'Tester',
    message: 'Hello!',
    createdAt: DateTime.now(),
  );

  blocTest<MessageListBloc, MessageListState>(
    'emits [Loading, Loaded] when message is streamed',
    build: () {
      when(() => mockRepository.messages).thenAnswer(
        (_) => Stream.fromIterable([mockMessage]),
      );
      when(() => mockRepository.cachedMessages).thenReturn([mockMessage]);

      return MessageListBloc(useCase);
    },
    act: (bloc) => bloc.add(const FetchMessages('feed', 5)),
    expect: () => [
      const MessageListLoading(),
      isA<MessageListLoaded>().having((s) => s.messages.length, 'message count', 1),
    ],
  );
}
