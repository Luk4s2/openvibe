import 'package:equatable/equatable.dart';

/// Events for [MessageListBloc] to trigger message fetching.
abstract class MessageListEvent extends Equatable {
  const MessageListEvent();

  @override
  List<Object?> get props => [];
}

/// Request to fetch a list of messages by feed and amount.
class FetchMessages extends MessageListEvent {
  final String feedId;
  final int amount;

  const FetchMessages(this.feedId, this.amount);

  @override
  List<Object?> get props => [feedId, amount];
}
