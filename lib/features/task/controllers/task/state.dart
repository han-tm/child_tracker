part of 'task_cubit.dart';

enum TaskStateStatus {
  initial,
  loading,
  success,
  error,
  canceling,
  cancelError,
  cancelSuccess,
  kidCompleting,
  kidCompletingError,
  kidCompletingSuccess,
}

class TaskState extends Equatable {
  final String? errorMessage;
  final TaskStateStatus status;
  final List<TaskModel> tasks;
  final KidTaskChip selectedKidChip;
  final DateTime currentDay;
  final UserModel? selectedKid;
  const TaskState({
    this.errorMessage,
    this.status = TaskStateStatus.initial,
    this.tasks = const [],
    this.selectedKidChip = KidTaskChip.all,
    required this.currentDay,
    this.selectedKid,
  });

  TaskState copyWith({
    String? errorMessage,
    TaskStateStatus? status,
    List<TaskModel>? tasks,
    KidTaskChip? selectedKidChip,
    DateTime? currentDay,
    UserModel? selectedKid,
  }) {
    return TaskState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      selectedKidChip: selectedKidChip ?? this.selectedKidChip,
      currentDay: currentDay ?? this.currentDay,
      selectedKid: selectedKid ?? this.selectedKid,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        status,
        tasks,
        selectedKidChip,
        currentDay,
        selectedKid,
      ];

  TaskState reset() => TaskState(currentDay: currentDay);

  TaskState resetSelectedKid() {
    return TaskState(
      errorMessage: errorMessage,
      status: status,
      tasks: tasks,
      selectedKidChip: selectedKidChip,
      currentDay: currentDay,
      selectedKid: null,
    );
  }
}
