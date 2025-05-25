part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeTasksInitial extends HomeState {}

final class HomeTasksLoaded extends HomeState {
  final List<TaskModel> tasks;
  HomeTasksLoaded({required this.tasks});
}

final class HomeTasksLoading extends HomeState {}

final class HomeTasksError extends HomeState {
  final String error;
  HomeTasksError({required this.error});
}

final class TaskAdded extends HomeState {}

final class TaskUpdated extends HomeState {}

final class NoTasks extends HomeState {}

final class TaskDeleted extends HomeState {}

final class SharedTaskloaded extends HomeState {
  final List<TaskModel> tasks;
  SharedTaskloaded({required this.tasks});
}

final class pickedRepeatTask extends HomeState {
  final String pickedRepeat;
  pickedRepeatTask(this.pickedRepeat);
}

class pickedReminderTask extends HomeState {
  final int reminder;
  pickedReminderTask(this.reminder);
}

final class TaskDone extends HomeState {}

final class pickedDateTask extends HomeState {
  final String pickedDate;
  pickedDateTask(this.pickedDate);
}

final class AllUsersLoaded extends HomeState {
  final List<dynamic> users;
  AllUsersLoaded({required this.users});
}
