import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KidProfileWidget extends StatelessWidget {
  final UserModel user;
  const KidProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => context.push('/edit_profile'),
            child: SizedBox(
              height: 80,
              width: double.infinity,
              child: Row(
                children: [
                  CachedClickableImage(
                    circularRadius: 100,
                    width: 80,
                    height: 80,
                    imageUrl: user.photo,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                      child: AppText(
                    text: user.name,
                    size: 20,
                    fw: FontWeight.w700,
                    maxLine: 2,
                  )),
                  const SizedBox(width: 10),
                  const Icon(CupertinoIcons.chevron_right, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ProfileMenuCard(
            onTap: () => {},
            icon: 'diary',
            title: 'Мой дневник',
            color: const Color(0xFF246BFD).withOpacity(0.08),
          ),
          const Divider(height: 48, thickness: 1, color: greyscale200),
          ProfileMenuCard(
            onTap: () => {},
            icon: 'progress',
            title: 'Прогресс по заданиям',
            color: const Color(0xFF246BFD).withOpacity(0.08),
          ),
          const SizedBox(height: 24),
          ProfileMenuCard(
            onTap: () => {},
            icon: 'coin',
            title: 'Баллы по заданиям',
            color: orange.withOpacity(0.08),
          ),
          const Divider(height: 48, thickness: 1, color: greyscale200),
          ProfileMenuCard(
            onTap: () => {},
            icon: 'game_filled_tab',
            title: 'Игровой рейтинг',
            iconColor: green,
            color: green.withOpacity(0.08),
          ),
          const SizedBox(height: 24),
          ProfileMenuCard(
            onTap: () => {},
            icon: 'star',
            title: 'Игровой уровень',
            color: yellow.withOpacity(0.08),
          ),
          const Divider(height: 48, thickness: 1, color: greyscale200),
          ProfileMenuCard(
            onTap: () {
              final Map<String, dynamic> extra = {
                'user': user,
                'canAdd': true,
                'showChat': true,
                'showDelete': true,
              };
              context.push('/connections', extra: extra);
            },
            icon: '3user',
            title: 'Мои наставники',
            iconColor: blue,
            color: const Color(0xFF235DFF).withOpacity(0.08),
          ),
          const SizedBox(height: 24),
          ProfileMenuCard(
            onTap: () => context.push('/notification'),
            icon: 'bell_fill',
            title: 'Уведомления',
            iconColor: red,
            color: const Color(0xFFFF5A5F).withOpacity(0.08),
          ),
        ],
      ),
    );
  }
}
