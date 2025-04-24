import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  final _controller = PageController();
  final List<Widget> _pages = [
    _OnboardingPage(
      title: 'Добро пожаловать!',
      description: 'Узнайте о нашем замечательном приложении и его возможностях.',
      color: Colors.blue.shade100,
    ),
    _OnboardingPage(
      title: 'Исследуйте функции',
      description: 'Откройте для себя множество полезных инструментов.',
      color: Colors.green.shade100,
    ),
    _OnboardingPage(
      title: 'Начните прямо сейчас!',
      description: 'Всего несколько шагов, и вы готовы к работе.',
      color: Colors.orange.shade100,
    ),
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    redirectFunc(context);
  }

  void onTap() async {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final StorageService service = sl<StorageService>();
      await service.setOnboardStatus(true);
      if (mounted) context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPageIndicator(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onTap,
                    child: Text(_currentPage < _pages.length - 1 ? 'Далее' : 'Начать'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pages.length; i++) {
      indicators.add(
        Container(
          width: 10.0,
          height: 10.0,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
