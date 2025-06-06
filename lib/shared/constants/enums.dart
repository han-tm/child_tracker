import 'package:child_tracker/index.dart';
import 'package:flutter/material.dart';

enum UserType { kid, mentor }

enum ChatType { private, group }

enum BonusStatus { needApprove, active, canceled, readyToReceive, received }

enum KidTaskChip { all, progress, completed, canceled }

String kidTaskChipRusName(KidTaskChip chip) {
  switch (chip) {
    case KidTaskChip.all:
      return 'Все';
    case KidTaskChip.progress:
      return 'В процессе';
    case KidTaskChip.completed:
      return 'Выполнены';
    case KidTaskChip.canceled:
      return 'Отменены';
    default:
      return '-';
  }
}

enum TaskType { kid, mentor, priority }

enum TaskStatus {
  /// Задание создано и доступно для выполнения.
  inProgress,

  /// Задание отправлено на проверку.
  onReview,

  /// Задание требует доработки после проверки.
  needsRework,

  /// Задание успешно выполнено.
  completed,

  /// Задание отменено.
  canceled,

  /// Задание удалено.
  deleted,
}

Color taskCardBorderColor(TaskStatus? status) {
  switch (status) {
    case TaskStatus.inProgress:
      return orange;
    case TaskStatus.onReview:
      return orange;
    case TaskStatus.needsRework:
      return orange;
    case TaskStatus.completed:
      return success;
    case TaskStatus.canceled:
      return deepOrange;
    case TaskStatus.deleted:
      return error;
    default:
      return error;
  }
}

Color taskCardStatusColor(TaskStatus? status) {
  switch (status) {
    case TaskStatus.inProgress:
      return const Color(0xFFFFFCEB);
    case TaskStatus.onReview:
    case TaskStatus.needsRework:
      return const Color(0xFFE4E7FF);
    case TaskStatus.completed:
      return const Color(0xFFEBF8F3);
    case TaskStatus.canceled:
    case TaskStatus.deleted:
      return const Color(0xFFFFEFED);
    default:
      return const Color(0xFFFFFCEB);
  }
}

Color taskCardStatusTextColor(TaskStatus? status) {
  switch (status) {
    case TaskStatus.inProgress:
      return infoPrimary;
    case TaskStatus.onReview:
    case TaskStatus.needsRework:
      return info;
    case TaskStatus.completed:
      return success;
    case TaskStatus.canceled:
    case TaskStatus.deleted:
      return error;
    default:
      return greyscale900;
  }
}

String taskCardStatusText(TaskStatus? status) {
  switch (status) {
    case TaskStatus.inProgress:
      return 'В процессе';
    case TaskStatus.onReview:
      return 'Проверить';
    case TaskStatus.needsRework:
      return 'Доработать';
    case TaskStatus.completed:
      return 'Выполнено';
    case TaskStatus.canceled:
      return 'Отменено';
    case TaskStatus.deleted:
      return 'Удалено';
    default:
      return '-';
  }
}

String taskDetailCardStatusText(TaskStatus? status) {
  switch (status) {
    case TaskStatus.inProgress:
    case TaskStatus.onReview:
    case TaskStatus.needsRework:
      return 'В процессе';
    case TaskStatus.completed:
      return 'Выполнено';
    case TaskStatus.canceled:
      return 'Отменено';
    case TaskStatus.deleted:
      return 'Удалено';
    default:
      return '-';
  }
}
