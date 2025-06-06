import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class KidTaskEditStartDateScreen extends StatelessWidget {
  const KidTaskEditStartDateScreen({super.key});

  void onDatePick(BuildContext context) async {
    final selectedDate = await showDatePickerModalBottomSheet(context);
    if (selectedDate != null && context.mounted) {
      context.read<KidTaskEditCubit>().onChangeStartDate(selectedDate);
    }
  }

  void onTimePick(BuildContext context) async {
    final selectedTime = await showTimePickerModalBottomSheet(context);
    if (selectedTime != null && context.mounted) {
      context.read<KidTaskEditCubit>().onChangeStartTime(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leadingWidth: 70,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: BlocBuilder<KidTaskEditCubit, KidTaskEditState>(
        builder: (context, state) {
          final valid = state.startData != null;
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 34, right: 24),
                child: MaskotMessage(
                  message: 'Когда нужно начать задание?',
                  maskot: '2177-min',
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
                        label: 'Дата начала',
                        date: state.startData,
                        onTap: () => onDatePick(context),
                      ),
                      const SizedBox(height: 16),
                      CustomTimeInput(
                        onTap: () => onTimePick(context),
                        label: 'Время начала (опц.)',
                        time: getTimeFromDate(state.startData),
                      ),
                    ],
                  ),
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
                        text: 'Применить',
                        isActive: valid,
                        onTap: () {
                          if (valid) {
                            context.pop();
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
      ),
    );
  }

  TimeOfDay? getTimeFromDate(DateTime? date) {
    if (date == null) return null;
    if (date.hour == 0 && date.minute == 0) return null;
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }
}
