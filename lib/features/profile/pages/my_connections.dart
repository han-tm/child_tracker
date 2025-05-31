import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyConnectionsScreen extends StatefulWidget {
  const MyConnectionsScreen({super.key});

  @override
  State<MyConnectionsScreen> createState() => _MyConnectionsScreenState();
}

class _MyConnectionsScreenState extends State<MyConnectionsScreen> {
  bool loading = false;
  void onDelete() {}

  void onChat(DocumentReference ref) async {
    setState(() {
      loading = true;
    });
    try {
      DocumentReference? chatRef = await context.read<NewChatCubit>().createOrReturnPrivateChat(ref);
      setState(() {
        loading = false;
      });
      if (chatRef != null) {
        if (mounted) context.push('/chat_room', extra: chatRef);
      }
    } catch (e) {
      SnackBarSerive.showErrorSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, me) {
        if (me == null) return const SizedBox();
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            leadingWidth: 70,
            leading: IconButton(
              icon: const Icon(CupertinoIcons.arrow_left),
              onPressed: () => context.pop(),
            ),
            title: AppText(text: me.isKid ? 'Мои наставники' : 'Мои дети', size: 24, fw: FontWeight.w700),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      itemCount: me.connections.length,
                      itemBuilder: (context, index) {
                        final userRef = me.connections[index];
                        return ConnectionCard(
                          onDelete: onDelete,
                          onChat: () => onChat(userRef),
                          onAdd: () {},
                          userRef: userRef,
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          FilledSecondaryAppButton(
                            text: 'Добавить наставника',
                            onTap: () => context.push('/add_connection'),
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(CupertinoIcons.add, color: primary900, size: 20),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (loading)
                Container(
                  constraints: const BoxConstraints.expand(),
                  color: black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: white),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppText(text: 'Загрузка...', size: 18, fw: FontWeight.w700),
                            SizedBox(height: 16),
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
