import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetAgeView extends StatelessWidget {
  const SetAgeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FillDataCubit, FillDataState>(
      builder: (context, state) {
        final valid = state.age != null;
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 34, right: 24),
              child: MaskotMessage(
                message: 'Сколько тебе лет?',
                maskot: '2186-min',
                flip: true,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: AgeSelector(
                onSelect: context.read<FillDataCubit>().onChangeAge,
                selectedAge: state.age,
              ),
            ),
            Container(
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: FilledAppButton(
                      text: 'Далее',
                      isActive: valid,
                      onTap: () {
                        if (valid) {
                          context.read<FillDataCubit>().nextPage();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
