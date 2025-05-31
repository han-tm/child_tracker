import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ConnectionCard extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onChat;
  final VoidCallback onAdd;
  final DocumentReference userRef;
  final bool isAdd;
  const ConnectionCard({
    super.key,
    required this.onDelete,
    required this.onChat,
    required this.onAdd,
    required this.userRef,
    this.isAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: greyscale200)),
      ),
      child: FutureBuilder<UserModel>(
        future: context.read<UserCubit>().getUserByRef(userRef),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return Row(
            children: [
              CachedClickableImage(
                height: 60,
                width: 60,
                circularRadius: 100,
                imageUrl: user?.photo,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(text: user?.name ?? '...', size: 16, fw: FontWeight.w700),
                    AppText(
                      text: user == null ? '...' : user.isKid ? '${user.age} лет, ${user.city}' : 'Наставник',
                      size: 14,
                      color: greyscale700,
                      fw: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  if (isAdd) {
                    return SizedBox(
                      width: 103,
                      child: FilledAppButton(
                        onTap: onAdd,
                        height: 34,
                        fontSize: 14,
                        fw: FontWeight.w600,
                        text: 'Добавить',
                      ),
                    );
                  } else {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: GestureDetector(
                            onTap: onChat,
                            child: SvgPicture.asset(
                              'assets/images/bubble.svg',
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: GestureDetector(
                            onTap: onDelete,
                            child: SvgPicture.asset(
                              'assets/images/delete.svg',
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          );
        }
      ),
    );
  }
}
