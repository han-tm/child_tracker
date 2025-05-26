import 'package:child_tracker/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatId;
  const ChatRoomScreen({super.key, required this.chatId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController controller = TextEditingController();
  late String senderId;

  @override
  void initState() {
    senderId = sl<UserCubit>().state?.id ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(chatId: widget.chatId, senderId: senderId)..getCurrentChat(),
      child: BlocConsumer<ChatCubit, ChatRoomState>(
        listener: (context, state) {
          if (state.status == ChatRoomStatus.messageSentError || state.status == ChatRoomStatus.error) {
            SnackBarSerive.showErrorSnackBar(state.errorMessage ?? defaultErrorText);
          } else if (state.status == ChatRoomStatus.messageSent) {
            setState(() {
              controller.clear();
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const AppText(text: 'Room'),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<MessageModel>>(
                    stream: context.read<ChatCubit>().getMessageStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                          child: AppText(text: defaultErrorText, color: secondary900),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: AppText(
                            text: 'Напишите первое сообщение',
                            color: secondary900,
                          ),
                        );
                      }

                      final messages = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return MessageBubble(message: message);
                        },
                      );
                    },
                  ),
                ),
                RoomInputWidget(
                  controller: controller,
                  onSend: context.read<ChatCubit>().sendMessage,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
