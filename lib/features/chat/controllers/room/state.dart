part of 'chat_room_cubit.dart';

enum ChatRoomStatus { initial, loading, success, error, sendingMessage, messageSent, messageSentError }

class ChatRoomState extends Equatable {
  const ChatRoomState({
    this.chat,
    this.status = ChatRoomStatus.initial,
    this.errorMessage,
  });

  final ChatModel? chat;
  final String? errorMessage;
  final ChatRoomStatus status;

  ChatRoomState copyWith({
    ChatModel? chat,
    ChatRoomStatus? status,
    String? errorMessage,
  }) {
    return ChatRoomState(
      chat: chat ?? this.chat,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        chat,
        errorMessage,
        status,
      ];
}
