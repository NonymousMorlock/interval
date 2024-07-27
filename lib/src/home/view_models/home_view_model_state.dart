part of 'home_view_model_cubit.dart';

sealed class HomeViewModelState extends Equatable {
  const HomeViewModelState();

  @override
  List<Object> get props => [];
}

final class HomeViewModelInitial extends HomeViewModelState {
  const HomeViewModelInitial();
}

final class HomeViewModelLoading extends HomeViewModelState {
  const HomeViewModelLoading();
}

final class IntervalsFetched extends HomeViewModelState {
  const IntervalsFetched(this.intervals);

  final List<IntervalSession> intervals;

  @override
  List<Object> get props => intervals;
}

final class IntervalDeleted extends HomeViewModelState {
  const IntervalDeleted();
}

final class HomeViewModelError extends HomeViewModelState {
  const HomeViewModelError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
