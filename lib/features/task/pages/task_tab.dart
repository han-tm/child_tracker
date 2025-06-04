import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TaskTabScreen extends StatelessWidget {
  const TaskTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, me) {
        if (me == null) {
          return Container(
            constraints: const BoxConstraints(),
            color: white,
          );
        }
        return Scaffold(
          backgroundColor: greyscale100,
          appBar: AppBar(
            backgroundColor: white,
            automaticallyImplyLeading: false,
            toolbarHeight: 72,
            leadingWidth: 0,
            title: me.isKid ? KidAppBarWidget(user: me) : MentorAppbarWidget(user: me),
          ),
          floatingActionButton: SizedBox(
            width: 56,
            height: 56,
            child: FloatingActionButton(
              onPressed: () {
                context.push('/kid_create_task');
              },
              elevation: 4,
              backgroundColor: primary900,
              shape: const CircleBorder(),
              child: const Icon(CupertinoIcons.add, color: white, size: 28),
            ),
          ),
          body: Column(
            children:  [
              const CustomCalendar(),
              Expanded(
                child: me.isKid ? const KidTasksWidget() : const MentorTasksWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}
