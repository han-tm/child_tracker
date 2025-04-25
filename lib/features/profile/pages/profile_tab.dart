import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const RobotoText(text: 'Profile'),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/kid/profile/edit');
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserModel?>(
        builder: (context, user) {
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user.isKid) return KidProfileWidget(user: user);
          return MentorProfileWidget(user: user);
        },
      ),
    );
  }
}
