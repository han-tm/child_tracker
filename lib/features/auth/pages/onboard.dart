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
  late List<Widget> pages;

  int _currentPage = 0;

  @override
  void initState() {
    initOnboard();
    super.initState();
    redirectFunc(context);
  }

  void initOnboard() {
    pages = [
      const _OnboardingPage(
        title: 'Добро пожаловать!',
        description:
            'Это не просто приложение — это ваш помощник в воспитании, мотивации и общении с ребёнком.\nСоздавайте задания, следите за прогрессом и поощряйте успехи!',
        icon: 'mascot_1',
      ),
      const _OnboardingPage(
        title: 'Задачи и награды',
        description:
            'Ставьте цели: от домашних дел до школьных успехов.\nЗа выполнение заданий ребёнок получает баллы, которые можно обменять на приятные бонусы',
        icon: 'mascot_1',
      ),
      const _OnboardingPage(
        title: 'Волшебный помощник',
        description:
            'Наш $MASCOTNAME всегда рядом — подскажет, поддержит и поздравит.\nОн сделает обучение и мотивацию весёлой и понятной для ребёнка!',
        icon: 'mascot_1',
      ),
    ];
  }

  void onTap() async {
    if (_currentPage < pages.length - 1) {
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
      backgroundColor: white,
      body: Stack(
        children: [
          const _OnboardBg(),
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    PageView(
                      controller: _controller,
                      children: pages,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 36.0),
                        child: _buildPageIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
                child: FilledAppButton(text: 'Далее', onTap: onTap),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < pages.length; i++) {
      bool isActive = i == _currentPage;
      indicators.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isActive ? 32 : 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: isActive ? primary900 : greyscale200,
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
  final String icon;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: Center(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/$icon.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText(
                  text: title,
                  size: 30,
                  fw: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                AppText(
                  text: description,
                  fw: FontWeight.normal,
                  color: greyscale700,
                  textAlign: TextAlign.center,
                  maxLine: 10,
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardBg extends StatelessWidget {
  const _OnboardBg();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 6,
          child: ClipPath(
            clipper: CurveClipper(),
            child: Container(
              height: double.infinity,
              color: primary300,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            height: double.infinity,
            color: white,
          ),
        ),
      ],
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 50;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
