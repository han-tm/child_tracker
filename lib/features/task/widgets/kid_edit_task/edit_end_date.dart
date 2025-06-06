import 'package:child_tracker/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class KidTaskEditEndDateScreen extends StatefulWidget {
  const KidTaskEditEndDateScreen({super.key});

  @override
  State<KidTaskEditEndDateScreen> createState() => _KidTaskEditEndDateScreenState();
}

class _KidTaskEditEndDateScreenState extends State<KidTaskEditEndDateScreen> {
  String? dateError;

  void onDatePick(BuildContext context) async {
    final selectedDate = await showDatePickerModalBottomSheet(context);
    if (selectedDate != null && context.mounted) {
      final startDate = context.read<KidTaskEditCubit>().state.startData;
      if (startDate != null && selectedDate.isBefore(startDate)) {
        setState(() {
          dateError = 'Дата окончания не может быть раньше даты начала';
        });
      } else {
        if (dateError != null) setState(() => dateError = null);
        context.read<KidTaskEditCubit>().onChangeEndDate(selectedDate);
      }
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
                          Expanded(
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
      ),
    );
  }

  TimeOfDay? getTimeFromDate(DateTime? date) {
    if (date == null) return null;
    if (date.hour == 0 && date.minute == 0) return null;
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }
}
