import 'package:child_tracker/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum UserType { kid, mentor }

enum ReminderType {single, daily}

enum ChatType { private, group, support }

enum BonusStatus { needApprove, active, canceled, readyToReceive, received }

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
