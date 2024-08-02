import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/src/home/repositories/home_local_repository.dart';

part 'home_view_model_state.dart';

class HomeViewModelCubit extends Cubit<HomeViewModelState> {
  HomeViewModelCubit(this._repository) : super(const HomeViewModelInitial());

  final HomeLocalRepository _repository;

  Future<void> getIntervalSessions({bool ascending = true}) async {
    emit(const HomeViewModelLoading());
    final result = await _repository.getSessions(ascending: ascending);

    result.fold(
      (failure) => emit(HomeViewModelError(failure.errorMessage)),
      (intervals) => emit(IntervalsFetched(intervals)),
    );
  }

  Future<void> deleteIntervalSession(int id) async {
    emit(const HomeViewModelLoading());
    final result = await _repository.deleteIntervalSession(id);

    result.fold(
      (failure) => emit(HomeViewModelError(failure.errorMessage)),
      (_) => emit(const IntervalDeleted()),
    );
  }
}
