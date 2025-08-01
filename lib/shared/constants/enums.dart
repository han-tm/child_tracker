import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum UserType { kid, mentor }

enum ReminderType { single, daily }

enum ChatType { private, group, support }

enum BonusStatus { needApprove, active, canceled, readyToReceive, received, rejected, deleted }

enum KidTaskChip { all, progress, completed, canceled }

String kidTaskChipRusName(KidTaskChip chip) {
  switch (chip) {
    case KidTaskChip.all:
      return 'all'.tr();
    case KidTaskChip.progress:
      return 'in_progress'.tr();
    case KidTaskChip.completed:
      return 'done'.tr();
    case KidTaskChip.canceled:
      return 'canceled_enum'.tr();
    default:
      return '-';
  }
}

enum TaskType { kid, mentor, priority }

enum TaskStatus {
  inProgress,

  onReview,

  needsRework,

  completed,

  canceled,

  deleted,
}

enum NotificationType {
  reminder,
  taskComplete,
  taskRework,
  taskCanceled,
  taskDeleted,
  taskCreated,
  taskReview,
  coinChange,
  bonusCreated,
  bonusNeedApprove,
  other,
}

NotificationType notificationTypeFromString(String? typeString) {
  if (typeString == null) return NotificationType.other;
  switch (typeString) {
    case 'reminder':
      return NotificationType.reminder;
    case 'taskComplete':
      return NotificationType.taskComplete;
    case 'taskRework':
      return NotificationType.taskRework;
    case 'taskCanceled':
      return NotificationType.taskCanceled;
    case 'taskDeleted':
      return NotificationType.taskDeleted;
    case 'taskCreated':
      return NotificationType.taskCreated;
    case 'taskReview':
      return NotificationType.taskReview;
    case 'coinChange':
      return NotificationType.coinChange;
    default:
      return NotificationType.other;
  }
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

String taskCardStatusText(TaskStatus? status, {bool isKid = false}) {
  switch (status) {
    case TaskStatus.inProgress:
      return 'in_progress'.tr();
    case TaskStatus.onReview:
      return isKid ? 'in_review'.tr() : 'check'.tr();
    case TaskStatus.needsRework:
      return 'rework'.tr();
    case TaskStatus.completed:
      return 'done_enum'.tr();
    case TaskStatus.canceled:
      return 'cancele_enum'.tr();
    case TaskStatus.deleted:
      return 'delet_enum'.tr();
    default:
      return '-';
  }
}

String taskDetailCardStatusText(TaskStatus? status) {
  switch (status) {
    case TaskStatus.inProgress:
    case TaskStatus.onReview:
    case TaskStatus.needsRework:
      return 'in_progress'.tr();
    case TaskStatus.completed:
      return 'done_enum'.tr();
    case TaskStatus.canceled:
      return 'cancele_enum'.tr();
    case TaskStatus.deleted:
      return 'delet_enum'.tr();
    default:
      return '-';
  }
}

enum DairyEmotion { bad, sad, normal, good, joyful }

String dairyEmotionIcon(DairyEmotion emotion, {bool filled = true}) {
  switch (emotion) {
    case DairyEmotion.bad:
      return 'em_bad${filled ? '_filled' : ''}';
    case DairyEmotion.sad:
      return 'em_sad${filled ? '_filled' : ''}';
    case DairyEmotion.normal:
      return 'em_normal${filled ? '_filled' : ''}';
    case DairyEmotion.joyful:
      return 'em_joyful${filled ? '_filled' : ''}';
    case DairyEmotion.good:
      return 'em_good${filled ? '_filled' : ''}';
    default:
      return 'em_normal${filled ? '_filled' : ''}';
  }
}

String dairyEmotionNameRus(DairyEmotion emotion) {
  switch (emotion) {
    case DairyEmotion.bad:
      return 'bad'.tr();
    case DairyEmotion.sad:
      return 'sad'.tr();
    case DairyEmotion.normal:
      return 'normal'.tr();
    case DairyEmotion.joyful:
      return 'joyful'.tr();
    case DairyEmotion.good:
      return 'good'.tr();
    default:
      return 'normal'.tr();
  }
}

enum BonusChip { request, active, received, canceled, rejected }

String bonusChipRusName(BonusChip chip) {
  switch (chip) {
    case BonusChip.request:
      return 'applications_chip'.tr();
    case BonusChip.active:
      return 'actives_chip'.tr();
    case BonusChip.received:
      return 'received_chip'.tr();
    case BonusChip.canceled:
      return 'canceled_chip'.tr();
    case BonusChip.rejected:
      return 'rejected_chip'.tr();
    default:
      return '-';
  }
}

Color bonusCardStatusColor(BonusStatus? status) {
  switch (status) {
    case BonusStatus.needApprove:
      return info;
    case BonusStatus.readyToReceive:
      return success;
    default:
      return white;
  }
}
