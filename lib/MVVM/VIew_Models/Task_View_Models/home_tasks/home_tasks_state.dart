part of 'home_tasks_cubit.dart';

@immutable
sealed class HomeTasksState {}

final class HomeTasksInitial extends HomeTasksState {}

final class HomeTasksLoaded extends HomeTasksState {
  final List<TaskModel> tasks;
  HomeTasksLoaded({required this.tasks});
}
final class HomeTasksLoading extends HomeTasksState {}
final class HomeTasksError extends HomeTasksState {
  final String error;
  HomeTasksError({required this.error});
}

final class NoTasks extends HomeTasksState {}

final class TaskDeleted extends HomeTasksState {}

