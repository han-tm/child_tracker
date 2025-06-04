import 'package:child_tracker/index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KidCreateTaskSetReminder extends StatelessWidget {
  const KidCreateTaskSetReminder({super.key});

  void onDatePick(BuildContext context) async {
    final selectedDate = await showDatePickerModalBottomSheet(context);
    if (selectedDate != null && context.mounted) {
      context.read<KidTaskCreateCubit>().onChangeReminderDate(selectedDate);
    }
  }

  void onTimePick(BuildContext context) async {
    final selectedTime = await showTimePickerModalBottomSheet(context);
    if (selectedTime != null && context.mounted) {
      context.read<KidTaskCreateCubit>().onChangeReminderTime(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KidTaskCreateCubit, KidTaskCreateState>(
      builder: (context, state) {
        
        final valid =
            state.reminderType == ReminderType.single && state.reminderDate != null && state.reminderDate!.hour != 0 ||
                state.reminderType == ReminderType.daily && state.reminderDays.isNotEmpty && state.reminderTime != null;
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 34, right: 24),
                child: MaskotMessage(
                  message: 'Добавить напоминание?',
                  maskot: '2182-min',
                  flip: true,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 42,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: greyscale100),
                child: TabBar(
                  onTap: (value) {
                    ReminderType type = value == 0 ? ReminderType.single : ReminderType.daily;
                    context.read<KidTaskCreateCubit>().onChangeReminderType(type);
                  },
                  dividerHeight: 0,
                  dividerColor: greyscale100,
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: greyscale900,
                    fontFamily: Involve,
                    height: 1.6,
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: white,
                    fontFamily: Involve,
                    height: 1.6,
                  ),
                  unselectedLabelColor: greyscale900,
                  labelColor: white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(borderRadius: BorderRadius.circular(6), color: primary900),
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  splashBorderRadius: BorderRadius.circular(6),
                  tabs: const [
                    Text('Однократно'),
                    Text('Повторять'),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          CustomDateInput(
                            date: state.reminderDate,
                            onTap: () => onDatePick(context),
                          ),
                          const SizedBox(height: 16),
                          CustomTimeInput(
                            onTap: () => onTimePick(context),
                            label: 'Время напоминания',
                            enable: state.reminderDate != null,
                            time: getTimeFromDate(state.reminderDate),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(text: 'Дни повторения'),
                          const SizedBox(height: 16),
                          LayoutBuilder(builder: (context, constraints) {
                            final double maxWidth = constraints.maxWidth;
                            final int numberOfCircles = russianWeekdaysNominative.length;
                            final double availableWidthForCircles = maxWidth - ((numberOfCircles - 1) * 7);
                            final double circleSize = availableWidthForCircles / numberOfCircles;

                            final double effectiveCircleSize = circleSize.isFinite && circleSize > 0 ? circleSize : 0.0;

                            return Row(
                              children: List.generate(numberOfCircles, (index) {
                                final isSelected = state.reminderDays.contains(index);
                                return GestureDetector(
                                  onTap: () {
                                    context.read<KidTaskCreateCubit>().onChangeReminderDayTap(index);
                                  },
                                  child: Container(
                                    width: effectiveCircleSize,
                                    height: effectiveCircleSize,
                                    margin: EdgeInsets.only(right: index == numberOfCircles - 1 ? 0.0 : 7),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: dark5, width: 1.5),
                                      color: isSelected ? primary900 : null,
                                    ),
                                    child: Center(
                                      child: AppText(
                                        text: russianWeekdaysNominative[index],
                                        color: isSelected ? white : greyscale700,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),
                          const SizedBox(height: 32),
                          CustomTimeInput(
                            onTap: () => onTimePick(context),
                            label: 'Время напоминания',
                            time: state.reminderTime,
                          ),
                        ],
                      ),
                    ),
                  ],
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
                                  context.read<KidTaskCreateCubit>().onChangeReminderDate(null);
                                  context.read<KidTaskCreateCubit>().onChangeReminderTime(null);
                                  context.read<KidTaskCreateCubit>().onChangeReminderDayTap(null);
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
          ),
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
