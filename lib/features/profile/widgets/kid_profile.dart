import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class KidProfileWidget extends StatelessWidget {
  final UserModel user;
  const KidProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        
      ],
    );
  }
}
