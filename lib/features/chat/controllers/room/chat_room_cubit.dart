import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';

class ChatCubit extends Cubit<ChatRoomState> {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final String chatId;
  final String senderId;

  ChatCubit({required this.chatId, required this.senderId})
      : assert(chatId.isNotEmpty),
        super(const ChatRoomState());

  Future<void> getCurrentChat() async {
    emit(state.copyWith(status: ChatRoomStatus.loading));
    try {
      final doc = await _fs.collection('chats').doc(chatId).get();
      final chat = ChatModel.fromFirestore(doc);
      emit(state.copyWith(chat: chat, status: ChatRoomStatus.success));
    } catch (e) {
      print('Error getting current chat: $e');
      emit(state.copyWith(status: ChatRoomStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    if (state.chat == null) {
      emit(state.copyWith(errorMessage: 'Чат не найден', status: ChatRoomStatus.messageSentError));
      return;
    }

    emit(state.copyWith(status: ChatRoomStatus.sendingMessage));

    try {
      final chatRef = state.chat!.ref;

      final newMessage = LastMessage(text: message, senderId: senderId, timestamp: DateTime.now());

      await chatRef.collection('messages').add(newMessage.toMap());

      final currentChatSnap = await chatRef.get();
      final currentChat = ChatModel.fromFirestore(currentChatSnap);

      final unreadUpdate = Map<String, int>.from(currentChat.unreads);
      for (var member in currentChat.members) {
        if (member != senderId) {
          unreadUpdate[member] = (unreadUpdate[member] ?? 0) + 1;
        }
      }

      await chatRef.update({
        'last_message': newMessage.toMap(),
        'last_edit_time': FieldValue.serverTimestamp(),
        'unreadCounts': unreadUpdate,
      });

      emit(state.copyWith(status: ChatRoomStatus.messageSent));
    } catch (e) {
      print('Error sending message: $e');
      emit(state.copyWith(status: ChatRoomStatus.messageSentError, errorMessage: e.toString()));
    }
  }

  Stream<List<MessageModel>> getMessageStream() {
    if (state.chat == null) {
      return const Stream.empty();
    }
    return state.chat!.ref.collection('messages').orderBy('timestamp', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return MessageModel.fromFirestore(doc);
        }).toList();
      },
    );
  }
}
