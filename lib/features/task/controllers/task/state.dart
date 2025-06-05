part of 'task_cubit.dart';

enum TaskStateStatus { initial, loading, success, error }

class TaskState extends Equatable {
  final String? errorMessage;
  final TaskStateStatus status;
  final List<TaskModel> tasks;
  final KidTaskChip selectedKidChip;
  final DateTime currentDay;
  const TaskState({
    this.errorMessage,
    this.status = TaskStateStatus.initial,
    this.tasks = const [],
    this.selectedKidChip = KidTaskChip.all,
    required this.currentDay,
  });

  TaskState copyWith({
    String? errorMessage,
    TaskStateStatus? status,
    List<TaskModel>? tasks,
    KidTaskChip? selectedKidChip,
    DateTime? currentDay,
  }) {
    return TaskState(
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      selectedKidChip: selectedKidChip ?? this.selectedKidChip,
      currentDay: currentDay ?? this.currentDay,
    );
  }

  @override
  List<Object?> get props => [
        errorMessage,
        status,
        tasks,
        selectedKidChip,
        currentDay,
      ];

  TaskState reset() =>  TaskState(currentDay: currentDay);
}
