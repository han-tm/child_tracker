import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';

class NewChatCubit extends Cubit<NewChatState> {
  final FirebaseFirestore _fs;
  NewChatCubit({required FirebaseFirestore fs})
      : _fs = fs,
        super(NewChatInitial());

  Future<void> createOrReturnPrivateChat(String kidId, String mentorId) async {
    emit(NewChatLoading());

    try {
      final QuerySnapshot query = await _fs
          .collection('chats')
          .where('kid', isEqualTo: kidId)
          .where('mentor', isEqualTo: mentorId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final chatId = query.docs.first.id;
        emit(NewChatReturn(chatId));
      } else {
        //создаем новый приватный чат
        final newChatRef = _fs.collection('chats').doc();

        final newMessage = LastMessage(text: 'Напишите первое сообщение', senderId: kidId, timestamp: DateTime.now());

        final Map<String, dynamic> newChatData = {
          'members': [kidId, mentorId],
          'kid': kidId,
          'mentor': mentorId,
          'type': ChatType.private.name,
          'last_message': newMessage.toMap(),
          'last_edit_time': FieldValue.serverTimestamp(),
          'unreads': {kidId: 0, mentorId: 0},
        };

        await newChatRef.set(newChatData);

        emit(NewChatReturn(newChatRef.id));
        emit(NewChatInitial());
      }
    } catch (e) {
      print('Error creating or returning chat: $e');
      emit(NewChatError(e.toString()));
    }
  }

  Future<void> createOrReturnGroupChat(String kidId, String mentorId) async {}
}
