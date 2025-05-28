import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class KidMainScreen extends StatefulWidget {
  final GoRouterState state;
  final Widget child;
  const KidMainScreen({super.key, required this.child, required this.state});

  @override
  State<KidMainScreen> createState() => _KidMainScreenState();
}

class _KidMainScreenState extends State<KidMainScreen> {
  void onTapTab(int index) async {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/kid_bonus');
      case 1:
        GoRouter.of(context).go('/kid_task');
      case 2:
        GoRouter.of(context).go('/kid_games');
      case 3:
        GoRouter.of(context).go('/kid_chat');
      case 4:
        GoRouter.of(context).go('/kid_profile');
    }
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/kid_bonus')) {
      return 0;
    }
    if (location.startsWith('/kid_task')) {
      return 1;
    }
    if (location.startsWith('/kid_games')) {
      return 2;
    }
    if (location.startsWith('/kid_chat')) {
      return 3;
    }
    if (location.startsWith('/kid_profile')) {
      return 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      backgroundColor: greyscale100,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _calculateSelectedIndex(context),
        onTap: onTapTab,
        enableFeedback: true,
        backgroundColor: white,
        selectedItemColor: Colors.black,
        unselectedItemColor: secondary900,
        selectedLabelStyle: const TextStyle(fontSize: 12, color: greyscale900),
        unselectedLabelStyle: const TextStyle(fontSize: 12, color: Color(0xFF818181)),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset('assets/images/bonus_filled_tab.svg'),
            icon: SvgPicture.asset('assets/images/bonus_tab.svg'),
            label: 'Бонусы',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset('assets/images/tracker_filled_tab.svg'),
            icon: SvgPicture.asset('assets/images/tracker_tab.svg'),
            label: 'Задания',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset('assets/images/game_filled_tab.svg'),
            icon: SvgPicture.asset('assets/images/game_tab.svg'),
            label: 'Игры',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset('assets/images/chat_filled_tab.svg'),
            icon: SvgPicture.asset('assets/images/chat_tab.svg'),
            label: 'Чаты',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset('assets/images/profile_filled_tab.svg'),
            icon: SvgPicture.asset('assets/images/profile_tab.svg'),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
