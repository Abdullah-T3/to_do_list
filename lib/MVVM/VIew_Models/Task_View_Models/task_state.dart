part of 'task_cubit.dart';

sealed class TaskState {}

// Initial state when no data is loaded yet
final class TaskInitial extends TaskState {
  final List<TaskModel> tasks;
  TaskInitial(this.tasks);
}

// State while loading data
final class TaskLoading extends TaskState {}

// State when data is successfully loaded
final class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;

  TaskLoaded(this.tasks);
}

final class TaskDone extends TaskState {}

final class pickedDateTask extends TaskState {
  final String pickedDate;
  pickedDateTask(this.pickedDate);
}
final class NoTaske extends TaskState {}

final class TaskUndone extends TaskState {}

final class TaskDeleted extends TaskState {}

final class TaskUpdated extends TaskState {}


final class TaskError extends TaskState {
  final String errorMessage;

  TaskError(this.errorMessage);
}
