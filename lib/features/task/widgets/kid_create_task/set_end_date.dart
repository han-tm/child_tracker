import 'package:child_tracker/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KidCreateTaskSetEndDate extends StatefulWidget {
  const KidCreateTaskSetEndDate({super.key});

  @override
  State<KidCreateTaskSetEndDate> createState() => _KidCreateTaskSetEndDateState();
}

class _KidCreateTaskSetEndDateState extends State<KidCreateTaskSetEndDate> {
  String? dateError;

  void onDatePick(BuildContext context) async {
    final selectedDate = await showDatePickerModalBottomSheet(context);
    if (selectedDate != null && context.mounted) {
      final startDate = context.read<KidTaskCreateCubit>().state.startData;
      if (startDate != null && selectedDate.isBefore(startDate)) {
        setState(() {
          dateError = 'Дата окончания не может быть раньше даты начала';
        });
      } else {
        if (dateError != null) setState(() => dateError = null);
        context.read<KidTaskCreateCubit>().onChangeEndDate(selectedDate);
      }
    }
  }

  void onTimePick(BuildContext context) async {
    final selectedTime = await showTimePickerModalBottomSheet(context);
    if (selectedTime != null && context.mounted) {
      context.read<KidTaskCreateCubit>().onChangeEndTime(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KidTaskCreateCubit, KidTaskCreateState>(
      builder: (context, state) {
        final valid = state.endData != null;
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 34, right: 24),
              child: MaskotMessage(
                message: 'Есть крайний срок? Можешь добавить его!',
                maskot: '2186-min',
                flip: true,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    CustomDateInput(
                      label: 'Дата окончания (опц.)',
                      date: state.endData,
                      errorText: dateError,
                      onTap: () => onDatePick(context),
                    ),
                    const SizedBox(height: 16),
                    CustomTimeInput(
                      onTap: () => onTimePick(context),
                      label: 'Время окончания (опц.)',
                      enable: state.endData != null,
                      time: getTimeFromDate(state.endData),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        if (!state.isEditMode)
                          Expanded(
                            child: FilledSecondaryAppButton(
                              text: 'Пропустить',
                              onTap: () {
                                context.read<KidTaskCreateCubit>().onChangeEndDate(null);
                                context.read<KidTaskCreateCubit>().nextPage();
                              },
                            ),
                          ),
                        if (!state.isEditMode) const SizedBox(width: 24),
                        Expanded(
                          child: FilledAppButton(
                            text: state.isEditMode ? 'Применить' : 'Добавить',
                            isActive: valid,
                            onTap: () {
                              if (valid) {
                                if (state.isEditMode) {
                                  context.read<KidTaskCreateCubit>().onChangeMode(false);
                                  context.read<KidTaskCreateCubit>().onJumpToPage(5);
                                } else {
                                  context.read<KidTaskCreateCubit>().nextPage();
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  TimeOfDay? getTimeFromDate(DateTime? date) {
    if (date == null) return null;
    if (date.hour == 0 && date.minute == 0) return null;
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }
}
