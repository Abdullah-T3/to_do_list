part of 'edit_task_cubit.dart';

@immutable
sealed class EditTaskState {}

final class EditTaskInitial extends EditTaskState {
}

final class EditTaskLoading extends EditTaskState {}
final class EditTaskLoaded extends EditTaskState {
}
final class TaskUpdated extends EditTaskState{}

final class EditTaskFailure extends EditTaskState {
  final String error;
  EditTaskFailure({required this.error});
}

final class EditTaskSuccess extends EditTaskState {}