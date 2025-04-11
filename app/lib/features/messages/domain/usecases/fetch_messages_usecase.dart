import '../../data/services/message_repository.dart';

/// A use case responsible for triggering message fetch requests.
class FetchMessagesUseCase {
  final MessageRepository repository;

  /// Creates a use case that uses the given [repository].
  FetchMessagesUseCase(this.repository);

  /// Triggers the repository to fetch messages from the server.
  void call(String feedId, int amount) {
    repository.requestMessages(feedId, amount);
  }
}
