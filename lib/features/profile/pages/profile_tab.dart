// ignore_for_file: deprecated_member_use

import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, user) {
        if (user == null) return const Center(child: CircularProgressIndicator());
        return Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            toolbarHeight: 72,
            backgroundColor: white,
            leadingWidth: 62,
            automaticallyImplyLeading: false,
            leading: Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/images/logo_min.svg',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
            title: const AppText(text: 'Профиль', size: 24, fw: FontWeight.w700),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: IconButton(
                  onPressed: () {
                    // context.push('/kid/profile/edit');
                  },
                  icon: SvgPicture.asset(
                    'assets/images/${user.isKid ? 'qr' : 'scan_q'}.svg',
                    color: greyscale900,
                    width: 28,
                    height: 28,
                  ),
                ),
              ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (user.isKid) return KidProfileWidget(user: user);
              return MentorProfileWidget(user: user);
            },
          ),
        );
      },
    );
  }
}
