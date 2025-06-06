import 'package:child_tracker/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class TaskDetailScreen extends StatefulWidget {
  final DocumentReference taskRef;
  final TaskModel? task;
  const TaskDetailScreen({super.key, required this.taskRef, this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TaskModel task;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.task != null) {
      task = widget.task!;
    } else {
      setState(() => loading = true);
      final doc = await widget.taskRef.get();
      task = TaskModel.fromFirestore(doc);
      setState(() => loading = false);
    }
  }

  void onCancel() async {
    final confrim = await showConfirmModalBottomSheet(
      context,
      title: 'Отменить',
      isDestructive: true,
      cancelText: 'Нет, не отменять',
      confirmText: 'Да, отменить',
      message: 'Хм… передумал? Бывает!',
    );
    if (confrim == true && mounted) {
      context.push('/task_cancel_reason', extra: task);
    }
  }

  void onEdit() async {
    final bool? refresh = await context.push('/edit_create_task', extra: task);
    if (refresh == true) {
      setState(() => loading = true);
      final doc = await widget.taskRef.get();
      task = TaskModel.fromFirestore(doc);
      setState(() => loading = false);
    }
  }

  void onDelete() async {
    final confrim = await showConfirmModalBottomSheet(
      context,
      title: 'Удалить',
      isDestructive: true,
      cancelText: 'Отмена',
      confirmText: 'Да, удалить',
      message: 'Ой... точно удаляем?',
    );
    if (confrim == true && mounted) {
      final result = await context.read<TaskCubit>().deleteTask(task);
      if (result && mounted) {
        context.replace('/task_delete_success');
      } else {
        SnackBarSerive.showErrorSnackBar('Не удалось удалить задачу');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        constraints: const BoxConstraints.expand(),
        color: white,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, me) {
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
            actions: ((me?.id != task.owner?.id) ||
                    task.status == TaskStatus.canceled ||
                    task.status == TaskStatus.deleted ||
                    task.status == TaskStatus.completed)
                ? null
                : [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/cancel.svg',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                        onPressed: onCancel,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/edit.svg',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                        onPressed: onEdit,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/delete.svg',
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        ),
                        onPressed: onDelete,
                      ),
                    ),
                  ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            child: BonusContainer(
                              color: taskCardBorderColor(task.status),
                              title: taskDetailCardStatusText(task.status),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Builder(builder: (context) {
                                        if (task.photo == null) {
                                          return const CachedClickableImage(
                                            height: 100,
                                            width: 100,
                                            circularRadius: 300,
                                          );
                                        } else {
                                          bool isEmoji = task.photo!.startsWith('emoji:');
                                          return CachedClickableImage(
                                            height: 100,
                                            width: 100,
                                            circularRadius: 300,
                                            emojiFontSize: 35,
                                            emoji: isEmoji ? task.photo!.replaceAll('emoji:', '') : null,
                                            imageUrl: isEmoji ? null : task.photo,
                                          );
                                        }
                                      }),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppText(
                                        text: task.name,
                                        size: 24,
                                        fw: FontWeight.bold,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  if (task.description != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: AppText(
                                        text: task.description!.trim(),
                                        fw: FontWeight.normal,
                                        color: greyscale700,
                                        maxLine: 10,
                                      ),
                                    ),
                                  const Divider(height: 40, thickness: 1, color: greyscale200),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppText(
                                          text: 'Ребёнок ${task.owner?.id == me?.id ? '(создал)' : ''}',
                                          size: 16,
                                          fw: FontWeight.w500,
                                          color: greyscale800,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      if (task.kid != null)
                                        Expanded(
                                          child: FutureBuilder<UserModel>(
                                            future: context.read<UserCubit>().getUserByRef(task.kid!),
                                            builder: (context, snapshot) {
                                              return AppText(
                                                text: snapshot.data?.name ?? '...',
                                                size: 16,
                                                textAlign: TextAlign.end,
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (task.type != TaskType.kid)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: AppText(
                                              text: 'Наставник ${task.owner?.id == me?.id ? '(создал)' : ''}',
                                              size: 16,
                                              fw: FontWeight.w500,
                                              color: greyscale800,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          if (task.owner != null)
                                            Expanded(
                                              flex: 2,
                                              child: FutureBuilder<UserModel>(
                                                future: context.read<UserCubit>().getUserByRef(task.owner!),
                                                builder: (context, snapshot) {
                                                  return AppText(
                                                    text: snapshot.data?.name ?? '...',
                                                    size: 16,
                                                    textAlign: TextAlign.end,
                                                  );
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  if ((task.coin ?? 0) > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: [
                                          const Expanded(
                                            flex: 2,
                                            child: AppText(
                                              text: 'Баллы (опц.)',
                                              size: 16,
                                              fw: FontWeight.w500,
                                              color: greyscale800,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/coin.svg',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                                const SizedBox(width: 6),
                                                AppText(
                                                  text: task.coin.toString(),
                                                  size: 16,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: AppText(
                                          text: 'Начало',
                                          size: 16,
                                          fw: FontWeight.w500,
                                          color: greyscale800,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      AppText(
                                        text: taskDate(task.startDate),
                                        size: 16,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: AppText(
                                          text: 'Окончание (опц.)',
                                          size: 16,
                                          fw: FontWeight.w500,
                                          color: greyscale800,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      AppText(
                                        text: taskDate(task.endDate),
                                        size: 16,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: AppText(
                                          text: 'Напоминание (опц.)',
                                          size: 16,
                                          fw: FontWeight.w500,
                                          color: greyscale800,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      AppText(
                                        text: task.reminderType == ReminderType.single
                                            ? taskDate(task.reminderDate)
                                            : formatTimeOfDay(context, task.reminderTime),
                                        size: 16,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                  if (task.type == TaskType.priority)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                const AppText(
                                                  text: 'Приоритет',
                                                  size: 16,
                                                  fw: FontWeight.w500,
                                                  color: greyscale800,
                                                ),
                                                const SizedBox(width: 10),
                                                SvgPicture.asset(
                                                  'assets/images/info_square.svg',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/red_flag.svg',
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                const SizedBox(width: 10),
                                                const AppText(
                                                  text: 'Задание дня',
                                                  size: 16,
                                                  textAlign: TextAlign.end,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(height: 24),
                          if (task.status == TaskStatus.inProgress || task.status == TaskStatus.needsRework)
                            Container(
                              decoration: const BoxDecoration(border: Border(top: BorderSide(color: greyscale100))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: FilledAppButton(
                                      text: 'Задание выполнено',
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
