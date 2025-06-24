import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameRaitingScreen extends StatelessWidget {
  const GameRaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: greyscale100,
        appBar: AppBar(
          toolbarHeight: 72,
          backgroundColor: white,
          leadingWidth: 70,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.arrow_left),
            onPressed: () => context.pop(),
          ),
          title: AppText(text: 'gameRating'.tr(), size: 24, fw: FontWeight.w700),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(66),
            child: Container(
              height: 42,
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: greyscale100,
              ),
              child: TabBar(
                onTap: (value) {
                  // ReminderType type = value == 0 ? ReminderType.single : ReminderType.daily;
                  // context.read<KidTaskCreateCubit>().onChangeReminderType(type);
                },
                dividerHeight: 0,
                dividerColor: greyscale100,
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: greyscale900,
                  fontFamily: Involve,
                  height: 1.6,
                ),
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: white,
                  fontFamily: Involve,
                  height: 1.6,
                ),
                unselectedLabelColor: greyscale900,
                labelColor: white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(borderRadius: BorderRadius.circular(6), color: primary900),
                indicatorPadding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                splashBorderRadius: BorderRadius.circular(6),
                tabs: [
                  Text('byCity'.tr()),
                  Text('byWorld'.tr()),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(children: [
          GameRaitingByCity(
            kids: [],
          ),
          GameRaitingByWorld(
            kids: [],
          ),
        ]),
      ),
    );
  }
}
