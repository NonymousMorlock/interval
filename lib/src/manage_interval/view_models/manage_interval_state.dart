part of 'manage_interval_cubit.dart';

sealed class ManageIntervalState extends Equatable {
  const ManageIntervalState();

  @override
  List<Object> get props => [];
}

final class ManageIntervalInitial extends ManageIntervalState {
  const ManageIntervalInitial();
}

final class ManageIntervalLoading extends ManageIntervalState {
  const ManageIntervalLoading();
}

final class IntervalSessionUpdated extends ManageIntervalState {
  const IntervalSessionUpdated();
}

final class IntervalSessionSaved extends ManageIntervalState {
  const IntervalSessionSaved();
}

final class ManageIntervalError extends ManageIntervalState {
  const ManageIntervalError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
