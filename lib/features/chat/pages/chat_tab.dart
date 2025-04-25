import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatTabScreen extends StatelessWidget {
  const ChatTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const RobotoText(text: 'Chat'),
        actions: [
          IconButton(
            onPressed: () {
              sl<NewChatCubit>()
                  .createOrReturnPrivateChat('R6rWquLQSLgpkHIB203iYEgalHE3', 'R6rWquLQSLgpkHIB203iYEgalHE3');
            },
            icon: const Icon(Icons.add, color: primaryText),
          )
        ],
      ),
      body: BlocBuilder<UserCubit, UserModel?>(
        builder: (context, user) {
          if (user == null) return const Center(child: CircularProgressIndicator());
          return StreamBuilder<List<ChatModel>>(
            stream: getChats(user.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) return Center(child: RobotoText(text: snapshot.error.toString(), color: appRed));
              final chats = snapshot.data!;
              if (chats.isEmpty) return const EmptyChatsWidget();
              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ChatCard(chat: chat, unreads: chat.getUnreadCount(user.id));
                },
              );
            },
          );
        },
      ),
    );
  }
}

Stream<List<ChatModel>> getChats(String userId) {
  final Query query = FirebaseFirestore.instance
      .collection('chats')
      .where('members', arrayContains: userId)
      .orderBy('last_edit_time', descending: true);

  return query.snapshots().map((query) => query.docs.map((doc) => ChatModel.fromFirestore(doc)).toList());
}
