import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

Future<String?> showMentorSelectorModalBottomSheet(BuildContext context) async {
  return showModalBottomSheet<String?>(
    context: context,
    backgroundColor: white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) => const _SelectMentorContent(),
  );
}

class _SelectMentorContent extends StatefulWidget {
  const _SelectMentorContent();

  @override
  State<_SelectMentorContent> createState() => __SelectMentorContentState();
}

class __SelectMentorContentState extends State<_SelectMentorContent> {
  String? selectedUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: greyscale200,
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          const AppText(text: 'Выбрать наставника', size: 24, fw: FontWeight.w700),
          const Divider(height: 40, thickness: 1, color: greyscale200),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Transform.flip(
                  flipX: true,
                  child: Image.asset(
                    'assets/images/2177-min.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Expanded(
                flex: 3,
                child: LeftArrowBubleShape(
                  child: AppText(
                    text: 'От кого посмотрим бонусы?',
                    size: 20,
                    maxLine: 10,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
               const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  ...['Все наставники', 'Аня', 'Мама', 'Папа', 'Дедушка', 'Бабушка'].map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: UserSelector(
                        onTap: () {
                          setState(() {
                            selectedUser = e;
                          });
                        },
                        isSelected: selectedUser == e,
                        name: e,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: greyscale200),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledSecondaryAppButton(
                  text: 'Отмена',
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledAppButton(
                  text: 'Выбрать',
                  onTap: () => Navigator.pop(context, 'true'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
