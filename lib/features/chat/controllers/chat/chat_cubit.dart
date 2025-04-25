import 'package:child_tracker/index.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentChatCubit extends Cubit<ChatModel?> {
  CurrentChatCubit() : super(null);

  void setChat(ChatModel newChat) => emit(newChat);
  void clearChat() => emit(null);
}

