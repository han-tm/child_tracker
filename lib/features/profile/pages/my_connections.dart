import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyConnectionsScreen extends StatelessWidget {
  const MyConnectionsScreen({super.key});

  void onDelete() {}
  void onChat() {}

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, user) {
        if (user == null) return const SizedBox();
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            leadingWidth: 70,
            leading: IconButton(
              icon: const Icon(CupertinoIcons.arrow_left),
              onPressed: () => context.pop(),
            ),
            title: AppText(text: user.isKid ? 'Мои наставники' : 'Мои дети', size: 24, fw: FontWeight.w700),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ConnectionCard(
                      onDelete: onDelete,
                      onChat: onChat,
                      onAdd:  (){},
                      user: user,
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
        );
      },
    );
  }
}
