
part of 'new_chat_cubit.dart';

abstract class NewChatState extends Equatable {
  const NewChatState();
}

class NewChatInitial extends NewChatState {
  @override
  List<Object> get props => [];
}


class NewChatLoading extends NewChatState {
  @override
  List<Object> get props => [];
}

class NewChatReturn extends NewChatState {
  final String chatId;
  
  const NewChatReturn(this.chatId);
  
  @override
  List<Object> get props => [chatId];
}

class NewChatError extends NewChatState {
  final String message;
  
  const NewChatError(this.message);
  
  @override
  List<Object> get props => [message];
}