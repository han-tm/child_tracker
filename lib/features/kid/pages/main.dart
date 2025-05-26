import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KidMainScreen extends StatefulWidget {
  final GoRouterState state;
  final StatefulNavigationShell navigationShell;
  const KidMainScreen({super.key, required this.navigationShell, required this.state});

  @override
  State<KidMainScreen> createState() => _KidMainScreenState();
}

class _KidMainScreenState extends State<KidMainScreen> {
  @override
  Widget build(BuildContext context) {
    
    bool show = showNavBar(widget.state.fullPath);
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: !show ? null : BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) => {widget.navigationShell.goBranch(index)},
        enableFeedback: true,
        backgroundColor: white,
        selectedItemColor: Colors.black,
        unselectedItemColor: secondary900,
        selectedLabelStyle: const TextStyle(fontSize: 12, color: greyscale900),
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

  bool showNavBar(String? path) {
    if (path == null) return true;
    if (path.startsWith('/kid/chat/room')) {
      return false;
    }
    return true;
  }
}
