part of 'task_cubit.dart';

sealed class TaskState {}

// Initial state when no data is loaded yet
final class TaskInitial extends TaskState {}

// State while loading data
final class TaskLoading extends TaskState {
final bool isLoading ;
TaskLoading(this.isLoading);
}

// State when data is successfully loaded
final class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;

  TaskLoaded(this.tasks);
}

// State when there is an error
final class TaskError extends TaskState {
  final String errorMessage;

  TaskError(this.errorMessage);
}
