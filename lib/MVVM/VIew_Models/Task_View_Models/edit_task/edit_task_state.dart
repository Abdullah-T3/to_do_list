part of 'edit_task_cubit.dart';

@immutable
sealed class EditTaskState {}

final class EditTaskInitial extends EditTaskState {
}

final class EditTaskLoading extends EditTaskState {}
final class EditTaskLoaded extends EditTaskState {
  final TaskModel task;
  EditTaskLoaded({required this.task});
}

final class EditTaskFailure extends EditTaskState {
  final String error;
  EditTaskFailure({required this.error});
}

final class EditTaskSuccess extends EditTaskState {}