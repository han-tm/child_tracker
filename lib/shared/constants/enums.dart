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
