import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KidAppBarWidget extends StatelessWidget {
  final UserModel user;
  const KidAppBarWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      width: double.infinity,
      child: Row(
        children: [
          CachedClickableImage(
            width: 48,
            height: 48,
            circularRadius: 100,
            noImageWidget: Image.asset('assets/images/mentors.png'),
          ),
          const Expanded(
            child: AppText(
              text: 'Задания',
              size: 24,
              fw: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              SvgPicture.asset('assets/images/coin.svg'),
              const Padding(
                padding: EdgeInsets.only(left: 5),
                child: AppText(
                  text: '200',
                  size: 20,
                  fw: FontWeight.bold,
                  color: dark5,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
