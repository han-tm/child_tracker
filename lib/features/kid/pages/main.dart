import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KidMainScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const KidMainScreen({super.key, required this.navigationShell});

  @override
  State<KidMainScreen> createState() => _KidMainScreenState();
}

class _KidMainScreenState extends State<KidMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) => {widget.navigationShell.goBranch(index)},
        enableFeedback: true,
        backgroundColor: primaryBackground,
        selectedItemColor: Colors.black,
        unselectedItemColor: secondaryText,
        selectedLabelStyle: const TextStyle(fontSize: 12, color: primaryText),
        unselectedLabelStyle: const TextStyle(fontSize: 12, color: Color(0xFF818181)),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.lens),
            label: 'Бонусы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Чаты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_day),
            label: 'Расписание',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
