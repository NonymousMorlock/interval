import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/src/manage_interval/repositories/manage_interval_local_repository.dart';

part 'manage_interval_state.dart';

class ManageIntervalCubit extends Cubit<ManageIntervalState> {
  ManageIntervalCubit(this._repository) : super(const ManageIntervalInitial());

  final ManageIntervalLocalRepository _repository;

  Future<void> saveIntervalSession(IntervalSession interval) async {
    emit(const ManageIntervalLoading());
    final result = await _repository.saveIntervalSession(interval);

    result.fold(
      (failure) => emit(ManageIntervalError(failure.errorMessage)),
      (_) => emit(const IntervalSessionSaved()),
    );
  }

  Future<void> updateIntervalSession(IntervalSession interval) async {
    emit(const ManageIntervalLoading());
    final result = await _repository.updateIntervalSession(interval);

    result.fold(
      (failure) => emit(ManageIntervalError(failure.errorMessage)),
      (_) => emit(const IntervalSessionUpdated()),
    );
  }
}
