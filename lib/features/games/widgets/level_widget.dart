import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LevelWidget extends StatelessWidget {
  final LevelModel level;
  final int index;
  final UserModel me;
  final bool available;
  const LevelWidget({super.key, required this.level, required this.index, required this.me, required this.available});

  @override
  Widget build(BuildContext context) {
    // print('level: ${level.name} $available');

    return StreamBuilder<List<UserGameModel>>(
        stream: getUserGamesStream(me),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                _LevelCard(
                  index: index,
                  level: level,
                  me: me,
                  available: available,
                ),
              ],
            );
          }
          final reversedGames = level.games.reversed.toList();
          final userGames = snapshot.data ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < reversedGames.length; i++) ...[
                Builder(
                  builder: (context) {
                    final gameRef = reversedGames[i];
                    final userGame = userGames.firstWhereOrNull((g) => g.gameRef == gameRef);
                    bool isFirst = reversedGames.last.id == gameRef.id;
                    bool completed = userGame?.isCompleted ?? false;
                    bool isPrevCompleted = userGames.any((g) => g.gameRef == reversedGames[i + 1]);

                    bool canPlay = (available && isFirst) || isPrevCompleted;

                    return _GameCircle(
                      level: level,
                      gameRef: gameRef,
                      canPlay: canPlay,
                      isCompleted: completed,
                    );
                  },
                )
              ],
              _LevelCard(
                index: index,
                level: level,
                me: me,
                available: available,
              ),
            ],
          );
        });
  }

  Stream<List<UserGameModel>> getUserGamesStream(UserModel me) {
    return me.userGamesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserGameModel.fromFirestore(doc)).toList();
    });
  }
}

class _LevelCard extends StatelessWidget {
  final LevelModel level;
  final int index;
  final UserModel me;
  final bool available;
  const _LevelCard({required this.level, required this.index, required this.me, required this.available});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: primary900,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: getTextByLocale(context, level.name, level.nameEng),
                  size: 20,
                  fw: FontWeight.w700,
                  maxLine: 2,
                  color: white,
                ),
                AppText(
                  text: '${"level".tr()} ${index + 1}',
                  size: 14,
                  fw: FontWeight.w500,
                  color: white,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: LinearProgressIndicator(
                        value: 0.5,
                        borderRadius: BorderRadius.circular(100),
                        backgroundColor: greyscale200,
                        color: orange,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const AppText(
                      text: '249 баллов',
                      size: 14,
                      fw: FontWeight.w400,
                      color: white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (!available)
            CircleAvatar(
              radius: 40,
              backgroundColor: white,
              child: Center(
                child: SvgPicture.asset('assets/images/lock_fill.svg'),
              ),
            )
        ],
      ),
    );
  }
}

class _GameCircle extends StatelessWidget {
  final DocumentReference gameRef;
  final LevelModel level;
  final bool isCompleted;
  final bool canPlay;
  const _GameCircle({required this.gameRef, required this.isCompleted, required this.canPlay, required this.level});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (canPlay && !isCompleted) {
          final data = {'gameRef': gameRef, 'level': level};
          context.push('/game_play', extra: data);
        }
      },
      child: Container(
        width: 120,
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted
              ? orange.withOpacity(0.2)
              : canPlay
                  ? primary900.withOpacity(0.2)
                  : greyscale500.withOpacity(0.2),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? orange
                : canPlay
                    ? primary900
                    : greyscale500,
          ),
          child: Center(
            child: AppText(text: gameRef.id),
          ),
        ),
      ),
    );
  }
}
